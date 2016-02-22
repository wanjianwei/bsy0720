//
//  yueBaTableViewController.h
//  BSY0720
//
//  Created by jway on 15-7-31.
//  Copyright (c) 2015年 jway. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface yueBaTableViewController : UITableViewController

//定义一个数组用来接受服务器返回的数据
@property(nonatomic,strong) NSMutableArray *infoArray;
//定义一个标志，用来判断是约吧还是精彩活动
//flag= 1 为约吧，flag=2为精彩活动
@property (nonatomic,strong) NSNumber * flag;
//定义存放发现或活动id的变量
@property (nonatomic,strong) NSNumber * sendId;
@end
