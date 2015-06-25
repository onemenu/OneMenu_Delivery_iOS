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

// keys
#define kAppLocalVersion_key @"localVersion"

// font name
#define kArial_key          @"Arial"
#define kHelvetica_key      @"Helvetica"

// Notifications
static NSString * const kRemoteNotification = @"remoteNotification";
static NSString * const kLoginSuccessedNotification = @"loginSuccessedNotification";
static NSString * const kLoginFailureNotification = @"loginFailureNotification";
static NSString * const kAutoLoginSuccessedNotification = @"autoLoginSuccessedNotification";
static NSString * const kAutoLoginFailureNotification = @"autoLoginFailureNotification";
static NSString * const kGetLocationSuccessNotification = @"getLocationSuccessNotification";
static NSString * const kGetLocationFailureNotification = @"getLocationFailureNotification";
static NSString * const kGetLocationDeniedNotification = @"getLocationDeniedNotification";

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


#define APP_MANAGER



#endif

