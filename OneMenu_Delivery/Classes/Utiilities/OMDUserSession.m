//
//  OMUserSession.m
//  OneMenu
//
//  Created by simmyoung on 14-9-1.
//  Copyright (c) 2014年 One Menu Limited Liability Company. All rights reserved.
//

#import "OMDUserSession.h"

static OMDUserSession *userSession = nil;
@implementation OMDUserSession

+ (OMDUserSession *)shareInstance
{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        userSession = [[self alloc] init];
    });
    return userSession;
}

@end
