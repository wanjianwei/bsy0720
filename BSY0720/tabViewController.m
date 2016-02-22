//
//  tabViewController.m
//  BSY0720
//
//  Created by jway on 15-7-21.
//  Copyright (c) 2015年 jway. All rights reserved.
//

#import "tabViewController.h"
@interface tabViewController ()

@end

@implementation tabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化
    self.tabBar.tintColor = [UIColor redColor];
    self.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma delegate

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    //记住点击的tabViewController
    if ([item.title isEqual:@"理财"]) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:1] forKey:@"selectedController"];
    }else if ([item.title isEqualToString:@"我的"]){
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:4] forKey:@"selectedController"];
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:0] forKey:@"selectedController"];
    }
    
   //将点击的视图指针持久化存储
  // 
    /*
    if([item.title  isEqual: @"理财"] || [item.title isEqual:@"我的"]){
        //判断是否要跳出登录界面
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"state"] intValue] == 0) {
            //跳出登录页面
            UIStoryboard * main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            loginViewController * loginView = [main instantiateViewControllerWithIdentifier:@"login"];
            loginView.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            [self presentViewController:loginView animated:YES completion:nil];
        }
    }
     */
}

//已经选择某视图
-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"state"] intValue] == 0)
    {
        if ([viewController.title isEqual:@"理财"] || [viewController.title isEqual:@"我的"]) {
            //跳出登录页面
            UIStoryboard * main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            loginViewController * loginView = [main instantiateViewControllerWithIdentifier:@"login"];
            loginView.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            //指定协议代理
            loginView.delegate = self;
            [self presentViewController:loginView animated:YES completion:nil];
            return NO;
        }else{
            //不需要登录
            return YES;
        }
    }else{
        //如果已经登录
        return YES;
    }
}

#pragma returnToTabViewProtocol
-(void)returnToTabViewController{
    self.selectedViewController = [self.viewControllers objectAtIndex:[[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedController"] intValue]];
}
@end
