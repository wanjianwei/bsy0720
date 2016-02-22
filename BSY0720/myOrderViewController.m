//
//  myOrderViewController.m
//  BSY0720
//
//  Created by jway on 15-7-27.
//  Copyright (c) 2015年 jway. All rights reserved.
//

#import "myOrderViewController.h"
#import "AppDelegate.h"
#import "SDRefresh.h"
#import "orderViewCell.h"
@interface myOrderViewController ()
//上拉加载
@property (nonatomic, weak) SDRefreshFooterView *refreshFooter;
@end

@implementation myOrderViewController
//定义应用程序委托
AppDelegate * app;

- (void)viewDidLoad {
    [super viewDidLoad];
    // 指定代理
    self.orderList.dataSource = self;
    self.orderList.delegate = self;
    self.orderList.backgroundColor = [UIColor clearColor];
    self.orderList.showsVerticalScrollIndicator = NO;
    //初始化
    app = [UIApplication sharedApplication].delegate;
    //上拉加载
    [self setupFooter];
    /*
    //加载数据
    [app.manager POST:@"" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //
    }];
     */
    //构造虚拟数据
    self.finishedArray = [[NSMutableArray alloc] initWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"2343234",@"orderNum",@"portrait.png",@"goodImg",@"统一珍珠奶茶",@"goodName",@"2015-05-30 12:00",@"placeOrderTime",@"2015-06-01 10:00",@"deliveryTime",@"武汉商贸学院男生寝室一栋一单元0001室",@"address",@"武汉光谷广场1120号",@"deliveryAddress",@"99",@"moneyNum", nil],[NSDictionary dictionaryWithObjectsAndKeys:@"2343234",@"orderNum",@"portrait.png",@"goodImg",@"康师傅统一鲜橙多",@"goodName",@"2015-05-30 12:00",@"placeOrderTime",@"2015-06-01 10:00",@"deliveryTime",@"武汉商贸学院男生寝室一栋一单元0001室",@"address",@"武汉光谷广场1120号",@"deliveryAddress",@"99",@"moneyNum", nil],[NSDictionary dictionaryWithObjectsAndKeys:@"2343234",@"orderNum",@"portrait.png",@"goodImg",@"康师傅统一鲜橙多",@"goodName",@"2015-05-30 12:00",@"placeOrderTime",@"2015-06-01 10:00",@"deliveryTime",@"武汉商贸学院男生寝室一栋一单元0001室",@"address",@"武汉光谷广场1120号",@"deliveryAddress",@"99",@"moneyNum", nil],nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//上拉加载
- (void)setupFooter
{
    SDRefreshFooterView *refreshFooter = [SDRefreshFooterView refreshView];
    [refreshFooter addToScrollView:self.orderList];
    [refreshFooter addTarget:self refreshAction:@selector(footerRefresh)];
    _refreshFooter = refreshFooter;
}

//再次向服务器请求数据，并重新加载
-(void)footerRefresh{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if (self.funSort.selectedSegmentIndex == 0) {
            //已完成
            [self.finishedArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"2343234",@"orderNum",@"portrait.png",@"goodImg",@"统一珍珠奶茶",@"goodName",@"2015-05-30 12:00",@"placeOrderTime",@"2015-06-01 10:00",@"deliveryTime",@"武汉商贸学院男生寝室一栋一单元0001室",@"address",@"武汉光谷广场1120号",@"deliveryAddress",@"99",@"moneyNum", nil]];
        }else{
            [self.unfinishedArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"2343234",@"orderNum",@"portrait.png",@"goodImg",@"康师傅统一鲜橙多",@"goodName",@"2015-05-30 12:00",@"placeOrderTime",@"2015-06-01 10:00",@"deliveryTime",@"武汉商贸学院男生寝室一栋一单元0001室",@"address",@"武汉光谷广场1120号",@"deliveryAddress",@"99",@"moneyNum", nil]];
        }
        [self.orderList reloadData];
        [self.refreshFooter endRefreshing];
    });
}


