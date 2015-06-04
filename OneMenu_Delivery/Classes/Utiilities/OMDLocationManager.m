//
//  OMDLocationManager.m
//  OneMenu
//
//  Created by simmyoung on 14-10-8.
//  Copyright (c) 2014年 One Menu Limited Liability Company. All rights reserved.
//

#import "OMDLocationManager.h"
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "OMDConstantsFile.h"

#define LOCAL_EN_US(string) [[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] displayNameForKey:NSLocaleIdentifier value:string]
#define IOS8  (__IPHONE_OS_VERSION_MAX_ALLOWED >= 80000) && ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@interface OMDLocationManager()<CLLocationManagerDelegate>
{
    CLLocationManager *mCLLocationMgr;
    CLGeocoder *mGeoCoder;
    NSDate *mLastUpdateAddressTime;//最后取地址的时间
    NSString *mLastProvince;
    NSString *mLastCity;
    NSString *mLastRegion;
    NSString *mDetailAddress;
    NSString *mPostalCode;
    NSString *mLastLongitude;
    NSString *mLastLatitude;
}

@property (nonatomic, assign) BOOL isSuccessed;

@end

@implementation OMDLocationManager

+ (OMDLocationManager *)sharedInstance
{
    static OMDLocationManager *locationManager;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        locationManager = [[OMDLocationManager alloc] init];
    });
    return locationManager;
}

- (id)init
{
    if (self = [super init]) {
        [[NSUserDefaults standardUserDefaults] setObject: [NSArray arrayWithObjects:@"en", nil] forKey:@"AppleLanguages"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        mLastCity = @"";
        mLastProvince = @"";
        mLastRegion = @"";
        mDetailAddress = @"";
        mPostalCode = @"";
        mLastLatitude = @"";
        mLastLongitude = @"";
    }
    return self;
}

- (void)start
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mCLLocationMgr = [[CLLocationManager alloc] init];
        mCLLocationMgr.delegate = self;
        mCLLocationMgr.desiredAccuracy = kCLLocationAccuracyBest;
        mCLLocationMgr.distanceFilter = 100;
        if (IOS8) {
            //使用期间
            [mCLLocationMgr requestWhenInUseAuthorization];
            //始终
            [mCLLocationMgr requestAlwaysAuthorization];
        }
    });
    [mCLLocationMgr startUpdatingLocation];
}

- (void)stop
{
    if (mCLLocationMgr) {
        [mCLLocationMgr stopUpdatingLocation];
    }
}

- (void)refresh
{
    if (!mCLLocationMgr) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            mCLLocationMgr = [[CLLocationManager alloc] init];
            mCLLocationMgr.delegate = self;
            mCLLocationMgr.desiredAccuracy = kCLLocationAccuracyBest;
            mCLLocationMgr.distanceFilter = 100;
            if (IOS8) {
                //使用期间
                [mCLLocationMgr requestWhenInUseAuthorization];
                //始终
                [mCLLocationMgr requestAlwaysAuthorization];
            }
        });
    }
    [mCLLocationMgr startUpdatingLocation];
}

#warning --
- (NSString *)latitude
{
#ifdef APP_LOCATION_TEST
    return @"40.802823";
#else
    return mLastLatitude;
#endif
}

- (NSString *)longitude{
#ifdef APP_LOCATION_TEST
    return @"-77.889503";
#else
    return mLastLongitude;
#endif
}

- (NSString *)province
{
    return mLastProvince;
}

- (NSString *)city
{
    return mLastCity;
}

- (NSString *)region
{
    return mLastRegion;
}

- (NSString *)detailAddress
{
    return mDetailAddress;
}

- (NSString *)postalCode
{
    return mPostalCode;
}

