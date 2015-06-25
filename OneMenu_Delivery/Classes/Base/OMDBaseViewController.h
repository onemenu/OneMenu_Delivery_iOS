//
//  OMBaseViewController.h
//  OneMenu
//
//  Created by OneMenu on 14-8-18.
//  Copyright (c) 2014年 Three Idiot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "OMDConstantsFile.h"
#import "OMDUtility.h"
#import "OMDNetworkManager.h"
#import "OMBaseNavigationController.h"
#import "OMSystemConfig.h"
#import "MJRefresh.h"
#import "OMDFalseDataManager.h"
#import "OMDNetworkManager.h"

@interface OMDBaseViewController : UIViewController
{
    CGPoint _currentOffset;
}

@property (nonatomic, assign) BOOL navigationBarHidden;
@property (nonatomic, assign) BOOL tabbarHidden;
@property (nonatomic, assign) BOOL isHidedNavBar;
@property (nonatomic, assign) BOOL isHidedTabBar;
@property (nonatomic, assign) BOOL disAppeared;

- (void)setNavigationTitle:(NSString *)navigationTitle;
- (void)setRightNavigationViews:(NSArray *)viewArray;

- (void)setLeftNavigationItemTittle:(NSString *)tittle action:(SEL)action;
- (void)setLeftNavigationItemImage:(UIImage *)image action:(SEL)action;
- (void)setRightNavigationItemTittle:(NSString *)tittle action:(SEL)action;
- (void)setRightNavigationItemImage:(UIImage *)image action:(SEL)action;
- (void)setRightNavigationView:(UIView *)rightView;

- (void)showTabBar;
- (void)hideTabBar;
- (void)showNavigationBarWithDuration:(CGFloat)dur;
- (void)hideNavigationBarWithDuration:(CGFloat)dur;

- (void)showAlertViewWithMessage:(NSString *)message;
- (void)showAlertViewWithMessage:(NSString *)message
                             tag:(NSInteger)tag
                    cancelString:(NSString *)cancelStr
                      sureString:(NSString *)sureStr;
- (void)showProcessHUD:(NSString *)text;
- (void)showProcessHUD:(NSString *)text inView:(UIView *)view;
- (void)showProcessHUD:(NSString *)text completionBlock:(void (^)(void))comepletion;
- (void)hideProcessHUD;
- (void)hideProcessHUDForView:(UIView *)view;
- (void)showToast:(NSString *)text;
- (void)showToast:(NSString *)text duration:(CGFloat)duration;
- (void)showToastWith:(NSString *)text duration:(CGFloat)duration completionBlock:(void (^)(void))comepletion;
@end
