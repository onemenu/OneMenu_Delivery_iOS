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

#import "OMDLocationManager.h"

@interface AppDelegate ()

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
    
//    [AWSLogger defaultLogger].logLevel = AWSLogLevelVerbose;
    
    OMDDeliveringViewController *deliveringCtrl = [[OMDDeliveringViewController alloc] init];
    UINavigationController *deliveringNavCtrl = [[UINavigationController alloc] initWithRootViewController:deliveringCtrl];
    OMDDeliveriedViewController *deliveriedCtrl = [[OMDDeliveriedViewController alloc] init];
    UINavigationController *deliveredNavCtrl = [[UINavigationController alloc] initWithRootViewController:deliveriedCtrl];
    
    self.tabbarCtrl = [[UITabBarController alloc] init];
    self.tabbarCtrl.delegate = self;
    self.tabbarCtrl.viewControllers = @[deliveringNavCtrl,deliveredNavCtrl];
    
    self.window.rootViewController = self.tabbarCtrl;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
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
    }
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    
}

//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
//{
//    
//}

@end
