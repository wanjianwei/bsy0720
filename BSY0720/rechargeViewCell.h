//
//  rechargeViewCell.h
//  BSY0720
//
//  Created by jway on 15-7-27.
//  Copyright (c) 2015年 jway. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface rechargeViewCell : UITableViewCell
//金额
@property (weak, nonatomic) IBOutlet UILabel *moneyNum;
//时间
@property (weak, nonatomic) IBOutlet UILabel *time;
//交易商户号
@property (weak, nonatomic) IBOutlet UILabel *orderNum;

@end
