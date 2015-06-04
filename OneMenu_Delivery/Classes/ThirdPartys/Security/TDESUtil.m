//
//  TDESUtil.m
// jqb_v2
//
//  Created by luozhiling on 14-8-11.
//  Copyright (c) 2014年 EFunds. All rights reserved.
//

#import "TDESUtil.h"
#import <CommonCrypto/CommonCryptor.h>
#import "NSError+String.h"

@implementation TDESUtil

+ (NSData *)encryptWithData:(NSData *)content secretKey:(NSString *)key error:(NSError *__autoreleasing *)error
{
    size_t plainTextBufferSize = [content length];
    const void *vplainText = (const void *)[content bytes];
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));//可以手动创建buffer，但之后要记得free掉
    memset((void *)bufferPtr, 0x0, bufferPtrSize);//TODO:采用ios中宏定义好的方法分配空间，可免去手动free
    
    const void *vkey = (const void *) [key UTF8String];
    //    const void *vinitVec = (const void *) [EFUND_TDES_IV UTF8String];//2013-07-29注释
    
    //加密数据，采用库中的CCCrypt方法，这个方法会按次序执行CCCrytorCreate(),
    // CCCryptorUpdate(), CCCryptorFinal(), and CCCryptorRelease() 如果开发者自己create这个对象，
    //那么后面就必须执行final、release之类的函数，CCCrypt方法一次性解决
    
    ccStatus = CCCrypt(kCCEncrypt,//方式：kCCEncrypt加密 或 kCCDecrypt解密
                       kCCAlgorithm3DES,//加密算法为3DES,其他有kCCAlgorithmAES128，kCCAlgorithmDES
                       kCCOptionPKCS7Padding|kCCOptionECBMode,//模式，这里各平台保持一致，kCCOptionPKCS7Padding还有kCCOptionECBMode或kCCOptionPKCS7Padding|kCCOptionECBMode
                       vkey,//加密密匙 UTF8的字符串
                       kCCKeySize3DES,//密匙长度字节 各算法有对应的长度宏
                       nil,//TODO:增加随机字符，可指定也可不指定，各平台之间不绝对//2013-07-29设置为nil，本来是vinitVec
                       vplainText,//待加密串的字节长度
                       plainTextBufferSize,//待加密串的长度
                       (void *)bufferPtr,//输出已加密串的内存地址
                       bufferPtrSize,//已加密串的大小
                       &movedBytes);
    
    NSData *retData = nil;
    if (ccStatus == kCCSuccess) {//判断是否加密成功
        retData = [NSData dataWithBytes:bufferPtr length:movedBytes];
    }else{
        //TODO:log error.
        if (error) {
            *error = [NSError errorWithDomain:@"LogicError"
                                         code:-97
                                     errorMsg:[NSString stringWithFormat:@"3des encrypt error with ccStatus:%d",ccStatus]];
        }
    }
    free(bufferPtr);
    return retData;
}

+(NSData *)decryptWithData:(NSData *)encryptContent secretKey:(NSString *)key error:(NSError *__autoreleasing *)error
{
    size_t plainTextBufferSize = [encryptContent length];
    const void *vplainText = (const void *)[encryptContent bytes];
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));//可以手动创建buffer，但之后要记得free掉
    memset((void *)bufferPtr, 0x0, bufferPtrSize);//TODO:采用ios中宏定义好的方法分配空间，可免去手动free
    
    const void *vkey = (const void *) [key UTF8String];
    //    const void *vinitVec = (const void *) [EFUND_TDES_IV UTF8String];//2013-07-29注释
    
    //加密数据，采用库中的CCCrypt方法，这个方法会按次序执行CCCrytorCreate(),
    // CCCryptorUpdate(), CCCryptorFinal(), and CCCryptorRelease() 如果开发者自己create这个对象，
    //那么后面就必须执行final、release之类的函数，CCCrypt方法一次性解决
    
    ccStatus = CCCrypt(kCCDecrypt,//方式：kCCEncrypt加密 或 kCCDecrypt解密
                       kCCAlgorithm3DES,//加密算法为3DES,其他有kCCAlgorithmAES128，kCCAlgorithmDES
                       kCCOptionPKCS7Padding|kCCOptionECBMode,//模式，这里各平台保持一致，kCCOptionPKCS7Padding还有kCCOptionECBMode或kCCOptionPKCS7Padding|kCCOptionECBMode
                       vkey,//加密密匙 UTF8的字符串
                       kCCKeySize3DES,//密匙长度字节 各算法有对应的长度宏
                       nil,//TODO:增加随机字符，可指定也可不指定，各平台之间不绝对//2013-07-29设置为nil，本来是vinitVec
                       vplainText,//待加密串的字节长度
                       plainTextBufferSize,//待加密串的长度
                       (void *)bufferPtr,//输出已加密串的内存地址
                       bufferPtrSize,//已加密串的大小
                       &movedBytes);
    
    NSData *retData = nil;
    if (ccStatus == kCCSuccess) {//判断是否加密成功
        retData = [NSData dataWithBytes:bufferPtr length:movedBytes];
    }else{
        //TODO:log error.
        if (error) {
            *error = [NSError errorWithDomain:@"LogicError"
                                         code:-97
                                     errorMsg:[NSString stringWithFormat:@"3des descrypt error with ccStatus:%d",ccStatus]];
        }
    }
    free(bufferPtr);
    return retData;

}

@end
