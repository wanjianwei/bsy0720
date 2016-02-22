//
//  noticeTableViewController.h
//  BSY0720
//
//  Created by jway on 15-7-30.
//  Copyright (c) 2015年 jway. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface noticeTableViewController : UITableViewController
//接收服务器返回数据
@property(nonatomic,strong) NSMutableArray * noticeArray;
@end