//已完成与未完成切换查看
- (IBAction)funSort:(id)sender {
    if (self.funSort.selectedSegmentIndex == 1) {
        if (self.unfinishedArray == nil) {
            /*
            //是第一次请求未完成的订单信息
            [app.manager POST:@"" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                //
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                //
            }];
             */
            self.unfinishedArray = [[NSMutableArray alloc] initWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"23411134",@"orderNum",@"portrait.png",@"goodImg",@"康师傅统一绿茶",@"goodName",@"2014-05-23 12:00",@"placeOrderTime",@"2015-06-01 10:00",@"deliveryTime",@"武汉商贸学院男生寝室一栋一单元0001室",@"address",@"武汉光谷广场1120号",@"deliveryAddress",@"99",@"moneyNum", nil], nil];
        }
    }
    [self.orderList reloadData];
}

#pragma dataSource/delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.funSort.selectedSegmentIndex == 0) {
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
        if (self.funSort.selectedSegmentIndex == 0) {
            //已完成
            cell.textLabel.text = [NSString stringWithFormat:@"订单号:%@",[[self.finishedArray objectAtIndex:indexPath.section] objectForKey:@"orderNum"]];
            cell.detailTextLabel.text = @"待收货";
            cell.detailTextLabel.textColor = [UIColor orangeColor];
        }else{
            //未完成
            cell.textLabel.text = [NSString stringWithFormat:@"订单号:%@",[[self.unfinishedArray objectAtIndex:indexPath.section] objectForKey:@"orderNum"]];
            cell.detailTextLabel.text = @"去支付";
            cell.detailTextLabel.textColor = [UIColor orangeColor];
        }
        return cell;
    }else{
        orderViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"orderCell"];
        if (self.funSort.selectedSegmentIndex == 0) {
           cell.goodImg.image = [UIImage imageNamed:[[self.finishedArray objectAtIndex:indexPath.section] objectForKey:@"goodImg"]];
            cell.goodName.text = [NSString stringWithFormat:@"名称:%@",[[self.finishedArray objectAtIndex:indexPath.section] objectForKey:@"goodName"]];
            cell.placeOrderTime.text = [NSString stringWithFormat:@"下单时间:%@",[[self.finishedArray objectAtIndex:indexPath.section] objectForKey:@"placeOrderTime"]];
            cell.deliveryTime.text = [NSString stringWithFormat:@"发货时间:%@",[[self.finishedArray objectAtIndex:indexPath.section] objectForKey:@"deliveryTime"]];
            cell.address.text = [NSString stringWithFormat:@"收货地址:%@",[[self.finishedArray objectAtIndex:indexPath.section] objectForKey:@"address"]];
            cell.deliveryAddress.text = [NSString stringWithFormat:@"发货地址:%@",[[self.finishedArray objectAtIndex:indexPath.section] objectForKey:@"deliveryAddress"]];
            cell.moneyNum.text = [NSString stringWithFormat:@"%@元",[[self.finishedArray objectAtIndex:indexPath.section] objectForKey:@"moneyNum"]];

        }else{
            cell.goodImg.image = [UIImage imageNamed:[[self.unfinishedArray objectAtIndex:indexPath.section] objectForKey:@"goodImg"]];
            cell.goodName.text = [NSString stringWithFormat:@"名称:%@",[[self.unfinishedArray objectAtIndex:indexPath.section] objectForKey:@"goodName"]];
            cell.placeOrderTime.text = [NSString stringWithFormat:@"下单时间:%@",[[self.unfinishedArray objectAtIndex:indexPath.section] objectForKey:@"placeOrderTime"]];
            cell.deliveryTime.text = [NSString stringWithFormat:@"发货时间:%@",[[self.unfinishedArray objectAtIndex:indexPath.section] objectForKey:@"deliveryTime"]];
            cell.address.text = [NSString stringWithFormat:@"收货地址:%@",[[self.unfinishedArray objectAtIndex:indexPath.section] objectForKey:@"address"]];
            cell.deliveryAddress.text = [NSString stringWithFormat:@"发货地址:%@",[[self.unfinishedArray objectAtIndex:indexPath.section] objectForKey:@"deliveryAddress"]];
            cell.moneyNum.text = [NSString stringWithFormat:@"%@元",[[self.unfinishedArray objectAtIndex:indexPath.section] objectForKey:@"moneyNum"]];
        }
        return cell;
    }
}

//单元格高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 44;
    }else{
        return 128;
    }
}

//未完成--跳转到支付页面
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ((self.funSort.selectedSegmentIndex == 1) && (indexPath.row == 0)) {
        //
    }
}


@end
