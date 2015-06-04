/*==========================================================================
 *
 * File Name: EKeyChain.m
 *      Desc: KeyChain操作类
 *      Auth: CGB
 *      Date: 2013/05/20
 *      Modi:
 *
 *==========================================================================*/

#import "EKeyChain.h"
#import <Security/Security.h>

@implementation EKeyChain

/*-------------------------------------------------------------------------
 * Function Name: getKeychainQuery:
 *          Desc: 获取keychain的内容
 *-------------------------------------------------------------------------*/
+(NSMutableDictionary *)getKeychainQuery:(NSString *)ekey{
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (__bridge id)kSecClassGenericPassword,(__bridge id)kSecClass,
            ekey,(__bridge id)kSecAttrService,
            ekey,(__bridge id)kSecAttrAccount,
            (__bridge id)kSecAttrAccessibleAfterFirstUnlock,(__bridge id)kSecAttrAccessible,nil];
}
/*-------------------------------------------------------------------------
 * Function Name: save: data:
 *          Desc: 保存
 *-------------------------------------------------------------------------*/
+(void)save:(NSString *)ekey data:(id)data{
    //Get search dictionary
    NSMutableDictionary *keychainQuery=[self getKeychainQuery:ekey];
    
    //Delete old item before add new item
    SecItemDelete((__bridge CFDictionaryRef)keychainQuery);
    //Add new object to search dictionary(Attention:the data format)
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(__bridge id)kSecValueData];
    //Add item to keychain with the search dictionary
    SecItemAdd((__bridge CFDictionaryRef)keychainQuery, NULL);
}
/*-------------------------------------------------------------------------
 * Function Name: load:
 *          Desc: 获取
 *-------------------------------------------------------------------------*/
+(id)load:(NSString *)ekey{
    id ret=nil;
    NSMutableDictionary *keychainQuery=[self getKeychainQuery:ekey];
    //Configure the search setting
    //Since in our simple case we are expecting only a single attribute to be returned
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
    [keychainQuery setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    CFDataRef keyData=NULL;
    if(SecItemCopyMatching((__bridge CFDictionaryRef)keychainQuery,(CFTypeRef *)&keyData)==noErr){
        @try {
            ret=[NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        }
        @catch (NSException *exception) {
            NSLog(@"unarchive failed:%@",exception);
        }
        @finally {
            
        }
    } 
    if(keyData)
        CFRelease(keyData);
    return ret;
}
/*-------------------------------------------------------------------------
 * Function Name: delete:
 *          Desc: 删除
 *-------------------------------------------------------------------------*/
+(void)delete:(NSString *)ekey{
    NSMutableDictionary *keychainQuery=[self getKeychainQuery:ekey];
    SecItemDelete((__bridge CFDictionaryRef)keychainQuery);
}

@end
