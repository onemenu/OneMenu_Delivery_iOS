//
//  OMDSignUpViewController.h
//  OneMenu_Delivery
//
//  Created by simmyoung on 15/6/14.
//  Copyright (c) 2015年 One Menu Limited Liability Company. All rights reserved.
//

#import "OMDBaseViewController.h"

@interface OMDSignUpViewController : OMDBaseViewController

@property (nonatomic, copy) void (^signUpSuccessedBlock)(NSString *emailStr);

@end
