//
//  subjectViewController.m
//  BSY0720
//
//  Created by jway on 15-7-24.
//  Copyright (c) 2015年 jway. All rights reserved.
//

#import "subjectViewController.h"
#import "SDRefresh.h"
#import "AppDelegate.h"
#import "commentViewCell.h"
@interface subjectViewController ()
//上拉刷新与下拉加载
@property (nonatomic, weak) SDRefreshFooterView *refreshFooter;
@property (nonatomic, weak) SDRefreshHeaderView *refreshHeader;
@end

@implementation subjectViewController

//自定义输入框
UIView * inputView;
//定义一个协议委托代理类
AppDelegate * app;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    // 初始化
    self.subjectList.dataSource = self;
    self.subjectList.delegate = self;
    //不显示上下滚动栏
    self.subjectList.showsVerticalScrollIndicator = NO;
   // self.subjectList.backgroundColor = [UIColor clearColor];
    //代码构建文字输入框
    inputView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-50, [UIScreen mainScreen].bounds.size.width, 50)];
    inputView.backgroundColor = [UIColor colorWithRed:233/255 green:236/266 blue:236/233 alpha:0.1];
    //添加“发送”按钮
    UIButton * sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(inputView.frame)-60, 10, 50, 30)];
    sendBtn.layer.cornerRadius = 4.0f;
    sendBtn.backgroundColor = [UIColor redColor];
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [sendBtn addTarget:self action:@selector(sendComment) forControlEvents:UIControlEventTouchUpInside];
    [inputView addSubview:sendBtn];
    
    //添加输入框
    UITextField * inputField = [[UITextField alloc] initWithFrame:CGRectMake(20, 10, [UIScreen mainScreen].bounds.size.width-90, 30)];
    inputField.backgroundColor = [UIColor whiteColor];
    inputField.borderStyle = UITextBorderStyleRoundedRect;
    inputField.delegate =self;
    [inputView addSubview:inputField];
    //添加入view
    [self.view addSubview:inputView];
   
    //实例化程序委托类
    app = [UIApplication sharedApplication].delegate;
    /*
     //获取服务器数据
     [app.manager POST:@"" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
         //
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         //
     }];
     */
    
    //构造虚拟数据
    self.subjectDic = [NSDictionary dictionaryWithObjectsAndKeys:@"万建伟",@"username",@"portrait.png",@"userPortrait",@"一小时前",@"time",@"在瑞环山",@"title",@"main_ad.png",@"bgView",@"我说的如果阿道夫两个人的时候两个人噶尔得换个色老头格式化速度和格式的分公司和收到公司的分公司",@"content",@"23",@"praiseNum",@"12",@"id", nil];
    self.commentArray = [[NSMutableArray alloc] initWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"wanjianwei",@"username",@"portrait.png",@"userPortrait",@"2015-12-23",@"time",@"我说的如果阿道夫两个人的时候两个人噶尔得换个色老十多个人虽然还挺好聊天哈萨尔速度和规划",@"content", nil],nil];
    
    //设置上拉刷新与下拉加载
    [self setupHeader];
    [self setupFooter];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    //添加输入框视图，注册通知
    /* 在此处添加inputView是为了保证，inputView是最后添加的视图，不会在移动当中被其他视图遮挡
     */
    [self.view insertSubview:inputView aboveSubview:self.subjectList];
    //注册键盘出现与隐藏通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

