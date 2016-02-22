//
//  myOrderViewController.h
//  BSY0720
//
//  Created by jway on 15-7-27.
//  Copyright (c) 2015年 jway. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface myOrderViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
//订单列表
@property (weak, nonatomic) IBOutlet UITableView *orderList;
//"已完成"和“未完成”
- (IBAction)funSort:(id)sender;
@property (weak, nonatomic) IBOutlet UISegmentedControl *funSort;

//定义两个可变数组，接收服务器返回数据
@property(nonatomic,strong) NSMutableArray * finishedArray; //已完成
@property(nonatomic,strong) NSMutableArray * unfinishedArray; //未完成
@end
