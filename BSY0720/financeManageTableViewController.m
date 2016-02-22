//
//  financeManageTableViewController.m
//  BSY0720
//
//  Created by jway on 15-7-30.
//  Copyright (c) 2015年 jway. All rights reserved.
//

#import "financeManageTableViewController.h"
#import "AppDelegate.h"
#import "rechargeTableViewController.h"
#import "withdrawTableViewController.h"
#import "investEarnTableViewController.h"
#import "SDRefresh.h"
@interface financeManageTableViewController (){
    AppDelegate * app;
    //定义一个故事板引用
    UIStoryboard * main;
}

@end

@implementation financeManageTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化
    app = [UIApplication sharedApplication].delegate;
    main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //设置下拉刷新
  ///  [self setupHeader];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
//下拉刷新
- (void)setupHeader
{
    SDRefreshHeaderView *refreshHeader = [SDRefreshHeaderView refreshView];
    
    // 默认是在navigationController环境下，如果不是在此环境下，请设置 refreshHeader.isEffectedByNavigationController = NO;
    [refreshHeader addToScrollView:self.tableView];
    __weak SDRefreshHeaderView *weakRefreshHeader = refreshHeader;
    refreshHeader.beginRefreshingOperation = ^{
        //界面失去响应
        self.view.userInteractionEnabled = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //界面恢复响应
            self.view.userInteractionEnabled = YES;
            //构造虚拟数据
            self.returnDic = [NSDictionary dictionaryWithObjectsAndKeys:@"10000",@"restMoney", nil];
            [self.tableView reloadData];
            [weakRefreshHeader endRefreshing];
        });
    };
    // 进入页面自动加载一次数据
    [refreshHeader beginRefreshing];
}
*/


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 3;
    }else{
        return 2;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"financeManageCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"financeManageCell"];
    }
    
    if (indexPath.section == 0) {
        UILabel * lab = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-50, 20, 100, 100)];
        lab.backgroundColor = [UIColor orangeColor];
        lab.layer.cornerRadius = 50.0f;
        lab.layer.masksToBounds = YES;
        lab.text = [NSString stringWithFormat:@"%.1f元",[[[NSUserDefaults standardUserDefaults] objectForKey:@"balance"] floatValue]];
        lab.textAlignment = NSTextAlignmentCenter;
        [cell addSubview:lab];
        //账号余额
        UILabel * lab2 = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-50, 130, 100, 20)];
        lab2.text = @"账号余额";
        lab2.textAlignment = NSTextAlignmentCenter;
        [cell addSubview:lab2];
        //取消cell选中时候的高亮状态
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if(indexPath.section == 1){
        if (indexPath.row == 0) {
            cell.textLabel.text = @"消费记录";
        }else if (indexPath.row == 1){
            cell.textLabel.text = @"充值记录";
        }else{
            cell.textLabel.text = @"提现记录";
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }else{
        if (indexPath.row == 0) {
            cell.textLabel.text = @"账户资产";
        }else{
            cell.textLabel.text = @"投资收益";
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
  
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 160;
    }else{
        return 44;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 10)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

//点击单元格跳转
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            //跳转到消费记录
            rechargeTableViewController * recharge = [main instantiateViewControllerWithIdentifier:@"rechargeTable"];
            recharge.flag = [NSNumber numberWithInt:2];
            recharge.title = @"消费记录";
            [self.navigationController pushViewController:recharge animated:YES];
            
        }else if (indexPath.row == 1){
            //跳转到充值记录
            rechargeTableViewController * recharge = [main instantiateViewControllerWithIdentifier:@"rechargeTable"];
            recharge.flag = [NSNumber numberWithInt:1];
            recharge.title = @"充值记录";
            [self.navigationController pushViewController:recharge animated:YES];
            
            
        }else{
            //跳转到提现记录
            withdrawTableViewController * withdrawView = [main instantiateViewControllerWithIdentifier:@"withdrawTable"];
            withdrawView.title = @"提现记录";
            [self.navigationController pushViewController:withdrawView animated:YES];
        }
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            //跳转到账户资产
            investEarnTableViewController * accountView = [main instantiateViewControllerWithIdentifier:@"investEarnTable"];
            accountView.flag = [NSNumber numberWithInt:1];
            accountView.title = @"账户资产";
            [self.navigationController pushViewController:accountView animated:YES];
        }else{
            //跳转到投资收益
            investEarnTableViewController * earnView = [main instantiateViewControllerWithIdentifier:@"investEarnTable"];
            earnView.flag = [NSNumber numberWithInt:2];
            earnView.title = @"投资收益";
            [self.navigationController pushViewController:earnView animated:YES];
        }
    }
    
}

@end
