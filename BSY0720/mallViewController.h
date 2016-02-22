//
//  mallViewController.h
//  BSY0720
//
//  Created by jway on 15-7-22.
//  Copyright (c) 2015年 jway. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "goodTableCell.h"
#import "dockTableCell.h"
@interface mallViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,mallProtocol>

//左边菜单栏
@property (weak, nonatomic) IBOutlet UITableView *dockTableView;
//右边商品信息栏
@property (weak, nonatomic) IBOutlet UITableView *disTableView;

//存放用户购买信息
@property(nonatomic,strong) NSMutableArray*buyArray;


//“结算”按钮
@property (weak, nonatomic) IBOutlet UIButton *account;
//事件响应
- (IBAction)account:(id)sender;
//购物车
@property (weak, nonatomic) IBOutlet UIView *basketView;
//已购买商品总数
@property (weak, nonatomic) IBOutlet UILabel *hasBuyNum;


//已购买商品的总金额
@property (weak, nonatomic) IBOutlet UILabel *totalNum;
//已节省金额
@property (weak, nonatomic) IBOutlet UICustomLineLabel *hasSaved;

//导航栏
@property (weak, nonatomic) IBOutlet UIView *navView;
//商城标题
@property (weak, nonatomic) IBOutlet UILabel *pageTitle;
@end
