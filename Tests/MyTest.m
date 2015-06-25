//
//  MyTest.m
//
#import <GHUnit/GHUnit.h>
#import "OMDConstantsFile.h"
#import "OMDUtility.h"
#import "OMDNetworkManager.h"

#define kTimeOutVal 30

@interface MyTest : GHAsyncTestCase
@end

@implementation MyTest

- (void)test {

}

- (void)testAF
{
    [self prepare];
    [[OMDNetworkManager createNetworkEngineer] testRequest];
}

- (void)testLogin
{
    [self prepare];
    OMDLoginRequest *request = [[OMDLoginRequest alloc] init];
    request.account = @"vincent@test.com";
    request.password = @"vincent";
    
    [[OMDNetworkManager createNetworkEngineer]
     loginWith:request
     completeBlock:^(OMDNetworkBaseResult *responseObj) {
         [self notify:kGHUnitWaitStatusSuccess];
         OMDLoginResult *result = (OMDLoginResult *)responseObj;
         if ([result.status isEqualToString:kSuccessCode]) {
             
         }
    }
     failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         [self notify:kGHUnitWaitStatusFailure];
    }];
//    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTimeOutVal];
}

- (void)testAutologin
{
    [self prepare];
    OMDAutoLoginRequest *request = [[OMDAutoLoginRequest alloc] init];
    request.loginToken = [OMDUtility getCurrentCustomerLoginToken];
    request.driverId = [OMDUtility getCurrentCustomerId];
    
    [[OMDNetworkManager createNetworkEngineer]
     autoLoginWith:request
     completeBlock:^(OMDNetworkBaseResult *responseObj) {
         [self notify:kGHUnitWaitStatusSuccess];
         OMDAutoLoginResult *result = (OMDAutoLoginResult *)responseObj;
         if ([result.status isEqualToString:kSuccessCode]) {
             
         }
    }
     failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         [self notify:kGHUnitWaitStatusFailure];
    }];
//    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:kTimeOutVal];
}

- (void)testOrderDetail
{
    [self prepare];
    OMDDeliveringDetailRequest *request = [[OMDDeliveringDetailRequest alloc] init];
    request.orderId = @"123";
    
    [[OMDNetworkManager createNetworkEngineer]
     getDeliveringDetailWith:request
     completeBlock:^(OMDNetworkBaseResult *responseObj) {
         [self notify:kGHUnitWaitStatusSuccess];
         OMDDeliveringDetailResult *result = (OMDDeliveringDetailResult *)responseObj;
         if ([result.status isEqualToString:kSuccessCode]) {
             
         }
    }
     failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         [self notify:kGHUnitWaitStatusFailure];
    }];
}
- (void)testAllOrder
{
    [self prepare];
    OMDAllOrderRequest *request = [[OMDAllOrderRequest alloc] init];
    
    [[OMDNetworkManager createNetworkEngineer]
     getAllOrderListWith:request completeBlock:^(OMDNetworkBaseResult *responseObj) {
        
    }
     failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

@end
