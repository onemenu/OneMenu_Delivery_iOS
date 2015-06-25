//
//  OMDNetworkManger.m
//  OneMenu_Delivery
//
//  Created by simmyoung on 15/6/4.
//  Copyright (c) 2015年 One Menu Limited Liability Company. All rights reserved.
//

#import "OMDNetworkManager.h"
#import "OMDUtility.h"
#import "OMDLocationManager.h"
#import "OMSystemConfig.h"

#import "OMDDeliveringObject.h"

// manager
#import "OMDAllOrderObject.h"
#import "OMDManagerCell.h"

//#define kHostName @"http://onemenu.mobi/"
#define kHostName @"http://development-wbsssi2pys.elasticbeanstalk.com"

#pragma mark -- Commons --
#define kGetAppConfigPath @""

#pragma mark -- Delivering --

//test
#define kGetAllOrderListPath @"/app/delivery/allOrders"
#define kAssignOrderPath @"/app/delivery/assignOrderFormToDriver"
#define kGetDriverListPath @"/app/delivery/allDrivers"
#define kChangeDriverOnDutyPath @"/app/delivery/onduty"

#define kGetDeliveringListPath @"/app/delivery/getDeliveryOrderFormListByDriverId"
#define kGetDeliveringDetailPath @"/app/delivery/getDetailOrder"
#define kConfirmOrderPath @"/app/delivery/confirmOrderFormByDriver"
#define kCancelOrderPath @"/app/delivery/cancelOrderByDriver"
#define kDoneOrderPath @"/app/delivery/finishOrderByDriver"
#define kResetOrderPricePath @"/app/delivery/billPriceByDriver"

#pragma mark -- Delivered --
#define kGetDeliveredListPath @""
#define kGetDeliveredDetailPath @""

#pragma mark -- Login --
#define kLoginPath @"/app/delivery/login"
#define kAutoLoginPath @"/app/delivery/autoLogin"
#define kSignUpPath @"/app/delivery/appSignUp"

#define kPostKey @"POST"
#define kGetKey @"GET"

static NSString * const Order_Status_Cancel = @"0";
static NSString * const Order_Status_Finished = @"1";
static NSString * const Order_Status_Restaurant_Pending = @"2";
static NSString * const Order_Status_Restaurant_Confirmed = @"3";
static NSString * const Order_Status_Call_Delivery = @"4";
static NSString * const Order_Status_Driver_Pending = @"5";
static NSString * const Order_Status_Delivery_Confirmed = @"6";

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

#pragma mark -- Test Request Methods --

- (void)testRequest
{
    NSString *urlString = [self getUrlStringWith:@"/app/menu/listMenuItem"];
    NSMutableDictionary *param = [self getParamWithRequest:nil needDriverId:NO];
    [param setObject:@"0" forKey:@"startNum"];
    [param setObject:@"25" forKey:@"range"];
    [param setObject:@"A" forKey:@"type"];
    [param setObject:@"" forKey:@"tags"];
    
    AFHTTPRequestOperation *op = [self POST:urlString
                                 parameters:param
                                    success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                        NSDictionary *dict = (NSDictionary *)responseObject;
    }
                                    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (void)getAllOrderListWith:(OMDAllOrderRequest *)request
              completeBlock:(CurrencyResponseObjectBlock)completeBlock
               failureBlock:(CurrencyFailureBlock)failureBlock
{
    NSString *urlString = [self getUrlStringWith:kGetAllOrderListPath];
    NSMutableDictionary *param = [self getParamWithRequest:request needDriverId:NO];
//    [param setObject:request.startNum forKey:@"startNum"];
//    [param setObject:request.range forKey:@"range"];
    AFHTTPRequestOperation *op = [self POST:urlString
                                 parameters:request
                                    success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                        NSDictionary *dict = (NSDictionary *)responseObject;
                                        NSLog(@"all order dict = %@",dict);
                                        OMDAllOrderResult *result = [[OMDAllOrderResult alloc] init];
                                        result.status = [dict objectForKey:kStatus_key];
                                        result.msg = [dict objectForKey:kMsg_key];
                                        if ([result.status isEqualToString:kSuccessCode]) {
                                            NSDictionary *dataDict = [dict objectForKey:kData_key];
                                            NSArray *ordersArray = [dataDict objectForKey:@"ordersArray"];
                                            NSMutableArray *listArray = [NSMutableArray array];
                                            for (NSInteger i = 0; i<ordersArray.count; i++) {
                                                NSDictionary *orderDict = [ordersArray objectAtIndex:i];
                                                OMDAllOrderObject *obj = [[OMDAllOrderObject alloc] init];
                                                obj.inReadyTime = [orderDict objectForKey:@"inReadyTime"];
                                                obj.driverId = [orderDict objectForKey:@"driverId"];
                                                obj.driverName = [orderDict objectForKey:@"driverName"];
                                                obj.orderCode = [orderDict objectForKey:@"orderCode"];
                                                obj.restName = [orderDict objectForKey:@"restName"];
                                                obj.restId = [orderDict objectForKey:@"restId"];
                                                NSString *status = [orderDict objectForKey:@"status"];
                                                if ([status isEqualToString:Order_Status_Driver_Pending] || [status isEqualToString:Order_Status_Call_Delivery]) {
                                                    obj.status = OrderStatus_DriverUnConfirm;
                                                }
                                                else if ([status isEqualToString:Order_Status_Delivery_Confirmed]) {
                                                    obj.status = OrderStatus_DriverConfirmed;
                                                }
                                                [listArray addObject:obj];
                                            }
                                            result.allOrderArray = listArray;
                                        }
                                        if (completeBlock) {
                                            completeBlock(result);
                                        }
    }
                                    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                        if (failureBlock) {
                                            failureBlock(op,error);
                                        }
    }];
}

