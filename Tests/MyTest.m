//
//  MyTest.m
//
#import <GHUnit/GHUnit.h>
#import "OMDNetworkManager.h"

@interface MyTest : GHAsyncTestCase
@end

@implementation MyTest

- (void)test {

}

- (void)testForAFNetworking
{
    [[OMDNetworkManager createNetworkEngineer] getDeliveringListDataWith:nil completeBlock:^(OMDNetworkBaseResult *responseObj) {
        
    } failureBlock:^(OMDNetworkBaseResult *responseObj, NSError *error) {
        
    }];
}

@end
