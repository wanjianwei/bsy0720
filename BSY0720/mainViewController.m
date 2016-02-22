//
//  mainViewController.m
//  BSY0720
//
//  Created by jway on 15-7-21.
//  Copyright (c) 2015年 jway. All rights reserved.
//

#import "mainViewController.h"
#import "AppDelegate.h"
#import "noticeTableViewController.h"
#import "schoolNewsTableViewController.h"
#import "notDetailViewController.h"
#import "financeViewController.h"
#import "yueBaTableViewController.h"
#import "marketTableViewController.h"
#import "myAccountTableViewController.h"
#import "TFIndicatorView.h"
#import "busInqueryViewController.h"
#import "expressInqueryViewController.h"
#define a  ([UIScreen mainScreen].bounds.size.height - 108)
#define b  [UIScreen mainScreen].bounds.size.width

@interface mainViewController (){
    //初始化应用程序代理
    AppDelegate *app;
    //定义一个数组
    NSArray *picArray;
    NSArray *funArray;
    //定义一个故事版引用
    UIStoryboard * main;
    //定义一个字典用来存储服务器返回数据
    NSDictionary * returnDic;
    //滚动图片地址数组
    NSArray * adURL;
    //定义一个定时器
    NSTimer * timer1;
    //定义活动指示器
    TFIndicatorView * indicator;
    //新闻标题
    UILabel*newTitle;
    //新闻时间
    UILabel*newTime;
    //新闻图片
    UIImageView*newImg;
    //添加公告
    UILabel*lab_noti;
}



@end

