//
//  schoolNewsTableCell.h
//  BSY0720
//
//  Created by jway on 15-7-27.
//  Copyright (c) 2015年 jway. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface schoolNewsTableCell : UITableViewCell

//新闻图片
@property (weak, nonatomic) IBOutlet UIImageView *newsImage;
//新闻标题
@property (weak, nonatomic) IBOutlet UILabel *newsTitle;
//简介
@property (weak, nonatomic) IBOutlet UILabel *shortDetail;
@end
