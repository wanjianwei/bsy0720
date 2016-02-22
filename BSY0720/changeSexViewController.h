//
//  changeSexViewController.h
//  BSY0720
//
//  Created by jway on 15-8-3.
//  Copyright (c) 2015年 jway. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface changeSexViewController : UIViewController
//性别
@property (weak, nonatomic) IBOutlet UILabel *sex;
//选择性别
- (IBAction)choseSex:(id)sender;
//保存
- (IBAction)save:(id)sender;
@end
