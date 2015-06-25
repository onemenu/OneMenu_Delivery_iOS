//
//  OMDDeliveredObject.h
//  OneMenu_Delivery
//
//  Created by simmyoung on 15/6/7.
//  Copyright (c) 2015年 One Menu Limited Liability Company. All rights reserved.
//

#import "OMDDeliveringObject.h"

//@class OMDDeliveringDetailObject;

@interface OMDDeliveredObject : OMDBaseObject

@property (nonatomic, copy) NSString *restId;
@property (nonatomic, copy) NSString *restName;

// onemenu info
//@property (nonatomic, copy) NSString *custName;
@property (nonatomic, copy) NSString *custAddr;
@property (nonatomic, copy) NSString *billPrice;

// commons info
@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, copy) NSString *readyInTime;
@property (nonatomic, copy) NSString *isOMOrder;
@property (nonatomic, assign) OrderStatus status;

@end

@interface OMDDeliveredDetailObject : OMDDeliveringDetailObject

@end