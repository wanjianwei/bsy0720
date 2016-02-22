//
//  noticeViewCell.h
//  BSY0720
//
//  Created by jway on 15-7-26.
//  Copyright (c) 2015年 jway. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface noticeViewCell : UITableViewCell
//消息图标
@property (weak, nonatomic) IBOutlet UIImageView *noticeImg;
//消息种类
@property (weak, nonatomic) IBOutlet UILabel *noticeSort;
//消息时间
@property (weak, nonatomic) IBOutlet UILabel *time;
//消息内容
@property (weak, nonatomic) IBOutlet UILabel *content;

@end
