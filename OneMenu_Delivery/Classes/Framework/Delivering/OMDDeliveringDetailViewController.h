//
//  OMDDeliveringDetailViewController.h
//  OneMenu_Delivery
//
//  Created by simmyoung on 15/6/4.
//  Copyright (c) 2015年 One Menu Limited Liability Company. All rights reserved.
//

#import "OMDBaseViewController.h"
#import "OMDTipsView.h"

@interface OMDDeliveringDetailViewController : OMDBaseViewController

@property (nonatomic, copy) void (^confirmBlock)(OrderStatus status, NSIndexPath *indexPath);
@property (nonatomic, copy) void (^resetPriceBlock)(NSString *billPrice, NSIndexPath *indexPath);
@property (nonatomic, assign) NSIndexPath *indexPath;

@property (nonatomic, copy) NSString *orderId;

@end