@implementation mainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //视图背景颜色
    self.view.backgroundColor = [UIColor whiteColor];
   //设置导航栏
    self.title = @"币生园";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"notice.png"] style:UIBarButtonItemStyleDone target:self action:@selector(checkNotices)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor grayColor];
    // 构造循环广告滚动图，
    /*
     当UIVIewController被push或initWithRootController成为UINavigationController控制器的controller时，这个UIViewController的view的字视图的所有子视图都会下移64px。
     解决方法：
     1、self.automaticallyAdjustsScrollViewInsets = NO;
     2、不要让UIScrollView成为一级子视图
     */
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.adView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,64,b,a/3-30)];
    self.adView.bounces = YES;
    self.adView.showsHorizontalScrollIndicator = NO;
    self.adView.showsVerticalScrollIndicator = NO;
    //是否整页翻动
    self.adView.pagingEnabled = YES;
    self.adView.delegate = self;
    //设置滚动视图的contentSize
    [self.adView setContentSize:CGSizeMake(b*7, a/3-30)]; //  +上第1页和第5页  原理：5-[1-2-3-4-5]-1
    [self.view addSubview:self.adView];
    
    //构造分页控件
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(b/2,CGRectGetMaxY(self.adView.frame)-37, b/2, 37)];
    [self.pageControl setCurrentPageIndicatorTintColor:[UIColor redColor]];
    [self.pageControl setPageIndicatorTintColor:[UIColor blackColor]];
    self.pageControl.numberOfPages = 5;
    self.pageControl.currentPage = 0;
    self.pageControl.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.pageControl];
    
    
    //构造广告栏
    self.banner = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.adView.frame), [UIScreen mainScreen].bounds.size.width, 30)];
    //添加公告图标
    UIImageView * adIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 20, 20)];
    adIcon.image = [UIImage imageNamed:@"main_notice.png"];
    [self.banner addSubview:adIcon];
    //添加label
    lab_noti = [[UILabel alloc] initWithFrame:CGRectMake(35, 5, b-35, 20)];
    lab_noti.textAlignment = NSTextAlignmentLeft;
    [self.banner addSubview:lab_noti];
    [self.view addSubview:self.banner];
    
    
    
    //构造功能集合视图
    UICollectionViewFlowLayout* Layout = [[UICollectionViewFlowLayout alloc] init];
    self.funView = [[UICollectionView alloc] initWithFrame:CGRectMake(-2, a/3+64, b+2, a/3) collectionViewLayout:Layout];
    self.funView.dataSource = self;
    self.funView.delegate = self;
    self.funView.backgroundColor = [UIColor whiteColor];
    self.funView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.funView.layer.borderWidth = 0.5f;
    //注册自定义单元格
    [self.funView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:self.funView];
    //构造图片,文字数组
    funArray = [NSArray arrayWithObjects:@"我的资金",@"商贸三宝",@"众帮商城",@"约吧",@"跳骚市场",@"快递查询",@"智能公交",@"精彩活动", nil];
    picArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"main_fun1.png"],[UIImage imageNamed:@"main_fun2.png"],[UIImage imageNamed:@"main_fun3.png"],[UIImage imageNamed:@"main_fun4.png"],[UIImage imageNamed:@"main_fun5.png"],[UIImage imageNamed:@"main_fun6.png"],[UIImage imageNamed:@"main_fun7.png"],[UIImage imageNamed:@"main_fun8.png"],nil];
    
    //构造校园地带
    self.newsView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.funView.frame), b, a/3)];
    //加入视图
    [self.view addSubview:self.newsView];
    UILabel*lab1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 60, 20)];
    lab1.text = @"校园地带";
    [self.newsView addSubview:lab1];
    //定义更多按钮
    UIButton*more = [[UIButton alloc] initWithFrame:CGRectMake(b-60, 5, 50, 20)];
    [more setTitle:@"更多>>" forState:UIControlStateNormal];
    [more setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [more setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [more addTarget:self action:@selector(checkNews) forControlEvents:UIControlEventTouchUpInside];
    [self.newsView addSubview:more];
    //新闻图片
    newImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 30, b-20, a/3-60)];
    [self.newsView addSubview:newImg];
    
    //新闻标题
    newTitle = [[UILabel alloc] initWithFrame:CGRectMake(10,CGRectGetMaxY(newImg.frame)+5, b*2/3-10, 20)];
    newTitle.textAlignment = NSTextAlignmentLeft;
    [self.newsView addSubview:newTitle];
    
    //新闻时间
    newTime = [[UILabel alloc] initWithFrame:CGRectMake(b*2/3+10, CGRectGetMaxY(newImg.frame)+5, b/3-20, 20)];
    newTime.textAlignment = NSTextAlignmentRight;
    
    //设置首页的字体大小
    if (b == 320) {
        //iphone4s，iphone5s
        lab_noti.font = [UIFont boldSystemFontOfSize:12];
        lab1.font = [UIFont boldSystemFontOfSize:12];
        more.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        newTitle.font = [UIFont boldSystemFontOfSize:12];
        newTime.font = [UIFont boldSystemFontOfSize:12];
    }else{
        //iphone6/6PLUS
        lab_noti.font = [UIFont boldSystemFontOfSize:15];
        lab1.font = [UIFont boldSystemFontOfSize:15];
        more.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        newTitle.font = [UIFont boldSystemFontOfSize:15];
        newTime.font = [UIFont boldSystemFontOfSize:15];
    }
    
    //初始显示第一页
    [self.adView scrollRectToVisible:CGRectMake(b, 0, b, a/3-30) animated:YES];
    //定义一个定时器，让广告滚动
    [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(runTimePage) userInfo:nil repeats:YES];
    //初始化
    app = [UIApplication sharedApplication].delegate;
    main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //构建活动指示器
    indicator = [[TFIndicatorView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-25, [UIScreen mainScreen].bounds.size.height/2-25, 50, 50)];
    [self.view addSubview:indicator];
    [indicator startAnimating];
    //默认隐藏
    indicator.hidden = YES;
    //请求数据
    [self getData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//重新请求数据
-(void)getDataAgain{
    if (app.Rea_manager.reachable == YES) {
        [self getData];
    }
}

//查看新闻详情
-(void)checkDetail{
    
    notDetailViewController * detailView = [main instantiateViewControllerWithIdentifier:@"newsDetail"];
    //将新闻id传递给下一个界面
    detailView.newsId = [NSNumber numberWithInt:12];
    detailView.hidesBottomBarWhenPushed = YES;
    //存储数据
    [[NSUserDefaults standardUserDefaults] setObject:[[returnDic objectForKey:@"result"] objectForKey:@"News"] forKey:@"News"];
    //跳转到下一个界面
    [self.navigationController pushViewController:detailView animated:YES];
}

//点击查看更多新闻
-(void)checkNews{
    if (app.Rea_manager.reachable == YES) {
        schoolNewsTableViewController * newsView = [main instantiateViewControllerWithIdentifier:@"schoolNewsTable"];
        newsView.title = @"校园地带";
        newsView.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:newsView animated:YES];
    }else{
        //请先检查网络
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请检查网络是否连接正常" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    
}

//查看系统消息
- (void)checkNotices {
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"state"] intValue] == 0) {
        //弹出登录界面
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请先登录" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
           // UIStoryboard * main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            loginViewController * loginView = [main instantiateViewControllerWithIdentifier:@"login"];
            loginView.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            [self presentViewController:loginView animated:YES completion:nil];
        }];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        noticeTableViewController * noticeView = [main instantiateViewControllerWithIdentifier:@"noticeTable"];
        noticeView.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:noticeView animated:YES];
    }
    
    
}

