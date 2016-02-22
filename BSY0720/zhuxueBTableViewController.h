//
//  zhuxueBTableViewController.h
//  BSY0720
//
//  Created by jway on 15-8-1.
//  Copyright (c) 2015年 jway. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "financeVIewCell.h"
@interface zhuxueBTableViewController : UITableViewController<financeProtocol>
//接受服务器返回数据
@property(nonatomic,strong) NSArray * infoArray;
//定义一个标志，用来判断是助学宝还是学费宝
//flag =1 为学费宝，flag=4为助学宝
@property(nonatomic,strong) NSNumber * flag;
@end
