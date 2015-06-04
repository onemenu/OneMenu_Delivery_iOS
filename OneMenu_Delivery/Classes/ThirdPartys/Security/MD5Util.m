/*==========================================================================
 *
 * File Name: MD5Util.m
 *      Desc: MD5加密解密类
 *      Auth: CGB
 *      Date: 2013/05/09
 *      Modi:
 *
 *==========================================================================*/

#import "MD5Util.h"
#import <CommonCrypto/CommonDigest.h>

@implementation MD5Util

+ (NSString *)encryptByMD5String:(NSString *)content
{
    if(!content)
        return nil;
    const char *original_str = [content UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash lowercaseString];
}

+ (NSString *)encryptByMD5StringForScreenLock:(NSString *)content
{
    NSString *privateKey = @"woshiyigechengxuyuan";
    content = [NSString stringWithFormat:@"%@%@",privateKey,content];
    if(!content)
        return nil;
    const char *original_str = [content UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash lowercaseString];
}

@end
