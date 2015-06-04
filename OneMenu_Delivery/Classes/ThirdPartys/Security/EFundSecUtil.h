//
//  EFundSecUtil.h
// jqb_v2
//
//  Created by luozhiling on 14-7-31.
//  Copyright (c) 2014年 EFunds. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EFundSecUtil : NSObject

/**
 * 加密
 */
+(NSString *)encryptWithString:(NSString *)content
                     secretKey:(NSString *)key
                         error:(NSError *__autoreleasing *)error;

/**解密*/
+(NSString *)decryptWithData:(NSString *)encryptContent
                   secretKey:(NSString *)key
                       error:(NSError *__autoreleasing *)error;

/**本地加密保存数据*/
+(void)safeSaveData:(id<NSCoding>)data forKey:(NSString *)key error:(NSError *__autoreleasing *)error;

/**
 *  读取本地加密数据
 *
 *  @param key <#key description#>
 *
 *  @return <#return value description#>
 */
+ (id)safeLoadDataForKey:(NSString *)key error:(NSError *__autoreleasing *)error;

@end
