//
//  telphoneCertiViewController.m
//  BSY0720
//
//  Created by jway on 15-7-28.
//  Copyright (c) 2015年 jway. All rights reserved.
//

#import "telphoneCertiViewController.h"

@interface telphoneCertiViewController ()

@end

@implementation telphoneCertiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化
    self.phoneNum.layer.cornerRadius = 4.0f;
    self.phoneNum.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.phoneNum.layer.borderWidth = 1.0f;
    self.phoneNum.layer.masksToBounds = YES;
    self.randNum.layer.cornerRadius = 4.0f;
    self.randNum.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.randNum.layer.borderWidth = 1.0f;
    self.randNum.layer.masksToBounds = YES;
    self.vcode.layer.cornerRadius = 4.0f;
    self.vcode.layer.borderWidth = 1.0f;
    self.vcode.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.vcode.layer.masksToBounds = YES;
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
    [self.phoneNum resignFirstResponder];
    [self.vcode resignFirstResponder];
    [self.randNum resignFirstResponder];
}


- (IBAction)sendPhone:(id)sender {
}

- (IBAction)getRandom:(id)sender {
}

- (IBAction)sendUp:(id)sender {
}
@end
