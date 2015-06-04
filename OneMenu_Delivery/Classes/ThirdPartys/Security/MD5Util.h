/*==========================================================================
 *
 * File Name: MD5Util.h
 *      Desc: MD5加密解密类
 *      Auth: CGB
 *      Date: 2013/05/09
 *      Modi:
 *
 *==========================================================================*/

#import <Foundation/Foundation.h>

//32位的加密
@interface MD5Util : NSObject

//返回小写的加密字符串
+ (NSString *)encryptByMD5String:(NSString *)content;//加密,参数为加密内容

//返回手势密码专用的小谢的加密字符串
+ (NSString *)encryptByMD5StringForScreenLock:(NSString *)content;

@end
