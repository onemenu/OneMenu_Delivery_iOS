//
//  OMBaseViewController.m
//  OneMenu
//
//  Created by OneMenu on 14-8-18.
//  Copyright (c) 2014年 Three Idiot. All rights reserved.
//

#import "OMDBaseViewController.h"
#import "OMDConstantsFile.h"
#import "MBProgressHUD.h"

#define kNavigationRightViewTag 987

@interface OMDBaseViewController ()

@end

@implementation OMDBaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
//    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
//    {
//        [self.navigationController.navigationBar setBackgroundImage:ImageWithBundlePath(@"navigation_background.png") forBarMetrics:UIBarMetricsDefault];
//    }
//    [self.navigationController.navigationBar setBarTintColor:UIColorFromRGBValues(210,0,19,1)];
    [self.navigationController.navigationBar setTranslucent:YES];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName,[UIFont fontWithName:kHelvetica_key size:14.0],NSFontAttributeName, nil] forState:UIControlStateNormal];
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
    
    self.view.autoresizesSubviews = YES;
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin;
    
//    UIView *navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-2*10, 44)];
//    navigationView.backgroundColor = [UIColor clearColor];
    
//    self.navigationItem.titleView = navigationView;
//    self.navigationItem.hidesBackButton = YES;
    
//    [self setLeftNavigationItemTittle:@"Back" action:nil];
    
    CGRect rect = self.view.frame;
    if (self.hidesBottomBarWhenPushed == NO) {
        rect.size.height -= kDefaultTabbarHeight;
    }
    self.view.frame = rect;
}

//- (void)setTabbarHidden:(BOOL)tabbarHidden
//{
//    _tabbarHidden = tabbarHidden;
//    if (_tabbarHidden) {
//        [self hideTabBar];
//    }
//    else {
//        [self showTabBar];
//    }
//}
//
//- (void)setNavigationBarHidden:(BOOL)navigationBarHidden
//{
//    _navigationBarHidden = navigationBarHidden;
//    if (_navigationBarHidden) {
//        [self hideNavigationBarWithDuration:0];
//    }
//    else {
//        [self showNavigationBarWithDuration:0];
//    }
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    __unused NSString *className = [NSString stringWithUTF8String:object_getClassName(self)];
}

- (void)viewWillDisappear:(BOOL)animated
{
    __unused NSString *className = [NSString stringWithUTF8String:object_getClassName(self)];
}

#pragma mark -- SetNavigationBar Views --
//- (void)setNavigationTitle:(NSString *)navigationTitle
//{
//    UILabel *titleLabel = (UILabel *)[self.navigationItem.titleView viewWithTag:kNavigationTitleLabelTag];
//    
//    CGRect rect = self.navigationItem.titleView.frame;
//    BOOL needRelease = YES;
//    if (titleLabel && [titleLabel isKindOfClass:[UILabel class]]) {
//        needRelease = NO;
//    } else {
//        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, 44)];
//    }
//    
//    titleLabel.text = navigationTitle;
//    titleLabel.textAlignment = NSTextAlignmentCenter;
//    titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
//    titleLabel.backgroundColor = [UIColor clearColor];
//    titleLabel.textColor = [UIColor darkTextColor];//[UIColor colorWithRed:83.0/255.0 green:19.0/255.0 blue:64.0/255.0 alpha:1.0];
//    titleLabel.tag = kNavigationTitleLabelTag;
//    [self.navigationItem.titleView addSubview:titleLabel];
//}

- (void)setNavigationTitle:(NSString *)navigationTitle
{
    self.navigationItem.title = navigationTitle;
    NSDictionary *attDic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor darkTextColor],NSForegroundColorAttributeName,[UIFont fontWithName:kHelvetica_key size:18.0],NSFontAttributeName, nil];
    self.navigationController.navigationBar.titleTextAttributes = attDic;
}

- (void)setRightNavigationViews:(NSArray *)viewArray
{
    [self.navigationItem setRightBarButtonItems:viewArray];
}

- (void)setLeftNavigationItemTittle:(NSString *)tittle action:(SEL)action
{
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:tittle style:UIBarButtonItemStylePlain target:self action:action?action:@selector(backAction)];
    leftItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:leftItem];
}

- (void)setLeftNavigationItemImage:(UIImage *)image action:(SEL)action
{
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:action?action:@selector(backAction)];
    leftItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setRightBarButtonItem:leftItem];
}
- (void)setRightNavigationItemTittle:(NSString *)tittle action:(SEL)action
{
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:tittle style:UIBarButtonItemStylePlain target:self action:action];
    rightItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setRightBarButtonItem:rightItem];
}
- (void)setRightNavigationItemImage:(UIImage *)image action:(SEL)action
{
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:action];
//    rightItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setRightBarButtonItem:rightItem];
}

