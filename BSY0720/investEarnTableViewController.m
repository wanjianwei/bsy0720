//
//  investEarnTableViewController.m
//  BSY0720
//
//  Created by jway on 15-7-30.
//  Copyright (c) 2015年 jway. All rights reserved.
//

#import "investEarnTableViewController.h"
#import "AppDelegate.h"
#import "SDRefresh.h"
@interface investEarnTableViewController ()
//下拉刷新
@property (nonatomic, weak) SDRefreshHeaderView *refreshHeader;
@end

@implementation investEarnTableViewController
//应用程序委托类代理
AppDelegate * app;
- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化
    app = [UIApplication sharedApplication].delegate;
    //设置下拉刷新
    if ([self.flag intValue] == 2) {
        [self setupHeader];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //界面恢复响应
            self.view.userInteractionEnabled = YES;
            //构造虚拟数据
            if ([self.flag intValue] == 1) {
                //账户资产
                // self.returnDic = [NSDictionary dictionaryWithObjectsAndKeys:@"1111111.000",@"totalEarn",@"1000",@"bst",@"100000",@"xuefei",@"100000000",@"zhuxue", nil];
            }else{
                //投资收益
                self.returnDic_1 = [NSDictionary dictionaryWithObjectsAndKeys:@"11111.000",@"totalEarn",@"1000",@"bst",@"100",@"xuefei",@"1000",@"zhuxue", nil];
            }
            [self.tableView reloadData];
            [weakRefreshHeader endRefreshing];
        });
        };
    // 进入页面自动加载一次数据
    [refreshHeader beginRefreshing];
                       
}

#pragma dataSource/delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        UITableViewCell * cell = [[UITableViewCell alloc] init];
        UILabel * lab1 = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-50, 4, 100, 100)];
        if ([self.flag intValue] == 1) {
            float a = [[[NSUserDefaults standardUserDefaults] objectForKey:@"balance"] floatValue];
            float b = [[[NSUserDefaults standardUserDefaults] objectForKey:@"xuefei"] floatValue];
            float c = [[[NSUserDefaults standardUserDefaults] objectForKey:@"zhuxue"] floatValue];
            //统计总资产
            lab1.text = [NSString stringWithFormat:@"%.2f元",a+b+c];
        }else{
            lab1.text = [NSString stringWithFormat:@"%@元",[self.returnDic_1 objectForKey:@"totalEarn"]];
        }
        
        lab1.textAlignment = NSTextAlignmentCenter;
        lab1.font = [UIFont boldSystemFontOfSize:20];
        lab1.layer.cornerRadius = 50;
        lab1.backgroundColor = [UIColor orangeColor];
        lab1.font = [UIFont boldSystemFontOfSize:12];
        lab1.layer.masksToBounds = YES;
        [cell addSubview:lab1];
        //“投资总收益”
        UILabel * lab2 = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-50, 104, 100, 28)];
        if ([self.flag intValue] ==1) {
            lab2.text = @"账户总资产";
        }else{
            lab2.text = @"投资总收益";
        }
        lab2.textAlignment = NSTextAlignmentCenter;
        lab2.font = [UIFont boldSystemFontOfSize:15];
        [cell addSubview:lab2];
        //取消单元格选中时的高亮状态
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"earnCell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"earnCell"];
        }
        if (indexPath.row == 1) {
            if ([self.flag intValue] ==1) {
                cell.textLabel.text = @"币升通";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f元",[[[NSUserDefaults standardUserDefaults] objectForKey:@"balance"] floatValue]];
            }else{
                cell.textLabel.text = @"币升通(总收益)";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@元",[self.returnDic_1 objectForKey:@"bst"]];
            }
        }else if (indexPath.row == 2){
            if ([self.flag intValue] ==1) {
                cell.textLabel.text = @"学费宝";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f元",[[[NSUserDefaults standardUserDefaults] objectForKey:@"xuefei"] floatValue]];
            }else{
                cell.textLabel.text = @"学费宝(预期减免学费)";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@元",[self.returnDic_1 objectForKey:@"xuefei"]];
            }
        }else{
            if ([self.flag intValue] == 1) {
                cell.textLabel.text = @"助学宝";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f元",[[[NSUserDefaults standardUserDefaults] objectForKey:@"zhuxue"] floatValue]];
            }else{
                cell.textLabel.text = @"助学宝(预期收益)";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@元",[self.returnDic_1 objectForKey:@"zhuxue"]];
            }
        }
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
        cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:14];
        //有数据就有分割线，无数据就无分割线
        if (tableView.dataSource>0) {
            tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
            [self setExtraCellLineHidden:tableView];
        }else{
            tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        }
        //取消单元格选中时候的高亮状态
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

//去除tableView 的分割线
- (void)setExtraCellLineHidden: (UITableView *)tableView{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

//单元格高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 138;
    }else{
        return 44;
    }
}


@end
