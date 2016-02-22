//
//  aboutUsViewController.h
//  BSY0720
//
//  Created by jway on 15-7-28.
//  Copyright (c) 2015年 jway. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface aboutUsViewController : UIViewController
//背景视图
@property (weak, nonatomic) IBOutlet UIView *bgView;
//网址
@property (weak, nonatomic) IBOutlet UILabel *website;
//联系电话
@property (weak, nonatomic) IBOutlet UILabel *telphone;

@end
