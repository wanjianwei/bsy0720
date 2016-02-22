//
//  AppDelegate.h
//  BSY0720
//
//  Created by jway on 15-7-20.
//  Copyright (c) 2015年 jway. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetWorking.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(strong,nonatomic) AFHTTPRequestOperationManager *manager;
//定义一个检测网络连接状态的管理器
@property(nonatomic,strong)AFNetworkReachabilityManager*Rea_manager;
@end

