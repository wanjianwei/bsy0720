//
//  withdrawTableViewController.m
//  BSY0720
//
//  Created by jway on 15-7-30.
//  Copyright (c) 2015年 jway. All rights reserved.
//

#import "withdrawTableViewController.h"
#import "AppDelegate.h"
#import "SDRefresh.h"
@interface withdrawTableViewController ()
//上拉刷新与下拉加载
@property (nonatomic, weak) SDRefreshFooterView *refreshFooter;
@property (nonatomic, weak) SDRefreshHeaderView *refreshHeader;
@end

@implementation withdrawTableViewController
//应用程序代理协议
AppDelegate * app;

- (void)viewDidLoad {
    [super viewDidLoad];
    //tableview的分割线样式为none
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    //初始化
    app = [UIApplication sharedApplication].delegate;
    //设置下拉刷新与上拉加载
    [self setupHeader];
    [self setupFooter];
    //初始化可变数组
    self.recordArray = [[NSMutableArray alloc] initWithObjects:nil, nil];
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
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //界面恢复响应
            self.view.userInteractionEnabled = YES;
            for (int i =0; i<5; i++) {
                [self.recordArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"2014-05-04 05:03",@"time",@"$30.40",@"money", nil]];
            }
            [self.tableView reloadData];
            [weakRefreshHeader endRefreshing];
        });
    };
    
    // 进入页面自动加载一次数据
    [refreshHeader beginRefreshing];
}

//上拉加载
- (void)setupFooter
{
    SDRefreshFooterView *refreshFooter = [SDRefreshFooterView refreshView];
    [refreshFooter addToScrollView:self.tableView];
    [refreshFooter addTarget:self refreshAction:@selector(footerRefresh)];
    _refreshFooter = refreshFooter;
}

//再次向服务器请求数据，并重新加载
-(void)footerRefresh{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.recordArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"2014-11-04 12:03",@"time",@"$44.40",@"money", nil]];
        [self.tableView reloadData];
        [self.refreshFooter endRefreshing];
    });
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma dataSource/Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.recordArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"recordCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"recordCell"];
    }
    
    cell.textLabel.text = [[self.recordArray objectAtIndex:indexPath.section] objectForKey:@"time"];
    cell.detailTextLabel.text = [[self.recordArray objectAtIndex:indexPath.section] objectForKey:@"money"];
    cell.detailTextLabel.textColor = [UIColor orangeColor];
    //取消单元格选中时的高亮状态
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width-32, 5)];
    view1.backgroundColor = [UIColor clearColor];
    return view1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

@end
