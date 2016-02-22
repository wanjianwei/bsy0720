//
//  marketTableViewController.m
//  BSY0720
//
//  Created by jway on 15-7-31.
//  Copyright (c) 2015年 jway. All rights reserved.
//

#import "marketTableViewController.h"
#import "AppDelegate.h"
#import "SDRefresh.h"
#import "marketViewCell.h"
#import "publishViewController.h"
#define a ([UIScreen mainScreen].bounds.size.width-16)
@interface marketTableViewController ()
//上拉刷新与下拉加载
@property (nonatomic, weak) SDRefreshFooterView *refreshFooter;
//@property (nonatomic, weak) SDRefreshHeaderView *refreshHeader;
//定义导航栏右边按钮
@property (nonatomic, strong)  UIBarButtonItem * rightBtn;
@end

@implementation marketTableViewController

//定义一个协议委托类
AppDelegate * app;
//商品图片
NSArray * imgArray;
//定义一个分页
int flag;

- (void)viewDidLoad {
    [super viewDidLoad];
    //实例化协议委托类
    app = [UIApplication sharedApplication].delegate;
    self.goodsArray = [[NSMutableArray alloc] init];
    //定义导航栏barbutton
    self.rightBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"publish.png"] style:UIBarButtonItemStyleDone target:self action:@selector(publish)];
    self.navigationItem.rightBarButtonItem = self.rightBtn;
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor grayColor];
    //设置单元格的分割线模式
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //设置上拉刷新与下拉加载
    [self setupHeader];
    [self setupFooter];
    
    imgArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"main_fun1.png"],[UIImage imageNamed:@"main_fun2.png"],[UIImage imageNamed:@"main_fun3.png"],[UIImage imageNamed:@"main_fun4.png"],[UIImage imageNamed:@"main_fun5.png"],nil];    
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
        if (self.goodsArray.count == 0) {
            //导航栏右边按钮隐藏
            self.navigationItem.rightBarButtonItem = nil;
            self.view.userInteractionEnabled = YES;
            //构造发送数据
            NSDictionary * sendic = [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"category_id",@"5",@"num",@"0",@"page", nil];
            [app.manager POST:@"http://120.25.162.238/bsy/index.php/Index/Blog/getBlogList" parameters:sendic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                //
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                //请求成功
                self.navigationItem.rightBarButtonItem = self.rightBtn;
                self.view.userInteractionEnabled = YES;
                //停止刷新
                [weakRefreshHeader endRefreshing];
                //解析返回数据
                NSDictionary * getdic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"getdic = %@",getdic);
                if ([[getdic objectForKey:@"code"] isEqualToString:@"100000"]) {
                    //加载数据
                    flag++;
                    [self.goodsArray addObjectsFromArray:[[getdic objectForKey:@"result"] objectForKey:@"Blog.List"]];
                    [self.tableView reloadData];
                    
                }else{
                    //请求失败
                    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[getdic objectForKey:@"message"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                }
                
            }];
        }else{
            [weakRefreshHeader endRefreshing];
        }
        
        /*
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //导航栏右边按钮重新出现
            self.navigationItem.rightBarButtonItem = self.rightBtn;
            for (int i =0; i<5; i++) {
                imgArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"main_fun1.png"],[UIImage imageNamed:@"main_fun2.png"],[UIImage imageNamed:@"main_fun3.png"],[UIImage imageNamed:@"main_fun4.png"],[UIImage imageNamed:@"main_fun5.png"],nil];
                [self.goodsArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"万建伟",@"username",@"2014-12-23",@"time",@"portrait.png",@"userPortrait",@"联想Y50-70AM-ISE",@"goodName",@"八成新",@"isNew",@"以物易物",@"needs",@"操作系统预装windows8 64bit（64位简体中文版）处理器问过去安慰率噶尔噶尔电话古巴是地方噶而后收到货后各色的风格让他而跟他去耳闻CPU系列速度速度和地方地方大对方告诉对方最大化的设备阿打发多少个",@"detail",@"12",@"praiseNum",@"34",@"commentNum",imgArray,@"goodImg", nil]];
            }
            [self.tableView reloadData];
            [weakRefreshHeader endRefreshing];
        });
         */
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
    //导航栏右边按钮隐藏
    self.navigationItem.rightBarButtonItem = nil;
    self.view.userInteractionEnabled = YES;
    //构造发送数据
    NSDictionary * sendic = [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"category_id",@"5",@"num",[NSString stringWithFormat:@"%i",flag],@"page", nil];
    [app.manager POST:@"http://120.25.162.238/bsy/index.php/Index/Blog/getBlogList" parameters:sendic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //请求成功
        self.navigationItem.rightBarButtonItem = self.rightBtn;
        self.view.userInteractionEnabled = YES;
        //停止刷新
        [_refreshFooter endRefreshing];
        //解析返回数据
        NSDictionary * getdic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"getdic = %@",getdic);
        if ([[getdic objectForKey:@"code"] isEqualToString:@"100000"]) {
            //加载数据
            flag++;
            [self.goodsArray addObject:[[getdic objectForKey:@"result"] objectForKey:@"Blog.List"]];
            [self.tableView reloadData];
        }else{
            //请求失败
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[getdic objectForKey:@"message"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    }];
}

//发布新需求
-(void)publish{
    UIStoryboard * main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    publishViewController * pubView = [main instantiateViewControllerWithIdentifier:@"publishView"];
    pubView.title = @"发布";
    pubView.flag = [NSNumber numberWithInt:2];
    [self.navigationController pushViewController:pubView animated:YES];
}


#pragma dataSource/delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.goodsArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

//构造视图
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    marketViewCell*cell = [tableView dequeueReusableCellWithIdentifier:@"goodTableCell"];
    NSDictionary * dic = [self.goodsArray objectAtIndex:indexPath.section];
    cell.userPortrait.image = [UIImage imageNamed:@"portrait"];
    cell.username.text = [dic objectForKey:@"name"];
    
    //设置时间格式
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:[[dic objectForKey:@"time"] intValue]];
    cell.time.text = [formatter stringFromDate:date];
    
    cell.goodName.text = [dic objectForKey:@"goodName"];
    cell.isNew.text = [NSString stringWithFormat:@"新旧程度:%@",@""];
    cell.needs.text = [NSString stringWithFormat:@"需求:%@",[dic objectForKey:@"needs"]];
    cell.detail.text = [dic objectForKey:@"summary"];
    
    cell.praiseNum.text = [dic objectForKey:@"praise_count"];
    cell.commentNum.text = [dic objectForKey:@"comment_count"];
    
    
    
    cell.goodImgs.contentSize = CGSizeMake(a/3*imgArray.count,72);
    //循环添加图片
    for (int i =0; i<imgArray.count; i++) {
        
        UIImageView * img = [[UIImageView alloc] initWithFrame:CGRectMake(i*a/3, 0, a/3-20, 72)];
        img.image = [imgArray objectAtIndex:i];
        [cell.goodImgs addSubview:img];
    }
    return cell;
    
}

//单元格高度-自适应label高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString * detail = [[self.goodsArray objectAtIndex:indexPath.section] objectForKey:@"summary"];
    //自适应label高度
    CGRect size = [detail boundingRectWithSize:CGSizeMake(a, 500) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:14]} context:nil];
    
    CGFloat height = size.size.height-53;
    return 293+height;
}

//单元格之间距离（section）
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(-1.5, 0, a+3, 10)];
    view.backgroundColor = [UIColor clearColor];
    // view.layer.borderWidth = 1.0f;
    //view.layer.borderColor = [UIColor lightGrayColor].CGColor;
    return view;
}

@end
