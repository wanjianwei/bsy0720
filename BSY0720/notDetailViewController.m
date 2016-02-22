//
//  notDetailViewController.m
//  BSY0720
//
//  Created by jway on 15-7-27.
//  Copyright (c) 2015年 jway. All rights reserved.
//

#import "notDetailViewController.h"
#import "AppDelegate.h"
@interface notDetailViewController (){
    //应用程序协议委托类
    AppDelegate * app;
}

@end

@implementation notDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*
    //初始化
    app = [UIApplication sharedApplication].delegate;
    //请求数据
    [app.manager POST:@"" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //
    }];
     */
    //构造虚拟数据
    //self.returnDic = [NSDictionary dictionaryWithObjectsAndKeys:@"我的手机",@"noticeTitle",@"新华社",@"source",@"2014-01-01",@"time",@"main_ad.png",@"img",@"    速度发了我阿嘎说过了两个的火锅是的哈格拉而过地方干啥都很合适的韩国啦发给他发的时候海上皇宫阿道夫格式的头发二分公司论坛大会公司的合法的非官方阿发给老师的风格哈都发给老师的回来哈尔和阿法拉伐格式好了噶尔问题阿格拉地方噶而后啊哈格拉的时候了发射厉害吧阿道夫盖拉多萨鲁法尔打算好了哈地方立法和任何阿萨德了更好的立法的两个哈阿斯顿发给老师的方法的两个号阿斯顿更好撒地方格式地老天荒阿尔德国哈额地方噶尔哈阿尔的供货商地方噶人工费阿瓦尔哈嘎到时候噶为额无聊噶是的噶设立的噶为\n阿什利gate聊过天阿尔噶尔尕尔尕尔尕尔哈尔而设立噶尔发芽舍利弗",@"content", nil];
    
    
    //接收数据
    self.returnDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"News"];
    self.noticeTitle.text = [self.returnDic objectForKey:@"title"];
    //新闻时间
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:[[self.returnDic objectForKey:@"time"] intValue]];
    self.time.text = [NSString stringWithFormat:@"管理员(id:%@)  %@",[self.returnDic objectForKey:@"admin_id"],[formatter stringFromDate:date]];
    
    //自定义内容视图
    UIImageView * noticeImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width-32, 110)];
    //noticeImg.image = [UIImage imageNamed:[self.returnDic objectForKey:@"img"]];
    noticeImg.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[self.returnDic objectForKey:@"picture"]]]]];
    [self.content addSubview:noticeImg];
    
    //获取label的动态高度
    CGRect rest = [[self.returnDic objectForKey:@"content"] boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.content.frame), 1000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15]} context:nil];
    
    //定义滚动视图的contentsize
    self.content.contentSize = CGSizeMake(CGRectGetWidth(self.content.frame), 110+20+rest.size.height);
    //定义lable
    UILabel * lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 130, [UIScreen mainScreen].bounds.size.width-32, rest.size.height)];
    lab.text = [self.returnDic objectForKey:@"content"];
    lab.font = [UIFont boldSystemFontOfSize:15];
    lab.numberOfLines = 0;
    //竖直滑动栏取消显示
    self.content.showsVerticalScrollIndicator = NO;
    [self.content addSubview:lab];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
