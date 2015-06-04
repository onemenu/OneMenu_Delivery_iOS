//
//  EFundSecUtil.m
// jqb_v2
//
//  Created by luozhiling on 14-7-31.
//  Copyright (c) 2014年 EFunds. All rights reserved.
//

#import "EFundSecUtil.h"
#import "TDESUtil.h"
#import "Base64Util.h"
#import "EKeyChain.h"

static NSString * const kDefault3DESKey = @"#$#$fasdfasdf$#%DFA^1234325";

@implementation EFundSecUtil

+(NSString *)encryptWithString:(NSString *)content
                     secretKey:(NSString *)key
                         error:(NSError *__autoreleasing *)error
{
    //TODO:合法性校验
    
    //utf8编码字符串转换成bytes
    NSData *utf8Bytes = [content dataUsingEncoding:NSUTF8StringEncoding];
    
    //3DES加密
    NSData *encryptData = [TDESUtil encryptWithData:utf8Bytes secretKey:key error:error];
    
    //base64编码
    return [Base64Util encodeBase64WithData:encryptData];
}

+(NSString *)decryptWithData:(NSString *)encryptContent
                   secretKey:(NSString *)key
                       error:(NSError *__autoreleasing *)error
{
    //base64 解码
    NSData *encryptData = [Base64Util decodeBase64String:encryptContent];
    
    //3DES 解码
    NSData *decryptData = nil;
    if (encryptData) {
        decryptData = [TDESUtil decryptWithData:encryptData secretKey:key error:error];
    }
    
    //返回utf8字符串
    NSString *retString = nil;
    if (decryptData) {
        retString = [[NSString alloc] initWithData:decryptData encoding:NSUTF8StringEncoding];
    }
    
    return retString;
}

+ (void)safeSaveData:(id<NSCoding>)data forKey:(NSString *)key error:(NSError *__autoreleasing *)error
{
    NSAssert(key, @"key should not be nil");
    
    if (data==nil) {
        [EKeyChain delete:key];
        return;
    }
    //keycode编码
    NSData *archivedData = [NSKeyedArchiver archivedDataWithRootObject:data];
    
    
    //先用3DES加密
    NSData *encodeData = [TDESUtil encryptWithData:archivedData secretKey:kDefault3DESKey error:error];
    
    if (encodeData!=nil) {
        //再存入操作系统keychain中
        [EKeyChain save:key data:encodeData];
    }
}

+ (id)safeLoadDataForKey:(NSString *)key error:(NSError *__autoreleasing *)error
{
    //先从操作系统keychain中读取数据
    NSData *encodeData = [EKeyChain load:key];
    
    if (encodeData==nil) {
        return nil;
    }
    //再进行3DES解密
    NSData *archivedData = [TDESUtil decryptWithData:encodeData secretKey:kDefault3DESKey error:error];
    
    //keycode解码
    if (archivedData!=nil) {
        return [NSKeyedUnarchiver unarchiveObjectWithData:archivedData];
    }
    return nil;
}



@end
