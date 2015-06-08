//
//  OMDNetworkManger.m
//  OneMenu_Delivery
//
//  Created by simmyoung on 15/6/4.
//  Copyright (c) 2015年 One Menu Limited Liability Company. All rights reserved.
//

#import "OMDNetworkManager.h"

#define kHostName @"http://onemenu.mobi/"

#define kGetDeliveringListPath @""
#define kGetDeliveringDetailPath @""
#define kConfirmOrderPath @""
#define kCancelOrderPath @""
#define kDoneOrderPath @""
#define kGetDeliveredListPath @""
#define kGetDeliveredDetailPath @""
#define kLoginPath @""

#define kPostKey @"POST"
#define kGetKey @"GET"

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

#pragma mark -- Request Methods --

#pragma mark -- Delivering --
- (void)getDeliveringListDataWith:(OMDDeliveringListRequest *)request
                    completeBlock:(CurrencyResponseObjectBlock)completeBlock
                     failureBlock:(CurrencyFailureBlock)failureBlock
{
    NSString *urlString = [self getUrlStringWith:kGetDeliveringListPath];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@"0" forKey:@"startNum"];
    [param setObject:@"20" forKey:@"range"];
    [param setObject:@"A" forKey:@"type"];
    AFHTTPRequestOperation *op = [self POST:urlString
                                 parameters:param
                                    success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                        NSDictionary *dict = (NSDictionary *)responseObject;
                                        NSLog(@"delivery list dict = %@",dict);
                                        OMDDeliveringListResult *result = [[OMDDeliveringListResult alloc] init];
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
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@"" forKey:@""];
    [param setObject:@"" forKey:@""];
    AFHTTPRequestOperation *op = [self POST:urlString
                                 parameters:param
                                    success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                        NSDictionary *dict = (NSDictionary *)responseObject;
                                        NSLog(@"delivery detail dict = %@",dict);
                                        OMDDeliveringDetailResult *result = [[OMDDeliveringDetailResult alloc] init];
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
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@"" forKey:@""];
    [param setObject:@"" forKey:@""];
    AFHTTPRequestOperation *op = [self POST:urlString
                                 parameters:param
                                    success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                        NSDictionary *dict = (NSDictionary *)responseObject;
                                        NSLog(@"confirm order dict = %@",dict);
                                        OMDConfirmOrderResult *result = [[OMDConfirmOrderResult alloc] init];
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
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@"" forKey:@""];
    [param setObject:@"" forKey:@""];
    AFHTTPRequestOperation *op = [self POST:urlString
                                 parameters:param
                                    success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                        NSDictionary *dict = (NSDictionary *)responseObject;
                                        NSLog(@"cancel order dict = %@",dict);
                                        OMDCancelOrderResult *result = [[OMDCancelOrderResult alloc] init];
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
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@"" forKey:@""];
    [param setObject:@"" forKey:@""];
    AFHTTPRequestOperation *op = [self POST:urlString
                                 parameters:param
                                    success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                        NSDictionary *dict = (NSDictionary *)responseObject;
                                        NSLog(@"done order dict = %@",dict);
                                        OMDDoneOrderResult *result = [[OMDDoneOrderResult alloc] init];
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
    NSString *urlString = [self getUrlStringWith:@""];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@"" forKey:@""];
    [param setObject:@"" forKey:@""];
    AFHTTPRequestOperation *op = [self POST:urlString
                                 parameters:param
                                    success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                        NSDictionary *dict = (NSDictionary *)responseObject;
                                        NSLog(@"delivered list dict = %@",dict);
                                        OMDDeliveredListResult *result = [[OMDDeliveredListResult alloc] init];
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
    NSString *urlString = [self getUrlStringWith:@""];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@"" forKey:@""];
    [param setObject:@"" forKey:@""];
    AFHTTPRequestOperation *op = [self POST:urlString
                                 parameters:param
                                    success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                        NSDictionary *dict = (NSDictionary *)responseObject;
                                        NSLog(@"delivered detail dict = %@",dict);
                                        OMDDeliveredDetailResult *result = [[OMDDeliveredDetailResult alloc] init];
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
- (void)loginWith:(OMDLoginRequest *)request
    completeBlock:(CurrencyResponseObjectBlock)completeBlock
     failureBlock:(CurrencyFailureBlock)failureBlock
{
    NSString *urlString = [self getUrlStringWith:@""];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@"" forKey:@""];
    [param setObject:@"" forKey:@""];
    AFHTTPRequestOperation *op = [self POST:urlString
                                 parameters:param
                                    success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                        NSDictionary *dict = (NSDictionary *)responseObject;
                                        NSLog(@"login dict = %@",dict);
                                        OMDLoginResult *result = [[OMDLoginResult alloc] init];
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

@end
