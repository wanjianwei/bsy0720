//
//  financeVIewCell.m
//  BSY0720
//
//  Created by jway on 15-7-24.
//  Copyright (c) 2015年 jway. All rights reserved.
//

#import "financeVIewCell.h"
#import "zhuxueBDetailViewController.h"
#import "xuefeiBDetailViewController.h"
@implementation financeVIewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)investment:(id)sender {
    //根据investment的tag来区分下一个界面所呈现的内容,委托模式
    UIButton * btn = (UIButton*)sender;
    [self.delegate transferTag:(int)btn.tag];
}
@end
