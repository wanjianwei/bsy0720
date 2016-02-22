//
//  goodTableCell.h
//  BSY0720
//
//  Created by jway on 15-7-22.
//  Copyright (c) 2015年 jway. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UICustomLineLabel.h"
//定义一个协议
@protocol mallProtocol <NSObject>
//当从购物栏中删除商品信息
-(void)deleteGoodInfo:(NSDictionary*)dic;
//但向购物栏中添加商品信息时
-(void)addGoodInfo:(NSDictionary*)dic;
@end


@interface goodTableCell : UITableViewCell
//商品名称
@property (weak, nonatomic) IBOutlet UILabel *goodName;
//商品图片
@property (weak, nonatomic) IBOutlet UIImageView *goodImg;
//商品价格
@property (weak, nonatomic) IBOutlet UILabel *goodPrice;
//商品原价
@property (weak, nonatomic) IBOutlet UICustomLineLabel *originalPrice;
//商品销量
@property (weak, nonatomic) IBOutlet UILabel *hasSold;
//购买数量
@property (weak, nonatomic) IBOutlet UILabel *num;
//减少
- (IBAction)delete1:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *delete1;

//增加
- (IBAction)add:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *add;

//定义一个协议引用代理
@property(nonatomic,weak) id<mallProtocol>delegate;

@end
