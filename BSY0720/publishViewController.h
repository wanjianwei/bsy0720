//
//  publishViewController.h
//  BSY0720
//
//  Created by jway on 15-8-2.
//  Copyright (c) 2015年 jway. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface publishViewController : UIViewController<UITextViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate>

//话题
@property (weak, nonatomic) IBOutlet UITextField *subject;
//内容
@property (weak, nonatomic) IBOutlet UITextView *content;
//图片
@property (weak, nonatomic) IBOutlet UIScrollView *images;
//话题类型
@property (weak, nonatomic) IBOutlet UILabel *subjectSorts;
//辅助实现功能的lab
@property (weak, nonatomic) IBOutlet UILabel *axuLab;
//选择话题
- (IBAction)chooseSubject:(id)sender;
//确认发布
- (IBAction)confirm:(id)sender;

//定义一个标志，用来判断是从什么界面进入发布界面
//flag = 1 为约吧，flag = 2 为跳蚤市场，flag = 3 为精彩活动，flag = 4为发现
@property (nonatomic,strong) NSNumber * flag;
@end
