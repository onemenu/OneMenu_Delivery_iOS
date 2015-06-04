//
//  OMDNetworkManger.h
//  OneMenu_Delivery
//
//  Created by simmyoung on 15/6/4.
//  Copyright (c) 2015年 One Menu Limited Liability Company. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"
#import "OMDNetworkObjects.h"

typedef void (^CurrencyResponseDictionaryBlock)(NSDictionary *);
typedef void (^CurrencyResponseArrayBlock)(NSArray *);
typedef void (^CurrencyResponseStringBlock)(NSString *);

typedef void (^CurrencyResponseObjectBlock)(OMDNetworkBaseResult *responseObj);
typedef void (^CurrencyFailureBlock)(OMDNetworkBaseResult *responseObj, NSError *error);

@interface OMDNetworkManager : AFHTTPRequestOperationManager

+ (id)createNetworkEngineer;
+ (void)destroyEngineer;

@end
