//
//  illustrateViewController.m
//  BSY0720
//
//  Created by jway on 15-7-27.
//  Copyright (c) 2015年 jway. All rights reserved.
//

#import "illustrateViewController.h"

@interface illustrateViewController (){
    //存放说明内容
    NSString * content;
}

@end

@implementation illustrateViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"说明";
    if ([self.flag intValue] ==1) {
        //助学宝
        content = [NSString stringWithFormat:@"助学宝是专门针对学生日常生活服务的一项金融创新，按月计息，购买期限为12个月-36个月，对应的月收益率为6%%~8%%。助学宝收益可用于学生每月生活支出，到期后一次取本也可复存转存。助学宝一方面通过高于银行同期利率的收益减轻家庭助学负担，同时实现按月定时提取，逐月计划支出，有利于培养学生生活自我管理力，省去家长每月定期向学生支付生活费的负担，也让家长不在担心一次性给太多生活费导致学生乱花钱所带来的烦恼。因此，助学宝不仅让学生生活无忧，也让家长省心、放心、安心！是学生大学生活的好助手"];
    }else{
        //学费宝
        content = [NSString stringWithFormat:@"学费宝是专门针对学生日常生活服务的一项金融创新，按年计息，购买期限为1年-3年，对应的年收益率为6%%~8%%。学费宝收益可用于学生每月生活支出，到期后一次取本也可复存转存。学费宝一方面通过高于银行同期利率的收益减轻家庭助学负担，同时实现按月定时提取，逐月计划支出，有利于培养学生生活自我管理力，省去家长每月定期向学生支付生活费的负担，也让家长不在担心一次性给太多生活费导致学生乱花钱所带来的烦恼。因此，学费宝不仅让学生生活无忧，也让家长省心、放心、安心！是学生大学生活的好助手"];
    }
    
    //自定义label,并动态获取label高度
    CGRect rect = [content boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width-32, 500) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15]} context:nil];
    UILabel * lab = [[UILabel alloc] initWithFrame:CGRectMake(16, 115, [UIScreen mainScreen].bounds.size.width-32, rect.size.height)];
    lab.text = content;
    lab.numberOfLines = 0;
    lab.font = [UIFont boldSystemFontOfSize:15];
    lab.textColor = [UIColor grayColor];
    [self.view addSubview:lab];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
