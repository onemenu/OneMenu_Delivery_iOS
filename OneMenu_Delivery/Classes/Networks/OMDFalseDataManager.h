//
//  OMDFalseDataManager.h
//  OneMenu_Delivery
//
//  Created by simmyoung on 15/6/4.
//  Copyright (c) 2015年 One Menu Limited Liability Company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OMDDeliveringObject.h"
#import "OMDDeliveredObject.h"

@interface OMDFalseDataManager : NSObject

+ (OMDFalseDataManager *)sharedInstance;

+ (NSArray *)gemDeliveringDatas;
+ (OMDDeliveringDetailObject *)gemDeliveringDetailObj;

+ (NSArray *)gemDeliveredDatas;
+ (OMDDeliveredObject *)gemDeliveredDetailObj;


@end
