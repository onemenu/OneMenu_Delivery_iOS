//
//  OMBaseNavigationController.m
//  OneMenu
//
//  Created by simmyoung on 14-8-23.
//  Copyright (c) 2014年 Three Idiot. All rights reserved.
//

#import "OMBaseNavigationController.h"

@interface OMBaseNavigationController ()

@end

@implementation OMBaseNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //add if need login logic here.
    //if need login , present model viewcontroller to logincontroller.
    //if not , super push view to destination viewcontroller.
//    OMUserSession *userSession = [OMUserSession shareInstance];
//    if ([viewController isKindOfClass:[OMBaseLoginViewController class]] && !userSession.isLogined) { //need login
//        OMLoginViewController *loginView = [[OMLoginViewController alloc] initWithNibName:@"OMLoginViewController" bundle:nil];
//        OMBaseNavigationController *loginNav = [[OMBaseNavigationController alloc] initWithRootViewController:loginView];
//        [self presentViewController:loginNav animated:YES completion:NULL];
//    }
//    else {
//        [super pushViewController:viewController animated:animated];
//    }
//    viewController.hidesBottomBarWhenPushed = YES;
    
    [super pushViewController:viewController animated:animated];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated horizontal:(DirectionStatus)directionStatus
{
    UIImage *image = [OMUtility screenImage];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    imageView.image = image;
    [[[UIApplication sharedApplication] keyWindow] addSubview:imageView];
    
    [super pushViewController:viewController animated:NO];
    
    
    CGRect rect = viewController.view.frame;
    if (DirectionStatus_FromLeft == directionStatus) {
        rect.origin.x = -rect.size.width;
    }
    else if (DirectionStatus_FromUp == directionStatus) {
        rect.origin.y = -rect.size.height;
    }
    else if (DirectionStatus_FromDown == directionStatus) {
        rect.origin.y = rect.size.height;
    }
    viewController.view.frame = rect;
    __weak UIViewController *wCtrl = viewController;
    __block DirectionStatus blockStatus = directionStatus;
    [UIView animateWithDuration:0.38
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         UIViewController *sCtrl = wCtrl;
                         CGRect nRect = sCtrl.view.frame;
                         if (DirectionStatus_FromLeft == blockStatus) {
                             nRect.origin.x = 0;
                         }
                         else if (DirectionStatus_FromUp == blockStatus) {
                             nRect.origin.y = 0;
                         }
                         else if (DirectionStatus_FromDown == blockStatus) {
                             nRect.origin.y = 0;
                         }
                         sCtrl.view.frame = nRect;
                     }
                     completion:^(BOOL finished) {
                         [imageView removeFromSuperview];
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
