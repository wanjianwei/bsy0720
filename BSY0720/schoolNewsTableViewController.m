//
//  schoolNewsTableViewController.m
//  BSY0720
//
//  Created by jway on 15-7-31.
//  Copyright (c) 2015年 jway. All rights reserved.
//

#import "schoolNewsTableViewController.h"
#import "schoolNewsTableCell.h"
#import "SDRefresh.h"
#import "AppDelegate.h"
#import "notDetailViewController.h"
@interface schoolNewsTableViewController ()
//下拉刷新与上拉加载
@property (nonatomic, weak) SDRefreshFooterView *refreshFooter;
@property (nonatomic, weak) SDRefreshHeaderView *refreshHeader;
@end

@implementation schoolNewsTableViewController
//应用程序委托类
AppDelegate * app;
//定义一个分页标志
int flag;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化
    app = [UIApplication sharedApplication].delegate;
    flag = 0;
    self.newsArray = [[NSMutableArray alloc] init];
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
            if (self.newsArray.count == 0) {
                //界面失去响应
                self.view.userInteractionEnabled = NO;
                //构造发送数据
                NSDictionary * senddic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%i",flag],@"page",@"10",@"num", nil];
                //请求服务器
                [app.manager POST:@"http://120.25.162.238/bsy/index.php/Index/News/getNewsList" parameters:senddic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    //
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    //停止刷新
                    [weakRefreshHeader endRefreshing];
                    self.view.userInteractionEnabled = YES;
                    //解析服务器返回数据
                    NSDictionary * getDic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
                    if ([[getDic objectForKey:@"code"] isEqualToString:@"100000"]) {
                        //接受数据
                        [self.newsArray addObjectsFromArray:[[getDic objectForKey:@"result"] objectForKey:@"News.List"]];
                        flag++;  //页数加1；
                        [self.tableView reloadData];
                        
                    }else{
                        //请求失败
                        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[getDic objectForKey:@"message"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [alert show];
                    }
                    
                    NSLog(@"self.array = %@",self.newsArray);
                }];

            }else{
                [weakRefreshHeader endRefreshing];
            }
            
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
    //页面失去响应
    self.view.userInteractionEnabled = YES;
    //构造发送数据
    NSDictionary * senddic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%i",flag],@"page",@"10",@"num", nil];
    //请求服务器
    [app.manager POST:@"http://120.25.162.238/bsy/index.php/Index/News/getNewsList" parameters:senddic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //停止刷新
        [_refreshFooter endRefreshing];
        self.view.userInteractionEnabled = YES;
        //解析服务器返回数据
        NSDictionary * getDic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        if ([[getDic objectForKey:@"code"] isEqualToString:@"100000"]) {
            //接受数据
            [self.newsArray addObject:[[getDic objectForKey:@"result"] objectForKey:@"News.List"]];
            flag++;  //页数加1；
            [self.tableView reloadData];
            
        }else{
            //请求失败
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[getDic objectForKey:@"message"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        
       
        
    }];
}

#pragma dataSource/Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.newsArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    schoolNewsTableCell * cell = [tableView dequeueReusableCellWithIdentifier:@"shcoolNews"];
    
    //新闻图片的加载
   // cell.newsImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[self.newsArray objectAtIndex:indexPath.row] objectForKey:@"picture"]]]];
    
    //异步缓存加载
    //此处图片必须缓存，并且异步加载
    NSFileManager * fm = [NSFileManager defaultManager];
    NSArray * fileArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * filetemp = [fileArray objectAtIndex:0];
    NSString * filePath = [filetemp stringByAppendingPathComponent:[NSString stringWithFormat:@"newsImg_%@.jpg",[[self.newsArray objectAtIndex:indexPath.row] objectForKey:@"news_id"]]];
    if ([fm fileExistsAtPath:filePath]) {
        //如果缓存存在
        cell.newsImage.image = [UIImage imageWithContentsOfFile:filePath];
    }else{
        //缓存不存在
        //异步缓存图片
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            //从网络获取图像数据
            NSData * data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[[self.newsArray objectAtIndex:indexPath.row] objectForKey:@"picture"]]];
            //将网络数据初始化为UIImage对象
            UIImage * image = [[UIImage alloc] initWithData:data];
            if (image != nil) {
                //存入本地缓存，成功就重载数据
                if([UIImageJPEGRepresentation(image, 0.5) writeToFile:filePath atomically:YES]){
                    //返回主线程
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.tableView reloadData];
                    });
                }
                
            }
        });
    }
    
    cell.newsTitle.text = [[self.newsArray objectAtIndex:indexPath.row] objectForKey:@"title"];
    cell.shortDetail.text = [[self.newsArray objectAtIndex:indexPath.row] objectForKey:@"summary"];
    
    
    
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

//点击单元格，跳转到新闻详情界面
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //将新闻id传递到下一个页面
    //////////
    //跳转到下一个页面
    UIStoryboard * main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    notDetailViewController * detailView = [main instantiateViewControllerWithIdentifier:@"newsDetail"];
    [self.navigationController pushViewController:detailView animated:YES];
    
}


@end
