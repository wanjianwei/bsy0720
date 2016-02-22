//
//  toCashViewController.h
//  BSY0720
//
//  Created by jway on 15-7-28.
//  Copyright (c) 2015年 jway. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface toCashViewController : UIViewController
//可提金额
@property (weak, nonatomic) IBOutlet UILabel *restMoney;
//提现金额
@property (weak, nonatomic) IBOutlet UITextField *moneyNum;
//银行卡号
@property (weak, nonatomic) IBOutlet UITextField *bankNum;
//立即提取
- (IBAction)cashNow:(id)sender;
@end
