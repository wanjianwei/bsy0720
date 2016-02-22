//
//  realnameCertiViewController.m
//  BSY0720
//
//  Created by jway on 15-7-28.
//  Copyright (c) 2015年 jway. All rights reserved.
//

#import "realnameCertiViewController.h"
#import "AppDelegate.h"
#import "TFIndicatorView.h"
@interface realnameCertiViewController (){
    AppDelegate * app;
    //活动指示器
    TFIndicatorView * indicator;
}

@end

@implementation realnameCertiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化
    self.certiNum.layer.cornerRadius = 4.0f;
    self.certiNum.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.certiNum.layer.borderWidth = 1.0f;
    self.certiNum.layer.masksToBounds = YES;
    
    self.studentNum.layer.cornerRadius = 4.0f;
    self.studentNum.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.studentNum.layer.borderWidth = 1.0f;
    self.studentNum.layer.masksToBounds = YES;
    app = [UIApplication sharedApplication].delegate;
    
    //定义一个手势处理器，关闭架盘
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handTap)];
    tap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tap];
    
    //构建活动指示器
    indicator = [[TFIndicatorView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-25, [UIScreen mainScreen].bounds.size.height/2-25, 50, 50)];
    [indicator startAnimating];
    [self.view addSubview:indicator];
    //默认隐藏活动指示器
    indicator.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//关闭键盘
-(void)handTap{
    [self.certiNum resignFirstResponder];
    [self.studentNum resignFirstResponder];
}

//确定
- (IBAction)confirm:(id)sender {
    if (app.Rea_manager.reachable == YES) {
        //输入合法性判断
        if ([self.certiNum.text isEqual:@""] || [self.studentNum.text isEqual:@""]) {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请将上述上述信息填写完整" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }else if (![[NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"^(\\d{14}|\\d{17})(\\d|[xX])$"] evaluateWithObject:self.certiNum.text]){
            //身份证号不合法
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"身份证号输入不合法" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }else{
            //活动指示器显示
            indicator.hidden = NO;
            NSDictionary * sendDic = [NSDictionary dictionaryWithObjectsAndKeys:self.certiNum.text,@"idcard",self.studentNum.text,@"student_number", nil];
            [app.manager POST:@"http://120.25.162.238/bsy/index.php/Index/Customer/certification" parameters:sendDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                //
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                //活动指示器消失
                indicator.hidden = YES;
                NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
                if ([[dic objectForKey:@"code"] isEqualToString:@"100000"]) {
                    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"认证成功" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                        [self.navigationController popViewControllerAnimated:YES];
                    }];
                    [alert addAction:action];
                    [self presentViewController:alert animated:YES completion:nil];
                }else{
                    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[dic objectForKey:@"message"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                }
            }];
        }
    }else{
        //网络连接异常
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"请求失败" message:@"请检查网络连接是否异常" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}

@end
