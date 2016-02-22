//
//  notDetailViewController.h
//  BSY0720
//
//  Created by jway on 15-7-27.
//  Copyright (c) 2015年 jway. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface notDetailViewController : UIViewController

//消息标题
@property (weak, nonatomic) IBOutlet UILabel *noticeTitle;
//发表时间
@property (weak, nonatomic) IBOutlet UILabel *time;
//消息内容
@property (weak, nonatomic) IBOutlet UIScrollView *content;
//定义一个变量，用来存放新闻id，已用于查询
@property (nonatomic,strong) NSNumber * newsId;
//接受服务器返回数据
@property (nonatomic,strong) NSDictionary * returnDic;
@end
