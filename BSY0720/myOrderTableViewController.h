//
//  myOrderTableViewController.h
//  BSY0720
//
//  Created by jway on 15-8-1.
//  Copyright (c) 2015年 jway. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZCTradeView.h"
@interface myOrderTableViewController : UITableViewController<ZCTradeViewDelegate>

//定义两个可变数组，接收服务器返回数据
@property(nonatomic,strong) NSMutableArray * finishedArray; //已完成
@property(nonatomic,strong) NSMutableArray * unfinishedArray; //未完成

@end
