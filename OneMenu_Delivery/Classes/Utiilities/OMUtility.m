//
//  OMUtility.m
//  OneMenu
//
//  Created by simmyoung on 14-8-19.
//  Copyright (c) 2014年 One Menu Limited Liability Company. All rights reserved.
//

#import "OMUtility.h"
#import "OMDNetworkManager.h"
#import "AppDelegate.h"

#import "sys/xattr.h"

#define ORIGINAL_MAX_WIDTH 640.0f

@implementation OMUtility

+ (void)saveLoginType:(LoginType)type
{
    NSString *customerId = [OMUtility getCurrentCustomerId];
    NSString *key = nil;
    if ([OMUtility isLogined] && ![OMUtility StringIsEmptyWith:customerId]) {
        key = [NSString stringWithFormat:@"%@-%@",@"LoginType",customerId];
    }
    else {
        key = [NSString stringWithFormat:@"%@-%@",@"LoginType",@"Current"];
    }
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:type] forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (LoginType)getLoginType
{
    NSString *customerId = [OMUtility getCurrentCustomerId];
    NSString *key = nil;
    if ([OMUtility isLogined] && ![OMUtility StringIsEmptyWith:customerId]) {
        key = [NSString stringWithFormat:@"%@-%@",@"LoginType",customerId];
    }
    else {
        key = [NSString stringWithFormat:@"%@-%@",@"LoginType",@"Current"];
    }
    LoginType type = LoginType_Non;
    type = [[[NSUserDefaults standardUserDefaults] objectForKey:key] integerValue];
    
    return type;
}

+ (void)setBadgeWith:(NSInteger)num
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UITabBarItem *tabbarItem = (UITabBarItem *)[[[appDelegate.tabbarCtrl tabBar] items] objectAtIndex:2];
    if (num==0) {
        [tabbarItem setBadgeValue:@""];
    }
    else if (num>0) {
        [tabbarItem setBadgeValue:[NSString stringWithFormat:@"%zd",num]];
    }
}

+ (void)clearBadge
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UITabBarItem *tabbarItem = (UITabBarItem *)[[[appDelegate.tabbarCtrl tabBar] items] objectAtIndex:2];
    [tabbarItem setBadgeValue:nil];
}

+ (NSString *)getKeyWith:(NSString *)string
{
    return [OMUtility getKeyWith:string needLogin:[OMUtility isLogined]];
}

+ (NSString *)getKeyWith:(NSString *)string needLogin:(BOOL)needLogin
{
    NSString *customerId = [OMUtility getCurrentCustomerIdWithNeedLogin:needLogin];
    NSString *key = nil;
    if (needLogin) {
        if ([OMUtility isLogined] && ![OMUtility StringIsEmptyWith:customerId]) {
            key = [NSString stringWithFormat:@"%@-%@",string,customerId];
        }
        else {
            key = [NSString stringWithFormat:@"%@-%@",string,@"Current"];
        }
    }
    else {
        key = [NSString stringWithFormat:@"%@-%@",string,@"Current"];
//        if (![OMUtility StringIsEmptyWith:customerId]) {
//            key = [NSString stringWithFormat:@"%@-%@",string,customerId];
//        }
//        else {
//            key = [NSString stringWithFormat:@"%@-%@",string,@"Current"];
//        }
    }
    return key;
}

