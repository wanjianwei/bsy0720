//
//  shopBasketTableViewCell.m
//  BSY0720
//
//  Created by jway on 15-8-4.
//  Copyright (c) 2015年 jway. All rights reserved.
//

#import "shopBasketTableViewCell.h"

@implementation shopBasketTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//减少商品数
- (IBAction)delete1:(id)sender {
    //先取出商品的id，也就是button的tag
    UIButton * btn = (UIButton *)sender;
    //当购买数大于0时，购买数减一
    if ([self.hasBuy.text intValue]>0) {
        self.hasBuy.text = [NSString stringWithFormat:@"%i",[self.hasBuy.text intValue]-1];
        //先去除￥符号
        NSString * goodPrice = [self.price.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"￥"]];
        NSString * originalPrice = [self.originalPrice.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"￥"]];
        //构造字典类型数据
        NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:goodPrice,@"goodPrice",originalPrice,@"originalPrice",[NSString stringWithFormat:@"%li",(long)btn.tag],@"id",self.hasSold.text,@"hasSold",self.goodName.text,@"goodName", nil];
        //同样应该采用协议的方法将数据传送出去
        [self.delegate deleteGood:dic];
    }}

//增加商品数
- (IBAction)add:(id)sender {
    //先取出商品的id，也就是button的tag
    UIButton * btn = (UIButton *)sender;
    //购买数+1
    self.hasBuy.text = [NSString stringWithFormat:@"%i",[self.hasBuy.text intValue]+1];
    //先去除￥符号
    NSString * goodPrice = [self.price.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"￥"]];
    NSString * originalPrice = [self.originalPrice.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"￥"]];
    //此处要将所选商品的信息传递出去（用协议的方法）
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:goodPrice,@"goodPrice",originalPrice,@"originalPrice",[NSString stringWithFormat:@"%li",(long)btn.tag],@"id",self.hasSold.text,@"hasSold",self.goodName.text,@"goodName", nil];
    [self.delegate addGood:dic];
}

@end
