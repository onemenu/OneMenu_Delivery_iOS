/*==========================================================================
 *
 * File Name: EKeyChain.h
 *      Desc: KeyChain操作类
 *      Auth: CGB
 *      Date: 2013/05/20
 *      Modi:
 *
 *==========================================================================*/

#import <Foundation/Foundation.h>

@interface EKeyChain : NSObject

//保存
+(void)save:(NSString *)ekey data:(id)data;
//获取
+(id)load:(NSString *)ekey;
//删除
+(void)delete:(NSString *)ekey;

@end
