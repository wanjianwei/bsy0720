//
//  myBillTableViewController.m
//  BSY0720
//
//  Created by jway on 15-7-31.
//  Copyright (c) 2015年 jway. All rights reserved.
//

#import "myBillTableViewController.h"
#import "AppDelegate.h"
#import "SDRefresh.h"
#import "billViewCell.h"
@interface myBillTableViewController ()
//上拉刷新与下拉加载
@property (nonatomic, weak) SDRefreshFooterView *refreshFooter;
@property (nonatomic, weak) SDRefreshHeaderView *refreshHeader;

@end

@implementation myBillTableViewController

//程序委托类
AppDelegate * app;
//定义一个分页标志
int flag;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的账单";
    //初始化
    app = [UIApplication sharedApplication].delegate;
    flag = 0;
    self.billArray = [[NSMutableArray alloc] init];
    //设置下拉刷新与上拉加载
    [self setupHeader];
    [self setupFooter];
    
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
        if (self.billArray.count == 0) {
            //界面失去响应
            self.view.userInteractionEnabled = NO;
            //构造请求参数
            NSDictionary * sendDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%i",flag],@"page",@"10",@"num", nil];
            //请求服务器
            [app.manager POST:@"http://120.25.162.238/bsy/index.php/Index/Finance/getHistory" parameters:sendDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                //
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                //请求服务器成功,界面恢复响应
                self.view.userInteractionEnabled = YES;
                //停止刷洗
                [weakRefreshHeader endRefreshing];
                //解析数据
                NSDictionary * getDic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
                
                NSLog(@"getdic = %@",getDic);
                
                if ([[getDic objectForKey:@"code"] isEqualToString:@"100000"]) {
                    [self.billArray addObjectsFromArray:[[getDic objectForKey:@"result"] objectForKey:@"Bill.List"]];
                    flag++;
                    [self.tableView reloadData];
                }else{
                    //请求出错
                    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[getDic objectForKey:@"message"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                }
            }];
        }else{
            [weakRefreshHeader endRefreshing];
        }
        
        
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
    //界面失去响应
    self.view.userInteractionEnabled = NO;
    //构造请求参数
    NSDictionary * sendDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%i",flag],@"page",@"10",@"num", nil];
    
    //请求服务器
    [app.manager POST:@"http://120.25.162.238/bsy/index.php/Index/Finance/getHistory" parameters:sendDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //请求服务器成功,界面恢复响应
        self.view.userInteractionEnabled = YES;
        //停止刷洗
        [_refreshFooter endRefreshing];
        //解析数据
        NSDictionary * getDic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        if ([[getDic objectForKey:@"code"] isEqualToString:@"100000"]) {
            [self.billArray addObject:[[getDic objectForKey:@"result"] objectForKey:@"Bill.List"]];
            flag++;
            [self.tableView reloadData];
        }else{
            //请求出错
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[getDic objectForKey:@"message"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    }];

}

#pragma dataSource/delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.billArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    billViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"billTableCell"];
    if ([[[self.billArray objectAtIndex:indexPath.section] objectForKey:@"operation"] intValue] == 0) {
         cell.sort.text = @"收入";
    }else{
        cell.sort.text = @"支出";
    }
    
    //构造时间格式
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:[[[self.billArray objectAtIndex:indexPath.section] objectForKey:@"time"] intValue]];
    cell.time.text = [formatter stringFromDate:date];
    
    if ([cell.sort.text isEqualToString:@"0"]) {
        //充值
        cell.sort.textColor = [UIColor greenColor];
        cell.moneyNum.text = [NSString stringWithFormat:@"%.2f",[[[self.billArray objectAtIndex:indexPath.section] objectForKey:@"sum"] floatValue]];
    }else{
        cell.sort.textColor = [UIColor redColor];
        cell.moneyNum.text = [NSString stringWithFormat:@"%.2f",[[[self.billArray objectAtIndex:indexPath.section] objectForKey:@"sum"] floatValue]];
    }
    cell.layer.cornerRadius = 3.0f;
    
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
- (void)setExtraCellLineHidden: (UITableView *)tableView{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width-32, 5)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
@end
