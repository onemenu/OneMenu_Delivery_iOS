//
//  OMDNetworkObjects.h
//  OneMenu_Delivery
//
//  Created by simmyoung on 15/6/4.
//  Copyright (c) 2015年 One Menu Limited Liability Company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OMDDeliveringObject.h"

@interface OMDNetworkObjects : NSObject

@end

@interface OMDNetworkBaseRequest : NSObject

@property (nonatomic, copy) NSString *driverId;
@property (nonatomic, copy) NSString *deviceId;
@property (nonatomic, copy) NSString *longitude;
@property (nonatomic, copy) NSString *latitude;

@end

@interface OMDNetworkBaseResult : NSObject

@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *msg;

@end

//test
@interface OMDAllOrderRequest : OMDNetworkBaseRequest

@property (nonatomic, copy) NSString *startNum;
@property (nonatomic, copy) NSString *range;

@end

@interface OMDAllOrderResult : OMDNetworkBaseResult

@property (nonatomic, strong) NSArray *allOrderArray;

@end

@interface OMDAssignOrderRequest : OMDNetworkBaseRequest

@property (nonatomic, copy) NSString *orderId;

@end

@interface OMDAssignOrderResult : OMDNetworkBaseResult

@end

@interface OMDGetDriverListRequest : OMDNetworkBaseRequest

@end

@interface OMDGetDriverListResult : OMDNetworkBaseResult

@property (nonatomic, strong) NSArray *driverList;

@end

@interface OMDChangeDriverOnDutyRequest : OMDNetworkBaseRequest

@property (nonatomic, copy) NSString *isOnDuty;

@end

@interface OMDChangeDriverOnDutyResult : OMDNetworkBaseResult

@end

#pragma mark -- Commons --
@interface OMDAppConfigRequest : OMDNetworkBaseRequest

@end

@interface OMDAppConfigResult : OMDNetworkBaseResult

@property (nonatomic, copy) NSString *hostName;
@property (nonatomic, copy) NSString *appVersion;
@property (nonatomic, copy) NSString *forceUpdate;

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

@property (nonatomic, strong) OMDDeliveringDetailObject *detailObj;

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
@property (nonatomic, copy) NSString *tipsType;
@property (nonatomic, copy) NSString *tipsFee;

@end

@interface OMDDoneOrderResult : OMDNetworkBaseResult

@end

@interface OMDResetOrderPriceRequest : OMDNetworkBaseRequest

@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, copy) NSString *billPrice;

@end

@interface OMDResetOrderPriceResult : OMDNetworkBaseResult

@end

#pragma mark -- OMDDevliered --
@interface OMDDeliveredListRequest : OMDNetworkBaseRequest

@property (nonatomic, copy) NSString *startNum;
@property (nonatomic, copy) NSString *range;

@end

@interface OMDDeliveredListResult : OMDNetworkBaseResult

@property (nonatomic, strong) NSArray *listArray;

@end

@interface OMDDeliveredDetailRequest : OMDNetworkBaseRequest

@property (nonatomic, copy) NSString *orderId;

@end

@interface OMDDeliveredDetailResult : OMDNetworkBaseResult

@end

#pragma mark -- Login --

@interface OMDSignUpRequest : OMDNetworkBaseRequest

@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *name;

@end

@interface OMDSignUpResult : OMDNetworkBaseResult

@property (nonatomic, copy) NSString *driverId;

@end

@interface OMDLoginRequest : OMDNetworkBaseRequest

@property (nonatomic, copy) NSString *account;
@property (nonatomic, copy) NSString *password;

@end

@interface OMDLoginResult : OMDNetworkBaseResult

@property (nonatomic, copy) NSString *driverId;
@property (nonatomic, copy) NSString *loginToken;

@end

@interface OMDAutoLoginRequest : OMDNetworkBaseRequest

@property (nonatomic, copy) NSString *loginToken;

@end

@interface OMDAutoLoginResult : OMDNetworkBaseResult

@property (nonatomic, copy) NSString *driverId;
@property (nonatomic, copy) NSString *loginToken;

@end

