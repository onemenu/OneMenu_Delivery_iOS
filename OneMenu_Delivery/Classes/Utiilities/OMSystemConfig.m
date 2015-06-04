//
//  OMSystemConfig.m
//  OneMenu
//
//  Created by simmyoung on 14-8-19.
//  Copyright (c) 2014年 One Menu Limited Liability Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OMSystemConfig.h"
//获取mac地址需要用到的头文件
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
//判断设备型号需要用到的头文件
#import <sys/utsname.h>
#import <AdSupport/AdSupport.h>
#import "MD5Util.h"

#define IDENTIFIER_HASH_KEY @"IDENTIFIER_HASH_KEY_EASY_EFUND_PHONE"

@implementation OMSystemConfig

/*-------------------------------------------------------------------------
 * Function Name: queryMacAddress
 *          Desc: 获取mac地址
 *-------------------------------------------------------------------------*/
+ (NSString *)queryMacAddress{
    int mib[6];
    size_t len;
    char *buf;
    unsigned char *ptr;
    struct if_msghdr *ifm;
    struct sockaddr_dl *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if((mib[5]=if_nametoindex("en0"))==0){
        return NULL;
    }
    
    if(sysctl(mib, 6,NULL, &len, NULL, 0)<0){
        return NULL;
    }
    
    if((buf=malloc(len))==NULL){
        free(buf);
        return NULL;
    }
    
    if(sysctl(mib, 6,buf, &len, NULL, 0)<0){
        free(buf);
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm+1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outStr = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x",*ptr,*(ptr+1),*(ptr+2),*(ptr+3),*(ptr+4),*(ptr+5)];
    free(buf);
    return outStr;
}

/*-------------------------------------------------------------------------
 * Function Name: queryDeviceIdentifier
 *          Desc: 获取设备序列号
 *-------------------------------------------------------------------------*/
+ (NSString *)queryDeviceIdentifier{
    NSString *macAddress = [[self queryMacAddress] copy];
    NSString *uniqueIdentifier = [MD5Util encryptByMD5String:macAddress];
    return uniqueIdentifier;
}
/*-------------------------------------------------------------------------
 * Function Name: queryHashIdentifier
 *          Desc: 获取设备序列号-Hash
 *-------------------------------------------------------------------------*/
+ (NSString *)queryHashIdentifier{
    NSString *macAddress = [self queryMacAddress];
    if([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f){
        //
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        macAddress = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
#pragma clang diagnostic pop
        if(macAddress == nil){
            macAddress = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        }
    }
//    NSString *hashStr=[[NSString stringWithFormat:@"%@%@",macAddress,IDENTIFIER_HASH_KEY] retain];
//    NSString *uniqueIdentifier=[EFundsAPI encryptByMD5:hashStr];
//    [hashStr release];
    NSString *uniqueIdentifier = [NSString stringWithFormat:@"%@",macAddress];
    return uniqueIdentifier;
}
/*-------------------------------------------------------------------------
 * Function Name: queryIDFA
 *          Desc: 获取idfa 广告标示符
 *-------------------------------------------------------------------------*/
+ (NSString *)queryIDFA{
    NSString *macAddress = nil;
    if([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f){
        //确定7.0sdk有此函数，忽略警告
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        macAddress = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
#pragma clage diagnostic pop
        
    }
    if(nil == macAddress)
        macAddress = @"";
    NSString *uniqueIdentifier = [NSString stringWithFormat:@"%@",macAddress];
    return uniqueIdentifier;
}
/*-------------------------------------------------------------------------
 * Function Name: queryIDFV
 *          Desc: 获取idfv Vendor标示符
 *-------------------------------------------------------------------------*/
+ (NSString *)queryIDFV{
    NSString *macAddress = nil;
    if([[UIDevice currentDevice].systemVersion floatValue]>=7.0f){
        macAddress = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    }
    if(nil == macAddress)
        macAddress = @"";
    NSString *uniqueIdentifier = [NSString stringWithFormat:@"%@",macAddress];
    return uniqueIdentifier;
}
/*-------------------------------------------------------------------------
 * Function Name: queryDeviceName
 *          Desc: 获取设备别名:用户定义的名称
 *-------------------------------------------------------------------------*/
+ (NSString *)queryDeviceName{
    return [[UIDevice currentDevice] name];
}
/*-------------------------------------------------------------------------
 * Function Name: querySystemName
 *          Desc: 获取设备名称
 *-------------------------------------------------------------------------*/
+ (NSString *)querySystemName{
    return [[UIDevice currentDevice] systemName];
}
/*-------------------------------------------------------------------------
 * Function Name: querySystemVersion
 *          Desc: 获取设备系统版本
 *-------------------------------------------------------------------------*/
+ (NSString *)querySystemVersion{
    return [[UIDevice currentDevice] systemVersion];
}
/*-------------------------------------------------------------------------
 * Function Name: queryDeviceModel
 *          Desc: 获取设备型号
 *-------------------------------------------------------------------------*/
+ (NSString *)queryDeviceModel{
    return [[UIDevice currentDevice] model];
}
/*-------------------------------------------------------------------------
 * Function Name: queryLocalizedModel
 *          Desc: 获取地方型号(国际化区域名称)
 *-------------------------------------------------------------------------*/
+ (NSString *)queryLocalizedModel{
    return [[UIDevice currentDevice] localizedModel];
}
/*-------------------------------------------------------------------------
 * Function Name: queryAppName
 *          Desc: 获取应用名称
 *-------------------------------------------------------------------------*/
+ (NSString *)queryAppName{
    NSDictionary *dict = [[NSBundle mainBundle] infoDictionary];
    NSString *appName = [dict objectForKey:@"CFBundleDisplayName"];
    return appName;
}
/*-------------------------------------------------------------------------
 * Function Name: queryAppVersion
 *          Desc: 获取应用版本号
 *-------------------------------------------------------------------------*/
+ (NSString *)queryAppVersion{
    NSDictionary *dict = [[NSBundle mainBundle] infoDictionary];
    return [dict objectForKey:@"CFBundleShortVersionString"];
}

/**获取应用版本号,带子版本*/
+ (NSString *)queryAppVersionBuild
{
    NSDictionary *dict = [[NSBundle mainBundle] infoDictionary];
    return  [dict objectForKey:@"CFBundleVersion"];
}

///*-------------------------------------------------------------------------
// * Function Name: queryAppVersionStr
// *          Desc: 获取应用版本号字符串
// *-------------------------------------------------------------------------*/
//+(NSString *)queryAppVersionStr{
//    NSDictionary *dict=[[NSBundle mainBundle] infoDictionary];
//    NSString *appVersionStr=[dict objectForKey:@"CFBundleShortVersionString"];
//    return appVersionStr;
//}
//
///**获取应用BuildSrcVersion （svn版本号）*/
//+(NSString *)queryAppBuildSrcVersion
//{
//    NSDictionary *dict=[[NSBundle mainBundle] infoDictionary];
//    return  [dict objectForKey:@"BuildSrcVersion"];
//}

/*-------------------------------------------------------------------------
 * Function Name: queryAppIdentifier
 *          Desc: 获取应用签名
 *-------------------------------------------------------------------------*/
+ (NSString *)queryAppIdentifier{
    return [[NSBundle mainBundle] bundleIdentifier];;
}
/*-------------------------------------------------------------------------
 * Function Name: queryDeviceModelName
 *          Desc: 获取设备的型号名称
 *-------------------------------------------------------------------------*/
+ (NSString *)queryDeviceModelName{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceName = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    /*
    //iPhone
    if([deviceName isEqualToString:@"iPhone1,1"])
        return @"iPhone 1";
    if([deviceName isEqualToString:@"iPhone1,2"])
        return @"iPhone 3G";
    if([deviceName isEqualToString:@"iPhone2,1"])
        return @"iPhone 3GS";
    if([deviceName isEqualToString:@"iPhone3,1"])
        return @"iPhone 4(移动,联通)";
    if([deviceName isEqualToString:@"iPhone3,2"])
        return @"iPhone 4(联通)";
    if([deviceName isEqualToString:@"iPhone3,3"])
        return @"iPhone 4(电信)";
    if([deviceName isEqualToString:@"iPhone4,1"])
        return @"iPhone 4S";
    if([deviceName isEqualToString:@"iPhone5,1"])
        return @"iPhone 5(移动,联通)";
    if([deviceName isEqualToString:@"iPhone5,2"])
        return @"iPhone 5(移动,联通,电信)";
    if([deviceName hasPrefix:@"iPhone"])
        return @"Latest iPhone 5";
    //iPod touch
    if([deviceName isEqualToString:@"iPod1,1"])
        return @"iPod Touch 1";
    if([deviceName isEqualToString:@"iPod2,1"])
        return @"iPod Touch 2";
    if([deviceName isEqualToString:@"iPod3,1"])
        return @"iPod Touch 3";
    if([deviceName isEqualToString:@"iPod4,1"])
        return @"iPod Touch 4";
    if([deviceName isEqualToString:@"iPod5,1"])
        return @"iPod Touch 5";
    if([deviceName hasPrefix:@"iPod"])
        return @"Latest iPod Touch 5";
    //iPad
    if([deviceName isEqualToString:@"iPad1,1"])
        return @"iPad 1";
    if([deviceName isEqualToString:@"iPad2,1"])
        return @"iPad 2(WiFi)";
    if([deviceName isEqualToString:@"iPad2,2"])
        return @"iPad 2(GSM)";
    if([deviceName isEqualToString:@"iPad2,3"])
        return @"iPad 2(CDMA)";
    if([deviceName isEqualToString:@"iPad2,4"])
        return @"iPad 2(32nm)";
    if([deviceName isEqualToString:@"iPad2,5"])
        return @"iPad mini(WiFi)";
    if([deviceName isEqualToString:@"iPad2,6"])
        return @"iPad mini(GSM)";
    if([deviceName isEqualToString:@"iPad2,7"])
        return @"iPad mini(CDMA)";
    if([deviceName isEqualToString:@"iPad3,1"])
        return @"iPad 3(WiFi)";
    if([deviceName isEqualToString:@"iPad3,2"])
        return @"iPad 3(CDMA)";
    if([deviceName isEqualToString:@"iPad3,3"])
        return @"iPad 3(4G)";
    if([deviceName isEqualToString:@"iPad3,4"])
        return @"iPad 4(WiFi)";
    if([deviceName isEqualToString:@"iPad3,5"])
        return @"iPad 4(4G)";
    if([deviceName isEqualToString:@"iPad3,6"])
        return @"iPad 4(CDMA)";
    if([deviceName hasPrefix:@"iPad"])
        return @"Latest iPad 4";
    //Simulator
    if([deviceName isEqualToString:@"i386"])
        return @"Simulator";
    if([deviceName isEqualToString:@"x86_64"])
        return @"Simulator";
     */
    return deviceName;
}

@end
