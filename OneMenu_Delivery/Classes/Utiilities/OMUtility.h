//
//  OMDUtility.h
//  OneMenu
//
//  Created by simmyoung on 14-8-19.
//  Copyright (c) 2014年 One Menu Limited Liability Company. All rights reserved.
//

#import <MobileCoreServices/MobileCoreServices.h>
#import "OMDConstantsFile.h"
#import "OMDCalculateManager.h"


typedef NS_ENUM(NSInteger, NSPUIImageType) {
    NSPUIImageType_JPEG,
    NSPUIImageType_PNG,
    NSPUIImageType_Unknown
};

typedef NS_ENUM(NSInteger, LoginType) {
    LoginType_Non = -1,
    LoginType_Email = 0,
    LoginType_ThirdParty_Facebook = 1,
    LoginType_ThirdParty_Twitter = 2,
    LoginType_ThirdParty_WeChat = 3
};

typedef NS_ENUM(NSInteger, DayOfWeekType) {
    DayOfWeekType_Unknow = 0,
    DayOfWeekType_Mon,
    DayOfWeekType_Tue,
    DayOfWeekType_Wed,
    DayOfWeekType_Thu,
    DayOfWeekType_Fri,
    DayOfWeekType_Sat,
    DayOfWeekType_Sun
};

@interface OMUtility : NSObject

#pragma mark -- Login Status --
+ (BOOL)isLogined;
+ (void)logout;
+ (void)saveLoginType:(LoginType)type;
+ (LoginType)getLoginType;
+ (void)setBadgeWith:(NSInteger)num;
+ (void)clearBadge;
+ (void)setShoppingCartBadge;

+ (void)decreaseAppBadgeWith:(NSInteger)count;
+ (void)increaseAppBadgeWith:(NSInteger)count;
+ (void)clearAppBadge;

+ (void)saveAppServerVersionWith:(NSString *)serverVersion;
+ (NSString *)getAppServerVersion;
+ (void)saveNotificationDeviceTokenWith:(NSString *)deviceToken;
+ (NSString *)getNotifacationDeviceToken;

#pragma mark -- Location --
+ (void)saveCustomerCreditCardNum:(NSString *)cardNum;
+ (NSString *)getCustomerCreditCardNum;
+ (NSString *)getCustomerCreditCardNumWithNeedLogin:(BOOL)needLogin;

+ (void)saveCustomerCreditCardMonth:(NSString *)month;
+ (NSString *)getCustomerCreditCardMonth;
+ (NSString *)getCustomerCreditCardMonthWithNeedLogin:(BOOL)needLogin;

+ (void)saveCustomerCreditCardYear:(NSString *)year;
+ (NSString *)getCustomerCreditCardYear;
+ (NSString *)getcustomerCreditCardYearWithNeedLogin:(BOOL)needLogin;

+ (void)saveCustomerCreditCardHolder:(NSString *)holder;
+ (NSString *)getCustomerCreditCardHolder;
+ (NSString *)getCustomerCreditCardHolderWithNeedLogin:(BOOL)needLogin;

+ (void)saveCustomerCreditCardPostalCode:(NSString *)postalCode;
+ (NSString *)getCustomerCreditCardPostalCode;
+ (NSString *)getCustomerCreditCardPostalCodeWithNeedLogin:(BOOL)needLogin;

+ (void)saveCustomerPhone:(NSString *)phoneStr;
+ (NSString *)getCustomerPhone;
+ (NSString *)getCustomerPhoneWithNeedLogin:(BOOL)needLogin;

+ (void)saveCustomerAddress:(NSString *)addressStr;
+ (NSString *)getCustomerAddress;
+ (NSString *)getCustomerAddressWithNeedLogin:(BOOL)needLogin;

+ (void)saveCustomerStreet:(NSString *)streetStr;
+ (NSString *)getCustomerStreet;
+ (NSString *)getCustomerStreetWithNeedLogin:(BOOL)needLogin;

+ (void)saveCustomerApt:(NSString *)aptStr;
+ (NSString *)getCustomerApt;
+ (NSString *)getCustomerAptWithNeedLogin:(BOOL)needLogin;

+ (void)saveCustomerCity:(NSString *)cityStr;
+ (NSString *)getCustomerCity;
+ (NSString *)getCustomerCityWithNeedLogin:(BOOL)needLogin;

+ (void)saveCustomerZipCode:(NSString *)zipCode;
+ (NSString *)getCustomerZipCode;
+ (NSString *)getCustomerZipCodeWithNeedLogin:(BOOL)needLogin;

#pragma mark -- Customer Info --
+ (NSString *)getLocalTax;
+ (void)saveLocalTaxWith:(NSString *)taxStr;

+ (void)saveRejectUpdateAppTime;
+ (BOOL)shouldAlertUpdateApp;

+ (void)saveCurrentCheckOutType:(CheckOutType)type;
+ (CheckOutType)getCurrentCheckOutType;
+ (CheckOutType)getCurrentCheckOutTypeWithNeedLogin:(BOOL)needLogin;

+ (void)saveCurrentCustomerAvatarImageWith:(UIImage *)image;
+ (UIImage *)getCurrentCustomerAvatarImage;
+ (UIImage *)getCurrentCustomerAvatarImageWithNeedLogin:(BOOL)needLogin;

+ (void)saveCurrentCustomerNameWith:(NSString *)userName;
+ (NSString *)getCurrentCustomerName;
+ (NSString *)getCurrentCustomerNameWithNeedLogin:(BOOL)needLogin;

