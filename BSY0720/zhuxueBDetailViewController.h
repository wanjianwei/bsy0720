//
//  zhuxueBDetailViewController.h
//  BSY0720
//
//  Created by jway on 15-7-26.
//  Copyright (c) 2015年 jway. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZCTradeView.h"
@interface zhuxueBDetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,ZCTradeViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *detailList;
//定义一个标志，用来判断是几个月的助学宝
@property(nonatomic,strong) NSNumber * flag;
//定义一个字典类型用来存储理财产品信息
@property (nonatomic,strong) NSDictionary * transDic;
@end
