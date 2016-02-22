//
//  registerViewController.h
//  BSY0720
//
//  Created by jway on 15-7-28.
//  Copyright (c) 2015年 jway. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface registerViewController : UIViewController<UITextFieldDelegate>
//返回
- (IBAction)back:(id)sender;

//背景1
@property (weak, nonatomic) IBOutlet UIView *bg1;
//电话号码输入框
@property (weak, nonatomic) IBOutlet UITextField *telphone;
//验证码输入框
@property (weak, nonatomic) IBOutlet UITextField *randomNum;
//背景2
@property (weak, nonatomic) IBOutlet UIView *bg2;
//密码输入
@property (weak, nonatomic) IBOutlet UITextField *password;
//背景3
@property (weak, nonatomic) IBOutlet UIView *bg3;
//密码再次输入
@property (weak, nonatomic) IBOutlet UITextField *password_again;
//获取验证码
@property (weak, nonatomic) IBOutlet UIButton *getRandom;
//获取验证码
- (IBAction)getRandom:(id)sender;
//立即注册
- (IBAction)registerNow:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *registerNow;
@end