+ (void)saveCurrentCustomerIdWith:(NSString *)customerId;
+ (NSString *)getCurrentCustomerId;
+ (NSString *)getCurrentCustomerIdWithNeedLogin:(BOOL)needLogin;

+ (void)saveCurrentCustomerAvatarImageUrlWith:(NSString *)path;
+ (NSString *)getCurrentCustomerAvatarUrl;
+ (NSString *)getCurrentCustomerAvatarUrlWithNeedLogin:(BOOL)needLogin;

+ (void)saveCurrentCustomerLoginToken:(NSString *)loginToken;
+ (NSString *)getCurrentCustomerLoginToken;
+ (NSString *)getCurrentCustomerLoginTokenWithNeedLogin:(BOOL)needLogin;

+ (void)saveCurrentCustomerEmail:(NSString *)email;
+ (NSString *)getCurrentCustomerEmail;
+ (NSString *)getcurrentcustomerEmailWithNeedLogin:(BOOL)needLogin;

+ (NSString *)getShoppingCartPlistPath;

+ (void)saveLastLoginEmail:(NSString *)email;
+ (NSString *)getLastLoginEmail;

#pragma mark --
+ (NSString *)getKeyWith:(NSString *)string;
+ (NSString *)getKeyWith:(NSString *)string needLogin:(BOOL)needLogin;
+ (NSString *)eggshellString;

+ (NSString *)imageToBase64StringWith:(UIImage *)image;

#pragma mark -- Camera --
+ (BOOL)isCameraAvailable;
+ (BOOL)isRearCameraAvailable;
+ (BOOL)isFrontCameraAvailable;
+ (BOOL)doesCameraSupportTakingPhotos;
+ (BOOL)isPhotoLibraryAvailable;

+ (BOOL)canUserPickVideosFromPhotoLibrary;
+ (BOOL)canUserPickPhotosFromPhotoLibrary;
+ (BOOL)cameraSupportsMedia:(NSString *)paramMediaType
                 sourceType:(UIImagePickerControllerSourceType)paramSourceType;

#pragma mark -- Image Operation --
+ (NSPUIImageType)NSPUIImageTypeFromData:(NSData *)imageData;
+ (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage;
+ (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage
                                          targetSize:(CGSize)targetSize;
+ (UIImage *)imageWithImageSimple:(UIImage *)image scaledToSize:(CGSize)newSize;
+ (UIImage *)getGrayImage:(UIImage *)sourceImage;
+ (UIImage *)screenImage;

#pragma mark -- Rect Calculate --
+ (CGRect)calculateRectWithBgRect:(CGRect)oriRect bgWHRate:(NSString *)bgWHRateStr subWHRate:(NSString *)subWHRateStr;

#pragma mark -- Text Calculate --
+ (CGSize)calculateNewSizeWithText:(NSString *)text withWidth:(CGFloat)width;
+ (CGSize)calculateNewSizeWithText:(NSString *)text withWidth:(CGFloat)width withFontSize:(CGFloat)fontSize;
+ (CGSize)calculateNewSizeWithText:(NSString *)text withHeight:(CGFloat)height withFontSize:(CGFloat)fontSize;

#pragma mark -- CreditCard Number Functions --
+ (NSString *)getCorrectCreditCardNumberWithSpaceNumber:(NSString *)spaceNumer;
+ (NSString *)getSpaceCreditCardNumberWithNumber:(NSString *)number;
+ (NSString *)getStarSpaceCreditCardNumberWithNumber:(NSString *)number;

#pragma mark -- String Estimate --
+ (BOOL)StringIsEmptyWith:(NSString *)string;
+ (BOOL)isCorrectMonthString:(NSString *)monthStr;
+ (BOOL)isCorrectYearString:(NSString *)yearStr;
+ (BOOL)isCorrectAvatarUrlString:(id)url;
+ (BOOL)isOnlyDitgitNumberWithString:(NSString *)textString;
+ (BOOL)isOnlyDicamalPointAndDitgitNumberWithString:(NSString *)textString;

#pragma mark -- Empty estimate --
+ (BOOL)ArrayIsEmptyWith:(NSArray *)array;

#pragma mark -- Date Format --
+ (NSDate *)nowDateInEST;
+ (NSDate *)nowTimeInEST;
+ (NSDate *)timeToDateWith:(NSString *)timeStr;
+ (NSString *)dateToStringWithFormat:(NSString *)format date:(NSDate *)date;
+ (NSDate *)stringToDateWithFormat:(NSString *)format string:(NSString *)string;
+ (NSString *)getMonthStringWithDateString:(NSString *)dateStr;
+ (NSString *)getDayStringWithDateString:(NSString *)dateStr;
+ (NSInteger)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay;
+ (BOOL)isAvailableTimeWithStartTime:(NSString *)startTime endTime:(NSString *)endTime;
+ (BOOL)isAvailableHourMiniteWithStart:(NSString *)start end:(NSString *)end;
+ (DayOfWeekType)getDayOfWeekType:(NSString *)dayString;
+ (DayOfWeekType)getDayOfWeekTypeFromNow;
+ (BOOL)isAvailableDatyOfWeekTypeFromNowWith:(NSArray *)array;

#pragma mark -- validate --
+ (BOOL)validateEmail:(NSString *)email;
+ (BOOL)validateMobile:(NSString *)mobile;

+ (BOOL)validateNumber:(NSString *)number;

+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL;
+ (BOOL)isServerVersionBiggerThanLocalVersionWith:(NSString *)localVersion serverVersion:(NSString *)serverVersion;

+ (void)moveFile;

+ (NSString *)nowHourMiniteInEST;

@end