//定时器循环播放
-(void)runTimePage{
   
    int page = (int)self.pageControl.currentPage;
    [UIView animateWithDuration:2.0f animations:^{
        [self.adView setContentOffset:CGPointMake(self.adView.contentOffset.x+b, 0)];
    }];
    page++;
    self.pageControl.currentPage = page;
    //回到首页
    if (page>4){
        self.pageControl.currentPage = 0;
       [self.adView scrollRectToVisible:CGRectMake(b,0, b, a/3-30) animated:NO];
    }else{
        self.pageControl.currentPage = page;
    }
}

#pragma UIScrollViewDelegate
// scrollview 委托函数
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    CGFloat pagewidth = self.adView.frame.size.width;
    int page = floor((self.adView.contentOffset.x - pagewidth/7)/pagewidth)+1;
    page --;  // 默认从第二页开始
    self.pageControl.currentPage = page;
}
// scrollview 委托函数
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pagewidth = self.adView.frame.size.width;
    int currentPage = floor((self.adView.contentOffset.x - pagewidth/7) / pagewidth) + 1;
    //    int currentPage_ = (int)self.scrollView.contentOffset.x/320; // 和上面两行效果一样
    //    NSLog(@"currentPage_==%d",currentPage_);
    if (currentPage==0)
    {
        [self.adView scrollRectToVisible:CGRectMake(b*5,64,b,a/3-30) animated:NO]; // 序号0 最后1页
    }
    else if (currentPage==6)
    {
        [self.adView scrollRectToVisible:CGRectMake(b,64,b,a/3-30) animated:NO]; // 最后+1,循环第1页
    }
}