//下拉刷新
- (void)setupHeader
{
    SDRefreshHeaderView *refreshHeader = [SDRefreshHeaderView refreshView];
    
    // 默认是在navigationController环境下，如果不是在此环境下，请设置 refreshHeader.isEffectedByNavigationController = NO;
    [refreshHeader addToScrollView:self.subjectList];
    refreshHeader.isEffectedByNavigationController = NO;
    __weak SDRefreshHeaderView *weakRefreshHeader = refreshHeader;
    refreshHeader.beginRefreshingOperation = ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            for (int i =0; i<5; i++) {
                [self.commentArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"wjw",@"username",@"portrait.png",@"userPortrait",@"2014-12-23",@"time",@"我说的如果阿道夫两个人的时候两个人噶尔得换个色老",@"content", nil]];
            }
            
            //构造虚拟数据
            self.subjectDic = [NSDictionary dictionaryWithObjectsAndKeys:@"万建伟",@"username",@"portrait.png",@"userPortrait",@"2014-12-23",@"time",@"在瑞环山",@"title",@"main_ad.png",@"bgView",@"我说的如果阿道adegadfgasdfgaerfg夫两个人的时候两个人噶尔得换个色老头格式化速sdfrgsdfhgsdfsdfghszdfgth度和格式的分公司和收到公司的分公司",@"content", nil];
            [self.subjectList reloadData];
            [weakRefreshHeader endRefreshing];
        });
    };
    
    // 进入页面自动加载一次数据
    [refreshHeader beginRefreshing];
}

//上拉加载
- (void)setupFooter
{
    SDRefreshFooterView *refreshFooter = [SDRefreshFooterView refreshView];
    [refreshFooter addToScrollView:self.subjectList];
    [refreshFooter addTarget:self refreshAction:@selector(footerRefresh)];
    _refreshFooter = refreshFooter;
}

//再次向服务器请求数据，并重新加载
-(void)footerRefresh{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.commentArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"wjw",@"username",@"portrait.png",@"userPortrait",@"2014-12-23",@"time",@"我说的如果阿道夫两个人的时候两个人噶尔得换个色老",@"content", nil]];
        [self.subjectList reloadData];
        [self.refreshFooter endRefreshing];
    });
}

//点赞操作
-(void)praise{
    
}

//发表评论
-(void)sendComment{
    
}

//键盘出现,输入框提升
-(void)keyboardWillShow:(NSNotification*)note{
    
    NSDictionary *info = [note userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//键盘的frame
    
    [UIView animateWithDuration:0.5 animations:^{
        //
        CGRect frame = inputView.frame;
        frame.origin.y -=keyboardSize.height;
        inputView.frame = frame;
    }];
}

//键盘消失，输入框回到原来位置
-(void)keyboardWillHide:(NSNotification*)note{
    [UIView animateWithDuration:0.5 animations:^{
        CGRect frame = inputView.frame;
        frame.origin.y = [UIScreen mainScreen].bounds.size.height-50;
        inputView.frame = frame;
    }];
}

#pragma UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


#pragma dataSource/delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        return self.commentArray.count;
    }
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==0) {
        //自定义一个单元格
        UITableViewCell * cell = [[UITableViewCell alloc] init];
        //头像
        UIImageView * view1 = [[UIImageView alloc] initWithFrame:CGRectMake(20, 5, 50, 50)];
        view1.image = [UIImage imageNamed:[self.subjectDic objectForKey:@"userPortrait"]];
        view1.layer.cornerRadius = 25;
        view1.layer.masksToBounds = YES;
        [cell addSubview:view1];
        //用户名
        UILabel * username = [[UILabel alloc] initWithFrame:CGRectMake(75, 10, 100, 20)];
        username.textAlignment = NSTextAlignmentLeft;
        username.font = [UIFont boldSystemFontOfSize:12];
        username.textColor = [UIColor grayColor];
        username.text = [self.subjectDic objectForKey:@"username"];
        [cell addSubview:username];
        //时间
        UILabel *time = [[UILabel alloc] initWithFrame:CGRectMake(220, 5, [UIScreen mainScreen].bounds.size.width-40-200, 20)];
        time.textAlignment = NSTextAlignmentRight;
        time.textColor = [UIColor grayColor];
        time.text = [self.subjectDic objectForKey:@"time"];
        time.font = [UIFont boldSystemFontOfSize:12];
        [cell addSubview:time];
        //标题
        UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(20, 30, [UIScreen mainScreen].bounds.size.width-40, 30)];
        title.textAlignment = NSTextAlignmentCenter;
        title.font = [UIFont boldSystemFontOfSize:17];
        title.text = [self.subjectDic objectForKey:@"title"];
        [cell addSubview:title];
        //添加图片
        UIImageView * bgView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 60, [UIScreen mainScreen].bounds.size.width-40, 80)];
        bgView.image = [UIImage imageNamed:[self.subjectDic objectForKey:@"bgView"]];
        [cell addSubview:bgView];
        
        //添加label
        //计算高度
        NSString * content = [self.subjectDic objectForKey:@"content"];
        CGRect rect = [content boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width-40, 500) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15]} context:nil];
        
        UILabel * content1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 140, [UIScreen mainScreen].bounds.size.width-40,rect.size.height)];
        //自适应行数,及字体大小要与适应时一致
        content1.numberOfLines = 0;
        content1.font = [UIFont boldSystemFontOfSize:15];
        content1.textAlignment = NSTextAlignmentLeft;
        content1.text = [self.subjectDic objectForKey:@"content"];
        [cell addSubview:content1];
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }else{
        commentViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commentCell"];
        NSDictionary * dic = [self.commentArray objectAtIndex:indexPath.row];
        cell.userPortrait.image = [UIImage imageNamed:[dic objectForKey:@"userPortrait"]];
        cell.userPortrait.layer.cornerRadius = 25;
        cell.userPortrait.layer.masksToBounds = YES;
        cell.username.text = [dic objectForKey:@"username"];
        cell.time.text = [dic objectForKey:@"time"];
        cell.floorNum.text = [NSString stringWithFormat:@"%iF",(int)indexPath.row+1];
        cell.content.text = [dic objectForKey:@"content"];
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }
}

