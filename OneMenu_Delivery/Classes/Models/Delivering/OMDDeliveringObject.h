//
//  OMDDeliveringObject.h
//  OneMenu_Delivery
//
//  Created by simmyoung on 15/6/4.
//  Copyright (c) 2015年 One Menu Limited Liability Company. All rights reserved.
//

#import "OMDBaseObject.h"

@interface OMDDeliveringObject : OMDBaseObject

// rest info
@property (nonatomic, copy) NSString *restId;
@property (nonatomic, copy) NSString *restName;
//@property (nonatomic, copy) NSString *restLongitude;
//@property (nonatomic, copy) NSString *restLatitude;

@property (nonatomic, strong) NSArray *orderArray;

@end

typedef NS_ENUM(NSInteger, OrderStatus)
{
    OrderStatus_DriverUnConfirm = 0,
    OrderStatus_DriverConfirmed,
    OrderStatus_DriverCancel,
    OrderStatus_DriverDone
};

@interface OMDDeliveringOrderObject : OMDBaseObject

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

@interface OMDDeliveringDetailObject : OMDBaseObject

// onemenu info
@property (nonatomic, copy) NSString *isOMOrder;
@property (nonatomic, copy) NSString *custName;
@property (nonatomic, copy) NSString *custPhone;
@property (nonatomic, copy) NSString *custAddr;
@property (nonatomic, copy) NSString *orderCode;
@property (nonatomic, copy) NSString *custLongitude;
@property (nonatomic, copy) NSString *custLatitude;
@property (nonatomic, strong) NSArray *dishArray;

// commons info
@property (nonatomic, copy) NSString *billPrice;
@property (nonatomic, assign) OrderStatus status;

@end

@interface OMDDeliveringDishObject : OMDBaseObject

@property (nonatomic, copy) NSString *dishName;
@property (nonatomic, copy) NSString *dishPrice;
@property (nonatomic, strong) NSArray *ingredientArray;

@end
