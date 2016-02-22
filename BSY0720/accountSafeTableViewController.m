//
//  accountSafeTableViewController.m
//  BSY0720
//
//  Created by jway on 15-7-31.
//  Copyright (c) 2015年 jway. All rights reserved.
//

#import "accountSafeTableViewController.h"
#import "telphoneCertiViewController.h"
#import "changePwdViewController.h"
#import "realnameCertiViewController.h"
#import "payPwdCertiViewController.h"
@interface accountSafeTableViewController ()

@end

@implementation accountSafeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"账户安全";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma dataSource/delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"funListCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"funListCell"];
    }
    if (indexPath.row == 0) {
        cell.imageView.image = [UIImage imageNamed:@"1.png"];
        cell.textLabel.text = @"手机认证";
    }else if (indexPath.row == 1){
        cell.imageView.image = [UIImage imageNamed:@"2.png"];
        cell.textLabel.text = @"实名认证";
    }else if(indexPath.row == 2){
        cell.imageView.image = [UIImage imageNamed:@"3.png"];
        cell.textLabel.text = @"登录密码";
    }else{
        cell.imageView.image = [UIImage imageNamed:@"4.png"];
        cell.textLabel.text = @"支付密码";
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    //有数据就有分割线，无数据就无分割线
    if (tableView.dataSource>0) {
        tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
        [self setExtraCellLineHidden:tableView];
    }else{
        tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    }
    return cell;
}

//去除tableView 的分割线
- (void)setExtraCellLineHidden: (UITableView *)tableView

{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}


//点击单元格跳转
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        //跳转到手机认证
        UIStoryboard * main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        telphoneCertiViewController * certiView = [main instantiateViewControllerWithIdentifier:@"telphoneCerti"];
        [self.navigationController pushViewController:certiView animated:YES];
    }else if (indexPath.row == 1){
        //跳转到实名认证界面
        UIStoryboard * main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        realnameCertiViewController * realnameCertiView = [main instantiateViewControllerWithIdentifier:@"realnameCerti"];
        [self.navigationController pushViewController:realnameCertiView animated:YES];
    }else if(indexPath.row == 2){
        //跳转到登录密码页面
        UIStoryboard * main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        changePwdViewController * changePwView = [main instantiateViewControllerWithIdentifier:@"changePwd"];
        [self.navigationController pushViewController:changePwView animated:YES];
    }else{
        //跳转到支付密码
        UIStoryboard * main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        payPwdCertiViewController * payView = [main instantiateViewControllerWithIdentifier:@"payPwdCerti"];
        [self.navigationController pushViewController:payView animated:YES];
    }
}



@end