- (void)assignOrderWith:(OMDAssignOrderRequest *)request
          completeBlock:(CurrencyResponseObjectBlock)completeBlock
           failureBlock:(CurrencyFailureBlock)failureBlock
{
    NSString *urlString = [self getUrlStringWith:kAssignOrderPath];
    NSMutableDictionary *param = [self getParamWithRequest:request needDriverId:YES];
    [param setObject:request.orderId forKey:@"orderFormId"];
    
    AFHTTPRequestOperation *op = [self POST:urlString
                                 parameters:param
                                    success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                        NSDictionary *dict = (NSDictionary *)responseObject;
                                        NSLog(@"assign dict = %@",dict);
                                        OMDAssignOrderResult *result = [[OMDAssignOrderResult alloc] init];
                                        result.status = [dict objectForKey:kStatus_key];
                                        result.msg = [dict objectForKey:kMsg_key];
                                        if ([result.status isEqualToString:kSuccessCode]) {
                                            
                                        }
                                        if (completeBlock) {
                                            completeBlock(result);
                                        }
    }
                                    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                        if (failureBlock) {
                                            failureBlock(op,error);
                                        }
    }];
}

- (void)getDriverListWith:(OMDGetDriverListRequest *)request completeBlock:(CurrencyResponseObjectBlock)completeBlock failureBlock:(CurrencyFailureBlock)failureBlock
{
    NSString *urlString = [self getUrlStringWith:kGetDriverListPath];
    NSMutableDictionary *param = [self getParamWithRequest:request needDriverId:YES];
    AFHTTPRequestOperation *op = [self POST:urlString
                                 parameters:param
                                    success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                        NSDictionary *dict = (NSDictionary *)responseObject;
                                        NSLog(@"driver list dict = %@",dict);
                                        OMDGetDriverListResult *result = [[OMDGetDriverListResult alloc] init];
                                        result.status = [dict objectForKey:kStatus_key];
                                        result.msg = [dict objectForKey:kMsg_key];
                                        if ([result.status isEqualToString:kSuccessCode]) {
                                            NSDictionary *dataDict = [dict objectForKey:kData_key];
                                            NSArray *driverArray = [dataDict objectForKey:@"driverArray"];
                                            NSMutableArray *driverList = [NSMutableArray array];
                                            for (NSInteger i = 0; i<driverArray.count; i++) {
                                                NSDictionary *driverDict = [driverArray objectAtIndex:i];
                                                OMDManagerObject *obj = [[OMDManagerObject alloc] init];
                                                obj.driverId = [driverDict objectForKey:@"driverId"];
                                                obj.driverName = [driverDict objectForKey:@"driverName"];
                                                obj.isOnDuty = [driverDict objectForKey:@"isOnDuty"];
                                                [driverList addObject:obj];
                                            }
                                            result.driverList = driverList;
                                        }
                                        if (completeBlock) {
                                            completeBlock(result);
                                        }
    }
                                    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                        if (failureBlock) {
                                            failureBlock(op,error);
                                        }
    }];
}