#pragma mark --
//cust credit num
+ (void)saveCustomerCreditCardNum:(NSString *)cardNum
{
    NSString *key = [OMUtility getKeyWith:@"customerCreditCardNum"];
    [[NSUserDefaults standardUserDefaults] setObject:cardNum forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getCustomerCreditCardNum
{
    return [OMUtility getCustomerCreditCardNumWithNeedLogin:[OMUtility isLogined]];
}

+ (NSString *)getCustomerCreditCardNumWithNeedLogin:(BOOL)needLogin
{
    NSString *key = [OMUtility getKeyWith:@"customerCreditCardNum" needLogin:needLogin];
    NSString *cardNum = @"";
    if (needLogin && [[NSUserDefaults standardUserDefaults] objectForKey:key] && [OMUtility isLogined]) {
        cardNum = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    }
    else if (!needLogin && [[NSUserDefaults standardUserDefaults] objectForKey:key]) {
        cardNum = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    }
    return cardNum;
}

//cust credit holder
+ (void)saveCustomerCreditCardHolder:(NSString *)holder
{
    NSString *key = [OMUtility getKeyWith:@"customerCreditCardHolder"];
    [[NSUserDefaults standardUserDefaults] setObject:holder forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getCustomerCreditCardHolder
{
    return [OMUtility getCustomerCreditCardHolderWithNeedLogin:[OMUtility isLogined]];
}

+ (NSString *)getCustomerCreditCardHolderWithNeedLogin:(BOOL)needLogin
{
    NSString *key = [OMUtility getKeyWith:@"customerCreditCardHolder" needLogin:needLogin];
    NSString *cardHolder = @"";
    if (needLogin && [[NSUserDefaults standardUserDefaults] objectForKey:key] && [OMUtility isLogined]) {
        cardHolder = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    }
    else if (!needLogin && [[NSUserDefaults standardUserDefaults] objectForKey:key]) {
        cardHolder = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    }
    return cardHolder;
}

//cust credit month
+ (void)saveCustomerCreditCardMonth:(NSString *)month
{
    NSString *key = [OMUtility getKeyWith:@"customerCreditCardMonth"];
    [[NSUserDefaults standardUserDefaults] setObject:month forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getCustomerCreditCardMonth
{
    return [OMUtility getCustomerCreditCardMonthWithNeedLogin:[OMUtility isLogined]];
}

+ (NSString *)getCustomerCreditCardMonthWithNeedLogin:(BOOL)needLogin
{
    NSString *key = [OMUtility getKeyWith:@"customerCreditCardMonth" needLogin:needLogin];
    NSString *month = @"";
    if (needLogin && [[NSUserDefaults standardUserDefaults] objectForKey:key] && [OMUtility isLogined]) {
        month = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    }
    else if (!needLogin && [[NSUserDefaults standardUserDefaults] objectForKey:key]) {
        month = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    }
    return month;
}

//cust credit year
+ (void)saveCustomerCreditCardYear:(NSString *)year
{
    NSString *key = [OMUtility getKeyWith:@"customerCreditCardYear"];
    [[NSUserDefaults standardUserDefaults] setObject:year forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getCustomerCreditCardYear
{
    return [OMUtility getcustomerCreditCardYearWithNeedLogin:[OMUtility isLogined]];
}

+ (NSString *)getcustomerCreditCardYearWithNeedLogin:(BOOL)needLogin
{
    NSString *key = [OMUtility getKeyWith:@"customerCreditCardYear" needLogin:needLogin];
    NSString *year = @"";
    if (needLogin && [[NSUserDefaults standardUserDefaults] objectForKey:key] && [OMUtility isLogined]) {
        year = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    }
    else if (!needLogin && [[NSUserDefaults standardUserDefaults] objectForKey:key]) {
        year = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    }
    return year;
}

//cust credit poastal code
+ (void)saveCustomerCreditCardPostalCode:(NSString *)postalCode
{
    NSString *key = [OMUtility getKeyWith:@"customerCreditCardPostalCode"];
    [[NSUserDefaults standardUserDefaults] setObject:postalCode forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getCustomerCreditCardPostalCode
{
    return [OMUtility getCustomerCreditCardPostalCodeWithNeedLogin:[OMUtility isLogined]];
}

+ (NSString *)getCustomerCreditCardPostalCodeWithNeedLogin:(BOOL)needLogin
{
    NSString *key = [OMUtility getKeyWith:@"customerCreditCardPostalCode" needLogin:needLogin];
    NSString *postalCode = @"";
    if (needLogin && [[NSUserDefaults standardUserDefaults] objectForKey:key] && [OMUtility isLogined]) {
        postalCode = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    }
    else if (!needLogin && [[NSUserDefaults standardUserDefaults] objectForKey:key]) {
        postalCode = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    }
    return postalCode;
}

//cust phone
+ (void)saveCustomerPhone:(NSString *)phoneStr
{
    NSString *key = [OMUtility getKeyWith:@"customerPhone"];
    [[NSUserDefaults standardUserDefaults] setObject:phoneStr forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getCustomerPhone
{
    return [OMUtility getCustomerPhoneWithNeedLogin:[OMUtility isLogined]];
}

+ (NSString *)getCustomerPhoneWithNeedLogin:(BOOL)needLogin
{
    NSString *key = [OMUtility getKeyWith:@"customerPhone" needLogin:needLogin];
    NSString *phone = nil;
    if (needLogin && [[NSUserDefaults standardUserDefaults] objectForKey:key] && [OMUtility isLogined]) {
        phone = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    }
    else if (!needLogin && [[NSUserDefaults standardUserDefaults] objectForKey:key]) {
        phone = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    }
    return phone;
}

//cust address
+ (void)saveCustomerAddress:(NSString *)addressStr
{
    NSString *key = [OMUtility getKeyWith:@"customerAddress"];
    [[NSUserDefaults standardUserDefaults] setObject:addressStr forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getCustomerAddress
{
    return [OMUtility getCustomerAddressWithNeedLogin:[OMUtility isLogined]];
}

+ (NSString *)getCustomerAddressWithNeedLogin:(BOOL)needLogin
{
    NSString *key = [OMUtility getKeyWith:@"customerAddress" needLogin:needLogin];
    NSString *address = nil;
    if (needLogin && [[NSUserDefaults standardUserDefaults] objectForKey:key] && [OMUtility isLogined]) {
        address = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    }
    else if (!needLogin && [[NSUserDefaults standardUserDefaults] objectForKey:key]) {
        address = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    }
    return address;
}

//cust street
+ (void)saveCustomerStreet:(NSString *)streetStr
{
    NSString *key = [OMUtility getKeyWith:@"customerStreet"];
    [[NSUserDefaults standardUserDefaults] setObject:streetStr forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getCustomerStreet
{
    return [OMUtility getCustomerStreetWithNeedLogin:[OMUtility isLogined]];
}

+ (NSString *)getCustomerStreetWithNeedLogin:(BOOL)needLogin
{
    NSString *key = [OMUtility getKeyWith:@"customerStreet" needLogin:needLogin];
    NSString *street = nil;
    if (needLogin && [[NSUserDefaults standardUserDefaults] objectForKey:key] && [OMUtility isLogined]) {
        street = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    }
    else if (!needLogin && [[NSUserDefaults standardUserDefaults] objectForKey:key]) {
        street = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    }
    return street;
}

//cust apt
+ (void)saveCustomerApt:(NSString *)aptStr
{
    NSString *key = [OMUtility getKeyWith:@"customerApt"];
    [[NSUserDefaults standardUserDefaults] setObject:aptStr forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getCustomerApt
{
    return [OMUtility getCustomerAptWithNeedLogin:[OMUtility isLogined]];
}

+ (NSString *)getCustomerAptWithNeedLogin:(BOOL)needLogin
{
    NSString *key = [OMUtility getKeyWith:@"customerApt" needLogin:needLogin];
    NSString *apt = nil;
    if (needLogin && [[NSUserDefaults standardUserDefaults] objectForKey:key] && [OMUtility isLogined]) {
        apt = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    }
    else if (!needLogin && [[NSUserDefaults standardUserDefaults] objectForKey:key]) {
        apt = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    }
    return apt;
}

//cust city
+ (void)saveCustomerCity:(NSString *)cityStr
{
    NSString *key = [OMUtility getKeyWith:@"customerCity"];
    [[NSUserDefaults standardUserDefaults] setObject:cityStr forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getCustomerCity
{
    return [OMUtility getCustomerCityWithNeedLogin:[OMUtility isLogined]];
}

+ (NSString *)getCustomerCityWithNeedLogin:(BOOL)needLogin
{
    NSString *key = [OMUtility getKeyWith:@"customerCity" needLogin:needLogin];
    NSString *city = nil;
    if (needLogin && [[NSUserDefaults standardUserDefaults] objectForKey:key] && [OMUtility isLogined]) {
        city = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    }
    else if (!needLogin && [[NSUserDefaults standardUserDefaults] objectForKey:key]) {
        city = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    }
    return city;
}

//cust zip code
+ (void)saveCustomerZipCode:(NSString *)zipCode
{
    NSString *key = [OMUtility getKeyWith:@"customerZipCode"];
    [[NSUserDefaults standardUserDefaults] setObject:zipCode forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getCustomerZipCode
{
    return [OMUtility getCustomerZipCodeWithNeedLogin:[OMUtility isLogined]];
}

+ (NSString *)getCustomerZipCodeWithNeedLogin:(BOOL)needLogin
{
    NSString *key = [OMUtility getKeyWith:@"customerZipCode" needLogin:needLogin];
    NSString *zipCode = nil;
    if (needLogin && [[NSUserDefaults standardUserDefaults] objectForKey:key] && [OMUtility isLogined]) {
        zipCode = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    }
    else if (!needLogin && [[NSUserDefaults standardUserDefaults] objectForKey:key]) {
        zipCode = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    }
    return zipCode;
}

//tax
+ (NSString *)getLocalTax
{
    NSString *taxStr = nil;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kLocalTax_key]) {
        taxStr = [[NSUserDefaults standardUserDefaults] objectForKey:kLocalTax_key];
    }
    return taxStr;
}

+ (void)saveLocalTaxWith:(NSString *)taxStr
{
    [[NSUserDefaults standardUserDefaults] setObject:taxStr forKey:kLocalTax_key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)saveAppServerVersionWith:(NSString *)serverVersion
{
    [[NSUserDefaults standardUserDefaults] setObject:serverVersion forKey:@"appServerVersion"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getAppServerVersion
{
    NSString *serverVersion = @"";
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"appServerVersion"]) {
        serverVersion = [[NSUserDefaults standardUserDefaults] objectForKey:@"appServerVersion"];
    }
    return serverVersion;
}

+ (void)saveNotificationDeviceTokenWith:(NSString *)deviceToken
{
    [[NSUserDefaults standardUserDefaults] setObject:deviceToken forKey:@"notificationDeviceToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getNotifacationDeviceToken
{
    NSString *notificationDeviceToken = nil;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"notificationDeviceToken"]) {
        notificationDeviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"notificationDeviceToken"];
    }
    return notificationDeviceToken;
}

+ (void)saveRejectUpdateAppTime
{
    CFAbsoluteTime nowTime = CFAbsoluteTimeGetCurrent();
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithDouble:nowTime] forKey:@"rejectUpdateTime"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)shouldAlertUpdateApp
{
    CFAbsoluteTime nowTime = CFAbsoluteTimeGetCurrent();
    
    CFAbsoluteTime oldTime = CFAbsoluteTimeGetCurrent();
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"rejectUpdateTime"] != nil) {
        oldTime = [[[NSUserDefaults standardUserDefaults] objectForKey:@"rejectUpdateTime"] doubleValue];
    }
    else {
        return YES;
    }
    // 4天内不重复提示.
    if (oldTime-nowTime>=4*24*60*60) {
        return YES;
    }
    else {
        return NO;
    }
}

+ (NSString *)eggshellString
{
    NSArray *dataArray = [NSArray arrayWithObjects:
            @"It Ain’t About How Hard You Eat",
            @"It’s About How Hard You Tip",
            @"Ratatouille Made By Remy",
            @"No Time for play",
            @"Sausages, eggs and fire, heed my call!",
            @"My Blade starves!",
            @"Ishnu-ala.",
            @"Nas beru uhn'adarr?",
            @"Where there's life there's hope, and need of vittles.",
            @"Play on!",
            @"All Happiness Depends on A Pizza!",
            @"A little Cheese a day keeps the doctor at bay",
            @"Without eating, life is nothing but work and sleep",
            @"To eat, or not to be.",
//            @"Gravitation is not responsible for people falling in love.",
             nil];
    srand(NSTimeIntervalSince1970);
    NSString *str = [dataArray objectAtIndex:arc4random()%dataArray.count];
    return str;
}

#pragma mark camera utility
+ (BOOL)isCameraAvailable
{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

+ (BOOL)isRearCameraAvailable
{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

+ (BOOL)isFrontCameraAvailable
{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

+ (BOOL)doesCameraSupportTakingPhotos
{
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

+ (BOOL)isPhotoLibraryAvailable
{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}

+ (BOOL)canUserPickVideosFromPhotoLibrary
{
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie
                          sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

+ (BOOL)canUserPickPhotosFromPhotoLibrary
{
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage
                          sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

+ (BOOL)cameraSupportsMedia:(NSString *)paramMediaType
                 sourceType:(UIImagePickerControllerSourceType)paramSourceType
{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}

#pragma mark image scale utility
+ (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage
{
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

+ (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage
                                          targetSize:(CGSize)targetSize
{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage *)imageWithImageSimple:(UIImage *)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}

+ (UIImage *)screenImage
{
    CGSize imgSize = CGSizeMake(kScreenWidth, kScreenHeight);

    UIGraphicsBeginImageContext(imgSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate; //获取app的appdelegate，便于取到当前的window用来截屏
    [app.window.layer renderInContext:context];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

#pragma mark -- Rect Calculate --
+ (CGRect)calculateRectWithBgRect:(CGRect)oriRect
                         bgWHRate:(NSString *)bgWHRateStr
                        subWHRate:(NSString *)subWHRateStr
{
    CGRect subRect = CGRectZero;
    
    if ([OMDCalculateManager isBiggerDecimalNumberWithStringOne:subWHRateStr stringTwo:bgWHRateStr]) {
        subRect.size.width = oriRect.size.width;
        CGFloat subWHRate = [subWHRateStr floatValue];
        NSString *subHeightStr = [OMDCalculateManager dividingNumberWithFloatOne:subRect.size.width floatTwo:subWHRate];
        subRect.size.height = [subHeightStr floatValue];
        subRect.origin.y = (oriRect.size.height-subRect.size.height)/2;
    }
    else if ([OMDCalculateManager isSmallerDecimalNumberWithStringOne:subWHRateStr stringTwo:bgWHRateStr]) {
        subRect.size.height = oriRect.size.height;
        CGFloat subWHRate = [subWHRateStr floatValue];
        NSString *subWidthStr = [OMDCalculateManager multiplyingNumberWithFloatOne:subRect.size.height floatTwo:subWHRate];
        subRect.size.width = [subWidthStr floatValue];
        subRect.origin.x = (oriRect.size.width-subRect.size.width)/2;
    }
    else {
        subRect.size.width = oriRect.size.width;
        subRect.size.height = oriRect.size.height;
        subRect.origin.y = oriRect.origin.y;
        subRect.origin.x = oriRect.origin.x;
    }
    
    return subRect;
}


+ (void)saveCurrentCustomerAvatarImageWith:(UIImage *)image
{
    NSString *key = [OMUtility getKeyWith:@"avatar"];
    NSData *data = nil;
    if (UIImagePNGRepresentation(image) == nil) {
        data = UIImageJPEGRepresentation(image, 1);
    } else {
        data = UIImagePNGRepresentation(image);
    }
    NSString *pngImage = nil;
    if (![[NSFileManager defaultManager] fileExistsAtPath:UserPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:UserPath withIntermediateDirectories:NO attributes:nil error:nil];
        [OMUtility addSkipBackupAttributeToItemAtURL:[NSURL URLWithString:UserPath]];
    }
    pngImage = [UserPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@",key,@".png"]];
    __unused BOOL success = [data writeToFile:pngImage atomically:YES];
}

+ (UIImage *)getCurrentCustomerAvatarImage
{
    return [OMUtility getCurrentCustomerAvatarImageWithNeedLogin:[OMUtility isLogined]];
}

+ (UIImage *)getCurrentCustomerAvatarImageWithNeedLogin:(BOOL)needLogin
{
    NSString *key = [OMUtility getKeyWith:@"avatar" needLogin:needLogin];
    UIImage *avatar = nil;
    NSString *pngImage = [SandDocPath() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@",key,@".png"]];
    NSData *data = [NSData dataWithContentsOfFile:pngImage];
    if (data) {
        avatar = [UIImage imageWithData:data];
    }
    return avatar;
}

+ (NSString *)getShoppingCartPlistPath
{
    NSString *path = nil;
    if (![[NSFileManager defaultManager] fileExistsAtPath:UserPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:UserPath withIntermediateDirectories:NO attributes:nil error:nil];
        [OMUtility addSkipBackupAttributeToItemAtURL:[NSURL URLWithString:UserPath]];
    }
    path = [UserPath stringByAppendingPathComponent:kShoppingCartPlist_key];
    return path;
}

+ (void)saveCurrentCustomerNameWith:(NSString *)userName
{
    NSString *key = [OMUtility getKeyWith:@"customerName"];
    [[NSUserDefaults standardUserDefaults] setObject:userName forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getCurrentCustomerName
{
    return [OMUtility getCurrentCustomerNameWithNeedLogin:[OMUtility isLogined]];
}

+ (NSString *)getCurrentCustomerNameWithNeedLogin:(BOOL)needLogin
{
    NSString *key = [OMUtility getKeyWith:@"customerName" needLogin:needLogin];
    NSString *customerName = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (needLogin && ![OMUtility StringIsEmptyWith:customerName] && [OMUtility isLogined]) {
        return customerName;
    }
    else if (needLogin && ![OMUtility StringIsEmptyWith:customerName]) {
        return customerName;
    }
    return nil;
}

+ (void)saveCurrentCustomerIdWith:(NSString *)customerId
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"customerIdArray"]) {
        NSMutableArray *customerIdArray = [[[NSUserDefaults standardUserDefaults] objectForKey:@"customerIdArray"] mutableCopy];
        BOOL isNew = YES;
        for (NSInteger i = 0; i<customerIdArray.count; i++) {
            NSString *customer = [customerIdArray objectAtIndex:i];
            if ([customer isEqualToString:customerId]) {
                [customerIdArray removeObjectAtIndex:i];
                [customerIdArray insertObject:customerId atIndex:0];
                isNew = NO;
                break;
            }
        }
        if (isNew) {
            [customerIdArray addObject:customerId];
        }
        NSLog(@"customerIdArray = %@",customerIdArray);
        [[NSUserDefaults standardUserDefaults] setObject:customerIdArray forKey:@"customerIdArray"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else {
        NSMutableArray *customerIdArray = [NSMutableArray array];
        [customerIdArray addObject:customerId];
        NSLog(@"customerIdArray = %@",customerIdArray);
        [[NSUserDefaults standardUserDefaults] setObject:customerIdArray forKey:@"customerIdArray"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    [[NSUserDefaults standardUserDefaults] setObject:customerId forKey:@"customerId"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getCurrentCustomerId
{
    return [OMUtility getCurrentCustomerIdWithNeedLogin:YES];
}

+ (NSString *)getCurrentCustomerIdWithNeedLogin:(BOOL)needLogin
{
    if (needLogin) {
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"customerIdArray"] && [OMUtility isLogined]) {
            NSArray *customerIdArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"customerIdArray"];
            NSString *customerId = [customerIdArray firstObject];
            return customerId;
        }
        else {
            return nil;
        }
    }
    else {
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"customerIdArray"]) {
            NSArray *customerIdArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"customerIdArray"];
            NSString *customerId = [customerIdArray firstObject];
            return customerId;
        }
        else {
            return nil;
        }
    }
}

+ (void)saveCurrentCustomerAvatarImageUrlWith:(NSString *)path
{
    NSString *key = [OMUtility getKeyWith:@"userAvatarPath"];
    if (![OMUtility StringIsEmptyWith:path]) {
        [[NSUserDefaults standardUserDefaults] setObject:path forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (NSString *)getCurrentCustomerAvatarUrl
{
    return [OMUtility getCurrentCustomerAvatarUrlWithNeedLogin:[OMUtility isLogined]];
}

+ (NSString *)getCurrentCustomerAvatarUrlWithNeedLogin:(BOOL)needLogin
{
    NSString *key = [OMUtility getKeyWith:@"userAvatarPath" needLogin:needLogin];
    NSString *avatarUrl = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (![OMUtility StringIsEmptyWith:avatarUrl] && [OMUtility isLogined]) {
        return avatarUrl;
    }
    else {
        return nil;
    }
}

+ (void)saveCurrentCustomerLoginToken:(NSString *)loginToken
{
    NSString *key = [OMUtility getKeyWith:@"customerLoginToken" needLogin:NO];
    if (![OMUtility StringIsEmptyWith:loginToken]) {
        [[NSUserDefaults standardUserDefaults] setObject:loginToken forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (NSString *)getCurrentCustomerLoginToken
{
    return [OMUtility getCurrentCustomerLoginTokenWithNeedLogin:NO];
}

+ (NSString *)getCurrentCustomerLoginTokenWithNeedLogin:(BOOL)needLogin
{
    NSString *key = [OMUtility getKeyWith:@"customerLoginToken" needLogin:needLogin];
    NSString *loginToken = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (needLogin & ![OMUtility StringIsEmptyWith:loginToken] && [OMUtility isLogined]) {
        return  loginToken;
    }
    else if (!needLogin && ![OMUtility StringIsEmptyWith:loginToken]) {
        return loginToken;
    }
    return nil;
}

+ (void)saveCurrentCustomerEmail:(NSString *)email
{
//    NSString *key = [OMUtility getKeyWith:@"customerEmail"];
//    [[NSUserDefaults standardUserDefaults] setObject:email forKey:key];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"customerEmailArray"]) {
        NSMutableArray *customerEmailArray = [[[NSUserDefaults standardUserDefaults] objectForKey:@"customerEmailArray"] mutableCopy];
        BOOL isNew = YES;
        for (NSInteger i = 0; i<customerEmailArray.count; i++) {
            NSString *email = [customerEmailArray objectAtIndex:i];
            if ([email isEqualToString:email]) {
                [customerEmailArray removeObjectAtIndex:i];
                [customerEmailArray insertObject:email atIndex:0];
                isNew = NO;
                break;
            }
        }
        if (isNew) {
            [customerEmailArray addObject:email];
        }
        NSLog(@"customerEmailArray = %@",customerEmailArray);
        [[NSUserDefaults standardUserDefaults] setObject:customerEmailArray forKey:@"customerEmailArray"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else {
        NSMutableArray *customerEmailArray = [NSMutableArray array];
        [customerEmailArray addObject:email];
        NSLog(@"customerEmailArray = %@",customerEmailArray);
        [[NSUserDefaults standardUserDefaults] setObject:customerEmailArray forKey:@"customerEmailArray"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    [[NSUserDefaults standardUserDefaults] setObject:email forKey:@"customerEmail"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

+ (NSString *)getCurrentCustomerEmail
{
    return [OMUtility getcurrentcustomerEmailWithNeedLogin:[OMUtility isLogined]];
}

+ (NSString *)getcurrentcustomerEmailWithNeedLogin:(BOOL)needLogin
{
    if (needLogin) {
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"customerEmailArray"] && [OMUtility isLogined]) {
            NSArray *customerEmailArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"customerEmailArray"];
            NSString *customerEmail = [customerEmailArray firstObject];
            return customerEmail;
        }
        else {
            return nil;
        }
    }
    else {
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"customerEmailArray"]) {
            NSArray *customerEmailArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"customerEmailArray"];
            NSString *customerEmail = [customerEmailArray firstObject];
            return customerEmail;
        }
        else {
            return nil;
        }
    }
}

+ (void)saveLastLoginEmail:(NSString *)email
{
    [[NSUserDefaults standardUserDefaults] setObject:email forKey:@"lastLoginEmail"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getLastLoginEmail
{
    NSString *email = nil;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"lastLoginEmail"]) {
        email = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastLoginEmail"];
    }
    return email;
}

#pragma mark --

+ (CGSize)calculateNewSizeWithText:(NSString *)text withWidth:(CGFloat)width withFontSize:(CGFloat)fontSize
{
    CGSize newSize = CGSizeZero;
    if (![OMUtility StringIsEmptyWith:text]) {
        CGSize boundingSize = CGSizeMake(width, 9999);
        NSMutableAttributedString *attStr = nil;
        if (text && ![text isKindOfClass:[NSNull class]]) {
            attStr = [[NSMutableAttributedString alloc] initWithString:text];
        }
        NSRange range = NSMakeRange(0, attStr.length);
        if (fontSize>1 && attStr) {
            [attStr addAttribute:NSFontAttributeName
                           value:[UIFont systemFontOfSize:fontSize]
                           range:range];
        }
        if (attStr && ![text isKindOfClass:[NSNull class]] && ![text isEqualToString:@""]) {
            NSDictionary *dic = [attStr attributesAtIndex:0 effectiveRange:&range];
            CGRect descriptionLabelRect = [text boundingRectWithSize:boundingSize options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
            newSize = descriptionLabelRect.size;
        }
    }
    return newSize;
}

+ (CGSize)calculateNewSizeWithText:(NSString *)text withWidth:(CGFloat)width
{
    return [OMUtility calculateNewSizeWithText:text withWidth:width withFontSize:0];
}

+ (CGSize)calculateNewSizeWithText:(NSString *)text withHeight:(CGFloat)height withFontSize:(CGFloat)fontSize
{
    CGSize newSize = CGSizeZero;
    if (![OMUtility StringIsEmptyWith:text]) {
        CGSize boundingSize = CGSizeMake(9999, height);
        NSMutableAttributedString *attStr = nil;
        if (text && ![text isKindOfClass:[NSNull class]]) {
            attStr = [[NSMutableAttributedString alloc] initWithString:text];
        }
        NSRange range = NSMakeRange(0, attStr.length);
        if (fontSize>1 && attStr) {
            [attStr addAttribute:NSFontAttributeName
                           value:[UIFont systemFontOfSize:fontSize]
                           range:range];
        }
        if (attStr && ![text isKindOfClass:[NSNull class]] && ![text isEqualToString:@""]) {
            NSDictionary *dic = [attStr attributesAtIndex:0 effectiveRange:&range];
            CGRect descriptionLabelRect = [text boundingRectWithSize:boundingSize options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
            newSize = descriptionLabelRect.size;
        }
    }
    return newSize;
}

#pragma mark -- CreditCard Number Functions --
+ (NSString *)getCorrectCreditCardNumberWithSpaceNumber:(NSString *)spaceNumer
{
    if (spaceNumer == nil) {
        spaceNumer = @"";
    }
    NSArray *numberArray = [spaceNumer componentsSeparatedByString:@" "];
    NSString *correntNumber = nil;
    if (numberArray && numberArray.count>0) {
        for (NSInteger i = 0; i<numberArray.count; i++) {
            if (correntNumber == nil) {
                correntNumber = [numberArray objectAtIndex:i];
            }
            else {
                NSString *tempStr = [numberArray objectAtIndex:i];
                correntNumber = [NSString stringWithFormat:@"%@%@",correntNumber,tempStr];
            }
        }
    }
    return correntNumber;
}

+ (NSString *)getSpaceCreditCardNumberWithNumber:(NSString *)number
{
    NSString *spaceNumber = nil;
    
    NSString *tempCorrectNumber = [OMUtility getCorrectCreditCardNumberWithSpaceNumber:number];
    if (![OMUtility StringIsEmptyWith:tempCorrectNumber]) {
        if (tempCorrectNumber.length<=4) {
            spaceNumber = tempCorrectNumber;
        }
        else if (tempCorrectNumber.length>4 && tempCorrectNumber.length<=8) {
            NSString *first4Str = [tempCorrectNumber substringWithRange:NSMakeRange(0, 4)];
            NSString *lastStr = [tempCorrectNumber substringFromIndex:4];
            spaceNumber = [NSString stringWithFormat:@"%@ %@",first4Str,lastStr];
        }
        else if (tempCorrectNumber.length>8 && tempCorrectNumber.length<=12) {
            NSString *first4Str = [tempCorrectNumber substringWithRange:NSMakeRange(0, 4)];
            NSString *mid4Str = [tempCorrectNumber substringWithRange:NSMakeRange(4, 4)];
            NSString *lastStr = [tempCorrectNumber substringFromIndex:8];
            spaceNumber = [NSString stringWithFormat:@"%@ %@ %@",first4Str,mid4Str,lastStr];
        }
        else if (tempCorrectNumber.length>12 && tempCorrectNumber.length<=16) {
            NSString *first4Str = [tempCorrectNumber substringWithRange:NSMakeRange(0, 4)];
            NSString *mid4Str = [tempCorrectNumber substringWithRange:NSMakeRange(4, 4)];
            NSString *secMid4Str = [tempCorrectNumber substringWithRange:NSMakeRange(8, 4)];
            NSString *last = [tempCorrectNumber substringFromIndex:12];
            spaceNumber = [NSString stringWithFormat:@"%@ %@ %@ %@",first4Str,mid4Str,secMid4Str,last];
        }
        else if (tempCorrectNumber.length>16 && tempCorrectNumber.length<=19) {
            NSString *first4Str = [tempCorrectNumber substringWithRange:NSMakeRange(0, 4)];
            NSString *mid4Str = [tempCorrectNumber substringWithRange:NSMakeRange(4, 4)];
            NSString *secMid4Str = [tempCorrectNumber substringWithRange:NSMakeRange(8, 4)];
            NSString *thirdMid4Str = [tempCorrectNumber substringWithRange:NSMakeRange(12, 4)];
            NSString *last = [tempCorrectNumber substringFromIndex:16];
            spaceNumber = [NSString stringWithFormat:@"%@ %@ %@ %@ %@",first4Str,mid4Str,secMid4Str,thirdMid4Str,last];
        }
    }
    return spaceNumber;
}

+ (NSString *)getStarSpaceCreditCardNumberWithNumber:(NSString *)number
{
    number = [OMUtility getCorrectCreditCardNumberWithSpaceNumber:number];
    NSString *starSpaceNumber = nil;
    
    NSInteger lastCount = number.length%4;
    NSInteger k = number.length/4;
    if (lastCount == 0) {
        lastCount = 4;
        k--;
    }

    NSString *lastStr = [number substringWithRange:NSMakeRange(number.length-lastCount, lastCount)];
    for (NSInteger i = 0; i<k; i++) {
        if (starSpaceNumber == nil) {
            starSpaceNumber = @"**** ";
        }
        else {
            starSpaceNumber = [NSString stringWithFormat:@"%@**** ",starSpaceNumber];
        }
    }
    starSpaceNumber = [NSString stringWithFormat:@"%@%@",starSpaceNumber,lastStr];
    return starSpaceNumber;
}

#pragma mark -- Day estimate --
+ (NSPUIImageType)NSPUIImageTypeFromData:(NSData *)imageData
{
    if (imageData.length > 4) {
        const unsigned char *bytes = [imageData bytes];
        
        if (bytes[0] == 0xff &&
            bytes[1] == 0xd8 &&
            bytes[2] == 0xff)
        {
            return NSPUIImageType_JPEG;
        }
        
        if (bytes[0] == 0x89 &&
            bytes[1] == 0x50 &&
            bytes[2] == 0x4e &&
            bytes[3] == 0x47)
        {
            return NSPUIImageType_PNG;
        }
    }
    return NSPUIImageType_Unknown;
}

+ (NSString *)imageToBase64StringWith:(UIImage *)image
{
    // scale image
    CGFloat k = image.size.height/image.size.width;
    UIImage *sizedImage = [OMUtility imageWithImageSimple:image scaledToSize:CGSizeMake(540, 540*k)];

    // compress image
    NSData *data = UIImageJPEGRepresentation(sizedImage, 1.0f);
    if (data.length>50*1024) {
        CGFloat k = 0.75;
        CGFloat z = 0.5;
        if (data.length>10*200*1024) {
            k = 0.6;
        }
        while (1) {
            NSData *data = UIImageJPEGRepresentation(sizedImage, z);
//            NSString *fullPathToFile = [SandDocPath() stringByAppendingPathComponent:@"abc.jpg"];
//            NSLog(@"%@",SandDocPath());
//            [data writeToFile:fullPathToFile atomically:NO];
            if (data.length<50*1024) {
//                NSString *fullPathToFile = [SandDocPath() stringByAppendingPathComponent:@"abc.jpg"];
//                NSLog(@"%@",SandDocPath());
//                [data writeToFile:fullPathToFile atomically:NO];
                NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
//                NSLog(@"len = %zd",encodedImageStr.length);
                NSString *resultString = [NSString stringWithFormat:@"%@%@",@"data:image/jpeg;base64,",encodedImageStr];
                return resultString;
            }
            else {
                sizedImage = [UIImage imageWithData:data];
                z *= k;
                if (z<0.1) {
                    z=0.1;
                }
            }
        }
    }
    else {
//        NSString *fullPathToFile = [SandDocPath() stringByAppendingPathComponent:@"abc.jpg"];
//        NSLog(@"%@",SandDocPath());
//        [data writeToFile:fullPathToFile atomically:NO];
        NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        NSString *resultString = [NSString stringWithFormat:@"%@%@",@"data:image/jpeg;base64,",encodedImageStr];
//        NSLog(@"len = %zd",encodedImageStr.length);
        return resultString;
    }
    
    //image -> base64
    
}

+ (UIImage *)getGrayImage:(UIImage *)sourceImage
{
    int width = sourceImage.size.width;
    int height = sourceImage.size.height;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate (nil, width, height, 8, 0, colorSpace, kCGBitmapAlphaInfoMask);
    CGColorSpaceRelease(colorSpace);
    
    if (context == NULL)
    {
        return nil;
    }
    CGContextDrawImage(context,CGRectMake(0, 0, width, height), sourceImage.CGImage);
    UIImage *grayImage = [UIImage imageWithCGImage:CGBitmapContextCreateImage(context)];
    CGContextRelease(context);
    
    return grayImage;
}

#pragma mark -- String --

+ (BOOL)StringIsEmptyWith:(NSString *)string
{
    if (string != nil && ![string isEqualToString:@""] && ![string isKindOfClass:[NSNull class]] && [string isKindOfClass:[NSString class]]) {
        return NO;
    }
    return YES;
}

+ (BOOL)isCorrectMonthString:(NSString *)monthStr
{
    BOOL status = NO;
    if ([OMUtility StringIsEmptyWith:monthStr]) {
        status = NO;
    }
    else if ([monthStr isEqualToString:@"01"] ||
             [monthStr isEqualToString:@"02"] ||
             [monthStr isEqualToString:@"03"] ||
             [monthStr isEqualToString:@"04"] ||
             [monthStr isEqualToString:@"05"] ||
             [monthStr isEqualToString:@"06"] ||
             [monthStr isEqualToString:@"07"] ||
             [monthStr isEqualToString:@"08"] ||
             [monthStr isEqualToString:@"09"] ||
             [monthStr isEqualToString:@"10"] ||
             [monthStr isEqualToString:@"11"] ||
             [monthStr isEqualToString:@"12"]) {
            status = YES;
    }
    return status;
}

+ (BOOL)isCorrectYearString:(NSString *)yearStr
{
    BOOL status = NO;
    if ([OMUtility StringIsEmptyWith:yearStr]) {
        status = NO;
    }
    else {
        NSDate *nowDate = [NSDate date];
        NSString *nowStr = [OMUtility dateToStringWithFormat:@"YYYY" date:nowDate];
        NSString *lastTwoStr = [nowStr substringFromIndex:2];
        NSInteger now = [lastTwoStr integerValue];
        NSInteger year = [yearStr integerValue];
        if (year>=now) {
            status = YES;
        }
    }
    return status;
}

+ (BOOL)isCorrectAvatarUrlString:(id)url
{
    BOOL status = NO;
    if (![url isKindOfClass:[NSNull class]] && url) {
        NSString *avatarUrlstr = (NSString *)url;
        NSArray *urlArray = [avatarUrlstr componentsSeparatedByString:@"/"];
        NSString *lastStr = [urlArray lastObject];
        if (![lastStr isEqualToString:@"null"]) {
            status = YES;
        }
    }
    return status;
}

+ (BOOL)isOnlyDitgitNumberWithString:(NSString *)textString
{
    if ([OMUtility validateNumber:textString]) {
        return YES;
    }
    return NO;
}

+ (BOOL)isOnlyDicamalPointAndDitgitNumberWithString:(NSString *)textString
{
    return [OMUtility validateMoneyNumber:textString];
}

#pragma mark -- Empty estimate --
+ (BOOL)ArrayIsEmptyWith:(NSArray *)array
{
    BOOL status = YES;
    if (array && array.count>0 && ![array isKindOfClass:[NSNull class]] && [array isKindOfClass:[NSArray class]]) {
        status = NO;
    }
    return status;
}

#pragma mark -- Date Format --
+ (NSString *)dateToStringWithFormat:(NSString *)format date:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
//    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"EST"]];
//    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"America/New_York"]];
    [dateFormatter setDateFormat:format];
    NSString *dateStr = [dateFormatter stringFromDate:date];
    return dateStr;
}

+ (NSDate *)stringToDateWithFormat:(NSString *)format string:(NSString *)string
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
//    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"EST"]];
//    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"America/New_York"]];
    [dateFormatter setDateFormat:format];
    NSDate *date = [dateFormatter dateFromString:string];
    return date;
}

+ (NSString *)getMonthStringWithDateString:(NSString *)dateStr
{
    NSString *monthStr = nil;
    NSDate *date = [OMUtility stringToDateWithFormat:@"yyyy-MM-dd HH:mm:ss" string:dateStr];
    NSString *dateString = [OMUtility dateToStringWithFormat:@"MM-dd" date:date];
    NSArray *strArray = [dateString componentsSeparatedByString:@"-"];
    if (strArray && strArray.count>0) {
        NSString *month = [strArray firstObject];
        if ([month isEqualToString:@"01"]) {
            monthStr = @"Jan";
        }
        else if ([month isEqualToString:@"02"]) {
            monthStr = @"Feb";
        }
        else if ([month isEqualToString:@"03"]) {
            monthStr = @"Mar";
        }
        else if ([month isEqualToString:@"04"]) {
            monthStr = @"Apr";
        }
        else if ([month isEqualToString:@"05"]) {
            monthStr = @"May";
        }
        else if ([month isEqualToString:@"06"]) {
            monthStr = @"Jun";
        }
        else if ([month isEqualToString:@"07"]) {
            monthStr = @"July";
        }
        else if ([month isEqualToString:@"08"]) {
            monthStr = @"Aug";
        }
        else if ([month isEqualToString:@"09"]) {
            monthStr = @"Sept";
        }
        else if ([month isEqualToString:@"10"]) {
            monthStr = @"Oct";
        }
        else if ([month isEqualToString:@"11"]) {
            monthStr = @"Nov";
        }
        else if ([month isEqualToString:@"12"]) {
            monthStr = @"Dec";
        }
    }
    return monthStr;
}

+ (NSString *)getDayStringWithDateString:(NSString *)dateStr
{
    NSString *dayStr = nil;
    NSDate *date = [OMUtility stringToDateWithFormat:@"yyyy-MM-dd HH:mm:ss" string:dateStr];
    NSString *dateString = [OMUtility dateToStringWithFormat:@"MM-dd" date:date];
    NSArray *strArray = [dateString componentsSeparatedByString:@"-"];
    if (strArray && strArray.count>0) {
        dayStr = [strArray lastObject];
    }
    return dayStr;
}

+ (NSInteger)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
//    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"EST"]];
//    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"America/New_York"]];
    NSString *oneDayStr = [dateFormatter stringFromDate:oneDay];
    NSString *anotherDayStr = [dateFormatter stringFromDate:anotherDay];
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
    NSComparisonResult result = [dateA compare:dateB];
    if (result == NSOrderedDescending) {
        //dateA>dateB
        return -1;
    }
    else if (result == NSOrderedAscending){
        //dateB>dateA
        return 1;
    }

    return 0;
    
}

+ (NSDate *)nowDateInEST
{
    NSDate *dates = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"America/New_York"];
    [formatter setTimeZone:timeZone];
    NSString *loctime = [formatter stringFromDate:dates];
    
    NSDateFormatter *nf = [[NSDateFormatter alloc] init];
    [nf setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSTimeZone *tz = [NSTimeZone timeZoneWithName:@"Ameriaca/New_York"];
    [nf setTimeZone:tz];
    NSDate *retDate = [nf dateFromString:loctime];
    
    return retDate;
}

+ (NSDate *)nowTimeInEST
{
    NSDate *dates = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"America/New_York"];
    [formatter setTimeZone:timeZone];
    NSString *nowTime = [formatter stringFromDate:dates];
    
    NSDateFormatter *nf = [[NSDateFormatter alloc] init];
    [nf setDateFormat:@"HH:mm"];
    NSTimeZone *tz = [NSTimeZone timeZoneWithName:@"Ameriaca/New_York"];
    [nf setTimeZone:tz];
    NSDate *retDate = [nf dateFromString:nowTime];
    
    return retDate;
}

+ (NSString *)nowHourMiniteInEST
{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"America/New_York"];
    [formatter setTimeZone:timeZone];
    NSString *nowHourMinite = [formatter stringFromDate:date];
    
    return nowHourMinite;
}

+ (NSDate *)timeToDateWith:(NSString *)timeStr
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"HH:mm"];
    [format setTimeZone:[NSTimeZone timeZoneWithName:@"Ameriaca/New_York"]];
    NSDate *retDate = [format dateFromString:timeStr];
    if ([timeStr isEqualToString:@"24:00"]) {
        retDate = [NSDate dateWithTimeInterval:24*60*60 sinceDate:retDate];
    }
    return retDate;
}

+ (BOOL)isAvailableTimeWithStartTime:(NSString *)startTime endTime:(NSString *)endTime
{
    BOOL status = NO;

    NSDate *nowDate = [OMUtility nowTimeInEST];
    NSDate *startDate = [OMUtility timeToDateWith:startTime];
    NSDate *endDate = [OMUtility timeToDateWith:endTime];

    if ([OMUtility compareOneDay:startDate withAnotherDay:nowDate] == 1 &&
        [OMUtility compareOneDay:nowDate withAnotherDay:endDate] == 1) {
        status = YES;
    }
    
    return status;
}

+ (BOOL)isAvailableHourMiniteWithStart:(NSString *)start end:(NSString *)end
{
    if ([OMUtility StringIsEmptyWith:start] || [OMUtility StringIsEmptyWith:end]) {
        return NO;
    }
    BOOL status = NO;
    
    NSString *nowStr = [OMUtility nowHourMiniteInEST];
    NSArray *startArray = [start componentsSeparatedByString:@":"];
    NSArray *nowArray = [nowStr componentsSeparatedByString:@":"];
    NSArray *endArray = [end componentsSeparatedByString:@":"];
    NSString *startFirstStr = [startArray objectAtIndex:0];
    NSString *nowFirstStr = [nowArray objectAtIndex:0];
    NSString *endFirstStr = [endArray objectAtIndex:0];
    NSString *startSecStr = [startArray objectAtIndex:1];
    NSString *nowSecStr = [nowArray objectAtIndex:1];
    NSString *endSecStr = [endArray objectAtIndex:1];
    
    if ([OMDCalculateManager isBiggerDecimalNumberWithStringOne:nowFirstStr stringTwo:startFirstStr] &&
        [OMDCalculateManager isSmallerDecimalNumberWithStringOne:nowFirstStr stringTwo:endFirstStr]) {
        status = YES;
    }
    else if (([OMDCalculateManager isEqualDecimalNumberWithStringOne:nowFirstStr stringTwo:startFirstStr] &&
             ![OMDCalculateManager isSmallerDecimalNumberWithStringOne:nowSecStr stringTwo:startSecStr]) ||
             ([OMDCalculateManager isEqualDecimalNumberWithStringOne:nowFirstStr stringTwo:endFirstStr] &&
              ![OMDCalculateManager isBiggerDecimalNumberWithStringOne:nowSecStr stringTwo:endSecStr])) {
        status = YES;
    }
    else {
        status = NO;
    }
    
    return status;
}

+ (DayOfWeekType)getDayOfWeekType:(NSString *)dayString
{
    DayOfWeekType type = DayOfWeekType_Unknow;
    if ([dayString isEqualToString:@"1"]) {
        type = DayOfWeekType_Mon;
    }
    else if ([dayString isEqualToString:@"2"]) {
        type = DayOfWeekType_Tue;
    }
    else if ([dayString isEqualToString:@"3"]) {
        type = DayOfWeekType_Wed;
    }
    else if ([dayString isEqualToString:@"4"]) {
        type = DayOfWeekType_Thu;
    }
    else if ([dayString isEqualToString:@"5"]) {
        type = DayOfWeekType_Fri;
    }
    else if ([dayString isEqualToString:@"6"]) {
        type = DayOfWeekType_Sat;
    }
    else if ([dayString isEqualToString:@"7"]) {
        type = DayOfWeekType_Sun;
    }
    return type;
}

+ (DayOfWeekType)getDayOfWeekTypeFromNow
{
    NSDate *nowDate = [OMUtility nowDateInEST];
    NSDateFormatter *fmtter = [[NSDateFormatter alloc] init];
    [fmtter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
//    [fmtter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"EST"]];
//    [fmtter setTimeZone:[NSTimeZone timeZoneWithName:@"America/New_York"]];
    [fmtter setDateFormat:@"EEE"];
    NSString *dayString = [fmtter stringFromDate:nowDate];
    if ([OMUtility StringIsEmptyWith:dayString]) {
        return DayOfWeekType_Unknow;
    }
    else if ([dayString hasPrefix:@"Mon"]) {
        return DayOfWeekType_Mon;
    }
    else if ([dayString hasPrefix:@"Tue"]) {
        return DayOfWeekType_Tue;
    }
    else if ([dayString hasPrefix:@"Wed"]) {
        return DayOfWeekType_Wed;
    }
    else if ([dayString hasPrefix:@"Thu"]) {
        return DayOfWeekType_Thu;
    }
    else if ([dayString hasPrefix:@"Fri"]) {
        return DayOfWeekType_Fri;
    }
    else if ([dayString hasPrefix:@"Sat"]) {
        return DayOfWeekType_Sat;
    }
    else if ([dayString hasPrefix:@"Sun"]) {
        return DayOfWeekType_Sun;
    }
    return DayOfWeekType_Unknow;
}

+ (BOOL)isAvailableDatyOfWeekTypeFromNowWith:(NSArray *)array
{
    BOOL status = NO;
    if (![OMUtility ArrayIsEmptyWith:array]) {
        for (NSInteger i = 0; i<array.count; i++) {
            NSString *dayOfWeekString = [array objectAtIndex:i];
            DayOfWeekType type = [OMUtility getDayOfWeekType:dayOfWeekString];
            DayOfWeekType nowType = [OMUtility getDayOfWeekTypeFromNow];
            if (type == nowType) {
                status = YES;
                break;
            }
        }
    }
    else {
        status = YES;
    }
    return status;
}

#pragma mark --
+ (BOOL)validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+ (BOOL)validateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    const char* filePath = [[URL path] fileSystemRepresentation];
    
    const char* attrName = "com.apple.MobileBackup";
    u_int8_t attrValue = 1;
    
    int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
    return result == 0;
}


+ (BOOL)validateNumber:(NSString *)number
{
    NSString *reg = @"^[0-9]*$";
    NSPredicate *numberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", reg];
    return [numberTest evaluateWithObject:number];
}

+ (BOOL)validateMoneyNumber:(NSString *)number
{
    NSString *reg = @"^[0-9.]*$";
    NSPredicate *numberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", reg];
    return [numberTest evaluateWithObject:number];
}

+ (BOOL)isServerVersionBiggerThanLocalVersionWith:(NSString *)localVersion serverVersion:(NSString *)serverVersion
{
    BOOL isBigger = NO;
    NSArray *arrayNow = [localVersion componentsSeparatedByString:@"."];
    NSArray *arrayNew = [serverVersion componentsSeparatedByString:@"."];
    NSInteger i = arrayNew.count > arrayNow.count? arrayNow.count : arrayNew.count;
    NSInteger j = 0;
    BOOL hasResult = NO;
    for (j = 0; j < i; j++) {
        NSString *strNew = [arrayNew objectAtIndex:j];
        NSString *strNow = [arrayNow objectAtIndex:j];
        if ([strNew integerValue] > [strNow integerValue]) {
            hasResult = YES;
            isBigger = YES;
            break;
        }
        if ([strNew integerValue] < [strNow integerValue]) {
            hasResult = YES;
            isBigger = NO;
            break;
        }
    }
    if (!hasResult) {
        if (arrayNew.count > arrayNow.count) {
            NSInteger nTmp = 0;
            NSInteger k = 0;
            for (k = arrayNow.count; k < arrayNew.count; k++) { 
                nTmp += [[arrayNew objectAtIndex:k]integerValue]; 
            } 
            if (nTmp > 0) { 
                isBigger = YES; 
            } 
        } 
    } 
    return isBigger; 
}

+ (void)moveFile
{
    NSString *oriPath = [SandDocPath() stringByAppendingPathComponent:kShoppingCartPlist_key];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:oriPath]) {
        BOOL status = [fileManager moveItemAtPath:oriPath toPath:[OMUtility getShoppingCartPlistPath] error:nil];
        if (status) {
            [fileManager removeItemAtPath:oriPath error:nil];
        }
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"customerIdArray"]) {
        NSArray *customerArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"customerIdArray"];
        NSString *avatarUrl = [OMUtility getCurrentCustomerAvatarUrlWithNeedLogin:NO];
        if (![OMUtility isCorrectAvatarUrlString:avatarUrl]) {
            [OMUtility saveCurrentCustomerAvatarImageUrlWith:nil];
        }
        for (NSInteger i = 0; i<customerArray.count; i++) {
            NSString *customerId = [customerArray objectAtIndex:i];
            NSString *key = [NSString stringWithFormat:@"avatar-%@.png",customerId];
            NSString *oPath = [SandDocPath() stringByAppendingPathComponent:key];
            if ([fileManager fileExistsAtPath:oPath]) {
                BOOL status = [fileManager moveItemAtPath:oPath toPath:[UserPath stringByAppendingPathComponent:key] error:nil];
                if (status) {
                    [fileManager removeItemAtPath:oPath error:nil];
                }
            }
        }
    }
}

@end
