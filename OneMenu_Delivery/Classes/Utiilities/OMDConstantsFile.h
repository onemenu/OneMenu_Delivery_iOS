//
//  OMDConstantsFile.h
//  OneMenu
//
//  Created by OneMenu on 14/8/18.
//  Copyright (c) 2014年 Three Idiot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#ifndef ONEMENU_OMDConstantFile_h
#define ONEMENU_OMDConstantFile_h

#ifdef DEBUG
#ifndef DLog
#   define DLog(fmt, ...) {NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);}
#endif
#ifndef ELog
#   define ELog(err) {if(err) DLog(@"%@", err)}
#endif
#else
#ifndef DLog
#   define DLog(...)
#endif
#ifndef ELog
#   define ELog(err)
#endif
#endif

// ALog always displays output regardless of the DEBUG setting
#ifndef ALog
#define ALog(fmt, ...) {NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);};
#endif

#define kDeviceiOSVersion [[[UIDevice currentDevice] systemVersion] floatValue]
#define IOS8  (__IPHONE_OS_VERSION_MAX_ALLOWED >= 80000) && ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define IOS7  (__IPHONE_OS_VERSION_MAX_ALLOWED >= 70000) && ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define IOS6  (__IPHONE_OS_VERSION_MAX_ALLOWED >= 60000) && ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)

#define iPad kScreenHeight>(1334/2)
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone4 [[UIScreen mainScreen] bounds].size.height<568

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define NavigationBarYPosition 64.0

#define ImageWithBundlePath(name)   [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:name ofType:nil]]
#define ImageWithSandBoxPath(imgPath)   [UIImage imageWithContentsOfFile:imgPath]
#define ImageWithImageName(name) [UIImage imageNamed:name]

#define UrlWithString(string) [NSURL URLWithString:string]

// doc paths
#define SandDocPath()				[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex: 0]
#define CacheDocPath()				[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex: 0]
#define CurrentUserDocPath(userName) [SandDocPath stringByAppendingPathComponent:userName]
#define CurrentUserAvatarPath(userName) [CurrentUserDocPath(userName) stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-icon.png"],userName]

#define UserPath    [SandDocPath() stringByAppendingPathComponent:@"UserPath"]

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define UIColorFromRGBValues(rValue,gValue,bValue,aValue) [UIColor colorWithRed:rValue/255.0 green:gValue/255.0 blue:bValue/255.0 alpha:aValue]

// global size
#define kScreenWidth [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height

//#define kBgViewColor [UIColor whiteColor]
#define kBgViewColor [UIColor groupTableViewBackgroundColor]

//datasource delegate
#define kDatasource(SEL) self.datasource && [self.datasource respondsToSelector:@selector(SEL)]
#define kDelegate(SEL) self.delegate && [self.delegate respondsToSelector:@selector(SEL)]

#define kProtocol(NAME,SEL) self.NAME && [self.NAME respondsToSelector:@selector(SEL)]

// OMBaseViewController
#define kSearchBarNavigationTag    77
#define kLeftNavigationButtonTag    78
#define kRightNavigationButtonTag   79+1000
#define kNavigationTitleLabelTag    80
#define kToastViewTag 1101

#define kDefaultNavigationBarHeight   44
#define kDefaultTabbarHeight          49

#define kMainScrollViewTag            44

// OMOneMenuCell
#define kOneMenuCell_Dish_Label_height       25
#define kOneMenuCell_Review_Name_height 25
#define kOneMenuCell_Review_Icon_height 25
#define kOneMenuCell_Review_Title_height 42

// Global
#define kNavigationBarHeight self.navigationController.navigationBar.frame.size.height
#define kStateBarHeight 20

// const values
static NSTimeInterval const timeInterval = 10;  // seconds

// Const String
#define kCheckNetConnection         @"Check network connection"
#define kUnableLoad                 @"Unable to load. Retry plz!"
#define kUnableLoadMore             @"Lol, you run out of new feeds."
#define kEmptyNotice                @"Required Field(s) Missing"

// ShoppingCart
#define kTakeOut_key    @"Take Out"
#define kDelivery_key   @"Delivery"
#define kShoppingCartPlist_key  @"shoppingCart.plist"

// Commons
#define kOrderDishObject_key    @"orderDishObject"
#define kLocalTax_key           @"localTax"

