//
//  orderSucViewController.m
//  BSY0720
//
//  Created by jway on 15-8-4.
//  Copyright (c) 2015年 jway. All rights reserved.
//

#import "orderSucViewController.h"
#import "UICustomLineLabel.h"
#import "tabViewController.h"
@interface orderSucViewController (){
    //定义控件
    //自定义导航栏
  //  UIView * navView;
    //标题
  //  UILabel * title;
    //定义一个完成按钮
 //   UIButton * back;
    // 添加一个UIview，做背景1
    UIView * view1;
    //添加交易成功图标
    UIImageView * img;
    //添加“交易成功”字样
    UILabel * lab;
    //添加一个滚动视图，显示交易详情
    UIScrollView * detailView;
    //添加订单号
    UILabel * lab1;
    UICustomLineLabel * lab_1;
    //添加商品名称
    UILabel * lab2;
    //高度动态变化
    UICustomLineLabel * lab_2;
    //交易时间
    UILabel * lab3;
    UICustomLineLabel * lab_3;
    //当前状态
    UILabel * lab4;
    UICustomLineLabel * lab_4;
    //总计
    UILabel * lab5;
    //金额
    UILabel * lab6;
    
}

@end

@implementation orderSucViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //监听通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handNoti:) name:@"orderDetailNotification" object:nil];
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor blackColor];
    // 添加一个UIview，做背景1
    view1 = [[UIView alloc] initWithFrame:CGRectMake(16, 20+64, [UIScreen mainScreen].bounds.size.width-32, 80)];
    view1.layer.borderColor = [UIColor lightGrayColor].CGColor;
    view1.layer.borderWidth = 1.0f;
    [self.view addSubview:view1];
    //添加交易成功图标
    img = [[UIImageView alloc] initWithFrame:CGRectMake(20, 25, 30, 30)];
    img.image = [UIImage imageNamed:@"orderSuc.png"];
    [view1 addSubview:img];
    //添加“交易成功”字样
    lab = [[UILabel alloc] initWithFrame:CGRectMake(60, 25, 100, 30)];
    lab.textAlignment = NSTextAlignmentLeft;
    lab.font = [UIFont boldSystemFontOfSize:25];
    lab.text = @"交易成功";
    [view1 addSubview:lab];
    
    //添加一个滚动视图，显示交易详情
    detailView = [[UIScrollView alloc] initWithFrame:CGRectMake(16, 164, [UIScreen mainScreen].bounds.size.width-32, [UIScreen mainScreen].bounds.size.height-200)];
    detailView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    detailView.layer.borderWidth = 1.0f;
    detailView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:detailView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"orderDetailNotification" object:nil];
}

