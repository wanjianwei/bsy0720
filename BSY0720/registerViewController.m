//
//  registerViewController.m
//  BSY0720
//
//  Created by jway on 15-7-28.
//  Copyright (c) 2015年 jway. All rights reserved.
//

#import "registerViewController.h"
#import "AppDelegate.h"
#import "TFIndicatorView.h"
@interface registerViewController (){
    AppDelegate * app;
    //倒计时变量
    int num;
    //定义一个计时器
    NSTimer * timer;
    //定义一个字典，用来接受服务器返回数据
    NSDictionary * returnDic;
}

@end

@implementation registerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化
    self.bg1.layer.borderWidth = 1.0f;
    self.bg1.layer.borderColor = [UIColor grayColor].CGColor;
    self.bg2.layer.borderWidth = 1.0f;
    self.bg2.layer.borderColor = [UIColor grayColor].CGColor;
    self.bg3.layer.borderWidth = 1.0f;
    self.bg3.layer.borderColor = [UIColor grayColor].CGColor;
    self.randomNum.layer.borderColor = [UIColor grayColor].CGColor;
    self.randomNum.layer.borderWidth = 1.0f;
    self.randomNum.layer.masksToBounds = YES;
    self.registerNow.layer.cornerRadius = 4.0f;
    //指定代理
    self.randomNum.delegate = self;
    //初始化程序委托类
    app = [UIApplication sharedApplication].delegate;
    [self.getRandom setTitle:@"获取验证码" forState:UIControlStateNormal];
    
    //注册手势处理器
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
    [self.telphone resignFirstResponder];
    [self.password resignFirstResponder];
    [self.password_again resignFirstResponder];
    [self.randomNum resignFirstResponder];
}
//返回
- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//获取验证码
- (IBAction)getRandom:(id)sender {
    if (![[NSPredicate predicateWithFormat:@"SELF MATCHES %@",[NSString stringWithFormat:@"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,1，5-9]))\\d{8}$"]] evaluateWithObject:self.telphone.text]){
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"输入手机号不合法" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        //取消按钮的响应属性
        self.getRandom.userInteractionEnabled = NO;
        self.getRandom.backgroundColor = [UIColor grayColor];
        //开启定时器
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(count) userInfo:nil repeats:YES];
        //时间为一分钟
        num = 60;
        //构造发送数据
        NSDictionary * sendDic = [NSDictionary dictionaryWithObject:self.telphone.text forKey:@"phonenum"];
        [app.manager POST:@"http://120.25.162.238/bsy/index.php/Index/Register/getCustomerCode" parameters:sendDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            //
            if (operation.responseData !=nil) {
                returnDic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"%@",returnDic);
                if ([[returnDic objectForKey:@"code"] isEqualToString:@"100000"]) {
                    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:[returnDic objectForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                        self.randomNum.text = [[returnDic objectForKey:@"result"] objectForKey:@"code"];
                        //恢复
                        [timer invalidate];
                        self.getRandom.userInteractionEnabled = YES;
                        [self.getRandom setTitle:@"重新获取验证码" forState:UIControlStateNormal];
                        self.getRandom.backgroundColor = [UIColor orangeColor];
                    }];
                    [alert addAction:action];
                    [self presentViewController:alert animated:YES completion:nil];
                }else{
                    //获取验证码失败
                    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[returnDic objectForKey:@"message"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                }
            }else{
                //网络连接出现问题
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请求短信验证码失败，请检查网络连接是否正常" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
            
        }];

    }
}

//立即注册
- (IBAction)registerNow:(id)sender {
    if (![self.password.text isEqual:self.password_again.text]) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"密码输入不一致" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }else if (![[NSPredicate predicateWithFormat:@"SELF MATCHES %@",[NSString stringWithFormat:@"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,1，5-9]))\\d{8}$"]] evaluateWithObject:self.telphone.text]){
        //电话号码不符合格式
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"输入手机号码不合法" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }else if (![[NSPredicate predicateWithFormat:@"SELF MATCHES %@",[NSString stringWithFormat:@"^[A-Z0-9a-z_]{6,24}+$"]] evaluateWithObject:self.password.text]){
        //用户密码不合法
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"输入密码不符合格式" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        //界面失去响应
        self.registerNow.userInteractionEnabled = NO;
        self.getRandom.userInteractionEnabled = NO;
        //构建活动指示器
        TFIndicatorView * indicator = [[TFIndicatorView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-20, [UIScreen mainScreen].bounds.size.height/2-20, 40, 40)];
        [indicator startAnimating];
        [self.view addSubview:indicator];
        //构建发送数据
        NSDictionary * sendDic = [NSDictionary dictionaryWithObjectsAndKeys:self.telphone.text,@"phonenum",self.randomNum.text,@"code",self.password.text,@"password", nil];
        [app.manager POST:@"http://120.25.162.238/bsy/index.php/Index/Register/customer" parameters:sendDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            //恢复按钮的事件响应
            self.registerNow.userInteractionEnabled = YES;
            self.getRandom.userInteractionEnabled = YES;
            //判断是否请求服务器成功
            if (operation.responseData != nil) {
                returnDic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
                if ([[returnDic objectForKey:@"code"] isEqualToString:@"100000"]){
                    //注册成功
                    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"注册成功！" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                        //返回登录界面
                        [self dismissViewControllerAnimated:YES completion:^{
                            returnDic = nil;
                        }];
                    }];
                    [alert addAction:action];
                    [self presentViewController:alert animated:YES completion:nil];
                }else{
                    //注册失败
                    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:[returnDic objectForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
                    [alert addAction:action];
                    [self presentViewController:alert animated:YES completion:nil];
                }
            }else{
                //请求服务器错误
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"注册失败，请检查网络是否连接正常" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
        }];

    }
}

//获取验证码倒计时
-(void)count{
    [self.getRandom setTitle:[NSString stringWithFormat:@"剩余(%i)s",num] forState:UIControlStateNormal];
    if (num > 0) {
        num --;
    }else{
        //计时完毕,按钮恢复
        self.getRandom.userInteractionEnabled = YES;
        self.getRandom.backgroundColor = [UIColor orangeColor];
        [self.getRandom setTitle:@"重新获取验证码" forState:UIControlStateNormal];
        [self.getRandom setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        //计时器销毁
        [timer invalidate];
    }
}


#pragma UITextFieldDelegate
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag == 1) {
        //定时器停止，按钮恢复
        [timer invalidate];
        self.getRandom.userInteractionEnabled = YES;
        self.getRandom.backgroundColor = [UIColor orangeColor];
        if ([textField.text isEqual:[[returnDic objectForKey:@"result"] objectForKey:@"code"]]){
            [self.getRandom setTitle:@"获取验证码" forState:UIControlStateNormal];
        }else{
            //验证码填写错误
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"验证码填写错误" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [self.getRandom setTitle:@"重新获取验证码" forState:UIControlStateNormal];
            }];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
    
}

@end
