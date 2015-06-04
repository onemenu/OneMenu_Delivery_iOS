//
//  OMDLocationManager.m
//  OneMenu
//
//  Created by simmyoung on 14-10-8.
//  Copyright (c) 2014年 One Menu Limited Liability Company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OMDLocationManager : NSObject

+ (OMDLocationManager *)sharedInstance;

- (void)start;
- (void)stop;
- (void)refresh;
- (NSString *)latitude;
- (NSString *)longitude;
- (NSString *)province;
- (NSString *)city;
- (NSString *)region;
- (NSString *)detailAddress;
- (NSString *)postalCode;

@end
