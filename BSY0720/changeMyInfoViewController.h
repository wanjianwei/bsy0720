//
//  changeMyInfoViewController.h
//  BSY0720
//
//  Created by jway on 15-8-3.
//  Copyright (c) 2015年 jway. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface changeMyInfoViewController : UIViewController
//将要修改的信息
@property (weak, nonatomic) IBOutlet UITextField *toChangeInfo;
//保存
- (IBAction)save:(id)sender;
//定义一个标志，用来判断需要修改的是什么
//flag = 1 为昵称修改，flag = 2 为院系修改
@property (nonatomic,strong) NSNumber * flag;
@end