//获取服务器数据
-(void)getData{
    //活动指示器显示
    indicator.hidden = NO;
    //请求数据
    [app.manager POST:@"http://120.25.162.238/bsy/index.php/Index/Index/index" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //请求成功,隐藏活动指示器
        indicator.hidden = YES;
        //定时器关闭
        if (timer1.valid == YES) {
            [timer1 invalidate];
        }
        //判断请求数据是否为空
        if (operation.responseData != nil) {
            returnDic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
            if ([[returnDic objectForKey:@"code"] isEqualToString:@"100000"]) {
                //广告滚动图片
                adURL = [NSArray arrayWithObjects:@"http://120.25.162.238/app/ad/1280115949992.jpg",@"http://120.25.162.238/app/ad/1303967876491.jpg",@"http://120.25.162.238/app/ad/m_1303967844788.jpg",@"http://120.25.162.238/app/ad/m_1303967870670.jpg",@"http://120.25.162.238/app/ad/1303967876491.jpg", nil];
                //异步加载图片
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                    //定义 一个可变数组
                    NSMutableArray * imgArray = [[NSMutableArray alloc] init];
                    for (int i = 0; i<adURL.count; i++) {
                        UIImage * image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[adURL objectAtIndex:i]]]];
                        if (image != nil) {
                            [imgArray addObject:image];
                        }
                    }
                    //将代码块提交给主线程关联的队列
                    dispatch_async(dispatch_get_main_queue(), ^{
                        for (int i =0; i<7; i++) {
                            UIImageView * view1;
                            if (i==0) {
                                view1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, b, a/3-30)];
                                view1.image = [imgArray objectAtIndex:4];
                                
                                
                            }else if (i == 6){
                                view1 = [[UIImageView alloc] initWithFrame:CGRectMake(b*7, 0, b, a/3-30)];
                                view1.image = [imgArray objectAtIndex:0];
                            }else{
                                view1 = [[UIImageView alloc] initWithFrame:CGRectMake(b*i, 0, b, a/3-30)];
                                view1.image = [imgArray objectAtIndex:i-1];
                            }
                            view1.backgroundColor = [UIColor whiteColor];
                            [self.adView addSubview:view1];
                        }
                    });
                });
                
                //新闻标题
                newTitle.text = [[[returnDic objectForKey:@"result"] objectForKey:@"News"] objectForKey:@"title"];
                //新闻时间
                NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy-MM-dd"];
                NSDate * date = [NSDate dateWithTimeIntervalSince1970:[[[[returnDic objectForKey:@"result"] objectForKey:@"News"] objectForKey:@"time"] intValue]];
                newTime.text = [formatter stringFromDate:date];
                //新闻图片
                NSString * imgURL = [[[returnDic objectForKey:@"result"] objectForKey:@"News"] objectForKey:@"picture"];
                newImg.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imgURL]]];
                //公告
                lab_noti.text = [[[returnDic objectForKey:@"result"] objectForKey:@"Announcement"] objectForKey:@"title"];
                //定义一个手势处理器，用来查看详细,只有消息返回成功，才能点击进去查看
                UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkDetail)];
                tap.numberOfTapsRequired = 1;
                [self.newsView addGestureRecognizer:tap];
                [self.newsView addSubview:newTime];
                
            }else{
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[returnDic objectForKey:@"message"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
        }else{
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"请求超时" message:@"请检查网络连接是否正常" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                if (timer1.valid == NO) {
                    //开启定时器
                    timer1 = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(getDataAgain) userInfo:nil repeats:YES];
                }
                
            }];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
}


#pragma mark - UICollectionDelegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 4;
}

//构造单元格
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString*identify = @"cell";
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    if(!cell){
        cell =[[UICollectionViewCell alloc] init];
    }
  
    UIImageView * view =[[UIImageView alloc] initWithFrame:CGRectMake(15, 0, CGRectGetWidth(cell.frame)-30, CGRectGetWidth(cell.frame)-30)];
    view.image = [picArray objectAtIndex:indexPath.section*4+indexPath.row];
    view.layer.cornerRadius = (CGRectGetWidth(cell.frame)-30)/2;
    view.layer.masksToBounds = YES;
    UILabel*lab = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(view.frame), CGRectGetWidth(cell.frame)-20, 20)];
    lab.text = [funArray objectAtIndex:indexPath.section*4+indexPath.row];
    //字体按iPhone版本来展示
    if (b == 320) {
        lab.font = [UIFont boldSystemFontOfSize:10];
    }else{
        lab.font = [UIFont boldSystemFontOfSize:15];
    }
    lab.textAlignment = NSTextAlignmentCenter;
    [cell addSubview:view];
    [cell addSubview:lab];
    return cell;
}