- (void)changeDriverOnDutyStatusWith:(OMDChangeDriverOnDutyRequest *)request
                       completeBlock:(CurrencyResponseObjectBlock)completeBlock
                        failureBlock:(CurrencyFailureBlock)failureBlock
{
    NSString *urlString = [self getUrlStringWith:kChangeDriverOnDutyPath];
    NSMutableDictionary *param = [self getParamWithRequest:request needDriverId:NO];
    [param setObject:request.isOnDuty forKey:@"isOnDuty"];
    [param setObject:request.driverId forKey:@"driverId"];
    AFHTTPRequestOperation *op = [self POST:urlString
                                 parameters:param
                                    success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                        NSDictionary *dict = (NSDictionary *)responseObject;
                                        NSLog(@"change dict = %@",dict);
                                        OMDChangeDriverOnDutyResult *result = [[OMDChangeDriverOnDutyResult alloc] init];
                                        result.status = [dict objectForKey:kStatus_key];
                                        result.msg = [dict objectForKey:kMsg_key];
                                        if ([result.status isEqualToString:kSuccessCode]) {
                                            
                                        }
                                        if (completeBlock) {
                                            completeBlock(result);
                                        }
    }
                                    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                        if (failureBlock) {
                                            failureBlock(op,error);
                                        }
    }];
}

#pragma mark -- Commons --
- (void)getAppConfigWith:(OMDAppConfigRequest *)request
           completeBlock:(CurrencyResponseObjectBlock)completeBlock
            failureBlock:(CurrencyFailureBlock)failureBlock
{
    NSString *urlString = [self getUrlStringWith:kGetAppConfigPath];
    NSMutableDictionary *param = [self getParamWithRequest:request needDriverId:YES];
    [param setObject:@"0" forKey:@"startNum"];
    [param setObject:@"20" forKey:@"range"];
    [param setObject:@"A" forKey:@"type"];
    AFHTTPRequestOperation *op = [self POST:urlString
                                 parameters:param
                                    success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                        NSDictionary *dict = (NSDictionary *)responseObject;
                                        NSLog(@"appConfig dict = %@",dict);
                                        OMDAppConfigResult *result = [[OMDAppConfigResult alloc] init];
                                        result.status = [dict objectForKey:kStatus_key];
                                        result.msg = [dict objectForKey:kMsg_key];
                                        if ([result.status isEqualToString:kSuccessCode]) {
                                            result.hostName = [dict objectForKey:@"hostName"];
                                            result.forceUpdate = [dict objectForKey:@"forceUpdate"];
                                            result.appVersion = [dict objectForKey:@"appVersion"];
                                        }
                                        if (completeBlock) {
                                            completeBlock(result);
                                        }
                                    }
                                    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                        if (failureBlock) {
                                            failureBlock(operation,error);
                                        }
                                    }];
}