-(void)handNoti:(NSNotification*)noti{
    NSDictionary * dic = [noti userInfo];
    
    //先计算商品名称字符串的多少
    CGRect rect = [[dic objectForKey:@"goodName"] boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width-122, 500) options:NSStringDrawingUsesLineFragmentOrigin| NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15]} context:nil];
    
    //在定义滚动视图的contentSize
    [detailView setContentSize:CGSizeMake([UIScreen mainScreen].bounds.size.width-32, rect.size.height+300)];
    
    //添加订单号
    lab1 = [[UILabel alloc] initWithFrame:CGRectMake(5, 20, 85, 20)];
    lab1.textAlignment = NSTextAlignmentLeft;
    lab1.text = @"订单号:";
    lab1.font = [UIFont boldSystemFontOfSize:15];
    [detailView addSubview:lab1];
    
    lab_1 = [[UICustomLineLabel alloc] initWithFrame:CGRectMake(90, 20, [UIScreen mainScreen].bounds.size.width-32-90, 30)];
    lab_1.textAlignment = NSTextAlignmentLeft;
    lab_1.text = [NSString stringWithFormat:@"%@                                                                  ",[dic objectForKey:@"orderNum"]];
    lab_1.font = [UIFont boldSystemFontOfSize:15];
    lab_1.lineType = LineTypeDown;
    lab_1.lineColor = [UIColor lightGrayColor];
    [detailView addSubview:lab_1];
    
    //添加商品名称
    lab2 = [[UILabel alloc] initWithFrame:CGRectMake(5, 70, 85, 20)];
    lab2.text = @"商品名称:";
    lab2.textAlignment = NSTextAlignmentLeft;
    lab2.font = [UIFont boldSystemFontOfSize:15];
    [detailView addSubview:lab2];
    
    //高度动态变化
    lab_2 = [[UICustomLineLabel alloc] initWithFrame:CGRectMake(90, 70, [UIScreen mainScreen].bounds.size.width-122, rect.size.height)];
    lab_2.text = [NSString stringWithFormat:@"%@                                             ",[dic objectForKey:@"goodName"]];
    lab_2.textAlignment = NSTextAlignmentLeft;
    lab_2.font = [UIFont boldSystemFontOfSize:15];
    lab_2.numberOfLines = 0;
    lab_2.lineType = LineTypeDown;
    lab_2.lineColor = [UIColor lightGrayColor];
    [detailView addSubview:lab_2];
    
    //交易时间
    lab3 = [[UILabel alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(lab_2.frame)+20, 85, 20)];
    lab3.textAlignment = NSTextAlignmentLeft;
    lab3.text = @"交易时间:";
    lab3.font = [UIFont boldSystemFontOfSize:15];
    [detailView addSubview:lab3];
    
    lab_3 = [[UICustomLineLabel alloc] initWithFrame:CGRectMake(90,CGRectGetMaxY(lab_2.frame)+20,[UIScreen mainScreen].bounds.size.width-122,30)];
    lab_3.text = [NSString stringWithFormat:@"%@                                                                     ",[dic objectForKey:@"time"]];
    lab_3.textAlignment = NSTextAlignmentLeft;
    lab_3.font = [UIFont boldSystemFontOfSize:15];
    lab_3.lineType = LineTypeDown;
    lab_3.lineColor = [UIColor lightGrayColor];
    [detailView addSubview:lab_3];
    
    //当前状态
    lab4 = [[UILabel alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(lab_3.frame)+20, 85, 20)];
    lab4.textAlignment = NSTextAlignmentLeft;
    lab4.text = @"当前状态:";
    lab4.font = [UIFont boldSystemFontOfSize:15];
    lab4.textAlignment = NSTextAlignmentLeft;
    [detailView addSubview:lab4];
    
    lab_4 = [[UICustomLineLabel alloc] initWithFrame:CGRectMake(90, CGRectGetMaxY(lab_3.frame)+20, [UIScreen mainScreen].bounds.size.width-122, 30)];
    lab_4.text = [NSString stringWithFormat:@"%@                                                                          ",[dic objectForKey:@"state"]];
    lab_4.textAlignment = NSTextAlignmentLeft;
    lab_4.font = [UIFont boldSystemFontOfSize:15];
    lab_4.lineType = LineTypeDown;
    lab_4.lineColor = [UIColor lightGrayColor];
    [detailView addSubview:lab_4];
    
    //总计
    lab5 = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-32-50, CGRectGetMaxY(lab_4.frame)+40, 40, 20)];
    lab5.textAlignment = NSTextAlignmentRight;
    lab5.text = @"总计";
    lab5.font = [UIFont boldSystemFontOfSize:15];
    [detailView addSubview:lab5];
    
    //金额
    lab6 = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-32-150, CGRectGetMaxY(lab5.frame)+30, 140, 30)];
    lab6.text = [NSString stringWithFormat:@"￥%@",[dic objectForKey:@"totalNum"]];
    lab6.font = [UIFont boldSystemFontOfSize:20];
    lab6.textAlignment = NSTextAlignmentRight;
    [detailView addSubview:lab6];
}

//返回按钮
-(void)back{
    UIStoryboard * main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    tabViewController * tab = [main instantiateViewControllerWithIdentifier:@"tabBar"];
    tab.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    tab.selectedIndex = 2;
    [self presentViewController:tab animated:tab completion:^{
        // 添加一个UIview，做背景1
        view1 = nil;
        //添加交易成功图标
        img = nil;
        //添加“交易成功”字样
        lab = nil;
        //添加一个滚动视图，显示交易详情
        detailView = nil;
    }];
}

@end