//指定单元格的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((b-25)/4, (a/3-20)/2);
}
//单元格间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(5, 5, 2.5, 5);
    
}

//行间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}


//点击某个功能按钮
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //判断网络连接是否异常
    if (app.Rea_manager.reachable == YES) {
        switch (indexPath.section*4+indexPath.row) {
            case 0:{
                //跳转到“我的资金”
                //判断用户是否已经登录
                if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"state"] intValue] == 0) {
                    //设置selectedController的值
                    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInt:5] forKey:@"selectedController"];
                    //弹出登录界面
                    loginViewController * loginView = [main instantiateViewControllerWithIdentifier:@"login"];
                    loginView.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
                    loginView.delegate = self;
                    [self presentViewController:loginView animated:YES completion:nil];
                }else{
                    myAccountTableViewController * accountView = [main instantiateViewControllerWithIdentifier:@"myAccountTable"];
                    accountView.title = @"我的账户";
                    accountView.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:accountView animated:YES];
                }
                break;
            }
            case 1:{
                //判断是否已经登录
                if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"state"] intValue] == 0) {
                    //记住将要跳转的tabViewController
                    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:1] forKey:@"selectedController"];
                    //弹出登录界面
                    loginViewController * loginView = [main instantiateViewControllerWithIdentifier:@"login"];
                    loginView.delegate = self;
                    loginView.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
                    [self presentViewController:loginView animated:YES completion:nil];
                }else{
                    //跳转到“理财”
                    [self.tabBarController setSelectedIndex:1];
                }
                break;
            }
            case 2:
                //跳转到“众帮商城”
                [self.tabBarController setSelectedIndex:2];
                break;
            case 3:
                //跳转到“约吧”
            {
                yueBaTableViewController * yuebaView = [main instantiateViewControllerWithIdentifier:@"yuebaTable"];
                //设定标志
                yuebaView.flag = [NSNumber numberWithInt:1];
                yuebaView.hidesBottomBarWhenPushed = YES;
                yuebaView.title = @"约吧";
                [self.navigationController pushViewController:yuebaView animated:YES];
                break;
            }
            case 4:
                //跳转到跳骚市场
            {
                marketTableViewController * marketView = [main instantiateViewControllerWithIdentifier:@"marketTable"];
                marketView.hidesBottomBarWhenPushed = YES;
                marketView.title = @"跳蚤市场";
                [self.navigationController pushViewController:marketView animated:YES];
                break;
            }
            case 5:{
                //跳转到“快递查询”
                expressInqueryViewController * expressView = [[expressInqueryViewController alloc] init];
                expressView.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:expressView animated:YES];
                break;
            }
            case 6:{
                //跳转到"公交查询"
                busInqueryViewController * busView = [[busInqueryViewController alloc] init];
                busView.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:busView animated:YES];
                break;
            }
            case 7:{
                //跳转到精彩活动,与约吧是同一个界面
                yueBaTableViewController * actionVview = [main instantiateViewControllerWithIdentifier:@"yuebaTable"];
                actionVview.flag = [NSNumber numberWithInt:2];
                actionVview.hidesBottomBarWhenPushed = YES;
                actionVview.title = @"精彩活动";
                [self.navigationController pushViewController:actionVview animated:YES];
                break;
            }
            default:
                break;
        }

    }else{
        //网络连接异常
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请求失败，请检查网络是否连接正常" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}

#pragma returnToTabViewProtocol
-(void)returnToTabViewController{
    //跳到“理财”界面
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedController"] intValue] == 5){
        //跳转到我的账户界面
        myAccountTableViewController * accountView = [main instantiateViewControllerWithIdentifier:@"myAccountTable"];
        accountView.hidesBottomBarWhenPushed = YES;
        accountView.title = @"我的账户";
        [self.navigationController pushViewController:accountView animated:YES];
    }
    [self.tabBarController setSelectedIndex:[[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedController"] intValue]];
}
@end
