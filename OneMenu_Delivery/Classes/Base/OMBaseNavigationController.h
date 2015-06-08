//
//  OMBaseNavigationController.h
//  OneMenu
//
//  Created by simmyoung on 14-8-23.
//  Copyright (c) 2014年 Three Idiot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OMDConstantsFile.h"
#import "OMUtility.h"

typedef NS_ENUM(NSInteger, DirectionStatus) {
    DirectionStatus_FromLeft = 0,
    DirectionStatus_FromRight = 1,
    DirectionStatus_FromUp = 2,
    DirectionStatus_FromDown = 3
};

@interface OMBaseNavigationController : UINavigationController

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated horizontal:(DirectionStatus)directionStatus;

@end
