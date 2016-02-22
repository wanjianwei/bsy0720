//
//  noticeTableViewController.m
//  BSY0720
//
//  Created by jway on 15-7-30.
//  Copyright (c) 2015年 jway. All rights reserved.
//

#import "noticeTableViewController.h"
#import "AppDelegate.h"
#import "SDRefresh.h"
#import "noticeViewCell.h"
#import "loginViewController.h"
@interface noticeTableViewController ()
    
//下拉刷新与上拉加载
@property (nonatomic, weak) SDRefreshFooterView *refreshFooter;
@property (nonatomic, weak) SDRefreshHeaderView *refreshHeader;
@end

@implementation noticeTableViewController

//定义一个协议委托类
AppDelegate * app;
//定义一个页码
int flag;

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始设置
    flag = 0;
    self.title = @"我的消息";
    //设置tableview的分割线样式
     self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    //初始化
    app = [UIApplication sharedApplication].delegate;
    self.noticeArray = [[NSMutableArray alloc] initWithObjects:nil, nil];
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
        if (self.noticeArray.count == 0) {
            //界面失去响应
            self.view.userInteractionEnabled = NO;
            //构造请求参数
            NSDictionary * senddic = [NSDictionary dictionaryWithObjectsAndKeys:@"all",@"status",@"10",@"num",@"0",@"page", nil];
            //请求服务器
            [app.manager POST:@"http://120.25.162.238/bsy/index.php/Index/Letter/getLetters" parameters:senddic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                //
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                //界面恢复响应
                self.view.userInteractionEnabled = YES;
                NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
                
                if ([[dic objectForKey:@"code"] isEqualToString:@"100000"]) {
                    [self.noticeArray addObjectsFromArray:[[dic objectForKey:@"result"] objectForKey:@"SystemLetter.List"]];
                    [self.tableView reloadData];
                    [weakRefreshHeader endRefreshing];
                }else{
                    [weakRefreshHeader endRefreshing];
                    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[dic objectForKey:@"message"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
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
    NSDictionary * senddic = [NSDictionary dictionaryWithObjectsAndKeys:@"all",@"status",@"10",@"num",[NSString stringWithFormat:@"%i",flag],@"page", nil];
    //请求服务器
    [app.manager POST:@"http://120.25.162.238/bsy/index.php/Index/Letter/getLetters" parameters:senddic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        self.view.userInteractionEnabled = YES;
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        if ([[dic objectForKey:@"code"] isEqualToString:@"100000"]) {
            [_refreshFooter endRefreshing];
            [self.noticeArray addObjectsFromArray:[[dic objectForKey:@"result"] objectForKey:@"SystemLetter.List"]];
            flag++;
            [self.tableView reloadData];
            
        }else{
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:[dic objectForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [_refreshFooter endRefreshing];
            }];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];

}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.noticeArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    noticeViewCell*cell = [tableView dequeueReusableCellWithIdentifier:@"noticeTableCell"];
    cell.noticeImg.image = [UIImage imageNamed:@"portrait"];
    cell.noticeSort.text = [[self.noticeArray objectAtIndex:indexPath.section] objectForKey:@"title"];
    //设置时间格式
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:[[[self.noticeArray objectAtIndex:indexPath.section] objectForKey:@"time"] intValue]];
    
    cell.time.text = [formatter stringFromDate:date];
    cell.content.text = [[self.noticeArray objectAtIndex:indexPath.section] objectForKey:@"content"];
    //取消单元格选中时候的高亮状态
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


//单元格高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * detail = [[self.noticeArray objectAtIndex:indexPath.section] objectForKey:@"content"];
    //自适应label高度
    CGRect size = [detail boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width-112, 500) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:14]} context:nil];
    
    CGFloat height = size.size.height-39;
    return 100+height;
}

//单元格之间距离
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 5)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

@end
