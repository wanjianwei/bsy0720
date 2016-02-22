//
//  findTableViewController.h
//  BSY0720
//
//  Created by jway on 15-7-31.
//  Copyright (c) 2015年 jway. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface findTableViewController : UITableViewController

//定义一个数组用来接受服务器返回的数据
@property(nonatomic,strong) NSMutableArray *infoArray;
@end
