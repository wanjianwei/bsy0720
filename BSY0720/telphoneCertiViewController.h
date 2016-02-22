//
//  telphoneCertiViewController.h
//  BSY0720
//
//  Created by jway on 15-7-28.
//  Copyright (c) 2015年 jway. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface telphoneCertiViewController : UIViewController

//手机号码输入
@property (weak, nonatomic) IBOutlet UITextField *phoneNum;
//短信验证码输入
@property (weak, nonatomic) IBOutlet UITextField *randNum;
//验证码输入
@property (weak, nonatomic) IBOutlet UITextField *vcode;
//验证码图片
@property (weak, nonatomic) IBOutlet UIImageView *vcodeImg;

//发送手机号码
- (IBAction)sendPhone:(id)sender;
//未收到验证码
- (IBAction)getRandom:(id)sender;
//提交
- (IBAction)sendUp:(id)sender;
@end