// keys
#define kAppLocalVersion_key @"localVersion"

// font name
#define kArial_key          @"Arial"
#define kHelvetica_key      @"Helvetica"

// Notifications
static NSString * const kTabbarIconNotification = @"tabbarIconNotification";
static NSString * const kRemoteNotification = @"remoteNotification";
static NSString * const kAddToShoppingCartNotification = @"addToShoppingCartNotification";
static NSString * const kDownLoadAvatarImageCompletedNotification = @"downLoadAvatarImageCompletedNotification";
static NSString * const kLogoutNotification = @"logoutNotification";
static NSString * const kLoginSuccessedNotification = @"loginSuccessedNotification";
static NSString * const kLoginFailureNotification = @"loginFailureNotification";
static NSString * const kCheckoutSuccessNotification = @"checkoutSuccessNotification";
static NSString * const kGetLocationSuccessNotification = @"getLocationSuccessNotification";
static NSString * const kGetLocationFailureNotification = @"getLocationFailureNotification";
static NSString * const kGetLocationDeniedNotification = @"getLocationDeniedNotification";
static NSString * const kGetCustomerCouponsSuccessedNotification = @"saveCouponSuccessedNotification";

//const string
static NSString * const kDishStatus_Delete = @"-1";
static NSString * const kDishStatus_Normal = @"1";
static NSString * const kDishStatus_OutOfOrder = @"0";

static NSString * const kRestaurantStatus_Disable = @"0";
static NSString * const kRestaurantStatus_Enable = @"1";

//tarde Type
static NSString * const kTradeType_TakeOut = @"1";
static NSString * const kTradeType_Delivery = @"2";

//thirdParty Type
static NSString * const kThirdParty_Facebook = @"1";
static NSString * const kThirdParty_Twitter = @"2";
static NSString * const kThirdParty_WeChat = @"3";

//login Type
static NSString * const kLoginType_Email = @"0";
static NSString * const kLoginType_Facebook = @"1";
static NSString * const kLoginType_Twitter = @"2";
static NSString * const kLoginType_WeChat = @"3";

//coupon Target Type
static NSString * const kCouponTarget_Dish = @"1";
static NSString * const kCouponTarget_Rawbill = @"2";
static NSString * const kCouponTarget_Trade = @"3";

//coupon ExtraCri Type
static NSString * const kCouponExtraCri_Non = @"0";
static NSString * const kCouponExtraCri_Dish = @"1";
static NSString * const kCouponExtraCri_Rawbill = @"2";
static NSString * const kCouponExtraCri_Trade = @"3";

//coupon Type
static NSString * const kCouponType_SpecialPrice = @"1";
static NSString * const kCouponType_DiscountPrice = @"2";
static NSString * const kCouponType_DiscountPercentage = @"3";
static NSString * const kCouponType_Free = @"4";

//type define
typedef NS_ENUM(int, CheckOutType) {
    CheckOutType_Non = 0,
    CheckOutType_Delivery = 1,
    CheckOutType_TakeOut = 2
};

typedef NS_ENUM(int, DeliveryStatus) {
    DeliveryStatus_Unavailable = 0,
    DeliveryStatus_Available = 1
};

typedef NS_ENUM(int, TakeOutStatus) {
    TakeOutStatus_Unavailable = 0,
    TakeOutStatus_Available = 1
};


#pragma mark -- Error Code --
// Common Code
#define kSuccessCode @"1"
#define kErrorCode @"0"

// Error code
// Common error code
#define kGetDataEmpty @"100001" //请求时没有数据
#define kDataNotExist @"100002" //数据不存在

// OneMenu error code

// Restaurant error code

// ShoppingCart error code

// About me

#pragma mark -- Param keys --
#define kData_key   @"data"
#define kStatus_key @"status"
#define kMsg_key    @"msg"

#pragma mark -- Public keys --
#define kTrue_key   @"1"
#define kFail_key   @"0"


//#define APP_TEST 1
//#define APP_SIMULATION 1
//#define APP_LOGIN 1

#define APP_LOCATION_TEST

//#define APP_HOST

//#define APP_BETA

#define APP_CHECKOUT

#ifdef APP_LOGIN
#define kIsLoginBefore_key @"isLoginBefore"
#endif

#endif

