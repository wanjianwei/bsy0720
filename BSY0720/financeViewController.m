//
//  financeViewController.m
//  BSY0720
//
//  Created by jway on 15-7-22.
//  Copyright (c) 2015年 jway. All rights reserved.
//

#import "financeViewController.h"
#import "AppDelegate.h"
#import "zhuxueBTableViewController.h"
#import "myBillTableViewController.h"
#import "TFIndicatorView.h"
#define a  ([UIScreen mainScreen].bounds.size.height - 112)
#define b  [UIScreen mainScreen].bounds.size.width
@interface financeViewController (){
    //引入程序代理
    AppDelegate * app;
    //定义故事版引用
    UIStoryboard * main;
    //定义一个活动指示器
    TFIndicatorView * indicatorView;
    //定义一个label,存储余额
    UILabel * lab4;
}

@end

@implementation financeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   //定义导航栏
    self.title = @"理财";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"账单" style:UIBarButtonItemStyleDone target:self action:@selector(checkfinanceList)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor blackColor];
    // 添加视图
    UIImageView * view1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, b, a*2/3)];
    view1.image = [UIImage imageNamed:@"financeBg.png"];
    [self.view addSubview:view1];
    //定义"昨日收益"
    UILabel * lab1 = [[UILabel alloc] initWithFrame:CGRectMake(0,25, b, 30)];
    lab1.text = @"昨日收益(元)";
    lab1.textAlignment = NSTextAlignmentCenter;
    lab1.font = [UIFont boldSystemFontOfSize:(a == 320)?15:17];
    [view1 addSubview:lab1];
    //收益金额框
    UILabel * lab2 = [[UILabel alloc] initWithFrame:CGRectMake(0, a/6, b, a/6)];
    lab2.font = [UIFont boldSystemFontOfSize:(b == 320)?50:60];
    lab2.textAlignment = NSTextAlignmentCenter;
    lab2.textColor = [UIColor redColor];
    [view1 addSubview:lab2];
    
    //“币生通总金额”
    UILabel * lab3 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lab2.frame)+((a == 368)?20:50), b, 30)];
    lab3.text = @"币生通总金额";
    lab3.font = [UIFont boldSystemFontOfSize:17];
    lab3.textAlignment = NSTextAlignmentCenter;
    [view1 addSubview:lab3];
    
    //收益总金额数
    lab4 = [[UILabel alloc] initWithFrame:CGRectMake(0, 8*a/15, b, 35)];
    lab4.textAlignment = NSTextAlignmentCenter;
    lab4.font = [UIFont boldSystemFontOfSize:19];
    [view1 addSubview:lab4];
    
    //添加"学费宝"
    UIButton * btn1 = [[UIButton alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(view1.frame)+5, (b-30)/2, a/3-10)];
    btn1.backgroundColor = [UIColor colorWithRed:236/255 green:236/255 blue:236/255 alpha:0.1];
    [self.view addSubview:btn1];
    //添加助学宝
    UIButton * btn2 = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(btn1.frame)+10, CGRectGetMaxY(view1.frame)+5, (b-30)/2, a/3-10)];
    btn2.backgroundColor = [UIColor colorWithRed:236/255 green:236/255 blue:236/255 alpha:0.1];
    [self.view addSubview:btn2];
    
    //给学费宝添加按钮图片
    UIImageView * img1 = [[UIImageView alloc] initWithFrame:CGRectMake(15, 25, CGRectGetWidth(btn1.frame)-30, CGRectGetHeight(btn1.frame)/2)];
    img1.image = [UIImage imageNamed:@"finance_1.png"];
    [btn1 addSubview:img1];
    //添加标题
    UILabel * btn1_lab = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(btn1.frame)*3/4, CGRectGetWidth(btn1.frame), 30)];
    btn1_lab.text = @"学费宝";
    btn1_lab.textAlignment = NSTextAlignmentCenter;
    btn1_lab.font = [UIFont boldSystemFontOfSize:17];
    [btn1 addSubview:btn1_lab];
    
    //给助学宝添加图片和标题
    UIImageView * img2 = [[UIImageView alloc] initWithFrame:CGRectMake(15, 25, CGRectGetWidth(btn1.frame)-30, CGRectGetHeight(btn1.frame)/2)];
    img2.image = [UIImage imageNamed:@"finance_2.png"];
    [btn2 addSubview:img2];
    //添加标题
    UILabel * btn2_lab = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(btn1.frame)*3/4, CGRectGetWidth(btn1.frame), 30)];
    btn2_lab.text = @"助学宝";
    btn2_lab.textAlignment = NSTextAlignmentCenter;
    btn2_lab.font = [UIFont boldSystemFontOfSize:17];
    [btn2 addSubview:btn2_lab];
    
    //给"学费宝"按钮添加事件响应
    [btn1 addTarget:self action:@selector(goToXueFeiB) forControlEvents:UIControlEventTouchUpInside];
    
    //给“助学宝”按钮添加事件响应
    [btn2 addTarget:self action:@selector(goToZhuXueB) forControlEvents:UIControlEventTouchUpInside];
    //初始化
    main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    //加载活动指示器
    indicatorView = [[TFIndicatorView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-20, [UIScreen mainScreen].bounds.size.height/2-25, 50, 50)];
    [indicatorView startAnimating];
    [self.view addSubview:indicatorView];
    //访问服务器获得数据
    app = [UIApplication sharedApplication].delegate;
    [app.manager POST:@"http://120.25.162.238/bsy/index.php/Index/PersonalCenter/index" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //请求到数据
        indicatorView.hidden = YES;
        if (operation.responseData != nil) {
            NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
            if ([[dic objectForKey:@"code"] isEqualToString:@"100000"]) {
                //请求成功
                lab2.text = [NSString stringWithFormat:@"%@元",[[[dic objectForKey:@"result"] objectForKey:@"MyFinance"] objectForKey:@"yesterday_income"]];
                //lab4.text = [NSString stringWithFormat:@"%@元",[[[dic objectForKey:@"result"] objectForKey:@"MyFinance"] objectForKey:@"balance"]];
            }else{
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"请求超时" message:[dic objectForKey:@"message"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
        }else{
            //请求超时
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"请求超时" message:@"请检查网络连接是否正常" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    //每次返回理财界面，都将余额刷新一次
    lab4.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"balance"];
}


//跳转到学费宝
-(void)goToXueFeiB{
    //模态视图跳转
    zhuxueBTableViewController * zhuxueView = [main instantiateViewControllerWithIdentifier:@"zhuxueB"];
    zhuxueView.flag = [NSNumber numberWithInt:1];
    zhuxueView.title = @"学费宝";
    zhuxueView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:zhuxueView animated:YES];
}

//跳转到助学宝
-(void)goToZhuXueB{
    //模态视图跳转
    zhuxueBTableViewController * zhuxueView = [main instantiateViewControllerWithIdentifier:@"zhuxueB"];
    zhuxueView.flag = [NSNumber numberWithInt:4];
    zhuxueView.title = @"助学宝";
    zhuxueView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:zhuxueView animated:YES];

}

//查看账单
- (void)checkfinanceList{
    myBillTableViewController * billView = [main instantiateViewControllerWithIdentifier:@"myBill"];
    billView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:billView animated:YES];
}
@end
