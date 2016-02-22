//
//  myOrderTableViewController.m
//  BSY0720
//
//  Created by jway on 15-8-1.
//  Copyright (c) 2015年 jway. All rights reserved.
//

#import "myOrderTableViewController.h"
#import "AppDelegate.h"
#import "SDRefresh.h"
#import "orderViewCell.h"
@interface myOrderTableViewController ()

//下拉刷新与上拉加载
@property (nonatomic, weak) SDRefreshFooterView *refreshFooter;
//@property (nonatomic, weak) SDRefreshHeaderView *refreshHeader;
@end

@implementation myOrderTableViewController
//定义应用程序委托
AppDelegate * app;
//定义一个segmentControll
UISegmentedControl * segView;
//定义一个分页控件
int flag;


- (void)viewDidLoad {
    [super viewDidLoad];
    //self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //初始化
    app = [UIApplication sharedApplication].delegate;
    self.unfinishedArray = [[NSMutableArray alloc] init];
    self.finishedArray = [[NSMutableArray alloc] init];
    //自定义titleView
    segView = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"已完成",@"未完成", nil]];
    [segView addTarget:self action:@selector(funSort) forControlEvents:UIControlEventValueChanged];
    segView.tintColor = [UIColor orangeColor];
    segView.selectedSegmentIndex = 0;
    self.navigationItem.titleView = segView;
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
    SDRefreshHeaderView * refreshHeader = [SDRefreshHeaderView refreshView];
    [refreshHeader addToScrollView:self.tableView];
    __weak SDRefreshHeaderView *weakRefreshHeader = refreshHeader;
    refreshHeader.beginRefreshingOperation = ^{
        //第一次进入页面才允许刷新
        if ((self.finishedArray.count == 0)) {
            //界面失去响应
            self.view.userInteractionEnabled = NO;
            //构造发送参数
            //默认加载已完成
            NSDictionary * sendic = [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"status",@"8",@"num",@"0",@"page", nil];
           
            //发送服务器
            [app.manager POST:@"http://120.25.162.238/bsy/index.php/Index/Order/getOrderList" parameters:sendic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                //
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                //界面恢复响应
                self.view.userInteractionEnabled = YES;
                //停止刷新
                [weakRefreshHeader endRefreshing];
                
                NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
                if ([[dic objectForKey:@"code"] isEqualToString:@"100000"]) {
                    [self.finishedArray addObjectsFromArray:[[dic objectForKey:@"result"] objectForKey:@"Order.List"]];
                    flag++;
                    [self.tableView reloadData];
                }else{
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
    //界面失去响应
    self.view.userInteractionEnabled = NO;
    //构造发送参数
    NSDictionary * sendic;
    if (segView.selectedSegmentIndex == 0) {
        //已完成
        sendic = [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"status",@"8",@"num",[NSString stringWithFormat:@"%i",flag],@"page", nil];
    }else{
        //未完成
        sendic = [NSDictionary dictionaryWithObjectsAndKeys:@"3",@"status",@"8",@"num",[NSString stringWithFormat:@"%i",flag],@"page", nil];
    }
    //发送服务器
    [app.manager POST:@"http://120.25.162.238/bsy/index.php/Index/Order/getOrderList" parameters:sendic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //界面恢复响应
        self.view.userInteractionEnabled = YES;
        //停止刷新
        [_refreshFooter endRefreshing];
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        if ([[dic objectForKey:@"code"] isEqualToString:@"100000"]) {
            if (segView.selectedSegmentIndex == 0) {
                [self.finishedArray addObjectsFromArray:[[dic objectForKey:@"result"] objectForKey:@"Order.List"]];
            }else{
                [self.unfinishedArray addObjectsFromArray:[[dic objectForKey:@"result"] objectForKey:@"Order.List"]];
            }
            flag++;
            [self.tableView reloadData];
        }else{
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[dic objectForKey:@"message"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            
        }
    }];
}

//已完成与未完成切换查看
- (void)funSort{
    if (segView.selectedSegmentIndex == 1) {
        if (self.unfinishedArray.count == 0) {
            //开启另一个线程来加载
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                NSDictionary * sendic = [NSDictionary dictionaryWithObjectsAndKeys:@"3",@"status",@"8",@"num",@"0",@"page", nil];
                //是第一次请求未完成的订单信息
                [app.manager POST:@"http://120.25.162.238/bsy/index.php/Index/Order/getOrderList" parameters:sendic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    //
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
                    //返回主线程
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if ([[dic objectForKey:@"code"] isEqualToString:@"100000"]) {
                            [self.unfinishedArray addObjectsFromArray:[[dic objectForKey:@"result"] objectForKey:@"Order.List"]];
                            [self.tableView reloadData];
                        }else{
                            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[dic objectForKey:@"message"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                            [alert show];
                        }
                        
                        
                    });
                    
                }];
            });
        }
    }
    [self.tableView reloadData];
}