#pragma mark -- Delivering --
- (void)getDeliveringListDataWith:(OMDDeliveringListRequest *)request
                    completeBlock:(CurrencyResponseObjectBlock)completeBlock
                     failureBlock:(CurrencyFailureBlock)failureBlock
{
    NSString *urlString = [self getUrlStringWith:kGetDeliveringListPath];
    NSMutableDictionary *param = [self getParamWithRequest:request needDriverId:YES];
    
    AFHTTPRequestOperation *op = [self POST:urlString
                                 parameters:param
                                    success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                        NSDictionary *dict = (NSDictionary *)responseObject;
                                        NSLog(@"delivery list dict = %@",dict);
                                        OMDDeliveringListResult *result = [[OMDDeliveringListResult alloc] init];
                                        result.status = [dict objectForKey:kStatus_key];
                                        result.msg = [dict objectForKey:kMsg_key];
                                        if ([result.status isEqualToString:kSuccessCode]) {
                                            NSDictionary *dataDict = [dict objectForKey:kData_key];
                                            NSArray *deliveringListArray = [dataDict objectForKey:@"deliveringListArray"];
                                            NSMutableArray *listArray = [NSMutableArray array];
                                            for (NSInteger i = 0; i<deliveringListArray.count; i++) {
                                                NSDictionary *restOrderDict = [deliveringListArray objectAtIndex:i];
                                                NSDictionary *restInfoDict = [restOrderDict objectForKey:@"restaurant"];
                                                OMDDeliveringObject *obj = [[OMDDeliveringObject alloc] init];
                                                obj.restId = [restInfoDict objectForKey:@"restId"];
                                                obj.restName = [restInfoDict objectForKey:@"restName"];
                                                NSArray *orders = [restOrderDict objectForKey:@"orders"];
                                                NSMutableArray *orderArray = [NSMutableArray array];
                                                for (NSInteger j = 0; j<orders.count; j++) {
                                                    NSDictionary *orderDict = [orders objectAtIndex:j];
                                                    NSDictionary *custDict = [orderDict objectForKey:@"customer"];
                                                    OMDDeliveringOrderObject *orderObj = [[OMDDeliveringOrderObject alloc] init];
                                                    orderObj.custAddr = [custDict objectForKey:@"custAddr"];
                                                    orderObj.billPrice = [orderDict objectForKey:@"billPrice"];
                                                    orderObj.orderId = [orderDict objectForKey:@"orderId"];
                                                    orderObj.isOMOrder = [orderDict objectForKey:@"isOMOrder"];
                                                    orderObj.readyInTime = [orderDict objectForKey:@"orderReadyTime"];
                                                    NSString *orderStatus = [orderDict objectForKey:@"status"];
                                                    if ([orderStatus isEqualToString:Order_Status_Call_Delivery]) {
                                                        orderObj.status = OrderStatus_DriverUnConfirm;
                                                    }
                                                    else if ([orderStatus isEqualToString:Order_Status_Delivery_Confirmed]) {
                                                        orderObj.status = OrderStatus_DriverConfirmed;
                                                    }
                                                    [orderArray addObject:orderObj];
                                                }
                                                obj.orderArray = orderArray;
                                                [listArray addObject:obj];
                                            }
                                            result.listArray = listArray;
                                        }
                                        if (completeBlock) {
                                            completeBlock(result);
                                        }
    }
                                    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                        if (failureBlock) {
                                            failureBlock(operation,error);
                                        }
    }];

}

- (void)getDeliveringDetailWith:(OMDDeliveringDetailRequest *)request
                  completeBlock:(CurrencyResponseObjectBlock)completeBlock
                   failureBlock:(CurrencyFailureBlock)failureBlock
{
    NSString *urlString = [self getUrlStringWith:kGetDeliveringDetailPath];
    NSMutableDictionary *param = [self getParamWithRequest:request needDriverId:YES];
    [param setObject:request.orderId forKey:@"orderFormId"];
    AFHTTPRequestOperation *op = [self POST:urlString
                                 parameters:param
                                    success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                        NSDictionary *dict = (NSDictionary *)responseObject;
                                        NSLog(@"delivery detail dict = %@",dict);
                                        OMDDeliveringDetailResult *result = [[OMDDeliveringDetailResult alloc] init];
                                        result.status = [dict objectForKey:kStatus_key];
                                        result.msg = [dict objectForKey:kMsg_key];
                                        if ([result.status isEqualToString:kSuccessCode]) {
                                            NSDictionary *dataDict = [dict objectForKey:kData_key];
                                            NSDictionary *detailDict = [dataDict objectForKey:@"orderDetail"];
                                            NSDictionary *custDict = [detailDict objectForKey:@"customer"];
                                            NSString *isOMOrder = [detailDict objectForKey:@"isOMOrder"];
                                            OMDDeliveringDetailObject *obj = [[OMDDeliveringDetailObject alloc] init];
                                            obj.isOMOrder = isOMOrder;
                                            obj.custName = [custDict objectForKey:@"custName"];
                                            obj.custPhone = [custDict objectForKey:@"custPhone"];
                                            obj.custAddr = [custDict objectForKey:@"custAddr"];
                                            obj.custLatitude = [custDict objectForKey:@"custLatitude"];
                                            obj.custLongitude = [custDict objectForKey:@"custLongitude"];
                                            NSArray *dishArray = [detailDict objectForKey:@"dishArray"];
                                            NSMutableArray *dishs = [NSMutableArray array];
                                            if (dishArray && dishArray.count>0) {
                                                OMDDeliveringDishObject *dishObj = [[OMDDeliveringDishObject alloc] init];
                                                for (NSInteger i = 0; i<dishArray.count; i++) {
                                                    NSDictionary *dishDict = [dishArray objectAtIndex:i];
                                                    dishObj.dishName = [dishDict objectForKey:@"dishName"];
                                                    dishObj.dishPrice = [dishDict objectForKey:@"dishPrice"];
                                                    NSArray *ingredients = [dishDict objectForKey:@"ingredientArray"];
                                                    NSMutableArray *ingredientArray = [NSMutableArray array];
                                                    for (NSInteger j = 0; j<ingredients.count; j++) {
                                                        NSString *ingredientName = [ingredients objectAtIndex:j];
                                                        [ingredientArray addObject:ingredientName];
                                                    }
                                                    dishObj.ingredientArray = ingredientArray;
                                                    [dishs addObject:dishObj];
                                                }
                                            }
                                            obj.dishArray = dishs;
                                            obj.billPrice = [detailDict objectForKey:@"billPrice"];
                                            NSString *status = [detailDict objectForKey:@"status"];
                                            if ([status isEqualToString:Order_Status_Call_Delivery]) {
                                                obj.status = OrderStatus_DriverUnConfirm;
                                            }
                                            else if ([status isEqualToString:Order_Status_Delivery_Confirmed]) {
                                                obj.status = OrderStatus_DriverConfirmed;
                                            }
                                            result.detailObj = obj;
                                        }
                                        if (completeBlock) {
                                            completeBlock(result);
                                        }
                                    }
                                    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                        if (failureBlock) {
                                            failureBlock(operation,error);
                                        }
                                    }];
}

