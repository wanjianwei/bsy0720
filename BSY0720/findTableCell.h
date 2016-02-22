//
//  findTableCell.h
//  BSY0720
//
//  Created by jway on 15-7-23.
//  Copyright (c) 2015年 jway. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface findTableCell : UITableViewCell
//用户头像
@property (weak, nonatomic) IBOutlet UIImageView *portrait;
//发布时间
@property (weak, nonatomic) IBOutlet UILabel *time;
//用户名
@property (weak, nonatomic) IBOutlet UILabel *username;
//动态内容
@property (weak, nonatomic) IBOutlet UILabel *content;
//动态图片
@property (weak, nonatomic) IBOutlet UIImageView *image;
//点赞数
@property (weak, nonatomic) IBOutlet UILabel *praiseNum;
//评论数
@property (weak, nonatomic) IBOutlet UILabel *commentNum;
//点赞
@property (weak, nonatomic) IBOutlet UIButton *praise;

- (IBAction)praise:(id)sender;
//评论
@property (weak, nonatomic) IBOutlet UIButton *comment;

- (IBAction)comment:(id)sender;

@end
