//
//  changeAddressViewController.h
//  BSY0720
//
//  Created by jway on 15-8-3.
//  Copyright (c) 2015年 jway. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface changeAddressViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
//输入列表
@property (weak, nonatomic) IBOutlet UITableView *inputList;
//保存操作
- (IBAction)save:(id)sender;
@end
