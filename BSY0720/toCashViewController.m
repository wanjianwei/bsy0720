//
//  toCashViewController.m
//  BSY0720
//
//  Created by jway on 15-7-28.
//  Copyright (c) 2015年 jway. All rights reserved.
//

#import "toCashViewController.h"
#import "AppDelegate.h"
@interface toCashViewController (){
    //应用程序委托协议
    AppDelegate * app;
}

@end

@implementation toCashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.restMoney.layer.cornerRadius = 4.0f;
    self.restMoney.layer.masksToBounds = YES;
    self.bankNum.layer.cornerRadius = 4.0f;
    self.bankNum.layer.masksToBounds = YES;
    self.moneyNum.layer.cornerRadius = 4.0f;
    self.moneyNum.layer.masksToBounds = YES;
    self.bankNum.layer.cornerRadius = 4.0f;
    self.bankNum.layer.masksToBounds = YES;
    //初始化
    app = [UIApplication sharedApplication].delegate;
    
    //向服务器请求数据
    self.restMoney.text = [NSString stringWithFormat:@"1000.00元"];
    //定义一个手势处理器，用来关闭键盘
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
    [self.moneyNum resignFirstResponder];
    [self.bankNum resignFirstResponder];
}

//立即提取
- (IBAction)cashNow:(id)sender {
    //金额应当大于0小于可提金额
    if (([self.moneyNum.text intValue] == 0) || ([self.moneyNum.text intValue]>[self.restMoney.text intValue])) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"输入提现金额应当大于0并小于可提金额" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }else if (![self isValidCardNumber:self.bankNum.text]){
        //银行卡号合法性验证
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"输入银行卡号不合法" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        //向服务器发送请求
        
    }
}

//银行卡合法性检验
-(BOOL)isValidCardNumber:(NSString *)cardNumber
{
    NSString *digitsOnly =cardNumber;
    int sum = 0;
    int digit = 0;
    int addend = 0;
    BOOL timesTwo = false;
    for (int i =(int)digitsOnly.length - 1; i >= 0; i--)
    {
        digit = [digitsOnly characterAtIndex:i] - '0';
        if (timesTwo)
        {
            addend = digit * 2;
            if (addend > 9)
            {
                addend -= 9;
            }
        }
        else
        {
            addend = digit;
        }
        sum += addend;
        timesTwo = !timesTwo;
    }
    int modulus = sum % 10;
    return modulus == 0;
}


@end
