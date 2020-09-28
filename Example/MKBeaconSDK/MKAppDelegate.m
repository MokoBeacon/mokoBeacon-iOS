//
//  MKAppDelegate.m
//  MKBeaconSDK
//
//  Created by aadyx2007@163.com on 09/28/2020.
//  Copyright (c) 2020 aadyx2007@163.com. All rights reserved.
//

#import "MKAppDelegate.h"

#import "HCKScanViewController.h"

static NSString *const UMengKey = @"5a027550f43e485063000288";
NSString *const centralManagerStateChangedNotification = @"centralManagerStateChangedNotification";
NSString *const peripheralConnectStateChangedNotification = @"peripheralConnectStateChangedNotification";

@interface MKAppDelegate ()

@end

@implementation MKAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _window.backgroundColor = COLOR_WHITE_MACROS;
    [HCKBeaconCentralManager sharedInstance].stateDelegate = self;
    HCKScanViewController *vc = [[HCKScanViewController alloc] initWithNavigationType:GYNaviTypeShow];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    _window.rootViewController = nav;
    [_window makeKeyAndVisible];
    //友盟统计
    [self loadMobClick];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - HCKCentralStatesChangedDelegate
- (void)centralManagerStateChanged:(HCKBeaconCentralManagerState)managerState manager:(HCKBeaconCentralManager *)manager{
    [[NSNotificationCenter defaultCenter]postNotificationName:centralManagerStateChangedNotification object:nil];
}
- (void)peripheralConnectStateChanged:(HCKBeaconConnectStatus)connectState manager:(HCKBeaconCentralManager *)manager{
    [[NSNotificationCenter defaultCenter] postNotificationName:peripheralConnectStateChangedNotification object:nil];
}

/**
 加载友盟统计，采用的是默认模式(app启动的时候，如果存在crash，则发送,)
 */
- (void)loadMobClick{
    //友盟统计
    NSString * version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [UMConfigInstance setAppKey:UMengKey];
    [MobClick setAppVersion:version];
    [MobClick startWithConfigure:UMConfigInstance];
}

@end
