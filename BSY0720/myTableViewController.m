//
//  myTableViewController.m
//  BSY0720
//
//  Created by jway on 15-7-30.
//  Copyright (c) 2015年 jway. All rights reserved.
//

#import "myTableViewController.h"
#import "AppDelegate.h"
#import "SDRefresh.h"
#import "setUpTableViewController.h"
#import "financeManageTableViewController.h"
#import "myOrderTableViewController.h"
#import "toCashViewController.h"
#import "myAccountTableViewController.h"
#import "loginViewController.h"
#define a [UIScreen mainScreen].bounds.size.width
#define b ([UIScreen mainScreen].bounds.size.height-112)/3

@interface myTableViewController (){
    AppDelegate *app;
    //定义一个故事版引用
    UIStoryboard * main;
}
//定义导航栏右边按钮
@property (nonatomic, strong)  UIBarButtonItem * rightBtn;
@end

@implementation myTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置不允许自动改变contentsize
    //self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"我的";
    self.rightBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"setUp.png"] style:UIBarButtonItemStyleDone target:self action:@selector(setUp)];
    self.navigationItem.rightBarButtonItem = self.rightBtn;
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor grayColor];
    //设置上拉刷新与下拉加载
    [self setupHeader];
    //初始化程序委托类
    app = [UIApplication sharedApplication].delegate;
    main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//设置按钮
