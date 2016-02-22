//
//  busInqueryViewController.m
//  BSY0720
//
//  Created by jway on 15-8-6.
//  Copyright (c) 2015年 jway. All rights reserved.
//

#import "busInqueryViewController.h"
#import "TFIndicatorView.h"
@interface busInqueryViewController (){
    //定义一个UIWebView
    UIWebView * webView;
    //定义一个活动指示器
    TFIndicatorView * indicator;
}

@end

@implementation busInqueryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //定义活动指示器
    indicator = [[TFIndicatorView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-20, [UIScreen mainScreen].bounds.size.height/2-25, 50, 50)];
    
    //加载公交查询的网页
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64)];
    [self.view addSubview:webView];
    //禁止自动调整contentsize
    self.automaticallyAdjustsScrollViewInsets = NO;
    webView.delegate = self;
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://m.8684.cn/wuhan_bus"]]];
    //加载活动指示器
    [self.view addSubview:indicator];
    [indicator startAnimating];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma UIWebViewDelegate
-(void)webViewDidStartLoad:(UIWebView *)webView{
    
}


-(void)webViewDidFinishLoad:(UIWebView *)webView{
    //隐藏活动指示器
    indicator.hidden = YES;
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    //加载失败
    indicator.hidden = YES;
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网页加载出现错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

@end
