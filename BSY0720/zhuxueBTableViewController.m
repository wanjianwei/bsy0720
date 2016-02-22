//
//  zhuxueBTableViewController.m
//  BSY0720
//
//  Created by jway on 15-8-1.
//  Copyright (c) 2015年 jway. All rights reserved.
//

#import "zhuxueBTableViewController.h"
#import "AppDelegate.h"
#import "SDRefresh.h"
#import "zhuxueBDetailViewController.h"
#import "xuefeiBDetailViewController.h"
#import "illustrateViewController.h"
@interface zhuxueBTableViewController ()
//类扩展，增加上拉刷新
//@property (nonatomic, weak) SDRefreshHeaderView *refreshHeader;
//定义导航栏右边按钮
@property (nonatomic, strong)  UIBarButtonItem * rightBtn;
@end

@implementation zhuxueBTableViewController
//定义一个应用程序委托类
AppDelegate * app;
//定义一个数组用来存放理财产品名称
NSArray * nameArray;




- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化
    app = [UIApplication sharedApplication].delegate;
    //定义导航栏
    self.rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"说明" style:UIBarButtonItemStyleDone target:self action:@selector(illustrate)];
    self.navigationItem.rightBarButtonItem = self.rightBtn;
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor blackColor];
    //分割线样式
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //设置理财产品名称
    if ([self.flag intValue] ==1) {
        nameArray = [NSArray arrayWithObjects:@"学费宝（1年）",@"学费宝（2年）",@"学费宝（3年）", nil];
        
    }else{
        nameArray = [NSArray arrayWithObjects:@"助学宝（12个月）",@"助学宝（24个月）",@"助学宝（36个月）", nil];
        
    }
    //设置上拉刷新
    [self setupHeader];
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
    self.navigationItem.rightBarButtonItem = nil;  //右边按钮消失
    //请求数据
    if ([self.flag intValue] == 1) {
        //学费宝
        NSDictionary * sendDic = [NSDictionary dictionaryWithObject:@"3" forKey:@"kind_id"];
        [app.manager POST:@"http://120.25.162.238/bsy/index.php/Index/Finance/getProductList" parameters:sendDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    //
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            //界面恢复响应
            self.view.userInteractionEnabled = YES;
            self.navigationItem.rightBarButtonItem = self.rightBtn;
            //解析服务器返回数据
            NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
            
            
            if ([[dic objectForKey:@"code"] isEqualToString:@"100000"]) {
                //
                self.infoArray = [[dic objectForKey:@"result"] objectForKey:@"FinanceProduct.List"];
                [self.tableView reloadData];
                [weakRefreshHeader endRefreshing];
            }else{
                [weakRefreshHeader endRefreshing];
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[dic objectForKey:@"message"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [alert show];
                }
        }];
    }else{
        //助学宝
        [app.manager POST:@"http://120.25.162.238/bsy/index.php/Index/Finance/getProductList" parameters:@{@"kind_id":@"2"} success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    //
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            //界面恢复响应
            self.view.userInteractionEnabled = YES;
            self.navigationItem.rightBarButtonItem = self.rightBtn;

            
            //解析服务器返回数据
            NSDictionary * returnDic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
                    
            if ([[returnDic objectForKey:@"code"] isEqualToString:@"100000"]) {
                //正确获得数据
                self.infoArray = [[returnDic objectForKey:@"result"] objectForKey:@"FinanceProduct.List"];
                [self.tableView reloadData];
                [weakRefreshHeader endRefreshing];
            }else{
                [weakRefreshHeader endRefreshing];
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[returnDic objectForKey:@"message"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                    }
                }];
            }
    };
    
    // 进入页面自动加载一次数据
     [refreshHeader beginRefreshing];
}

//投资说明
- (void)illustrate{
    UIStoryboard * main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    illustrateViewController * illustrateView = [main instantiateViewControllerWithIdentifier:@"illustrate"];
    if ([self.flag intValue] == 1) {
        //学费报
        illustrateView.flag = [NSNumber numberWithInt:2];
    }else{
        //助学宝
        illustrateView.flag = [NSNumber numberWithInt:1];
    }
    illustrateView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:illustrateView animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma dataSource/Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    financeVIewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"financeTableCell"];
    //设置理财产品名称
    cell.sortName.text = [nameArray objectAtIndex:indexPath.section];
    //按钮要记住是哪个产品,并且要正确区分
    cell.investment.tag = indexPath.section+[self.flag intValue];
    //修饰按钮的外观
    cell.investment.layer.cornerRadius = 33;
    if ([self.flag intValue] ==1) {
        //学费宝
        cell.incomeRatio.text = [NSString stringWithFormat:@"%4.2f%%",[[[self.infoArray objectAtIndex:indexPath.section] objectForKey:@"yield"] floatValue]*100];
        cell.beginNum.hidden = YES;
    }else{
        //助学宝
        cell.incomeRatio.text = [NSString stringWithFormat:@"%4.2f%%",[[[self.infoArray objectAtIndex:indexPath.section] objectForKey:@"yield"] floatValue]*100];
        NSString * str = @"5000元起投";
        //字符串显示不同颜色
        NSMutableAttributedString * str_temp = [[NSMutableAttributedString alloc] initWithString:str];
        [str_temp addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(0, str.length-3)];
        // [str_temp addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:15] range:];
        //字体大小
        cell.beginNum.attributedText = str_temp;
        cell.beginNum.font = [UIFont boldSystemFontOfSize:([UIScreen mainScreen].bounds.size.width ==320)?13:17];
    }
    //修饰cell背景的圆角
    cell.bgView.layer.cornerRadius = 6.0f;
    cell.backgroundColor = [UIColor clearColor];
    //指定协议代理
    cell.delegate = self;
    return cell;
}

//单元格高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view = [[UIView  alloc] initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, 10)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

#pragma financeProtocol
-(void)transferTag:(int)tag{
    UIStoryboard * main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    if (tag ==1 || tag == 2 || tag == 3) {
        xuefeiBDetailViewController * xuefeiView = [main instantiateViewControllerWithIdentifier:@"xuefei"];
        //将理财产品信息传递给下一个页面
        xuefeiView.transDic = [self.infoArray objectAtIndex:tag-1];
        xuefeiView.flag = [NSNumber numberWithInt:tag];
        [self.navigationController pushViewController:xuefeiView animated:YES];
    }else{
        zhuxueBDetailViewController * zhuxueView = [main instantiateViewControllerWithIdentifier:@"zhuxue"];
        //传递数据
        zhuxueView.transDic = [self.infoArray objectAtIndex:tag-4];
        zhuxueView.flag = [NSNumber numberWithInt:tag-3];
        [self.navigationController pushViewController:zhuxueView animated:YES];
    }
}

@end