- (void)setUp{
    //跳转到设置界面
    setUpTableViewController * setUpView = [main instantiateViewControllerWithIdentifier:@"setUp1"];
    setUpView.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    setUpView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:setUpView animated:YES];
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
        //导航栏右边按钮也重新出现
        self.navigationItem.rightBarButtonItem = nil;
        //请求服务器
        [app.manager POST:@"http://120.25.162.238/bsy/index.php/Index/PersonalCenter/index" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            //判断是否有数据返回
            if (operation.responseData != nil) {
                self.returnDic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
                if ([[self.returnDic objectForKey:@"code"] isEqual:@"100000"]) {
                    //界面恢复
                    self.view.userInteractionEnabled = YES;
                    self.navigationItem.rightBarButtonItem = self.rightBtn;   //按钮重新出现
                    //获取数据成功
                    [self.tableView reloadData];
                    [weakRefreshHeader endRefreshing];
                }else if ([[self.returnDic objectForKey:@"code"] isEqualToString:@"100001"]){
                    //弹出请先登录提示
                    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:[self.returnDic objectForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                        //界面恢复
                        self.view.userInteractionEnabled = YES;
                        self.navigationItem.rightBarButtonItem = self.rightBtn;   //按钮重新出现
                        [weakRefreshHeader endRefreshing];
                        //弹出登录界面
                        loginViewController * loginView = [main instantiateViewControllerWithIdentifier:@"login"];
                        loginView.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
                        [self presentViewController:loginView animated:YES completion:nil];
                    }];
                    UIAlertAction * action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                    [alert addAction:action1];
                    [alert addAction:action2];
                    [self presentViewController:alert animated:YES completion:nil];
                }
                else{
                    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:[self.returnDic objectForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                        //界面恢复
                        self.view.userInteractionEnabled = YES;
                        self.navigationItem.rightBarButtonItem = self.rightBtn;   //按钮重新出现
                        [weakRefreshHeader endRefreshing];
                    }];
                    [alert addAction:action];
                    [self presentViewController:alert animated:YES completion:nil];
                }
                NSLog(@"我的=%@",self.returnDic);
            }else{
                UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"请求超时" message:@"请检查网络连接是否正常" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    //界面恢复
                    self.view.userInteractionEnabled = YES;
                    self.navigationItem.rightBarButtonItem = self.rightBtn;   //按钮重新出现
                    [weakRefreshHeader endRefreshing];
                }];
                [alert addAction:action];
                [self presentViewController:alert animated:YES completion:nil];
            }
            
        }];
    };
    // 进入页面自动加载一次数据
    [refreshHeader beginRefreshing];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 2;
    }else if (section == 2){
        return 2;
    }else{
        return 1;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell*cell = [[UITableViewCell alloc] init];
    if (indexPath.section == 0) {
        //添加一个大背景
        UIImageView * bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,a, b-10)];
        bgView.image = [UIImage imageNamed:@"my_bg.png"];
        //添加头像
        UIImageView * portrait = [[UIImageView alloc] initWithFrame:CGRectMake(a/6, (b-10)/3, (b-10)/3, (b-10)/3)];
        //如果用户已经上传，则显示用户头像，如果没有上传，则显示默认头像,头像也是用户登录成功后自动返回
        if ([[[[NSUserDefaults standardUserDefaults] objectForKey:@"Customer"] objectForKey:@"picture"] isEqual:@""]) {
            portrait.image = [UIImage imageNamed:@"portrait.png"];
        }else{
            portrait.image = [UIImage imageNamed:@"portrait.png"];
        }
        portrait.backgroundColor = [UIColor whiteColor];
        portrait.layer.cornerRadius = (b-10)/6;
        portrait.layer.masksToBounds = YES;
        [bgView addSubview:portrait];
        
        //增加用户名
        UILabel * lab = [[UILabel alloc] initWithFrame:CGRectMake(a/3+15, (b-10)/3, a/3, 30)];
        lab.textAlignment = NSTextAlignmentLeft;
        lab.font = [UIFont boldSystemFontOfSize:15];
        //名称登录时已经返回
        lab.text = [[[NSUserDefaults standardUserDefaults] objectForKey:@"Customer"] objectForKey:@"name"];
        lab.textColor = [UIColor whiteColor];
        //lab.backgroundColor = [UIColor whiteColor];
        [bgView addSubview:lab];
        //添加修改地址按钮
        UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(a/2, (b-10)/2, a/2, 20)];
        //btn.titleLabel.textAlignment = NSTextAlignmentRight;
        [btn setTitle:@"账号管理收货地址>" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:13];
        //设置标题颜色
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        btn.backgroundColor = [UIColor clearColor];
        //给按钮添加事件响应
       // [btn addTarget:self action:@selector(changeAddress) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:btn];
        [cell addSubview:bgView];
        
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            cell.imageView.image = [UIImage imageNamed:@"my_3.png"];
            cell.textLabel.text = @"我的理财";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
        }else{
            
            UILabel * lab1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, [UIScreen mainScreen].bounds.size.width/3, 25)];
            lab1.textAlignment = NSTextAlignmentCenter;
            lab1.font = [UIFont boldSystemFontOfSize:15];
            lab1.text = @"币生通余额";
            [cell addSubview:lab1];
            //添加“|”
            UILabel * lab_1 = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/3-2, 10, 4, 60)];
            lab_1.numberOfLines = 2;
            lab_1.text = [NSString stringWithFormat:@"|\n|"];
            lab_1.textColor = [UIColor lightGrayColor];
            [cell addSubview:lab_1];
            
            UILabel * lab2 = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/3, 10, [UIScreen mainScreen].bounds.size.width/3, 25)];
            lab2.textAlignment = NSTextAlignmentCenter;
            lab2.font = [UIFont boldSystemFontOfSize:15];
            lab2.text = @"昨日收益";
            [cell addSubview:lab2];
            //添加“|”
            UILabel * lab_2 = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width*2/3-2, 10, 4, 60)];
            lab_2.numberOfLines = 2;
            lab_2.text = [NSString stringWithFormat:@"|\n|"];
            lab_2.textColor = [UIColor lightGrayColor];
            [cell addSubview:lab_2];
            
            UILabel * lab3 = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width*2/3, 10, [UIScreen mainScreen].bounds.size.width/3, 25)];
            lab3.textAlignment = NSTextAlignmentCenter;
            lab3.font = [UIFont boldSystemFontOfSize:15];
            lab3.text = @"已投资金额";
            [cell addSubview:lab3];
            
            UILabel * lab4 = [[UILabel alloc] initWithFrame:CGRectMake(0, 45, [UIScreen mainScreen].bounds.size.width/3, 25)];
            lab4.textAlignment = NSTextAlignmentCenter;
            lab4.font = [UIFont boldSystemFontOfSize:15];
            lab4.text = [NSString stringWithFormat:@"%@元",[[[self.returnDic objectForKey:@"result"] objectForKey:@"MyFinance"] objectForKey:@"balance"]];
            [cell addSubview:lab4];
            
            UILabel * lab5 = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/3, 45, [UIScreen mainScreen].bounds.size.width/3, 25)];
            lab5.textAlignment = NSTextAlignmentCenter;
            lab5.font = [UIFont boldSystemFontOfSize:15];
            lab5.text = [NSString stringWithFormat:@"%@元",[[[self.returnDic objectForKey:@"result"] objectForKey:@"MyFinance"] objectForKey:@"yesterday_income"]];
            [cell addSubview:lab5];
            
            UILabel * lab6 = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width*2/3, 45, [UIScreen mainScreen].bounds.size.width/3, 25)];
            lab6.textAlignment = NSTextAlignmentCenter;
            lab6.font = [UIFont boldSystemFontOfSize:15];
            lab6.text = [NSString stringWithFormat:@"%@元",[[[self.returnDic objectForKey:@"result"] objectForKey:@"MyFinance"] objectForKey:@"finance_sum"]];
            [cell addSubview:lab6];
        }
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            cell.imageView.image = [UIImage imageNamed:@"my_2.png"];
            cell.textLabel.text = @"我的订单";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
        }else{
            
            UILabel * lab1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, [UIScreen mainScreen].bounds.size.width/3, 25)];
            lab1.textAlignment = NSTextAlignmentCenter;
            lab1.font = [UIFont boldSystemFontOfSize:15];
            lab1.text = @"待付款";
            [cell addSubview:lab1];
            
            //添加“|”
            UILabel * lab_3 = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/3-2, 10, 4, 60)];
            lab_3.numberOfLines = 2;
            lab_3.text = [NSString stringWithFormat:@"|\n|"];
            lab_3.textColor = [UIColor lightGrayColor];
            [cell addSubview:lab_3];
            
            UILabel * lab2 = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/3, 10, [UIScreen mainScreen].bounds.size.width/3, 25)];
            lab2.textAlignment = NSTextAlignmentCenter;
            lab2.font = [UIFont boldSystemFontOfSize:15];
            lab2.text = @"待收货";
            [cell addSubview:lab2];
            
            
            //添加“|”
            UILabel * lab_4 = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width*2/3-2, 10, 4, 60)];
            lab_4.numberOfLines = 2;
            lab_4.text = [NSString stringWithFormat:@"|\n|"];
            lab_4.textColor = [UIColor lightGrayColor];
            [cell addSubview:lab_4];
            
            UILabel * lab3 = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width*2/3, 10, [UIScreen mainScreen].bounds.size.width/3, 25)];
            lab3.textAlignment = NSTextAlignmentCenter;
            lab3.font = [UIFont boldSystemFontOfSize:15];
            lab3.text = @"待评价";
            [cell addSubview:lab3];
            
            UILabel * lab4 = [[UILabel alloc] initWithFrame:CGRectMake(0, 45, [UIScreen mainScreen].bounds.size.width/3, 25)];
            lab4.textAlignment = NSTextAlignmentCenter;
            lab4.font = [UIFont boldSystemFontOfSize:15];
            lab4.text = [NSString stringWithFormat:@"%@",[[[self.returnDic objectForKey:@"result"] objectForKey:@"MyBill"] objectForKey:@"topay"]];
            [cell addSubview:lab4];
            
            UILabel * lab5 = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/3, 45, [UIScreen mainScreen].bounds.size.width/3, 25)];
            lab5.textAlignment = NSTextAlignmentCenter;
            lab5.font = [UIFont boldSystemFontOfSize:15];
            lab5.text = [NSString stringWithFormat:@"%@",[[[self.returnDic objectForKey:@"result"] objectForKey:@"MyBill"] objectForKey:@"toreceive"]];
            [cell addSubview:lab5];
            
            UILabel * lab6 = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width*2/3, 45, [UIScreen mainScreen].bounds.size.width/3, 25)];
            lab6.textAlignment = NSTextAlignmentCenter;
            lab6.font = [UIFont boldSystemFontOfSize:15];
            lab6.text = [NSString stringWithFormat:@"%@",[[[self.returnDic objectForKey:@"result"] objectForKey:@"MyBill"] objectForKey:@"tocomment"]];
            [cell addSubview:lab6];
            
        }
    }else{
        cell.imageView.image = [UIImage imageNamed:@"my_1.png"];
        cell.textLabel.text = @"我要提现";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

//单元格的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return ([UIScreen mainScreen].bounds.size.height-112)/3-10;
    }else if (indexPath.section == 1 || indexPath.section == 2){
        if (indexPath.row == 0) {
            return 44;
        }else{
            return 80;
        }
    }else{
        return 44;
    }
}

//单元格之间的距离
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

//构造footer
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 10)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

//当点击单元格
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            //跳转到“我的理财”
            financeManageTableViewController * financeView = [main instantiateViewControllerWithIdentifier:@"financeManageTable"];
            financeView.title = @"我的理财";
            financeView.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:financeView animated:YES];
        }
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            //跳转到我的订单
            myOrderTableViewController * orderView = [main instantiateViewControllerWithIdentifier:@"myOrderTable"];
            orderView.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:orderView animated:YES];
        }
    }else if (indexPath.section == 3){
        if (indexPath.row == 0) {
            //跳转到"我要提现"
            toCashViewController * cashView = [main instantiateViewControllerWithIdentifier:@"toCash"];
            cashView.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            cashView.title = @"我要提现";
            cashView.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:cashView animated:YES];
        }
    }else if (indexPath.section == 0){
        myAccountTableViewController * accountView = [main instantiateViewControllerWithIdentifier:@"myAccountTable"];
        //已push得方式进入
        accountView.hidesBottomBarWhenPushed = YES;
        accountView.title = @"我的账户";
        [self.navigationController pushViewController:accountView animated:YES];
    }
    
}

@end
