//
//  financeVIewCell.h
//  BSY0720
//
//  Created by jway on 15-7-24.
//  Copyright (c) 2015年 jway. All rights reserved.
//

//定义一个协议
@protocol financeProtocol

-(void)transferTag:(int)tag;

@end


#import <UIKit/UIKit.h>
@interface financeVIewCell : UITableViewCell
//理财产品名称
@property (weak, nonatomic) IBOutlet UILabel *sortName;
//年化收益率
@property (weak, nonatomic) IBOutlet UILabel *incomeRatio;
//起投金额
@property (weak, nonatomic) IBOutlet UILabel *beginNum;
//立即投资
- (IBAction)investment:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *investment;
//背景图
@property (weak, nonatomic) IBOutlet UIView *bgView;

//定义一个协议代理
@property(nonatomic,weak)id<financeProtocol>delegate;
@end
