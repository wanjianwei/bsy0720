//
//  changePwdViewController.h
//  BSY0720
//
//  Created by jway on 15-7-28.
//  Copyright (c) 2015年 jway. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface changePwdViewController : UIViewController<UITextFieldDelegate>
//旧密码
@property (weak, nonatomic) IBOutlet UITextField *oldPwd;
//新密码
@property (weak, nonatomic) IBOutlet UITextField *xinPwd;
//新密码确认
@property (weak, nonatomic) IBOutlet UITextField *xinPwd_confirm;
//确定提交
- (IBAction)confirm:(id)sender;
@end
