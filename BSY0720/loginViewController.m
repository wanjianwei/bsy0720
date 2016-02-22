//
//  loginViewController.m
//  BSY0720
//
//  Created by jway on 15-7-28.
//  Copyright (c) 2015年 jway. All rights reserved.
//

#import "loginViewController.h"
#import "AppDelegate.h"
#import "TFIndicatorView.h"
#import "registerViewController.h"
@interface loginViewController (){
    AppDelegate * app;
    //定义一个标志，用来表示是否记住密码
    int flag;
}

@end

@implementation loginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化导航栏
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"注册" style:UIBarButtonItemStyleDone target:self action:@selector(toRegister)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor blackColor];
    // 初始化
    self.bg1.layer.borderColor = [UIColor grayColor].CGColor;
    self.bg1.layer.borderWidth = 1.0f;
    self.bg2.layer.borderColor = [UIColor grayColor].CGColor;
    self.bg2.layer.borderWidth = 1.0f;
    self.forgetPwd.layer.cornerRadius = 3.0f;
    self.login.layer.cornerRadius = 4.0f;
    //初始化
    app = [UIApplication sharedApplication].delegate;
    
    //定义手势处理器，用来关闭键盘
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
    [self.username resignFirstResponder];
    [self.password resignFirstResponder];
}

//跳转到登录
-(void)toRegister{
    UIStoryboard * main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    registerViewController * reigsterView = [main instantiateViewControllerWithIdentifier:@"register"];
    reigsterView.title = @"注册";
    [self.navigationController pushViewController:reigsterView animated:YES];
}

//返回
- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//忘记密码
- (IBAction)forgetPwd:(id)sender {
}
//是否自动登录
- (IBAction)isRemPwd:(id)sender {
    if (flag == 1) {
        flag = 0;
    }else{
        flag = 1;
    }
    if (flag == 1) {
        //自动登录
        [self.isRemPwd setBackgroundImage:[UIImage imageNamed:@"login_checkbox_2.png"] forState:UIControlStateNormal];
    }else{
        [self.isRemPwd setBackgroundImage:[UIImage imageNamed:@"login_checkbox_1.png"] forState:UIControlStateNormal];
    }
}
- (IBAction)login:(id)sender {
    //界面失去响应
    self.login.userInteractionEnabled = NO;
    self.login.backgroundColor = [UIColor lightGrayColor];
    self.view.userInteractionEnabled = NO;
    //构建活动指示器
    TFIndicatorView * indicator = [[TFIndicatorView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-20, [UIScreen mainScreen].bounds.size.height/2-20, 40, 40)];
    [indicator startAnimating];
    [self.view addSubview:indicator];
    
    //构造发送数据
    NSDictionary * send = [NSDictionary dictionaryWithObjectsAndKeys:self.username.text,@"username",self.password.text,@"password", nil];
    //发送服务器
    [app.manager POST:@"http://120.25.162.238/bsy/index.php/Index/Index/login" parameters:send success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //请求成功
        [indicator removeFromSuperview];
        self.login.userInteractionEnabled = YES;
        self.login.backgroundColor = [UIColor orangeColor];
        self.view.userInteractionEnabled = YES;
        //判断是否获取数据成功
        if (operation.responseData != nil) {
            //解析数据
            NSDictionary * returnDic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
            if ([[returnDic objectForKey:@"code"] isEqualToString:@"100000"]) {
                //登录成功
                [self dismissViewControllerAnimated:YES completion:nil];
                 //将服务器返回的一些数据进行持久化存储
                [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:1] forKey:@"state"];
                [[NSUserDefaults standardUserDefaults] setObject:[[returnDic objectForKey:@"result"] objectForKey:@"Customer"] forKey:@"Customer"];
                //单独存储账户余额
                [[NSUserDefaults standardUserDefaults] setObject:[[[returnDic objectForKey:@"result"] objectForKey:@"Customer"] objectForKey:@"balance"] forKey:@"balance"];
                [self.delegate returnToTabViewController];
            }else{
                //登录失败
                UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:[returnDic objectForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
                [alert addAction:action];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }else{
            //登录失败
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"登录失败，请检查网络连接是否正常" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
}


@end
