//
//  rechargeTableViewController.m
//  BSY0720
//
//  Created by jway on 15-7-30.
//  Copyright (c) 2015年 jway. All rights reserved.
//

#import "rechargeTableViewController.h"
#import "SDRefresh.h"
#import "AppDelegate.h"
#import "rechargeViewCell.h"
@interface rechargeTableViewController ()

//下拉刷新与上拉加载
@property (nonatomic, weak) SDRefreshFooterView *refreshFooter;
@property (nonatomic, weak) SDRefreshHeaderView *refreshHeader;

@end

@implementation rechargeTableViewController
//定义应用程序委托
AppDelegate * app;

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置tableview无分割线
   // self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    //初始化
    app = [UIApplication sharedApplication].delegate;
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
        //界面失去响应
        self.view.userInteractionEnabled = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //界面恢复响应
            self.view.userInteractionEnabled = YES;
            //获取数据
            if ([self.flag intValue] == 1) {
                //获取充值记录
                /*
                 [app.manager POST:@"" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 //
                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 //
                 }];
                 */
                NSArray * array1 = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"30.40",@"moneyNum",@"2014-05-04 05:03",@"cashTime",@"255sdghsfba",@"recordNum", nil], [NSDictionary dictionaryWithObjectsAndKeys:@"30.40",@"moneyNum",@"2014-05-04 05:03",@"cashTime",@"255sdghsfba",@"recordNum", nil],nil];
                
                NSArray * array2 = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"30.40",@"moneyNum",@"2014-05-04 05:03",@"cashTime",@"255sdghsfba",@"recordNum", nil], [NSDictionary dictionaryWithObjectsAndKeys:@"30.40",@"moneyNum",@"2014-05-04 05:03",@"cashTime",@"255sdghsfba",@"recordNum", nil],[NSDictionary dictionaryWithObjectsAndKeys:@"30.40",@"moneyNum",@"2014-05-04 05:03",@"cashTime",@"255sdghsfba",@"recordNum", nil],nil];
                
                self.recordArray = [[NSMutableArray alloc] initWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"2014-04-02",@"time",array2,@"list", nil],[NSDictionary dictionaryWithObjectsAndKeys:@"2014-04-02",@"time",array1,@"list", nil],nil];
            }else{
                //获取消费记录
                /*
                 [app.manager POST:@"" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 //
                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 //
                 }];
                 */
                
                NSArray * array1 = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"30.40",@"moneyNum",@"2014-05-04 05:03",@"cashTime",@"255sdghsfba",@"recordNum", nil], [NSDictionary dictionaryWithObjectsAndKeys:@"30.40",@"moneyNum",@"2014-05-04 05:03",@"cashTime",@"255sdghsfba",@"recordNum", nil],nil];
                
                NSArray * array2 = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"30.40",@"moneyNum",@"2014-05-04 05:03",@"cashTime",@"255sdghsfba",@"recordNum", nil], [NSDictionary dictionaryWithObjectsAndKeys:@"30.40",@"moneyNum",@"2014-05-04 05:03",@"cashTime",@"255sdghsfba",@"recordNum", nil],[NSDictionary dictionaryWithObjectsAndKeys:@"30.40",@"moneyNum",@"2014-05-04 05:03",@"cashTime",@"255sdghsfba",@"recordNum", nil],nil];
                
                NSArray * array3 = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"30.40",@"moneyNum",@"2014-05-04 05:03",@"cashTime",@"255sdghsfba",@"recordNum", nil], [NSDictionary dictionaryWithObjectsAndKeys:@"30.40",@"moneyNum",@"2014-05-04 05:03",@"cashTime",@"255sdghsfba",@"recordNum", nil],nil];
                
                self.recordArray = [[NSMutableArray alloc] initWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"2014-04-02",@"time",array2,@"list", nil],[NSDictionary dictionaryWithObjectsAndKeys:@"2014-06-02",@"time",array1,@"list", nil],[NSDictionary dictionaryWithObjectsAndKeys:@"2014-05-02",@"time",array3,@"list", nil],nil];
            }
            [self.tableView reloadData];
            [weakRefreshHeader endRefreshing];
        });
    };
    
    // 进入页面自动加载一次数据
    [refreshHeader beginRefreshing];
}

//下拉加载
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
        if ([self.flag intValue] == 1) {
            //获取充值记录
            NSArray * array = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"30.40",@"moneyNum",@"2014-05-04 05:03",@"cashTime",@"255sdghsfba",@"recordNum", nil], [NSDictionary dictionaryWithObjectsAndKeys:@"30.40",@"moneyNum",@"2014-05-04 05:03",@"cashTime",@"255sdghsfba",@"recordNum", nil],nil];
            [self.recordArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"2015-04-02",@"time",array,@"list", nil]];
        }else{
            //获取消费记录
            NSArray * array = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"30.40",@"moneyNum",@"2014-05-04 05:03",@"cashTime",@"255sdghsfba",@"recordNum", nil], [NSDictionary dictionaryWithObjectsAndKeys:@"30.40",@"moneyNum",@"2014-05-04 05:03",@"cashTime",@"255sdghsfba",@"recordNum", nil],nil];
            [self.recordArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"2015-04-02",@"time",array,@"list", nil]];
        }
        [self.tableView reloadData];
        [self.refreshFooter endRefreshing];
    });
}




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.recordArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    //每节的单元格个数
    return [[[self.recordArray objectAtIndex:section] objectForKey:@"list"] count]+1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //定义一个整型统计总金额
    float totalNum = 0.0;
    //取出数组
    NSArray * array = [[self.recordArray objectAtIndex:indexPath.section] objectForKey:@"list"];
    //统计金钱总数
    for (int i =0; i<array.count; i++) {
        totalNum +=[[[array objectAtIndex:i] objectForKey:@"moneyNum"] floatValue];
    }
    //第一行统计
    if (indexPath.row == 0) {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"rechargeCell_1"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"rechargeCell_1"];
        }
        cell.textLabel.text = [[self.recordArray objectAtIndex:indexPath.section] objectForKey:@"time"];
        
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f元",totalNum];
        cell.detailTextLabel.textColor = [UIColor redColor];
        cell.backgroundColor = [UIColor orangeColor];
        //取消单元格选中时候的高亮状态
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        //消费记录
        rechargeViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"rechargeTableCell"];
        cell.moneyNum.text = [NSString stringWithFormat:@"%@元",[[array objectAtIndex:indexPath.row-1] objectForKey:@"moneyNum"]];
        cell.time.text = [[array objectAtIndex:indexPath.row-1] objectForKey:@"cashTime"];
        cell.orderNum.text = [NSString stringWithFormat:@"交易商户号:%@",[[array objectAtIndex:indexPath.row-1] objectForKey:@"recordNum"]];
        //取消单元格选中时候的高亮状态
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }

}

//单元格高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 44;
    }else{
        return 65;
    }
}
//节间距
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width-32, 7)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
@end
