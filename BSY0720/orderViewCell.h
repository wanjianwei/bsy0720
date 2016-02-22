//
//  orderViewCell.h
//  BSY0720
//
//  Created by jway on 15-7-27.
//  Copyright (c) 2015年 jway. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface orderViewCell : UITableViewCell
//商品图片
@property (weak, nonatomic) IBOutlet UIImageView *goodImg;
//商品名称
@property (weak, nonatomic) IBOutlet UILabel *goodName;
//下单时间
@property (weak, nonatomic) IBOutlet UILabel *placeOrderTime;
//发货时间
@property (weak, nonatomic) IBOutlet UILabel *deliveryTime;
//收货地址
@property (weak, nonatomic) IBOutlet UILabel *address;
//发货地址
@property (weak, nonatomic) IBOutlet UILabel *deliveryAddress;
//金额总数
@property (weak, nonatomic) IBOutlet UILabel *moneyNum;
@end
