//
//  OMDNetworkManger.m
//  OneMenu_Delivery
//
//  Created by simmyoung on 15/6/4.
//  Copyright (c) 2015年 One Menu Limited Liability Company. All rights reserved.
//

#import "OMDNetworkManager.h"

#define kHostName @"hppt://onemenu.delivery/"

#define kPostKey @"POST"
#define kGetKey @"GET"

static OMDNetworkManager *nwManager;

@implementation OMDNetworkManager

+ (id)createNetworkEngineer
{
    @synchronized(self) {
        if (nil == nwManager) {
            nwManager = [OMDNetworkManager manager];
        }
    }
    return nwManager;
}

+ (void)destroyEngineer
{
    @synchronized(self) {
        if (nwManager) {
            nwManager = nil;
        }
    }
}

- (NSString *)getUrlStringWith:(NSString *)path
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",kHostName,path];
    return urlString;
}

#pragma mark -- Request Methods --

@end
