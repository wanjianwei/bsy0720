//
//  billViewCell.h
//  BSY0720
//
//  Created by jway on 15-7-27.
//  Copyright (c) 2015年 jway. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface billViewCell : UITableViewCell
//收入或支出
@property (weak, nonatomic) IBOutlet UILabel *sort;
//金额数
@property (weak, nonatomic) IBOutlet UILabel *moneyNum;
//时间
@property (weak, nonatomic) IBOutlet UILabel *time;

@end
