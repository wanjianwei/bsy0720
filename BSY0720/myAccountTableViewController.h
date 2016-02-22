//
//  myAccountTableViewController.h
//  BSY0720
//
//  Created by jway on 15-7-31.
//  Copyright (c) 2015年 jway. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface myAccountTableViewController : UITableViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
//定义一个字典，用于接收服务器返回数据
@property (nonatomic,strong) NSDictionary * returnDic;
@end
