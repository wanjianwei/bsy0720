//
//  changePwdViewController.m
//  BSY0720
//
//  Created by jway on 15-7-28.
//  Copyright (c) 2015年 jway. All rights reserved.
//

#import "changePwdViewController.h"
#import "TFIndicatorView.h"
#import "AppDelegate.h"
#import "loginViewController.h"
@interface changePwdViewController (){
    AppDelegate * app;
    TFIndicatorView * indicatorView;
}

@end

@implementation changePwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化
    app = [UIApplication sharedApplication].delegate;
    indicatorView = [[TFIndicatorView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-25, [UIScreen mainScreen].bounds.size.height/2-25, 50, 50)];
    [self.view addSubview:indicatorView];
    [indicatorView startAnimating];
    //默认隐藏
    indicatorView.hidden = YES;
    //修饰
    self.oldPwd.layer.cornerRadius = 4.0f;
    self.oldPwd.layer.borderWidth = 1.0f;
    self.oldPwd.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.oldPwd.layer.masksToBounds = YES;
    self.oldPwd.delegate = self;
    
    self.xinPwd.layer.cornerRadius = 4.0f;
    self.xinPwd.layer.borderWidth = 1.0f;
    self.xinPwd.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.xinPwd.layer.masksToBounds = YES;
    self.xinPwd.delegate = self;
    
    self.xinPwd_confirm.layer.cornerRadius = 4.0f;
    self.xinPwd_confirm.layer.borderWidth = 1.0f;
    self.xinPwd_confirm.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.xinPwd_confirm.layer.masksToBounds = YES;
    self.xinPwd_confirm.delegate = self;
    
    //定义一个手势处理器，关闭键盘
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handTap)];
    tap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//关闭键盘
-(void)handTap{
    [self.oldPwd resignFirstResponder];
    [self.xinPwd resignFirstResponder];
    [self.xinPwd_confirm resignFirstResponder];
}

//确定提交
- (IBAction)confirm:(id)sender {
    //先判断是否网络连接正常
    if (app.Rea_manager.reachable == YES) {
        //首先密码输入要符合格式
        if ([self.oldPwd.text isEqual:@""] || [self.xinPwd.text isEqual:@""]) {
            //请将信息填写完整
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请将信息填写完整" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }else if (![[NSPredicate predicateWithFormat:@"SELF MATCHES %@",[NSString stringWithFormat:@"^[A-Z0-9a-z_]{6,24}+$"]] evaluateWithObject:self.xinPwd.text]){
            //新密码不符合格式
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入6~24位，由数字，字母下划线组成的新密码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }else if (![self.xinPwd.text isEqualToString:self.xinPwd_confirm.text]){
            //两次密码输入不一致
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"新密码前后输入不一致" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }else{
            //活动指示器出现
            indicatorView.hidden = NO;
            //发送给服务器
            NSDictionary * send = [NSDictionary dictionaryWithObjectsAndKeys:self.oldPwd.text,@"old_password",self.xinPwd_confirm.text,@"new_password", nil];
            [self.view addSubview:indicatorView];
            [indicatorView startAnimating];
            [app.manager POST:@"http://120.25.162.238/bsy/index.php/Index/AccountSecurity/modifyLoginPwd" parameters:send success:^(AFHTTPRequestOperation *operation, id responseObject) {
                //
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                //隐藏活动指示器
                indicatorView.hidden = YES;
                NSDictionary * returnDic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
                if ([[returnDic objectForKey:@"code"] isEqualToString:@"100000"]) {
                    //密码重置成功
                    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:[returnDic objectForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                        //返回
                        [self.navigationController popViewControllerAnimated:YES];
                    }];
                    [alert addAction:action];
                    [self presentViewController:alert animated:YES completion:nil];
                }else if ([[returnDic objectForKey:@"code"] isEqualToString:@"100001"]){
                    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请先登录" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                        //弹出登录界面
                        UIStoryboard * main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                        loginViewController * login = [main instantiateViewControllerWithIdentifier:@"login"];
                        login.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
                        [self presentViewController:login animated:YES completion:nil];
                    }];
                    UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                    [alert addAction:action];
                    [alert addAction:action1];
                    [self presentViewController:alert animated:YES completion:nil];
                }
                else{
                    //错误提示
                    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[returnDic objectForKey:@"message"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                }
            }];
            
        }

    }else{
        //网络连接失败
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请求失败，请检查网络是否已连接" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}

#pragma UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

@end
