//
//  goodTableCell.m
//  BSY0720
//
//  Created by jway on 15-7-22.
//  Copyright (c) 2015年 jway. All rights reserved.
//

#import "goodTableCell.h"

@implementation goodTableCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//增加购买数
- (IBAction)add:(id)sender {
    //先取出商品的id，也就是button的tag
    UIButton * btn = (UIButton *)sender;
    //购买数+1
    self.num.text = [NSString stringWithFormat:@"%i",[self.num.text intValue]+1];
    //先去除￥符号
    NSString * goodPrice = [self.goodPrice.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"￥"]];
    NSString * originalPrice = [self.originalPrice.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"￥"]];
    //此处要将所选商品的信息传递出去（用协议的方法）
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:goodPrice,@"goodPrice",originalPrice,@"originalPrice",[NSString stringWithFormat:@"%li",(long)btn.tag],@"id",self.hasSold.text,@"hasSold",self.goodName.text,@"goodName", nil];
    [self.delegate addGoodInfo:dic];
    
}
- (IBAction)delete1:(id)sender {
    //先取出商品的id，也就是button的tag
    UIButton * btn = (UIButton *)sender;
    //当购买数大于0时，购买数减一
    if ([self.num.text intValue]>0) {
        self.num.text = [NSString stringWithFormat:@"%i",[self.num.text intValue]-1];
        //先去除￥符号
        NSString * goodPrice = [self.goodPrice.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"￥"]];
        NSString * originalPrice = [self.originalPrice.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"￥"]];
       //构造字典类型数据
       NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:goodPrice,@"goodPrice",originalPrice,@"originalPrice",[NSString stringWithFormat:@"%li",(long)btn.tag],@"id",self.hasSold.text,@"hasSold",self.goodName.text,@"goodName", nil];
        //同样应该采用协议的方法将数据传送出去
        [self.delegate deleteGoodInfo:dic];
    }
   
}
@end
