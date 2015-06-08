//
//  OMDLoginViewController.h
//  OneMenu_Delivery
//
//  Created by simmyoung on 15/6/7.
//  Copyright (c) 2015年 One Menu Limited Liability Company. All rights reserved.
//

#import "OMDBaseViewController.h"

@interface OMDLoginViewController : OMDBaseViewController

@property (nonatomic, copy) void (^loginSuccessedBlock)(void);

@property (nonatomic, copy) void (^loginCanceledBlock)(void);

@end
