//
//  AppDelegate.m
//  BSY0720
//
//  Created by jway on 15-7-20.
//  Copyright (c) 2015年 jway. All rights reserved.
//

#import "AppDelegate.h"
#import "AFNetworkActivityIndicatorManager.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //初始化并设置网络热舞请求管理器
    self.manager=[AFHTTPRequestOperationManager manager];
    self.manager.responseSerializer=[AFJSONResponseSerializer serializer];
    //实例化网络状态管理器
    self.Rea_manager=[AFNetworkReachabilityManager sharedManager];
    //先设置登录状态为未登录
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:0] forKey:@"state"];
    //初始化网络活动指示器
    //初始化网络活动指示器
    [AFNetworkActivityIndicatorManager sharedManager].enabled=YES;
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    //开始检测网络连接状态
    [self.Rea_manager stopMonitoring];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    //开始检测网络连接状态
    [self.Rea_manager startMonitoring];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
