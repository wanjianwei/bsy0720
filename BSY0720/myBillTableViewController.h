//
//  myBillTableViewController.h
//  BSY0720
//
//  Created by jway on 15-7-31.
//  Copyright (c) 2015年 jway. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface myBillTableViewController : UITableViewController
//可变数组，存放服务器返回数据
@property (nonatomic,strong) NSMutableArray * billArray;
@end
