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
    NSMutableArray *rest1Array = [NSMutableArray array];
    OMDDeliveringObject *obj1 = [[OMDDeliveringObject alloc] init];
    obj1.restId = @"123";
    obj1.restName = @"Fuji";
    obj1.custAdd = @"1400 Martin Street Apt 2053";
    obj1.custName = @"Hanyuan Zhu";
    obj1.billPrice = @"998";
    obj1.isOMOrder = @"1";
    [rest1Array addObject:obj1];
    OMDDeliveringObject *obj2 = [[OMDDeliveringObject alloc] init];
    obj2.restId = @"123";
    obj2.restName = @"Fuji";
    obj2.custAdd = @"1400 Martin Street Apt 2053";
    obj2.custName = @"Hanyuan Zhu";
    obj2.billPrice = @"998";
    obj2.isOMOrder = @"0";
    [rest1Array addObject:obj2];
    [dataArray addObject:rest1Array];
    
    NSMutableArray *rest2Array = [NSMutableArray array];
    OMDDeliveringObject *obj3 = [[OMDDeliveringObject alloc] init];
    obj3.restId = @"234";
    obj3.restName = @"MyThai";
    obj3.custAdd = @"1400 Martin Street Apt 2053";
    obj3.custName = @"Hanyuan Zhu";
    obj3.billPrice = @"998";
    obj3.isOMOrder = @"1";
    [rest2Array addObject:obj3];
    OMDDeliveringObject *obj4 = [[OMDDeliveringObject alloc] init];
    obj4.restId = @"234";
    obj4.restName = @"MyThai";
    obj4.custAdd = @"1400 Martin Street Apt 2053";
    obj4.custName = @"Hanyuan Zhu";
    obj4.billPrice = @"998";
    obj4.isOMOrder = @"1";
    [rest2Array addObject:obj4];
    [dataArray addObject:rest2Array];
    
    NSMutableArray *rest3Array = [NSMutableArray array];
    OMDDeliveringObject *obj5 = [[OMDDeliveringObject alloc] init];
    obj5.restId = @"345";
    obj5.restName = @"BaiDu";
    obj5.custAdd = @"1400 Martin Street Apt 2053";
    obj5.custName = @"Hanyuan Zhu";
    obj5.billPrice = @"998";
    obj5.isOMOrder = @"1";
    [rest3Array addObject:obj5];
    [dataArray addObject:rest3Array];
    
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
        
        obj.custName = @"Hanyuan Zhu";
        obj.custAdd = @"1400 Martin Street Apt 2053, State College, PA";
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
