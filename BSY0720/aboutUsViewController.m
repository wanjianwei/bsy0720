//
//  aboutUsViewController.m
//  BSY0720
//
//  Created by jway on 15-7-28.
//  Copyright (c) 2015年 jway. All rights reserved.
//

#import "aboutUsViewController.h"

@interface aboutUsViewController ()

@end

@implementation aboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bgView.layer.cornerRadius = 8.0f;
    self.bgView.layer.borderColor = [UIColor redColor].CGColor;
    self.bgView.layer.borderWidth = 1.0f;
    //网址和电话
    self.website.text = [NSString stringWithFormat:@"http://bsy.whicu.com/index.php/home/product/detail/2/1"];
    self.telphone.text = @"33333335566";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
