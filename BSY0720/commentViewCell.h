//
//  commentViewCell.h
//  BSY0720
//
//  Created by jway on 15-7-24.
//  Copyright (c) 2015年 jway. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface commentViewCell : UITableViewCell

//用户头像
@property (weak, nonatomic) IBOutlet UIImageView *userPortrait;
//用户名
@property (weak, nonatomic) IBOutlet UILabel *username;
//时间
@property (weak, nonatomic) IBOutlet UILabel *time;
//评论楼层
@property (weak, nonatomic) IBOutlet UILabel *floorNum;
//评论内容
@property (weak, nonatomic) IBOutlet UILabel *content;

@end