#pragma dataSource/delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (segView.selectedSegmentIndex == 0) {
        //已完成
        return self.finishedArray.count;
    }else{
        //未完成
        return self.unfinishedArray.count;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width-32, 10)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"orderCell_1"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"orderCell_1"];
        }
        if (segView.selectedSegmentIndex == 0) {
            //已完成
            cell.textLabel.text = [NSString stringWithFormat:@"订单号:%@",[[self.finishedArray objectAtIndex:indexPath.section] objectForKey:@"order_id"]];
            cell.detailTextLabel.text = @"待收货";
            cell.detailTextLabel.textColor = [UIColor orangeColor];
        }else{
            //未完成
            cell.textLabel.text = [NSString stringWithFormat:@"订单号:%@",[[self.unfinishedArray objectAtIndex:indexPath.section] objectForKey:@"order_id"]];
            cell.detailTextLabel.text = @"去支付";
            cell.detailTextLabel.textColor = [UIColor orangeColor];
        }
        return cell;
    }else{
        orderViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"orderTableCell"];
        if (segView.selectedSegmentIndex == 0) {
            cell.goodImg.image = [UIImage imageNamed:@"portrait"];
            cell.goodName.text = [NSString stringWithFormat:@"名称:%@",[[self.finishedArray objectAtIndex:indexPath.section] objectForKey:@"goodName"]];
            //设置时间格式
            NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate * date1 = [NSDate dateWithTimeIntervalSince1970:[[[self.finishedArray objectAtIndex:indexPath.section] objectForKey:@"order_time"] intValue]];
            cell.placeOrderTime.text = [NSString stringWithFormat:@"下单时间:%@",[formatter stringFromDate:date1]];
            
            
            NSDate * date2 = [NSDate dateWithTimeIntervalSince1970:[[[self.finishedArray objectAtIndex:indexPath.section] objectForKey:@"delivery_time"] intValue]];
            
            cell.deliveryTime.text = [formatter stringFromDate:date2];
            
            
            cell.address.text = [NSString stringWithFormat:@"收货地址:%@",[[self.finishedArray objectAtIndex:indexPath.section] objectForKey:@"address"]];
            
            cell.deliveryAddress.text = [NSString stringWithFormat:@"发货人电话:%@",[[self.finishedArray objectAtIndex:indexPath.section] objectForKey:@"phonenum"]];
            cell.moneyNum.text = [NSString stringWithFormat:@"%@元",[[self.finishedArray objectAtIndex:indexPath.section] objectForKey:@"amount"]];
            
        }else{
            cell.goodImg.image = [UIImage imageNamed:@"portrait"];
            cell.goodName.text = [NSString stringWithFormat:@"名称:%@",[[self.unfinishedArray objectAtIndex:indexPath.section] objectForKey:@"goodName"]];
            //设置时间格式
            NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate * date1 = [NSDate dateWithTimeIntervalSince1970:[[[self.unfinishedArray objectAtIndex:indexPath.section] objectForKey:@"order_time"] intValue]];
            cell.placeOrderTime.text = [NSString stringWithFormat:@"下单时间:%@",[formatter stringFromDate:date1]];
            
            NSDate * date2 = [NSDate dateWithTimeIntervalSince1970:[[[self.unfinishedArray objectAtIndex:indexPath.section] objectForKey:@"delivery_time"] intValue]];
            
            cell.deliveryTime.text = [NSString stringWithFormat:@"发货时间:%@",[formatter stringFromDate:date2]];
            
            
            cell.address.text = [NSString stringWithFormat:@"收货地址:%@",[[self.unfinishedArray objectAtIndex:indexPath.section] objectForKey:@"address"]];
            
            cell.deliveryAddress.text = [NSString stringWithFormat:@"发货人电话:%@",[[self.unfinishedArray objectAtIndex:indexPath.section] objectForKey:@"phonenum"]];
            cell.moneyNum.text = [NSString stringWithFormat:@"%@元",[[self.unfinishedArray objectAtIndex:indexPath.section] objectForKey:@"amount"]];
        }
        
        return cell;
    }
}

//单元格高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 44;
    }else{
        //动态计算发货地址的高度
        if (segView.selectedSegmentIndex == 0) {
            NSString * content = [NSString stringWithFormat:@"收货人电话:%@",[[self.finishedArray objectAtIndex:indexPath.section] objectForKey:@"phonenum"]];
            CGRect  rect = [content boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width-98, 100) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading  attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:12]} context:nil];
            CGFloat  labHeight = rect.size.height;
            return 140+labHeight-27;
        }else{
            NSString * content = [NSString stringWithFormat:@"收货人电话:%@",[[self.unfinishedArray objectAtIndex:indexPath.section] objectForKey:@"phonenum"]];
            CGRect  rect = [content boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width-98, 100) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading  attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:12]} context:nil];
            CGFloat  labHeight = rect.size.height;
            return 140+labHeight-27;
        }
       
    }
}

//未完成--跳转到支付页面
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ((segView.selectedSegmentIndex == 1) && (indexPath.row == 0)) {
        //直接弹出支付密码
        ZCTradeView * pwdInput = [[ZCTradeView alloc] init];
        pwdInput.delegate = self;
        [pwdInput show];
    }
}

#pragma ZCTradeViewDelegate
-(NSString*)finish:(NSString *)pwd{
    //支付
    //NSLog(@"%i",[inputField.text intValue]);
    return pwd;
}

@end
