//
//  myTableViewController.h
//  BSY0720
//
//  Created by jway on 15-7-30.
//  Copyright (c) 2015年 jway. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface myTableViewController : UITableViewController
//定义一个字典类型数据存放服务器返回数据
@property(nonatomic,strong) NSDictionary * returnDic;
@end
