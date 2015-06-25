//
//  OMUserSession.h
//  OneMenu
//
//  Created by simmyoung on 14-9-1.
//  Copyright (c) 2014年 One Menu Limited Liability Company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OMDUserSession : NSObject

@property (nonatomic, assign) BOOL isLogined;

@property (nonatomic, copy) NSString *driverId;

+ (OMDUserSession *)shareInstance;

@end
