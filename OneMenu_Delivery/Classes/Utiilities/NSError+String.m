//
//  NSError+String.m
//  OneMenu
//
//  Created by simmyoung on 14-8-19.
//  Copyright (c) 2014年 One Menu Limited Liability Company. All rights reserved.
//

#import "NSError+String.h"

@implementation NSError (String)

+ (id)errorWithDomain:(NSString *)domain code:(NSInteger)code errorMsg:(NSString *)errMsg
{
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:errMsg?errMsg:@""
                                                         forKey:NSLocalizedFailureReasonErrorKey];
    return [NSError errorWithDomain:domain?domain:@""
                               code:code
                           userInfo:userInfo];
}

@end
