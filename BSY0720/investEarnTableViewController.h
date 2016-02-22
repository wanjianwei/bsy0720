//
//  investEarnTableViewController.h
//  BSY0720
//
//  Created by jway on 15-7-30.
//  Copyright (c) 2015年 jway. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface investEarnTableViewController : UITableViewController

//定义两个字典用于接收服务器返回数据
@property (nonatomic,strong) NSDictionary * returnDic_1; //账户资产
@property(nonatomic,strong) NSDictionary * returnDic;  //投资收益
//定义一个标志，用来区分是“账户资产”还是“投资收益”
//flag = 1为账户资产；flag = 2为“投资收益”
@property (nonatomic,strong) NSNumber * flag;

@end