- (void)confirmOrderWith:(OMDConfirmOrderRequest *)request
           completeBlock:(CurrencyResponseObjectBlock)completeBlock
            failureBlock:(CurrencyFailureBlock)failureBlock
{
    NSString *urlString = [self getUrlStringWith:kConfirmOrderPath];
    NSMutableDictionary *param = [self getParamWithRequest:request needDriverId:YES];
    [param setObject:request.orderId forKey:@"orderFormId"];
    AFHTTPRequestOperation *op = [self POST:urlString
                                 parameters:param
                                    success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                        NSDictionary *dict = (NSDictionary *)responseObject;
                                        NSLog(@"confirm order dict = %@",dict);
                                        OMDConfirmOrderResult *result = [[OMDConfirmOrderResult alloc] init];
                                        result.status = [dict objectForKey:kStatus_key];
                                        result.msg = [dict objectForKey:kMsg_key];
                                        if ([result.status isEqualToString:kSuccessCode]) {
                                            
                                        }
                                        if (completeBlock) {
                                            completeBlock(result);
                                        }
    }
                                    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                        if (failureBlock) {
                                            failureBlock(op,error);
                                        }
    }];
}

- (void)cancelOrderWith:(OMDCancelOrderRequest *)request
          completeBlock:(CurrencyResponseObjectBlock)completeBlock
           failureBlock:(CurrencyFailureBlock)failureBlock
{
    NSString *urlString = [self getUrlStringWith:kCancelOrderPath];
    NSMutableDictionary *param = [self getParamWithRequest:request needDriverId:YES];
    [param setObject:request.orderId forKey:@"orderFormId"];
    AFHTTPRequestOperation *op = [self POST:urlString
                                 parameters:param
                                    success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                        NSDictionary *dict = (NSDictionary *)responseObject;
                                        NSLog(@"cancel order dict = %@",dict);
                                        OMDCancelOrderResult *result = [[OMDCancelOrderResult alloc] init];
                                        result.status = [dict objectForKey:kStatus_key];
                                        result.msg = [dict objectForKey:kMsg_key];
                                        if ([result.status isEqualToString:kSuccessCode]) {
                                            
                                        }
                                        if (completeBlock) {
                                            completeBlock(result);
                                        }
                                    }
                                    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                        if (failureBlock) {
                                            failureBlock(op,error);
                                        }
                                    }];
}

