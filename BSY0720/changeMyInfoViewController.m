//
//  changeMyInfoViewController.m
//  BSY0720
//
//  Created by jway on 15-8-3.
//  Copyright (c) 2015年 jway. All rights reserved.
//

#import "changeMyInfoViewController.h"
#import "AppDelegate.h"
#import "TFIndicatorView.h"
@interface changeMyInfoViewController (){
    AppDelegate * app;
    //活动指示器
    TFIndicatorView * indicator;
}

@end

@implementation changeMyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //修饰外观
    self.toChangeInfo.layer.cornerRadius = 4.0f;
    self.toChangeInfo.layer.borderColor = [UIColor grayColor].CGColor;
    self.toChangeInfo.layer.borderWidth = 1.0f;
    
    if ([self.flag intValue] == 1) {
        self.toChangeInfo.placeholder = @"请输入昵称";
        self.title = @"修改昵称";
    }else if([self.flag intValue] == 2) {
        //修改姓名
        self.toChangeInfo.placeholder = @"请输入姓名";
        self.title = @"修改姓名";
    }else{
        //修改院系
        self.toChangeInfo.placeholder = @"请输入院系";
        self.title = @"修改院系";
    }
    
    //定义手势处理器，关闭键盘
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handTap)];
    tap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tap];
    //初始化
    app = [UIApplication sharedApplication].delegate;
    
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
    [self.toChangeInfo resignFirstResponder];
}
//保存
- (IBAction)save:(id)sender {
    //判断输入合法性
    if (app.Rea_manager.reachable == YES) {
        if ([self.toChangeInfo.text isEqualToString:@""]) {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先填写待修改信息" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }else{
            //活动指示器出现
            indicator.hidden = NO;
            NSDictionary * sendDic;
            //构造发送数据
            if ([self.flag intValue] == 1) {
                sendDic = [NSDictionary dictionaryWithObjectsAndKeys:self.toChangeInfo.text,@"name", nil];
            }else if ([self.flag intValue] == 2){
                sendDic = [NSDictionary dictionaryWithObjectsAndKeys:self.toChangeInfo.text,@"realname", nil];
            }else{
                sendDic = [NSDictionary dictionaryWithObjectsAndKeys:self.toChangeInfo.text,@"department", nil];
            }
            [app.manager POST:@"http://120.25.162.238/bsy/index.php/Index/Customer/editInfo" parameters:sendDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                //
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                //活动指示器隐藏
                indicator.hidden = YES;
                NSDictionary * getdic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
                if ([[getdic objectForKey:@"code"] isEqualToString:@"100000"]) {
                    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:[getdic objectForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                        [self.navigationController popViewControllerAnimated:YES];
                    }];
                    [alert addAction:action];
                    [self presentViewController:alert animated:YES completion:nil];
                }else{
                    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[getdic objectForKey:@"message"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                }
            }];
            
        }
    }else{
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先检查网络连接是否正常" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}
@end
