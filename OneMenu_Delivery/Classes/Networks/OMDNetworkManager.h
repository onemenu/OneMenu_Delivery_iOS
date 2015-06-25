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
typedef void (^CurrencyFailureBlock)(AFHTTPRequestOperation *operation, NSError *error);

@interface OMDNetworkManager : AFHTTPRequestOperationManager

+ (id)createNetworkEngineer;
+ (void)destroyEngineer;

//test
- (void)testRequest;
- (void)getAllOrderListWith:(OMDAllOrderRequest *)request
              completeBlock:(CurrencyResponseObjectBlock)completeBlock
               failureBlock:(CurrencyFailureBlock)failureBlock;

- (void)assignOrderWith:(OMDAssignOrderRequest *)request
          completeBlock:(CurrencyResponseObjectBlock)completeBlock
           failureBlock:(CurrencyFailureBlock)failureBlock;

- (void)getDriverListWith:(OMDGetDriverListRequest *)request
            completeBlock:(CurrencyResponseObjectBlock)completeBlock
             failureBlock:(CurrencyFailureBlock)failureBlock;

- (void)changeDriverOnDutyStatusWith:(OMDChangeDriverOnDutyRequest *)request
                       completeBlock:(CurrencyResponseObjectBlock)completeBlock
                        failureBlock:(CurrencyFailureBlock)failureBlock;

#pragma mark -- Commons --
- (void)getAppConfigWith:(OMDAppConfigRequest *)request
           completeBlock:(CurrencyResponseObjectBlock)completeBlock
            failureBlock:(CurrencyFailureBlock)failureBlock;

#pragma mark -- Delivering --
- (void)getDeliveringListDataWith:(OMDDeliveringListRequest *)request
                    completeBlock:(CurrencyResponseObjectBlock)completeBlock
                     failureBlock:(CurrencyFailureBlock)failureBlock;

- (void)getDeliveringDetailWith:(OMDDeliveringDetailRequest *)request
                  completeBlock:(CurrencyResponseObjectBlock)completeBlock
                   failureBlock:(CurrencyFailureBlock)failureBlock;

- (void)confirmOrderWith:(OMDConfirmOrderRequest *)request
           completeBlock:(CurrencyResponseObjectBlock)completeBlock
            failureBlock:(CurrencyFailureBlock)failureBlock;

- (void)cancelOrderWith:(OMDCancelOrderRequest *)request
          completeBlock:(CurrencyResponseObjectBlock)completeBlock
           failureBlock:(CurrencyFailureBlock)failureBlock;

- (void)doneOrderWith:(OMDDoneOrderRequest *)request
        completeBlock:(CurrencyResponseObjectBlock)completeBlock
         failureBlock:(CurrencyFailureBlock)failureBlock;

- (void)resetOrderPriceWith:(OMDResetOrderPriceRequest *)request
              completeBlock:(CurrencyResponseObjectBlock)completeBlock
               failureBlock:(CurrencyFailureBlock)failureBlock;

#pragma mark -- Delivered --
- (void)getDeliveredListDataWith:(OMDDeliveredListRequest *)request
                   completeBlock:(CurrencyResponseObjectBlock)completeBlock
                    failureBlock:(CurrencyFailureBlock)failureBlock;

- (void)getDeliveredDetailWith:(OMDDeliveredDetailRequest *)request
                 completeBlock:(CurrencyResponseObjectBlock)completeBlock
                  failureBlock:(CurrencyFailureBlock)failureBlock;

#pragma mark -- Login --
- (void)signUpWith:(OMDSignUpRequest *)request
     completeBlock:(CurrencyResponseObjectBlock)completeBlock
      failureBlock:(CurrencyFailureBlock)failureBlock;

- (void)loginWith:(OMDLoginRequest *)request
    completeBlock:(CurrencyResponseObjectBlock)completeBlock
     failureBlock:(CurrencyFailureBlock)failureBlock;

- (void)autoLoginWith:(OMDAutoLoginRequest *)request
        completeBlock:(CurrencyResponseObjectBlock)completeBlock
         failureBlock:(CurrencyFailureBlock)failureBlock;

@end