- (void)doneOrderWith:(OMDDoneOrderRequest *)request
        completeBlock:(CurrencyResponseObjectBlock)completeBlock
         failureBlock:(CurrencyFailureBlock)failureBlock
{
    NSString *urlString = [self getUrlStringWith:kDoneOrderPath];
    NSMutableDictionary *param = [self getParamWithRequest:request needDriverId:YES];
    [param setObject:request.orderId forKey:@"orderFormId"];
    [param setObject:request.driverId forKeyedSubscript:@"driverId"];
    [param setObject:request.tipsType forKey:@"tipsType"];
    [param setObject:request.tipsFee?request.tipsFee:@"" forKey:@"tipsFee"];
    AFHTTPRequestOperation *op = [self POST:urlString
                                 parameters:param
                                    success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                        NSDictionary *dict = (NSDictionary *)responseObject;
                                        NSLog(@"done order dict = %@",dict);
                                        OMDDoneOrderResult *result = [[OMDDoneOrderResult alloc] init];
                                        result.status = [dict objectForKey:kStatus_key];
                                        result.msg = [dict objectForKey:kMsg_key];
                                        if ([result.status isEqualToString:kSuccessCode]) {
                                            
                                        }
                                        if (completeBlock) {
                                            completeBlock(result);
                                        }
                                    }
                                    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                        if (failureBlock) {
                                            failureBlock(op,error);
                                        }
                                    }];
}

- (void)resetOrderPriceWith:(OMDResetOrderPriceRequest *)request
              completeBlock:(CurrencyResponseObjectBlock)completeBlock
               failureBlock:(CurrencyFailureBlock)failureBlock
{
    NSString *urlString = [self getUrlStringWith:kResetOrderPricePath];
    NSMutableDictionary *param = [self getParamWithRequest:request needDriverId:YES];
    [param setObject:request.orderId forKey:@"orderFormId"];
    [param setObject:request.billPrice forKey:@"billPrice"];
    AFHTTPRequestOperation *op = [self POST:urlString
                                 parameters:param
                                    success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                        NSDictionary *dict = (NSDictionary *)responseObject;
                                        NSLog(@"reset dict = %@",dict);
                                        OMDResetOrderPriceResult *result = [[OMDResetOrderPriceResult alloc] init];
                                        result.status = [dict objectForKey:kStatus_key];
                                        result.msg = [dict objectForKey:kMsg_key];
                                        if ([result.status isEqualToString:kSuccessCode]) {
                                            
                                        }
                                        if (completeBlock) {
                                            completeBlock(result);
                                        }
    }
                                    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                        if (failureBlock) {
                                            failureBlock(op,error);
                                        }
    }];
}

#pragma mark -- Delivered --
- (void)getDeliveredListDataWith:(OMDDeliveredListRequest *)request
                   completeBlock:(CurrencyResponseObjectBlock)completeBlock
                    failureBlock:(CurrencyFailureBlock)failureBlock
{
    NSString *urlString = [self getUrlStringWith:kGetDeliveredListPath];
    NSMutableDictionary *param = [self getParamWithRequest:request needDriverId:YES];
    [param setObject:@"" forKey:@""];
    [param setObject:@"" forKey:@""];
    AFHTTPRequestOperation *op = [self POST:urlString
                                 parameters:param
                                    success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                        NSDictionary *dict = (NSDictionary *)responseObject;
                                        NSLog(@"delivered list dict = %@",dict);
                                        OMDDeliveredListResult *result = [[OMDDeliveredListResult alloc] init];
                                        result.status = [dict objectForKey:kStatus_key];
                                        result.msg = [dict objectForKey:kMsg_key];
                                        if ([result.status isEqualToString:kSuccessCode]) {
                                            
                                        }
                                        if (completeBlock) {
                                            completeBlock(result);
                                        }
                                    }
                                    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                        if (failureBlock) {
                                            failureBlock(op,error);
                                        }
                                    }];
}

- (void)getDeliveredDetailWith:(OMDDeliveredDetailRequest *)request
                 completeBlock:(CurrencyResponseObjectBlock)completeBlock
                  failureBlock:(CurrencyFailureBlock)failureBlock
{
    NSString *urlString = [self getUrlStringWith:kGetDeliveredDetailPath];
    NSMutableDictionary *param = [self getParamWithRequest:request needDriverId:YES];
    [param setObject:@"" forKey:@""];
    [param setObject:@"" forKey:@""];
    AFHTTPRequestOperation *op = [self POST:urlString
                                 parameters:param
                                    success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                        NSDictionary *dict = (NSDictionary *)responseObject;
                                        NSLog(@"delivered detail dict = %@",dict);
                                        OMDDeliveredDetailResult *result = [[OMDDeliveredDetailResult alloc] init];
                                        result.status = [dict objectForKey:kStatus_key];
                                        result.msg = [dict objectForKey:kMsg_key];
                                        if ([result.status isEqualToString:kSuccessCode]) {
                                            
                                        }
                                        if (completeBlock) {
                                            completeBlock(result);
                                        }
                                    }
                                    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                        if (failureBlock) {
                                            failureBlock(op,error);
                                        }
                                    }];
}

