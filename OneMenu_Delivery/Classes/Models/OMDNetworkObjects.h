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

@property (nonatomic, copy) NSString *driveId;
@property (nonatomic, copy) NSString *deviceId;
@property (nonatomic, copy) NSString *longitude;
@property (nonatomic, copy) NSString *latitude;

@end

@interface OMDNetworkBaseResult : NSObject

@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *msg;

@end

#pragma mark -- OMDDelivering --
@interface OMDDeliveringListRequest : OMDNetworkBaseRequest

@end

@interface OMDDeliveringListResult : OMDNetworkBaseResult

@property (nonatomic, strong) NSArray *listArray;

@end

@interface OMDDeliveringDetailRequest : OMDNetworkBaseRequest

@property (nonatomic, copy) NSString *orderId;

@end

@interface OMDDeliveringDetailResult : OMDNetworkBaseResult

@end

@interface OMDConfirmOrderRequest : OMDNetworkBaseRequest

@property (nonatomic, copy) NSString *orderId;

@end

@interface OMDConfirmOrderResult : OMDNetworkBaseResult

@end

@interface OMDCancelOrderRequest : OMDNetworkBaseRequest

@property (nonatomic, copy) NSString *orderId;

@end

@interface OMDCancelOrderResult : OMDNetworkBaseResult

@end

@interface OMDDoneOrderRequest : OMDNetworkBaseRequest

@property (nonatomic, copy) NSString *orderId;

@end

@interface OMDDoneOrderResult : OMDNetworkBaseResult

@end

#pragma mark -- OMDDevliered --
@interface OMDDeliveredListRequest : OMDNetworkBaseRequest

@property (nonatomic, copy) NSString *startNum;
@property (nonatomic, copy) NSString *range;

@end

@interface OMDDeliveredListResult : OMDNetworkBaseResult

@end

@interface OMDDeliveredDetailRequest : OMDNetworkBaseRequest

@property (nonatomic, copy) NSString *orderId;

@end

@interface OMDDeliveredDetailResult : OMDNetworkBaseResult

@end

#pragma mark -- Login --
@interface OMDLoginRequest : OMDNetworkBaseRequest

@property (nonatomic, copy) NSString *account;
@property (nonatomic, copy) NSString *password;

@end

@interface OMDLoginResult : OMDNetworkBaseResult

@end

