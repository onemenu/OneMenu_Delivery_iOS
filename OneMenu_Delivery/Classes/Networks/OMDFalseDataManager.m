//
//  OMDFalseDataManager.m
//  OneMenu_Delivery
//
//  Created by simmyoung on 15/6/4.
//  Copyright (c) 2015年 One Menu Limited Liability Company. All rights reserved.
//

#import "OMDFalseDataManager.h"

@implementation OMDFalseDataManager

+ (OMDFalseDataManager *)sharedInstance
{
    static OMDFalseDataManager *falseData = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        falseData = [[OMDFalseDataManager alloc] init];
    });
    //    OMFalseDataManager *falseData = [[OMFalseDataManager alloc] init];
    return falseData;
}

+ (NSArray *)gemDeliveringDatas
{
    NSMutableArray *dataArray = [NSMutableArray array];
    NSMutableArray *order1Array = [NSMutableArray array];
    OMDDeliveringObject *obj1 = [[OMDDeliveringObject alloc] init];
    obj1.restId = @"123";
    obj1.restName = @"Fuji";
    OMDDeliveringOrderObject *orderObj1 = [[OMDDeliveringOrderObject alloc] init];
    orderObj1.custAddr = @"1400 Martin Street Apt 2053";
    orderObj1.readyInTime = @"7";
    orderObj1.billPrice = @"998";
    orderObj1.isOMOrder = @"1";
    [order1Array addObject:orderObj1];
    OMDDeliveringOrderObject *orderObj2 = [[OMDDeliveringOrderObject alloc] init];
    orderObj2.custAddr = @"1400 Martin Street Apt 2053";
    orderObj2.readyInTime = @"8";
    orderObj2.billPrice = @"998";
    orderObj2.isOMOrder = @"0";
    [order1Array addObject:orderObj2];
    obj1.orderArray = order1Array;
    [dataArray addObject:obj1];
    
    NSMutableArray *order2Array = [NSMutableArray array];
    OMDDeliveringObject *obj2 = [[OMDDeliveringObject alloc] init];
    obj2.restId = @"234";
    obj2.restName = @"MyThai";
    OMDDeliveringOrderObject *order3 = [[OMDDeliveringOrderObject alloc] init];
    order3.custAddr = @"1400 Martin Street Apt 2053";
    order3.readyInTime = @"6";
    order3.billPrice = @"998";
    order3.isOMOrder = @"1";
    [order2Array addObject:order3];
    OMDDeliveringOrderObject *order4 = [[OMDDeliveringOrderObject alloc] init];
    order4.custAddr = @"1400 Martin Street Apt 2053";
    order4.readyInTime = @"4";
    order4.billPrice = @"998";
    order4.isOMOrder = @"1";
    [order2Array addObject:order4];
    obj2.orderArray = order2Array;
    [dataArray addObject:obj2];
    
    NSMutableArray *order3Array = [NSMutableArray array];
    OMDDeliveringObject *obj3 = [[OMDDeliveringObject alloc] init];
    obj3.restId = @"345";
    obj3.restName = @"BaiDu";
    OMDDeliveringOrderObject *order5 = [[OMDDeliveringOrderObject alloc] init];
    order5.custAddr = @"1400 Martin Street Apt 2053";
    order5.readyInTime = @"10";
    order5.billPrice = @"998";
    order5.isOMOrder = @"1";
    [order3Array addObject:order5];
    obj3.orderArray = order3Array;
    [dataArray addObject:obj3];
    
    return dataArray;
}

+ (OMDDeliveringDetailObject *)gemDeliveringDetailObj
{
    OMDDeliveringDetailObject *detailObj = [[OMDDeliveringDetailObject alloc] init];
    detailObj.orderCode = @"OM201506051120000001";
    detailObj.custName = @"Hanyuan Zhu";
    detailObj.custPhone = @"8143863918";
    detailObj.custAddr = @"713 West WhiteHall Road state college";
    NSMutableArray *dishArray = [NSMutableArray array];
    for (NSInteger i = 0; i<3; i++) {
        OMDDeliveringDishObject *dishObj = [[OMDDeliveringDishObject alloc] init];
        dishObj.dishName = [NSString stringWithFormat:@"abc %zd",i+10];
        dishObj.dishPrice = @"2";
        [dishArray addObject:dishObj];
    }
    detailObj.dishArray = dishArray;
    detailObj.billPrice = @"6";
    return detailObj;
}

+ (NSArray *)gemDeliveredDatas
{
    NSMutableArray *array = [NSMutableArray array];
    for (NSInteger i = 0; i<10; i++) {
        OMDDeliveredObject *obj = [[OMDDeliveredObject alloc] init];
        NSInteger restId = 0;
        NSString *restName = @"";
        if (i%3==0) {
            restId = 0;
            restName = @"Fuji";
        }
        else if (i%3==1) {
            restId = 1;
            restName = @"MyThai";
        }
        else {
            restId = 2;
            restName = @"BaiDu";
        }
        obj.restId = [NSString stringWithFormat:@"%zd",123+i];
        obj.restName = restName;
        
        obj.readyInTime = @"7";
        obj.custAddr = @"1400 Martin Street Apt 2053, State College, PA";
        obj.billPrice = @"998";
        
        obj.isOMOrder = [NSString stringWithFormat:@"%zd",arc4random()%2];
        
        obj.status = OrderStatus_DriverDone;
        [array addObject:obj];
    }
    return array;
}

+ (OMDDeliveredDetailObject *)gemDeliveredDetailObj
{
    OMDDeliveredDetailObject *detailObj = [[OMDDeliveredDetailObject alloc] init];
    detailObj.orderCode = @"OM201506051120000001";
    detailObj.custName = @"Hanyuan Zhu";
    detailObj.custPhone = @"8143863918";
    detailObj.custAddr = @"713 West WhiteHall Road state college";
    NSMutableArray *dishArray = [NSMutableArray array];
    for (NSInteger i = 0; i<3; i++) {
        OMDDeliveringDishObject *dishObj = [[OMDDeliveringDishObject alloc] init];
        dishObj.dishName = [NSString stringWithFormat:@"abc %zd",i+10];
        dishObj.dishPrice = @"2";
        [dishArray addObject:dishObj];
    }
    detailObj.dishArray = dishArray;
    detailObj.billPrice = @"6";
    return detailObj;
}

@end
