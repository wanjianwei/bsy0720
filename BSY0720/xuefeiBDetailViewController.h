//
//  xuefeiBDetailViewController.h
//  BSY0720
//
//  Created by jway on 15-7-26.
//  Copyright (c) 2015年 jway. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZCTradeView.h"
@interface xuefeiBDetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,ZCTradeViewDelegate>

//详情表
@property (weak, nonatomic) IBOutlet UITableView *detailList;
//立即投资按钮
@property (weak, nonatomic) IBOutlet UIButton *invest;
- (IBAction)invest:(id)sender;
//定义一个标志，用来判断是几年期限的
@property(nonatomic,strong) NSNumber * flag;

//定义一个字典，用来存放上一个页面返回的数据
@property (nonatomic,strong) NSDictionary * transDic;

@end