//返回单元格的高度(动态变化)
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==0) {
        //计算高度
        NSString * content = [self.subjectDic objectForKey:@"content"];
        CGRect rect = [content boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width-40, 500) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15]} context:nil];
        CGFloat height = rect.size.height+60+80;
        //返回单元格的高度,60为标题高度，80为图片高度
        return height;
        
    }else{
        NSString * content = [[self.commentArray objectAtIndex:indexPath.row] objectForKey:@"content"];
        CGRect rect = [content boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width-98, 500) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15]} context:nil];
        CGFloat height = rect.size.height-44;
        //返回单元格的高度
        return height+100;
    }
}

//单元格的距离
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section ==0) {
        return 30;
    }else{
        return 0;
    }
}


//footer
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 0) {
        UIView * view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40)];
        //添加......................
        UILabel*lab_1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, [UIScreen mainScreen].bounds.size.width-40, 5)];
        lab_1.text = @"......................................................................................................................................................................................................................................................";
        lab_1.textColor = [UIColor blackColor];
        lab_1.font = [UIFont boldSystemFontOfSize:6];
        [view1 addSubview:lab_1];
        //增加点赞数显示
        UIButton * praise = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-40-75, 10, 20, 20)];
        [praise setBackgroundImage:[UIImage imageNamed:@"praise-2.png"] forState:UIControlStateNormal];
        //添加事件响应
        [praise addTarget:self action:@selector(praise) forControlEvents:UIControlEventTouchUpInside];
        [view1 addSubview:praise];
        
        //添加点赞数label
        UILabel * praiseNum = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-40-50, 10, 50, 20)];
        praiseNum.font = [UIFont boldSystemFontOfSize:12];
        praiseNum.textAlignment = NSTextAlignmentCenter;
        praiseNum.text = [self.subjectDic objectForKey:@"praiseNum"];
        [view1 addSubview:praiseNum];
        
        //“全部评论”
        UILabel * lab = [[UILabel alloc] initWithFrame:CGRectMake(20, 30, 50, 10)];
        lab.font = [UIFont boldSystemFontOfSize:10];
        lab.textAlignment = NSTextAlignmentLeft;
        lab.text = @"全部评论";
        //添加label“...........................”
        UILabel * lab_2 = [[UILabel alloc] initWithFrame:CGRectMake(70, 30, [UIScreen mainScreen].bounds.size.width-40-50, 10)];
        lab_2.text = @".....................................................................................................................................................................................";
        lab_2.font = [UIFont boldSystemFontOfSize:6];
        [view1 addSubview:lab_2];
        [view1 addSubview:lab];
        return view1;
    }else{
        return nil;
    }
}


@end
