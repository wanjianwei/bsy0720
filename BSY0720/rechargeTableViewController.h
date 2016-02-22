//
//  rechargeTableViewController.h
//  BSY0720
//
//  Created by jway on 15-7-30.
//  Copyright (c) 2015年 jway. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface rechargeTableViewController : UITableViewController
//定义一个数组，用来接受服务器数据
@property (nonatomic,strong) NSMutableArray * recordArray;
//定义一个标志，用来判断是充值记录还是消费记录
//flag=1充值记录，flag=2消费记录
@property (nonatomic,strong) NSNumber * flag;
@end
