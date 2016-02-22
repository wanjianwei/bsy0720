//
//  shopBasketTableViewCell.h
//  BSY0720
//
//  Created by jway on 15-8-4.
//  Copyright (c) 2015年 jway. All rights reserved.
//



#import <UIKit/UIKit.h>
#import "UICustomLineLabel.h"

//定义一个协议
@protocol shopBasketProtocol
//购物车中删除商品
-(void)deleteGood:(NSDictionary *)dic;
//购物车中增加商品
-(void)addGood:(NSDictionary *)dic;
@end

@interface shopBasketTableViewCell : UITableViewCell<shopBasketProtocol>
//商品名称
@property (weak, nonatomic) IBOutlet UILabel *goodName;
//商品图片
@property (weak, nonatomic) IBOutlet UIImageView *goodImg;
//商品价格
@property (weak, nonatomic) IBOutlet UILabel *price;
//商品原价
@property (weak, nonatomic) IBOutlet UICustomLineLabel *originalPrice;
//已销售数量
@property (weak, nonatomic) IBOutlet UILabel *hasSold;
//已购买数量
@property (weak, nonatomic) IBOutlet UILabel *hasBuy;
//减少商品数量
@property (weak, nonatomic) IBOutlet UIButton *delete1;
//增加商品数量
@property (weak, nonatomic) IBOutlet UIButton *add;

//定义一个委托代理
@property (weak,nonatomic) id<shopBasketProtocol>delegate;

//增减商品数
- (IBAction)delete1:(id)sender;
- (IBAction)add:(id)sender;

@end
