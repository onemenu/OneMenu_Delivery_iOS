//
//  NSError+String.h
//  OneMenu
//
//  Created by simmyoung on 14-8-19.
//  Copyright (c) 2014年 One Menu Limited Liability Company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (String)

+(id)errorWithDomain:(NSString *)domain code:(NSInteger)code errorMsg:(NSString *)errMsg;

@end