#pragma mark -- CLLocation Manager Delegate --
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"location updated!");
    if ([locations count]>0) {
        CLLocation *lastLocation = [locations lastObject];
        mLastLongitude = [NSString stringWithFormat:@"%.6f",lastLocation.coordinate.longitude];
        mLastLatitude = [NSString stringWithFormat:@"%.6f",lastLocation.coordinate.latitude];
//        NSLog(@"current latitude = %@",mLastLatitude);
//        NSLog(@"current longitude = %@",mLastLongitude);
        [[NSNotificationCenter defaultCenter] postNotificationName:kGetLocationSuccessNotification object:nil];
        [self updateAddressWithLocation:lastLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    if ([error code]==kCLErrorDenied) {
        NSLog(@"访问被拒绝");
        [[NSNotificationCenter defaultCenter] postNotificationName:kGetLocationDeniedNotification object:nil];
    }
    if ([error code]==kCLErrorLocationUnknown) {
        NSLog(@"无法获取位置信息");
        [[NSNotificationCenter defaultCenter] postNotificationName:kGetLocationFailureNotification object:nil];
    }
}

- (void)locationManager:(CLLocationManager *)manager
    didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            if ([mCLLocationMgr respondsToSelector:@selector(requestAlwaysAuthorization)]) {
                [mCLLocationMgr requestWhenInUseAuthorization];
            }
            break;
        default:
            break;
    }
}

// before ios7 delegate method
//- (void)locationManager:(CLLocationManager *)manager
//    didUpdateToLocation:(CLLocation *)newLocation
//           fromLocation:(CLLocation *)oldLocation
//{
//    NSLog(@"location updated!");
//    CLLocation *lastLocation = newLocation;
//    mLastLongitude = [NSString stringWithFormat:@"%.6f",lastLocation.coordinate.longitude];
//    mLastLatitude = [NSString stringWithFormat:@"%.6f",lastLocation.coordinate.latitude];
//    NSLog(@"current latitude = %@",mLastLatitude);
//    NSLog(@"current longitude = %@",mLastLongitude);
//    [self updateAddressWithLocation:lastLocation];
//}

- (void)updateAddressWithLocation:(CLLocation *)locationGps
{
    NSDate *now = [NSDate date];
    //如果距离上次调用时间小于2分钟，则不调用（苹果对该函数有调用频率限制）
    if (mGeoCoder!=nil || (mLastUpdateAddressTime!=nil && [now timeIntervalSinceDate:mLastUpdateAddressTime]< 10) ) {
        return;
    }

    mGeoCoder = [[CLGeocoder alloc] init];
    
    [mGeoCoder reverseGeocodeLocation:locationGps completionHandler:^(NSArray *placemarks, NSError *error)
     {
         NSLog(@"address %@ placemarks count %lu",error.localizedDescription,(unsigned long)placemarks.count);
         
         for (CLPlacemark *placeMark in placemarks)
         {
             //Key: province(省份)、city(城市)、county(区\县)、lat（纬度）、lng（经度）

             NSString *province = placeMark.administrativeArea;
             NSString *city = placeMark.locality;
             NSString *subLocality = placeMark.subLocality;
             NSString *postalCode = placeMark.postalCode;
             __unused NSString *thoroughfare = placeMark.thoroughfare;
             __unused NSString *subThoroughfare = placeMark.subThoroughfare;
             __unused NSString *locality = placeMark.locality;
             __unused NSString *administrativeArea = placeMark.administrativeArea;
             __unused NSString *subAdministrativeArea = placeMark.subAdministrativeArea;
             __unused NSArray *areasOfInterest = placeMark.areasOfInterest;
             __unused NSString *name = placeMark.name;
             __unused NSString *country = placeMark.country;
             NSDictionary *dict = placeMark.addressDictionary;
             NSString *street = [dict objectForKey:@"Street"];
             __unused NSString *FormattedAddressLines = [dict objectForKey:@"FormattedAddressLines"];
             NSLog(@"province = %@",province);
             NSLog(@"city = %@",city);
             NSLog(@"region = %@",subLocality);
             NSLog(@"detail = %@",street);
             if (province != nil || city != nil || subLocality != nil || street != nil || postalCode != nil) {
                 mLastProvince = province?[province copy]:@"";
                 mLastCity = city?[city copy]:@"";
                 mLastRegion = subLocality?[subLocality copy]:@"";
                 mDetailAddress = street?[street copy]:@"";
                 mPostalCode = postalCode?[postalCode copy]:@"";
                 break;
             }
         }
         mGeoCoder = nil;
     }];
    mLastUpdateAddressTime = now;
}

@end
