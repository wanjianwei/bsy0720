//
//  shopBasketViewController.h
//  BSY0720
//
//  Created by jway on 15-8-4.
//  Copyright (c) 2015年 jway. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZCTradeView.h"
#import "shopBasketTableViewCell.h"

@interface shopBasketViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,ZCTradeViewDelegate,shopBasketProtocol>


//购物车列表
@property (weak, nonatomic) IBOutlet UITableView *goodList;
//总金额
@property (weak, nonatomic) IBOutlet UILabel *totalNum;
//支付
- (IBAction)pay:(id)sender;

//定义一个可变数组，来接收购物清单数据
@property (nonatomic,strong) NSMutableArray * goodArray;
//定义一个字典，来存放某个商品买了几个
@property (nonatomic,strong) NSMutableDictionary * goodnum;

@end
