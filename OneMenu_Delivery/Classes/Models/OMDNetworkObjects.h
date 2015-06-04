//
//  OMDNetworkObjects.h
//  OneMenu_Delivery
//
//  Created by simmyoung on 15/6/4.
//  Copyright (c) 2015年 One Menu Limited Liability Company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OMDNetworkObjects : NSObject

@end

@interface OMDNetworkBaseRequest : NSObject

@property (nonatomic, copy) NSString *customerId;
@property (nonatomic, copy) NSString *deviceId;
@property (nonatomic, copy) NSString *longitude;
@property (nonatomic, copy) NSString *latitude;

@end

@interface OMDNetworkBaseResult : NSObject

@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *msg;

@end

