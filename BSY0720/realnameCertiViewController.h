//
//  realnameCertiViewController.h
//  BSY0720
//
//  Created by jway on 15-7-28.
//  Copyright (c) 2015年 jway. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface realnameCertiViewController : UIViewController
//学号
@property (weak, nonatomic) IBOutlet UITextField *studentNum;
//身份证号
@property (weak, nonatomic) IBOutlet UITextField *certiNum;
//确定按钮
- (IBAction)confirm:(id)sender;
@end
