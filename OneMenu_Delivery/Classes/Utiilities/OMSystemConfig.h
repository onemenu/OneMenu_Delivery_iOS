//
//  OMSystemConfig.h
//  OneMenu
//
//  Created by simmyoung on 14-8-19.
//  Copyright (c) 2014年 One Menu Limited Liability Company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OMSystemConfig : NSObject

//获取mac地址
+ (NSString *)queryMacAddress;
//获取设备序列号
+ (NSString *)queryDeviceIdentifier;
//获取设备序列号-Hash
+ (NSString *)queryHashIdentifier;
//获取idfa，广告标示符
+ (NSString *)queryIDFA;
//获取idfv，Vendor标示符
+ (NSString *)queryIDFV;
//获取设备别名:用户定义的名称
+ (NSString *)queryDeviceName;
//获取设备名称
+ (NSString *)querySystemName;
//获取设备系统版本
+ (NSString *)querySystemVersion;
//获取设备型号
+ (NSString *)queryDeviceModel;
//获取地方型号(国际化区域名称)
+ (NSString *)queryLocalizedModel;
//获取应用名称
+ (NSString *)queryAppName;
//获取应用版本号
+ (NSString *)queryAppVersion;
/**获取应用版本号,带子版本*/
+ (NSString *)queryAppVersionBuild;
//获取应用签名
+ (NSString *)queryAppIdentifier;
//获取设备的型号名称,如iPhone 4s,iPhone 5
+ (NSString *)queryDeviceModelName;

@end