- (void)setRightNavigationView:(UIView *)rightView
{
    UIView *oldRightView = [self.navigationItem.titleView viewWithTag:kRightNavigationButtonTag];
    if (oldRightView) {
        [oldRightView removeFromSuperview];
    }
    CGRect rect = self.navigationItem.titleView.frame;
    rightView.frame = CGRectMake(rect.size.width-10-rightView.frame.size.width, (44-rightView.frame.size.height)/2, rightView.frame.size.width, rightView.frame.size.height);
    rightView.tag = kRightNavigationButtonTag;
    [self.navigationItem.titleView addSubview:rightView];
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- SetTabbar Views --
- (void)hideTabBar
{
    for(UIView *view in self.tabBarController.view.subviews) {
        if([view isKindOfClass:[UITabBar class]]) {
            __weak OMDBaseViewController *wSelf = self;
            if (!self.isHidedTabBar) {
                [UIView animateWithDuration:0.38
                                      delay:0.0
                                    options:UIViewAnimationOptionCurveEaseInOut
                                 animations:^(){
                                     CGRect tabbarRect = view.frame;
                                     tabbarRect.origin.y = [UIScreen mainScreen].bounds.size.height;
                                     view.frame = tabbarRect;
                                 }
                                 completion:^(BOOL finished){
                                     OMDBaseViewController *sSelf = wSelf;
                                     sSelf.isHidedTabBar = YES;
                                 }];
            }
        }
    }
    
}

- (void)showTabBar
{
    for(UIView *view in self.tabBarController.view.subviews) {
        if([view isKindOfClass:[UITabBar class]]) {
            __weak OMDBaseViewController *wSelf = self;
            if (self.isHidedTabBar) {
                [UIView animateWithDuration:0.38
                                      delay:0.0
                                    options:UIViewAnimationOptionCurveEaseInOut
                                 animations:^(){
                                     CGRect tabbarRect = view.frame;
                                     tabbarRect.origin.y = [UIScreen mainScreen].bounds.size.height-kDefaultTabbarHeight;
                                     view.frame = tabbarRect;
                                 }
                                 completion:^(BOOL finished){
                                     OMDBaseViewController *sSelf = wSelf;
                                     sSelf.isHidedTabBar = NO;
                                 }];
            }
        }
    }
}

#pragma mark -- setNavigationBar --
- (void)showNavigationBarWithDuration:(CGFloat)dur
{
    __weak OMDBaseViewController *wSelf = self;
    [UIView animateWithDuration:dur
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^(){
                         OMDBaseViewController *sSelf = wSelf;
                         CGRect rect = sSelf.navigationController.navigationBar.frame;
                         rect.origin.y = 20;
                         sSelf.navigationController.navigationBar.frame = rect;
                     }
                     completion:^(BOOL finished){
                         OMDBaseViewController *sSelf = wSelf;
                         sSelf.isHidedNavBar = NO;
                     }];
}

- (void)hideNavigationBarWithDuration:(CGFloat)dur
{
    __weak OMDBaseViewController *wSelf = self;
    [UIView animateWithDuration:dur
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^(){
                         OMDBaseViewController *sSelf = wSelf;
                         CGRect rect = sSelf.navigationController.navigationBar.frame;
                         rect.origin.y = -rect.size.height;
                         sSelf.navigationController.navigationBar.frame = rect;
                     }
                     completion:^(BOOL finished){
                         OMDBaseViewController *sSelf = wSelf;
                         sSelf.isHidedNavBar = YES;
                     }];
}

#pragma mark -- private methods --
- (void)showAlertViewWithMessage:(NSString *)message
{
    [self showAlertViewWithMessage:message tag:-1 cancelString:@"Cancel" sureString:@"OK"];
}

- (void)showAlertViewWithMessage:(NSString *)message
                             tag:(NSInteger)tag
                    cancelString:(NSString *)cancelStr
                      sureString:(NSString *)sureStr
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:self cancelButtonTitle:cancelStr otherButtonTitles:sureStr, nil];
    alert.tag = tag;
//    if (tag>=0) {
//        alert.tag = tag;
//    }
    [alert show];
}

- (void)showProcessHUD:(NSString *)text inView:(UIView *)view
{
    [MBProgressHUD showHUDAddedTo:view text:text animated:YES];
}

- (void)showProcessHUD:(NSString *)text
{
    if (text) {
        [MBProgressHUD showHUDAddedTo:self.view  text:text animated:YES];
    }
    else {
        [MBProgressHUD showHUDAddedTo:self.view  text:nil animated:YES];
    }
}

- (void)showProcessHUD:(NSString *)text completionBlock:(void (^)(void))comepletion
{
    if (text) {
        [MBProgressHUD showHUDAddedTo:self.view  text:text animated:YES];
    }
    else {
        [MBProgressHUD showHUDAddedTo:self.view  text:nil animated:YES];
    }
    if (comepletion) {
        comepletion();
    }
}

- (void)hideProcessHUD
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

- (void)hideProcessHUDForView:(UIView *)view
{
    [MBProgressHUD hideAllHUDsForView:view animated:YES];
}

- (void)showToast:(NSString *)text
{
//    [self showToastWith:text duration:2 completionBlock:NULL];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.color = [UIColor whiteColor];
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = text;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hide:YES afterDelay:1.0];
}

- (void)showToast:(NSString *)text duration:(CGFloat)duration
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = text;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hide:YES afterDelay:duration];
}

- (void)showToastWith:(NSString *)text duration:(CGFloat)duration completionBlock:(void (^)(void))comepletion
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.color = [UIColor whiteColor];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = text;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    hud.completionBlock = comepletion;
    [hud hide:YES afterDelay:1.0];
}

@end
