//
//  OMDAllOrderObject.h
//  OneMenu_Delivery
//
//  Created by simmyoung on 15/6/21.
//  Copyright (c) 2015年 One Menu Limited Liability Company. All rights reserved.
//

#import "OMDBaseObject.h"
#import "OMDDeliveredObject.h"

@interface OMDAllOrderObject : OMDBaseObject

@property (nonatomic, copy) NSString *driverId;
@property (nonatomic, copy) NSString *driverName;
@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, copy) NSString *orderCode;
@property (nonatomic, copy) NSString *inReadyTime;
@property (nonatomic, copy) NSString *restName;
@property (nonatomic, copy) NSString *restId;

@property (nonatomic, assign) OrderStatus status;

@end
