//
//  subjectViewController.h
//  BSY0720
//
//  Created by jway on 15-7-24.
//  Copyright (c) 2015年 jway. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface subjectViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>


//话题及评论列表
@property (weak, nonatomic) IBOutlet UITableView *subjectList;
//定义一个数组用来存放评论
@property(nonatomic,strong)NSMutableArray * commentArray;
//定义一个字典存放话题
@property(nonatomic,strong)NSDictionary * subjectDic;
@end
