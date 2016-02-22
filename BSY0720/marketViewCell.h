//
//  marketViewCell.h
//  BSY0720
//
//  Created by jway on 15-7-24.
//  Copyright (c) 2015年 jway. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface marketViewCell : UITableViewCell
//用户头像
@property (weak, nonatomic) IBOutlet UIImageView *userPortrait;
//用户名称
@property (weak, nonatomic) IBOutlet UILabel *username;
//发布时间
@property (weak, nonatomic) IBOutlet UILabel *time;
//商品名称
@property (weak, nonatomic) IBOutlet UILabel *goodName;
//新旧程度
@property (weak, nonatomic) IBOutlet UILabel *isNew;
//需求
@property (weak, nonatomic) IBOutlet UILabel *needs;
//详细说明
@property (weak, nonatomic) IBOutlet UILabel *detail;
//商品图片
@property (weak, nonatomic) IBOutlet UIScrollView *goodImgs;
//点赞数
@property (weak, nonatomic) IBOutlet UILabel *praiseNum;
//评论数
@property (weak, nonatomic) IBOutlet UILabel *commentNum;

//点赞及评论
- (IBAction)praise:(id)sender;
- (IBAction)comment:(id)sender;

@end
