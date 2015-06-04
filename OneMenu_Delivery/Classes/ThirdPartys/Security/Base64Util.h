/*==========================================================================
 *
 * File Name: Base64Util.h
 *      Desc: Base64加密解密类
 *      Auth: CGB
 *      Date: 2013/05/08
 *      Modi:
 *
 *==========================================================================*/

#import <Foundation/Foundation.h>
//base64加密解密类,是对GTMBase64类的再次封装
@interface Base64Util : NSObject
+ (NSString*)encodeBase64WithData:(NSData *)data;//加密-nsdata
+ (NSData*)decodeBase64String:(NSString *)base64String;//解密-nsdata
@end
