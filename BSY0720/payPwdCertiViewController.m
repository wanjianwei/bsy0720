//
//  payPwdCertiViewController.m
//  BSY0720
//
//  Created by jway on 15-7-29.
//  Copyright (c) 2015年 jway. All rights reserved.
//

#import "payPwdCertiViewController.h"
#import "AppDelegate.h"
#import "TFIndicatorView.h"
@interface payPwdCertiViewController (){
    //定义一个应用程序委托类
    AppDelegate * app;
    //定义一个活动指示器
    TFIndicatorView * indicator;
}

@end

@implementation payPwdCertiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"支付密码";
    //初始化
    app = [UIApplication sharedApplication].delegate;
    self.password1.delegate = self;
    self.password2.delegate = self;
    //定义一个手势处理器，用来关闭键盘
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handTap)];
    tap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tap];
    //修饰外观
    self.password1.layer.cornerRadius = 4.0f;
    self.password1.layer.borderColor = [UIColor grayColor].CGColor;
    self.password1.layer.borderWidth = 1.0f;
    self.password2.layer.borderWidth = 1.0f;
    self.password2.layer.borderColor = [UIColor grayColor].CGColor;
    self.password2.layer.cornerRadius = 4.0f;
    //构建活动指示器
    indicator = [[TFIndicatorView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-25, [UIScreen mainScreen].bounds.size.height/2-25, 50, 50)];
    [indicator startAnimating];
    [self.view addSubview:indicator];
    //默认隐藏
    indicator.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//关闭键盘
-(void)handTap{
    [self.password1 resignFirstResponder];
    [self.password2 resignFirstResponder];
}
//确认
- (IBAction)confirm:(id)sender {
    //先判断是否网络连接正常
    if (app.Rea_manager.reachable == YES) {
        if ([self.password1.text isEqualToString:self.password2.text]) {
            //活动指示器显示
            indicator.hidden = NO;
            //构造发送函数
            NSDictionary * senddic = [NSDictionary dictionaryWithObjectsAndKeys:self.password1.text,@"trade_pass", nil];
            [app.manager POST:@"http://120.25.162.238/bsy/index.php/Index/AccountSecurity/setTradePwd" parameters:senddic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                //
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                //活动指示器隐藏
                indicator.hidden = YES;
                NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
                
                NSLog(@"%@",dic);
                
                if ([[dic objectForKey:@"code"] isEqualToString:@"100000"]) {
                    //支付密码设置成功
                    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"支付密码设置成功" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                        [self.navigationController popViewControllerAnimated:YES];
                    }];
                    [alert addAction:action];
                    [self presentViewController:alert animated:YES completion:nil];
                }else{
                    //支付密码设置失败
                    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[dic objectForKey:@"message"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                }
            }];
            
        }else{
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"两次密码输入不匹配" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    }else{
        //网络连接异常
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先检查网络连接是否正常" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    
}

#pragma UITextFieldDelegate
//限制密码输入位数始终为6位
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (string.length == 0) {
        return YES;
    }
    NSInteger existedLength = textField.text.length;
    NSInteger selectedLength = range.length;
    NSInteger replaceLength = string.length;
    if (existedLength - selectedLength + replaceLength > 6) {
        return NO;
    }else{
        return YES;
    }
}
@end
