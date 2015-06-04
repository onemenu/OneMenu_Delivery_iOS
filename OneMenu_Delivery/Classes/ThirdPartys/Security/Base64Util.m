/*==========================================================================
 *
 * File Name: Base64Util.m
 *      Desc: Base64加密解密类
 *      Auth: CGB
 *      Date: 2013/05/08
 *      Modi:
 *
 *==========================================================================*/

#import "Base64Util.h"
#import "GTMBase64.h"

@implementation Base64Util

+(NSString *)encodeBase64WithData:(NSData *)data{
    //base64 默认使用ascii编码  （跟utf8编码结果是一样的）
    return [GTMBase64 stringByEncodingData:data];
}

+ (NSData *)decodeBase64String:(NSString *)base64String
{
    return [GTMBase64 decodeString:base64String];
}

@end
