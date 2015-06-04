//
//  TDESUtil.h
// jqb_v2
//
//  Created by luozhiling on 14-8-11.
//  Copyright (c) 2014年 EFunds. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDESUtil : NSObject

/**
 * 加密
 */
+(NSData *)encryptWithData:(NSData *)content
                     secretKey:(NSString *)key
                         error:(NSError *__autoreleasing *)error;

/**解密*/
+(NSData *)decryptWithData:(NSData *)encryptContent
                   secretKey:(NSString *)key
                       error:(NSError *__autoreleasing *)error;

@end
