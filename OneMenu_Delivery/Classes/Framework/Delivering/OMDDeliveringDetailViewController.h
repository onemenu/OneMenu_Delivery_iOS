//
//  OMDDeliveringDetailViewController.h
//  OneMenu_Delivery
//
//  Created by simmyoung on 15/6/4.
//  Copyright (c) 2015年 One Menu Limited Liability Company. All rights reserved.
//

#import "OMDBaseViewController.h"

@interface OMDDeliveringDetailViewController : OMDBaseViewController

@property (nonatomic, copy) void (^confirmBlock)(NSInteger index);
@property (nonatomic, assign) NSInteger index;

@end
