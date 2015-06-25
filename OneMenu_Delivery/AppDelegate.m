//
//  AppDelegate.m
//  OneMenu_Delivery
//
//  Created by simmyoung on 15/6/3.
//  Copyright (c) 2015年 One Menu Limited Liability Company. All rights reserved.
//

#import "AppDelegate.h"
#import "OMDDeliveringViewController.h"
#import "OMDDeliveriedViewController.h"

#import "OMDAllOrderViewController.h"

#import <AWSSNS.h>
#import <AWSCognito.h>

#import "OMDLocationManager.h"

@interface AppDelegate ()
<UITabBarControllerDelegate>

@property (nonatomic, assign) NSInteger tabbarSeletectedIndex;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [NSThread sleepForTimeInterval:1.5];
    
    [application setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
#ifdef __IPHONE_8_0
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIRemoteNotificationTypeBadge
                                                                                             |UIRemoteNotificationTypeSound
                                                                                             |UIRemoteNotificationTypeAlert) categories:nil];
        [application registerUserNotificationSettings:settings];
#endif
    } else {
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        [application registerForRemoteNotificationTypes:myTypes];
    }
    
    [[OMDLocationManager sharedInstance] start];
    
    [AWSLogger defaultLogger].logLevel = AWSLogLevelVerbose;
    
    if (launchOptions) {
        NSDictionary *userInfo = [launchOptions valueForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"];
        if (userInfo) {
            NSDictionary *apsInfo = [userInfo objectForKey:@"aps"];
            NSString *badgeStr = [apsInfo objectForKey:@"badge"];
            [OMDUtility increaseAppBadgeWith:[badgeStr integerValue]];
        }
    }
    
    [self createUserPath];
    
    [self initTabbarController];
    
    self.window.rootViewController = self.tabbarCtrl;
    
    [self appConfigRequest];
//    [self autoLoginRequest];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)initTabbarController
{
    OMDDeliveringViewController *deliveringCtrl = [[OMDDeliveringViewController alloc] init];
    OMBaseNavigationController *deliveringNavCtrl = [[OMBaseNavigationController alloc] initWithRootViewController:deliveringCtrl];
    OMDDeliveriedViewController *deliveriedCtrl = [[OMDDeliveriedViewController alloc] init];
    OMBaseNavigationController *deliveredNavCtrl = [[OMBaseNavigationController alloc] initWithRootViewController:deliveriedCtrl];
  
#ifdef APP_MANAGER
    OMDAllOrderViewController *allOrderCtrl = [[OMDAllOrderViewController alloc] init];
    OMBaseNavigationController *allOrderNavCtrl = [[OMBaseNavigationController alloc] initWithRootViewController:allOrderCtrl];
#endif
    
    self.tabbarCtrl = [[UITabBarController alloc] init];
    self.tabbarCtrl.delegate = self;
#ifdef APP_MANAGER
    self.tabbarCtrl.viewControllers = @[deliveringNavCtrl,deliveredNavCtrl,allOrderNavCtrl];
#else
    self.tabbarCtrl.viewControllers = @[deliveringNavCtrl,deliveredNavCtrl];
#endif
//    self.tabbarCtrl.viewControllers = @[deliveringNavCtrl,allOrderNavCtrl,deliveredNavCtrl];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
//    [self initTabbarController];
//    self.window.rootViewController = self.tabbarCtrl;
    [self receiveRemoteNotificationAction];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    if (deviceToken) {
//        NSString *notificationDeviceTokenStr = [[NSString alloc] initWithData:deviceToken encoding:NSUTF8StringEncoding];
//        NSLog(@"tokenStr = %@",notificationDeviceTokenStr);
//        [OMUtility saveNotificationDeviceTokenWith:notificationDeviceTokenStr];
        NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
        token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
        [OMDUtility saveNotificationDeviceTokenWith:token];
    }
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    NSDictionary *apsDict = [userInfo objectForKey:@"aps"];
//    NSString *alertStr = [apsDict objectForKey:@"alert"];
    NSString *badgeStr = [apsDict objectForKey:@"badge"];
//    [OMDUtility increaseAppBadgeWith:[badgeStr integerValue]];
    [OMDUtility setAppBadgeWith:[badgeStr integerValue]];
    [self receiveRemoteNotificationAction];
    if (application.applicationState == UIApplicationStateActive) {
        UILocalNotification *localNoti = [[UILocalNotification alloc] init];
        localNoti.alertBody = @"You have new orders";
        NSDate *now = [NSDate date];
        localNoti.fireDate = [now dateByAddingTimeInterval:2]; //触发通知的时间
        localNoti.timeZone=[NSTimeZone defaultTimeZone];
        localNoti.soundName = UILocalNotificationDefaultSoundName;
        localNoti.repeatInterval = 0; //循环次数，kCFCalendarUnitWeekday一周一次
//        localNoti.alertAction = @"OK";  //提示框按钮
//        localNoti.hasAction = YES;
        localNoti.applicationIconBadgeNumber = [badgeStr integerValue];
        //发送通知
        [[UIApplication sharedApplication] scheduleLocalNotification:localNoti];
    }
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:notification.alertBody delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

#pragma mark --
- (void)receiveRemoteNotificationAction
{
    UIViewController *lastCtrl = [[(OMBaseNavigationController *)[(UITabBarController *)[[UIApplication sharedApplication] delegate].window.rootViewController selectedViewController] viewControllers] lastObject];
    
    UIViewController *topCtl = lastCtrl;
    while (topCtl.presentedViewController) {
        topCtl = topCtl.presentedViewController;
    }
    if (topCtl && [topCtl isKindOfClass:[UINavigationController class]]) {
        UIViewController *root = [(UINavigationController *)topCtl viewControllers][0];
        [root dismissViewControllerAnimated:NO completion:NULL];
    }
    [self.tabbarCtrl setSelectedIndex:0];
    UIViewController *lastViewCtrl = [[(OMBaseNavigationController *)[self.tabbarCtrl selectedViewController] viewControllers] lastObject];
    [lastViewCtrl.navigationController popToRootViewControllerAnimated:NO];
    OMDDeliveringViewController *deliveringCtrl = (OMDDeliveringViewController *)[[(OMBaseNavigationController *)[self.tabbarCtrl selectedViewController] viewControllers] firstObject];
    [deliveringCtrl refreshTableView];
}

- (void)appConfigRequest
{
    [[OMDNetworkManager createNetworkEngineer]
     getAppConfigWith:nil
     completeBlock:^(OMDNetworkBaseResult *responseObj) {
         
     }
     failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
         
     }];
}

//- (void)autoLoginRequest
//{
//    OMDAutoLoginRequest *request = [[OMDAutoLoginRequest alloc] init];
//    request.loginToken = [OMDUtility getCurrentCustomerLoginToken];
//    
//    if (request.loginToken) {
//        [[OMDNetworkManager createNetworkEngineer]
//         autoLoginWith:request
//         completeBlock:^(OMDNetworkBaseResult *responseObj) {
//            
//        }
//         failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
//            
//        }];
//    }
//    else {
//        [[NSNotificationCenter defaultCenter] postNotificationName:kAutoLoginFailureNotification object:nil];
//    }
//}

- (void)createUserPath
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:UserPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:UserPath withIntermediateDirectories:NO attributes:nil error:nil];
    }
    BOOL status = [OMDUtility addSkipBackupAttributeToItemAtURL:[NSURL URLWithString:UserPath]];
    NSLog(@"skip back up %zd",status);
}

#pragma mark UITabbarController Delegate --
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    if (self.tabbarSeletectedIndex == 0 && tabBarController.selectedIndex == 0) {
        OMDDeliveringViewController *deliveringCtrl = (OMDDeliveringViewController *)[[(OMBaseNavigationController *)viewController viewControllers] firstObject];
        [deliveringCtrl refreshTableView];
    }
    else if (self.tabbarSeletectedIndex == 2 && tabBarController.selectedIndex == 2) {
        OMDAllOrderViewController *allOrderCtrl = (OMDAllOrderViewController *)[[(OMBaseNavigationController *)viewController viewControllers] objectAtIndex:0];
        [allOrderCtrl refreshTableView];
    }
    else if (self.tabbarSeletectedIndex == 1 && tabBarController.selectedIndex == 1) {
        OMDDeliveriedViewController *deliveriedCtrl = (OMDDeliveriedViewController *)[[(OMBaseNavigationController *)viewController viewControllers] objectAtIndex:0];
        [deliveriedCtrl refreshTableView];
    }
    self.tabbarSeletectedIndex = tabBarController.selectedIndex;
}

@end