#pragma mark -- Login --
- (void)signUpWith:(OMDSignUpRequest *)request
     completeBlock:(CurrencyResponseObjectBlock)completeBlock
      failureBlock:(CurrencyFailureBlock)failureBlock
{
    NSString *urlString = [self getUrlStringWith:kSignUpPath];
    NSMutableDictionary *param = [self getParamWithRequest:request needDriverId:NO];
    [param setObject:request.email forKey:@"email"];
    [param setObject:request.password forKey:@"password"];
    [param setObject:request.phone forKey:@"phone"];
    [param setObject:request.name?request.name:@"" forKey:@"name"];
    [param setObject:request.address?request.address:@"" forKey:@"address"];
    AFHTTPRequestOperation *op = [self POST:urlString
                                 parameters:param
                                    success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                        NSDictionary *dict = (NSDictionary *)responseObject;
                                        NSLog(@"sign up dict = %@",dict);
                                        OMDSignUpResult *result = [[OMDSignUpResult alloc] init];
                                        result.status = [dict objectForKey:kStatus_key];
                                        result.msg = [dict objectForKey:kMsg_key];
                                        if ([result.status isEqualToString:kSuccessCode]) {
                                            NSDictionary *dataDict = [dict objectForKey:kData_key];
                                            result.driverId = [dataDict objectForKey:@"driverId"];
                                            [OMDUtility saveCurrentCustomerIdWith:result.driverId];
                                        }
                                        if (completeBlock) {
                                            completeBlock(result);
                                        }
    }
                                    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                        if (failureBlock) {
                                            failureBlock(op,error);
                                        }
    }];
}

- (void)loginWith:(OMDLoginRequest *)request
    completeBlock:(CurrencyResponseObjectBlock)completeBlock
     failureBlock:(CurrencyFailureBlock)failureBlock
{
    NSString *urlString = [self getUrlStringWith:kLoginPath];
    NSMutableDictionary *param = [self getParamWithRequest:request needDriverId:YES];
    [param setObject:request.account forKey:@"account"];
    [param setObject:request.password forKey:@"password"];
    AFHTTPRequestOperation *op = [self POST:urlString
                                 parameters:param
                                    success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                        NSDictionary *dict = (NSDictionary *)responseObject;
                                        NSLog(@"login dict = %@",dict);
                                        OMDLoginResult *result = [[OMDLoginResult alloc] init];
                                        result.status = [dict objectForKey:kStatus_key];
                                        result.msg = [dict objectForKey:kMsg_key];
                                        if ([result.status isEqualToString:kSuccessCode]) {
                                            NSDictionary *dataDict = [dict objectForKey:@"data"];
                                            result.driverId = [dataDict objectForKey:@"driverId"];
                                            result.loginToken = [dataDict objectForKey:@"loginToken"];
                                            [OMDUtility saveCurrentCustomerIdWith:result.driverId];
                                            [OMDUtility saveCurrentCustomerLoginToken:result.loginToken];
                                            [OMDUtility setLogined];
                                            [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccessedNotification object:nil];
                                        }
                                        else {
                                            [[NSNotificationCenter defaultCenter] postNotificationName:kLoginFailureNotification object:nil];
                                        }
                                        
                                        if (completeBlock) {
                                            completeBlock(result);
                                        }
    }
                                    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                        [[NSNotificationCenter defaultCenter] postNotificationName:kLoginFailureNotification object:nil];
                                        if (failureBlock) {
                                            failureBlock(operation,error);
                                        }
    }];
}

