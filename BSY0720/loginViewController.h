//
//  loginViewController.h
//  BSY0720
//
//  Created by jway on 15-7-28.
//  Copyright (c) 2015年 jway. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol returnToTabViewProtocol

-(void)returnToTabViewController;

@end

@interface loginViewController : UIViewController
//返回
- (IBAction)back:(id)sender;

//忘记密码
- (IBAction)forgetPwd:(id)sender;
//登录
- (IBAction)login:(id)sender;
//是否自动登录
- (IBAction)isRemPwd:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *isRemPwd;
//背景图1
@property (weak, nonatomic) IBOutlet UIView *bg1;
//用户名
@property (weak, nonatomic) IBOutlet UITextField *username;
//背景图2
@property (weak, nonatomic) IBOutlet UIView *bg2;
//密码
@property (weak, nonatomic) IBOutlet UITextField *password;
//忘记密码
@property (weak, nonatomic) IBOutlet UIButton *forgetPwd;
//登录
@property (weak, nonatomic) IBOutlet UIButton *login;
//logo图片
@property (weak, nonatomic) IBOutlet UIImageView *logoImg;
//定义一个协议代理
@property (weak,nonatomic) id<returnToTabViewProtocol>delegate;
@end
