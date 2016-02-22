//
//  findTableCell.m
//  BSY0720
//
//  Created by jway on 15-7-23.
//  Copyright (c) 2015年 jway. All rights reserved.
//

#import "findTableCell.h"

@implementation findTableCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)praise:(id)sender {
    //点赞操作
    UIButton*btn = (UIButton*)sender;
    NSLog(@"%li",(long)btn.tag);
}

- (IBAction)comment:(id)sender {
    //跳转到评论页面
}
@end