- (void)autoLoginWith:(OMDAutoLoginRequest *)request
        completeBlock:(CurrencyResponseObjectBlock)completeBlock
         failureBlock:(CurrencyFailureBlock)failureBlock
{
    NSString *urlString = [self getUrlStringWith:kAutoLoginPath];
    NSMutableDictionary *param = [self getParamWithRequest:request needDriverId:YES];
    [param setObject:request.loginToken forKey:@"loginToken"];
//    [param setObject:request.driverId?request.driverId:@"" forKey:@"driverId"];
    AFHTTPRequestOperation *op = [self POST:urlString
                                 parameters:param
                                    success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                        NSDictionary *dict = (NSDictionary *)responseObject;
                                        NSLog(@"autoLogin dict = %@",dict);
                                        OMDAutoLoginResult *result = [[OMDAutoLoginResult alloc] init];
                                        result.status = [dict objectForKey:kStatus_key];
                                        result.msg = [dict objectForKey:kMsg_key];
                                        if ([result.status isEqualToString:kSuccessCode]) {
                                            NSDictionary *dataDict = [dict objectForKey:@"data"];
                                            result.driverId = [dataDict objectForKey:@"driverId"];
                                            result.loginToken = [dataDict objectForKey:@"loginToken"];
                                            [OMDUtility saveCurrentCustomerIdWith:result.driverId];
                                            [OMDUtility saveCurrentCustomerLoginToken:result.loginToken];
                                            [OMDUtility setLogined];
                                            [[NSNotificationCenter defaultCenter] postNotificationName:kAutoLoginSuccessedNotification object:nil];
                                        }
                                        else {
                                            [[NSNotificationCenter defaultCenter] postNotificationName:kAutoLoginFailureNotification object:nil];
                                        }
                                        if (completeBlock) {
                                            completeBlock(result);
                                        }
                                    }
                                    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                        [[NSNotificationCenter defaultCenter] postNotificationName:kAutoLoginFailureNotification object:nil];
                                        if (failureBlock) {
                                            failureBlock(operation,error);
                                        }
                                    }];
}


#pragma mark -- Private Methods --
- (NSMutableDictionary *)getParamWithRequest:(OMDNetworkBaseRequest *)request needDriverId:(BOOL)needDriverId
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (request && ![OMDUtility StringIsEmptyWith:request.longitude]) {
        [param setObject:request.longitude forKey:@"longitude"];
    }
    else if (request && ![OMDUtility StringIsEmptyWith:request.latitude]) {
        [param setObject:request.latitude forKey:@"latitude"];
    }
    else {
        NSString *longitude = [[OMDLocationManager sharedInstance] longitude];
        NSString *latitude = [[OMDLocationManager sharedInstance] latitude];
        if (([OMDUtility StringIsEmptyWith:longitude] || [OMDUtility StringIsEmptyWith:latitude])) {
            [[OMDLocationManager sharedInstance] start];
        }
        
        NSString *longitudeStr = [[OMDLocationManager sharedInstance] longitude];
        [param setObject:longitudeStr forKey:@"longitude"];
        
        NSString *latitudeStr = [[OMDLocationManager sharedInstance] latitude];
        [param setObject:latitudeStr forKey:@"latitude"];
    }
    NSString *deviceId = @"";
    if ([OMSystemConfig queryDeviceIdentifier]) {
        deviceId = [OMSystemConfig queryDeviceIdentifier];
    }
    [param setObject:deviceId forKey:@"deviceId"];
    
    NSString *notificationDeviceToken = @"";
    if (![OMDUtility StringIsEmptyWith:[OMDUtility getNotifacationDeviceToken]]) {
        notificationDeviceToken = [OMDUtility getNotifacationDeviceToken];
    }
    [param setObject:notificationDeviceToken forKey:@"notificationDeviceToken"];
    
    NSString *appVersion = @"";
    if ([OMSystemConfig queryAppVersionBuild]) {
        appVersion = [OMSystemConfig queryAppVersionBuild];
    }
    [param setObject:appVersion forKey:@"appVersion"];
    
    if (needDriverId) {
        if (![OMDUtility StringIsEmptyWith:request.driverId]) {
            [param setObject:request.driverId forKey:@"driverId"];
        }
        else {
            NSString *driverId = [OMDUtility getCurrentCustomerId];
            if (![OMDUtility StringIsEmptyWith:driverId]) {
                [param setObject:driverId forKey:@"driverId"];
            }
        }
    }
    
    return param;
}

@end
