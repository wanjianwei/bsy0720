//
//  payPwdCertiViewController.h
//  BSY0720
//
//  Created by jway on 15-7-29.
//  Copyright (c) 2015年 jway. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface payPwdCertiViewController : UIViewController<UITextFieldDelegate>
//密码输入框
@property (weak, nonatomic) IBOutlet UITextField *password1;
@property (weak, nonatomic) IBOutlet UITextField *password2;
//确定
- (IBAction)confirm:(id)sender;
@end
