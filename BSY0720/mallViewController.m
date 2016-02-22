//
//  mallViewController.m
//  BSY0720
//
//  Created by jway on 15-7-22.
//  Copyright (c) 2015年 jway. All rights reserved.
//

#import "mallViewController.h"
#import "AppDelegate.h"
#import "SDRefresh.h"
#import "UICustomLineLabel.h"
#import "INSSearchBar.h"
#import "orderSucViewController.h"
#import "shopBasketViewController.h"
#import "TFIndicatorView.h"
#import "loginViewController.h"
@interface mallViewController ()<INSSearchBarDelegate>
//上拉加载
@property (nonatomic, weak) SDRefreshFooterView *refreshFooter;
//带协议的简易搜索栏
@property (nonatomic, strong) INSSearchBar *searchBarWithDelegate;
@end

@implementation mallViewController

AppDelegate * app;
//定义菜单栏图片
NSArray * array_pic;
//菜单栏各项功能名称
NSArray * array_name;
//定义一个可变字典，用来接收某商品已购买的份数
NSMutableDictionary* good_num;
//定义一个标志，用来判断是第几次点击搜索按钮
int flag;
//定义一个活动指示器
TFIndicatorView * indicatorView;
//定义一个定时器
NSTimer * timer1;
//存放第1类商品数据
NSMutableArray * infoArray1;
//存放第2类商品数据
NSMutableArray * infoArray2;
//存放第3类商品数据
NSMutableArray * infoArray3;
//存放第4类商品数据
NSMutableArray * infoArray4;
//存放第5类商品数据
NSMutableArray * infoArray5;
//存放第6类商品数据
NSMutableArray * infoArray6;
//存放第7类商品数据
NSMutableArray * infoArray7;
//存放第8类商品数据
NSMutableArray * infoArray8;
//定义标志2，用来判断用户点击加载的是哪类商品
int flag2;
//定义一个数组，用来存放商品信息的分页；
NSMutableArray * pageArray;

//定义加载状态标识
BOOL _loadingMore;

- (void)viewDidLoad
{
    [super viewDidLoad];
   // self.automaticallyAdjustsScrollViewInsets = NO;
    //添加搜索栏
    self.searchBarWithDelegate = [[INSSearchBar alloc] initWithFrame:CGRectMake(15, 28.0, [UIScreen mainScreen].bounds.size.width-30, 34.0)];
    self.searchBarWithDelegate.delegate = self;
    [self.navView addSubview:self.searchBarWithDelegate];
    //标志设置为0
    flag = 0;
    
    //菜单表示图
    self.dockTableView.dataSource = self;
    self.dockTableView.delegate = self;
    self.dockTableView.tag = 0;
   
    //商品表示图
    self.disTableView.dataSource = self;
    self.disTableView.delegate = self;
    self.disTableView.tag = 1;
    
    
    //修饰控件外观属性,并设置其初始标题
    self.account.layer.cornerRadius = 3.0f;
    [self.account setTitle:@"请选购" forState:UIControlStateNormal];
    //购物车
    self.basketView.layer.cornerRadius = 33.0f;
    self.hasBuyNum.layer.masksToBounds = YES;
    self.hasBuyNum.layer.cornerRadius = 11.0f;
    self.hasBuyNum.backgroundColor = [UIColor redColor];
    //最初先隐藏hasBuyNum等
    self.hasBuyNum.hidden = YES;
    self.totalNum.hidden = YES;
    self.hasSaved.hidden = YES;
    self.hasSaved.lineType = LineTypeMiddle;
    //构造菜单栏
    array_pic = [NSArray arrayWithObjects:[UIImage imageNamed:@"list1.png"],[UIImage imageNamed:@"list2.png"],[UIImage imageNamed:@"list3.png"],[UIImage imageNamed:@"list4.png"],[UIImage imageNamed:@"list5.png"],[UIImage imageNamed:@"list6.png"],[UIImage imageNamed:@"list7.png"],[UIImage imageNamed:@"list8.png"], nil];
    
    //初始化可变数组,只有初始化后才能进行加减对象
    self.buyArray = [[NSMutableArray alloc] init];
    good_num = [[NSMutableDictionary alloc] init];
    //初始化分页数组
    pageArray = [NSMutableArray arrayWithObjects:@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0", nil];
    //初始化可变数组
    infoArray1 = [[NSMutableArray alloc] init];
    infoArray2 = [[NSMutableArray alloc] init];
    infoArray3 = [[NSMutableArray alloc] init];
    infoArray4 = [[NSMutableArray alloc] init];
    infoArray5 = [[NSMutableArray alloc] init];
    infoArray6 = [[NSMutableArray alloc] init];
    infoArray7 = [[NSMutableArray alloc] init];
    infoArray8 = [[NSMutableArray alloc] init];
    //加载活动指示器
    indicatorView = [[TFIndicatorView alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width-126)/2-25, ([UIScreen mainScreen].bounds.size.height-114)/2-25, 50, 50)];
    [indicatorView startAnimating];
    [self.disTableView addSubview:indicatorView];
    
    //初始化程序委托类
    app = [UIApplication sharedApplication].delegate;
    
    //设置下拉刷新与上拉加载
    [self setupFooter];
    //获取初始数据
    [self getData];
    
}

//当视图重现的时候就重载一次数据
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [self.disTableView reloadData];
}


//下拉加载
- (void)setupFooter
{
    SDRefreshFooterView *refreshFooter = [SDRefreshFooterView refreshView];
    [refreshFooter addToScrollView:self.disTableView];
    [refreshFooter addTarget:self refreshAction:@selector(footerRefresh)];
    _refreshFooter = refreshFooter;
}

//再次向服务器请求数据，并重新加载
-(void)footerRefresh{
    //禁止界面响应新的操作
    self.disTableView.userInteractionEnabled = NO;
    //先构造发送参数
    NSDictionary * sendDic = [NSDictionary dictionaryWithObjectsAndKeys:[[array_name objectAtIndex:flag2-1] objectForKey:@"classification_id"],@"classification_id",@"10",@"num",[pageArray objectAtIndex:flag2-1],@"page", nil];
    //向服务器请求数据
    [app.manager POST:@"http://120.25.162.238/bsy/index.php/Index/Product/getProductList" parameters:sendDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //界面恢复响应
        self.disTableView.userInteractionEnabled = YES;
        [_refreshFooter endRefreshing];
        //此处不需要未登录错误提示
        NSDictionary * returnDic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"footer = %@",returnDic);
        if ([[returnDic objectForKey:@"code"] isEqualToString:@"100000"]) {
            switch (flag2) {
                case 1:
                    [infoArray1 addObjectsFromArray:[[returnDic objectForKey:@"result"] objectForKey:@"Product.List"]];
                    //页数再加1
                    int page1 = [[pageArray objectAtIndex:0] intValue];
                    [pageArray replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"%i",page1+1]];
                    [self.disTableView reloadData];
                    break;
                case 2:
                    [infoArray2 addObjectsFromArray:[[returnDic objectForKey:@"result"] objectForKey:@"Product.List"]];
                    //页数再加1
                    int page2 = [[pageArray objectAtIndex:1] intValue];
                    [pageArray replaceObjectAtIndex:1 withObject:[NSString stringWithFormat:@"%i",page2+1]];
                    [self.disTableView reloadData];
                    break;
                case 3:
                    [infoArray3 addObjectsFromArray:[[returnDic objectForKey:@"result"] objectForKey:@"Product.List"]];
                    //页数再加1
                    int page3 = [[pageArray objectAtIndex:2] intValue];
                    [pageArray replaceObjectAtIndex:2 withObject:[NSString stringWithFormat:@"%i",page3+1]];
                    [self.disTableView reloadData];
                    break;
                case 4:
                    [infoArray4 addObjectsFromArray:[[returnDic objectForKey:@"result"] objectForKey:@"Product.List"]];
                    //页数再加1
                    int page4 = [[pageArray objectAtIndex:3] intValue];
                    [pageArray replaceObjectAtIndex:3 withObject:[NSString stringWithFormat:@"%i",page4+1]];
                    [self.disTableView reloadData];
                    break;
                case 5:
                    [infoArray5 addObjectsFromArray:[[returnDic objectForKey:@"result"] objectForKey:@"Product.List"]];
                    //页数再加1
                    int page5 = [[pageArray objectAtIndex:4] intValue];
                    [pageArray replaceObjectAtIndex:4 withObject:[NSString stringWithFormat:@"%i",page5+1]];
                    [self.disTableView reloadData];
                    break;
                case 6:
                    [infoArray6 addObjectsFromArray:[[returnDic objectForKey:@"result"] objectForKey:@"Product.List"]];
                    //页数再加1
                    int page6 = [[pageArray objectAtIndex:5] intValue];
                    [pageArray replaceObjectAtIndex:5 withObject:[NSString stringWithFormat:@"%i",page6+1]];
                    [self.disTableView reloadData];
                    break;
                case 7:
                    [infoArray7 addObjectsFromArray:[[returnDic objectForKey:@"result"] objectForKey:@"Product.List"]];
                    //页数再加1
                    int page7 = [[pageArray objectAtIndex:6] intValue];
                    [pageArray replaceObjectAtIndex:6 withObject:[NSString stringWithFormat:@"%i",page7+1]];
                    [self.disTableView reloadData];
                    break;
                case 8:
                    [infoArray8 addObjectsFromArray:[[returnDic objectForKey:@"result"] objectForKey:@"Product.List"]];
                    //页数再加1
                    int page8 = [[pageArray objectAtIndex:7] intValue];
                    [pageArray replaceObjectAtIndex:7 withObject:[NSString stringWithFormat:@"%i",page8+1]];
                    [self.disTableView reloadData];
                    break;
                default:
                    break;
            }
        }else{
            
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[returnDic objectForKey:@"message"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    }];
}


//向服务器请求数据
-(void)getData{
    //在请求数据时
    self.disTableView.userInteractionEnabled = NO;
    //请求服务器
    [app.manager POST:@"http://120.25.162.238/bsy/index.php/Index/Product/getClassificationList" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //如果定时器已经开启，关闭定时器
        if (timer1.valid == YES) {
            [timer1 invalidate];
        }
        if (operation.responseData != nil) {
            //服务器有数据返回
            NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
            if ([[dic objectForKey:@"code"] isEqualToString:@"100000"]) {
                array_name = [[dic objectForKey:@"result"] objectForKey:@"Classification.List"];
                [self.dockTableView reloadData];
                //默认选中第一行，一定要放在reloadData后面，否则会报错
                NSIndexPath *firstPath = [NSIndexPath indexPathForRow:0 inSection:0];
                [self.dockTableView selectRowAtIndexPath:firstPath animated:NO scrollPosition:UITableViewScrollPositionTop];//默认选中一行
                flag2 = 1;   //加载第一类商品数据
                //开启另一个线程，来请求第一类商品
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                    //构造发送数据
                    NSDictionary * sendDic = [NSDictionary dictionaryWithObjectsAndKeys:[[array_name objectAtIndex:0] objectForKey:@"classification_id"],@"classification_id",@"0",@"page",@"10",@"num", nil];
                    [app.manager POST:@"http://120.25.162.238/bsy/index.php/Index/Product/getProductList" parameters:sendDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        //
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        //这时候，活动指示器隐藏
                        indicatorView.hidden = YES;
                        self.disTableView.userInteractionEnabled = YES;
                        if (operation.responseData != nil) {
                            NSDictionary * dic3 = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
                            if ([[dic3 objectForKey:@"code"] isEqualToString:@"100000"]) {
                                //存储数据
                                infoArray1 = [[dic3 objectForKey:@"result"] objectForKey:@"Product.List"];
                                //成功返回数据，第一类商品的页数要加1
                                [pageArray replaceObjectAtIndex:0 withObject:@"1"];
                                [self.disTableView reloadData];
                            }else{
                                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[dic3 objectForKey:@"message"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                                [alert show];
                            }
                        }
                    }];
                });
                
            }else{
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[dic objectForKey:@"message"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
        }else{
            
            indicatorView.hidden = YES;
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"请求超时" message:@"请检查网络连接是否正常" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                if (timer1.valid == NO) {
                    NSLog(@"123");
                    //开启定时器
                    timer1 = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(getDataAgain) userInfo:nil repeats:YES];
                }
            }];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];

}

//重新请求数据
-(void)getDataAgain{
    if (app.Rea_manager.reachable == YES) {
        //显示活动指示器
        indicatorView.hidden = NO;
        [self getData];
    }
}

//获取非“全校疯强”商品信息
-(void)getGoodInfo:(int)flag2{
    //活动指示器出现
    indicatorView.hidden = NO;
    //构造请求参数
    NSDictionary * sendDic = [NSDictionary dictionaryWithObjectsAndKeys:[[array_name objectAtIndex:flag2-1] objectForKey:@"classification_id"],@"classification_id",@"10",@"num",[pageArray objectAtIndex:flag2-1],@"page", nil];
    //请求服务器
    [app.manager POST:@"http://120.25.162.238/bsy/index.php/Index/Product/getProductList" parameters:sendDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //活动指示器消失
        indicatorView.hidden = YES;
        if (operation.responseData != nil) {
            NSDictionary * getDic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
            
            NSLog(@"getDic = %@",getDic);
            
            
            if ([[getDic objectForKey:@"code"] isEqualToString:@"100000"]) {
                //成功获取数据
                switch (flag2) {
                    case 1:
                        [infoArray1 addObjectsFromArray:[[getDic objectForKey:@"result"] objectForKey:@"Product.List"]];
                        //页数再加1
                        int page1 = [[pageArray objectAtIndex:0] intValue];
                        [pageArray replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"%i",page1+1]];
                        [self.disTableView reloadData];
                        break;
                    case 2:
                        [infoArray2 addObjectsFromArray:[[getDic objectForKey:@"result"] objectForKey:@"Product.List"]];
                        //页数再加1
                        int page2 = [[pageArray objectAtIndex:1] intValue];
                        [pageArray replaceObjectAtIndex:1 withObject:[NSString stringWithFormat:@"%i",page2+1]];
                        [self.disTableView reloadData];
                        break;
                    case 3:
                        [infoArray3 addObjectsFromArray:[[getDic objectForKey:@"result"] objectForKey:@"Product.List"]];
                        //页数再加1
                        int page3 = [[pageArray objectAtIndex:2] intValue];
                        [pageArray replaceObjectAtIndex:2 withObject:[NSString stringWithFormat:@"%i",page3+1]];
                        [self.disTableView reloadData];
                        break;
                    case 4:
                        [infoArray4 addObjectsFromArray:[[getDic objectForKey:@"result"] objectForKey:@"Product.List"]];
                        //页数再加1
                        int page4 = [[pageArray objectAtIndex:3] intValue];
                        [pageArray replaceObjectAtIndex:3 withObject:[NSString stringWithFormat:@"%i",page4+1]];
                        [self.disTableView reloadData];
                        break;
                    case 5:
                        [infoArray5 addObjectsFromArray:[[getDic objectForKey:@"result"] objectForKey:@"Product.List"]];
                        //页数再加1
                        int page5 = [[pageArray objectAtIndex:4] intValue];
                        [pageArray replaceObjectAtIndex:4 withObject:[NSString stringWithFormat:@"%i",page5+1]];
                        [self.disTableView reloadData];
                        break;
                    case 6:
                        [infoArray6 addObjectsFromArray:[[getDic objectForKey:@"result"] objectForKey:@"Product.List"]];
                        //页数再加1
                        int page6 = [[pageArray objectAtIndex:5] intValue];
                        [pageArray replaceObjectAtIndex:5 withObject:[NSString stringWithFormat:@"%i",page6+1]];
                        [self.disTableView reloadData];
                        break;
                    case 7:
                        [infoArray7 addObjectsFromArray:[[getDic objectForKey:@"result"] objectForKey:@"Product.List"]];
                        //页数再加1
                        int page7 = [[pageArray objectAtIndex:6] intValue];
                        [pageArray replaceObjectAtIndex:6 withObject:[NSString stringWithFormat:@"%i",page7+1]];
                        [self.disTableView reloadData];
                        break;
                    case 8:
                        [infoArray8 addObjectsFromArray:[[getDic objectForKey:@"result"] objectForKey:@"Product.List"]];
                        //页数再加1
                        int page8 = [[pageArray objectAtIndex:7] intValue];
                        [pageArray replaceObjectAtIndex:7 withObject:[NSString stringWithFormat:@"%i",page8+1]];
                        [self.disTableView reloadData];
                        break;
                    default:
                        break;
                }
            }else{
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[getDic objectForKey:@"message"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
        }else{
            //网络连接问题
            
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//去结算
- (IBAction)account:(id)sender{
    //先判断是否已购买了商品
    if ([self.hasBuyNum.text intValue] == 0) {
        //如果未购买
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先选购商品" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"state"] intValue] == 0) {
            //请先登录
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请先登录" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                //弹出登录界面
                UIStoryboard * main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                loginViewController * loginView = [main instantiateViewControllerWithIdentifier:@"login"];
                loginView.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
                [self presentViewController:loginView animated:YES completion:nil];
            }];
            UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:action1];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        }else{
            //跳转到购物车列表页面
            UIStoryboard * main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            shopBasketViewController * shopBasketView = [main instantiateViewControllerWithIdentifier:@"shopBasket"];
            UINavigationController * navCon = [[UINavigationController alloc] initWithRootViewController:shopBasketView];
            //将购物数据传递给购物车界面
            //这里可以直接传递数值
            shopBasketView.goodArray = [[NSMutableArray alloc] initWithArray:self.buyArray];
            shopBasketView.goodnum = [[NSMutableDictionary alloc] initWithDictionary:good_num copyItems:YES];
            [self presentViewController:navCon animated:YES completion:^{
                //把购物数据全部清空
                good_num = [NSMutableDictionary dictionaryWithObjectsAndKeys:nil, nil];
                self.buyArray = [NSMutableArray arrayWithObjects:nil, nil];
                self.hasBuyNum.text = [NSString stringWithFormat:@"0"];
                //将一些控件隐藏
                self.hasBuyNum.hidden = YES;
                self.totalNum.text = @"0";
                self.totalNum.hidden = YES;
                self.hasSaved.text = @"0";
                self.hasSaved.hidden = YES;
                //按钮的标题变为请选购
                [self.account setTitle:@"请选购" forState:UIControlStateNormal];
            }];

        }
    }
    
}


#pragma dataSource/delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView.tag == 0) {
        return 1;
    }else{
        if (flag2 == 1) {
            return infoArray1.count;
        }else if (flag2 == 2){
            return infoArray2.count;
        }else if (flag2 == 3){
            return infoArray3.count;
        }else if (flag2 == 4){
            return infoArray4.count;
        }else if (flag2 == 5){
            return infoArray5.count;
        }else if (flag2 == 6){
            return infoArray6.count;
        }else if (flag2 == 7){
            return infoArray7.count;
        }else{
            return infoArray8.count;
        }
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == 0) {
        return array_name.count;
    }else{
        return 1;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 0) {
        //菜单栏
        dockTableCell * cell = [tableView dequeueReusableCellWithIdentifier:@"dockcell"];
        cell.img.image = [array_pic objectAtIndex:indexPath.row];
        cell.lab.text = [[array_name objectAtIndex:indexPath.row] objectForKey:@"name"];
        //单元格的背景颜色
        cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
        return cell;
    }else{
        goodTableCell * cell = [tableView dequeueReusableCellWithIdentifier:@"goodCell"];
        NSDictionary * dic;
        switch (flag2) {
            case 1:
                dic = [infoArray1 objectAtIndex:indexPath.section];
                break;
            case 2:
                dic = [infoArray2 objectAtIndex:indexPath.section];
                break;
            case 3:
                dic = [infoArray3 objectAtIndex:indexPath.section];
                break;
            case 4:
                dic = [infoArray4 objectAtIndex:indexPath.section];
                break;
            case 5:
                dic = [infoArray5 objectAtIndex:indexPath.section];
                break;
            case 6:
                dic = [infoArray6 objectAtIndex:indexPath.section];
                break;
            case 7:
                dic = [infoArray7 objectAtIndex:indexPath.section];
                break;
            case 8:
                dic = [infoArray8 objectAtIndex:indexPath.section];
                break;
            default:
                break;
        }
        cell.goodName.text = [dic objectForKey:@"name"];
        cell.goodPrice.text = [NSString stringWithFormat:@"￥%3.0f",[[dic objectForKey:@"member_price"] floatValue]];
        
        //此处图片必须缓存，并且异步加载
        NSFileManager * fm = [NSFileManager defaultManager];
        NSArray * fileArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString * filetemp = [fileArray objectAtIndex:0];
        NSString * filePath = [filetemp stringByAppendingPathComponent:[NSString stringWithFormat:@"goodImg_%@.jpg",[dic objectForKey:@"product_id"]]];
        if ([fm fileExistsAtPath:filePath]) {
            //如果缓存存在
            cell.goodImg.image = [UIImage imageWithContentsOfFile:filePath];
        }else{
            //缓存不存在
            //异步缓存图片
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                //从网络获取图像数据
                NSData * data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[dic objectForKey:@"default_url"]]];
                //将网络数据初始化为UIImage对象
                UIImage * image = [[UIImage alloc] initWithData:data];
                if (image != nil) {
                    //存入本地缓存，成功就重载数据
                    if([UIImageJPEGRepresentation(image, 0.5) writeToFile:filePath atomically:YES]){
                        //返回主线程
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.disTableView reloadData];
                        });
                    }
                
                }
            });
        }
       // cell.goodImg.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[dic objectForKey:@"default_url"]]]];
        
        cell.originalPrice.text = [NSString stringWithFormat:@"￥%3.0f",[[dic objectForKey:@"price"] floatValue]];
        cell.originalPrice.lineType = LineTypeMiddle;
        cell.hasSold.text = [NSString stringWithFormat:@"销量:%@",[dic objectForKey:@"sold_amount"]];
        cell.num.layer.borderColor = [[UIColor grayColor] CGColor];
        cell.num.layer.borderWidth = 1.0f;
        //设置单元格有圆角
        cell.layer.cornerRadius = 8.0f;
        //设置商品图片有圆角
        cell.goodImg.layer.cornerRadius = 4.0f;
        cell.goodImg.layer.masksToBounds = YES;
        //加减按钮的tag 为商品的id
        cell.delete1.tag = [[dic objectForKey:@"product_id"] intValue];
        cell.add.tag = [[dic objectForKey:@"product_id"] intValue];
        
        cell.num.text = [NSString stringWithFormat:@"%i",[[good_num objectForKey:[dic objectForKey:@"product_id"]] intValue]];
        
        //采用协议代理的模式，将self设置为cell的代理
        cell.delegate = self;
        //取消单元格选中高亮状态
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

//section之间的距离
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

//构造footer
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0,0,CGRectGetWidth(self.disTableView.frame),10)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 0) {
        //菜单栏--访问不同接口
        if (indexPath.row == 0) {
            flag2 = 1;
            if (infoArray1.count > 0) {
                //已请求过数据，直接加载
                [self.disTableView reloadData];
            }
        }else if (indexPath.row == 1){
            flag2 = 2;
            if (infoArray2.count == 0) {
                //请求数据
                [self getGoodInfo:flag2];
            }else{
                [self.disTableView reloadData];
            }
        }else if (indexPath.row == 2){
            flag2 = 3;
            if (infoArray3.count == 0) {
                [self getGoodInfo:flag2];
            }else{
                [self.disTableView reloadData];
            }
        }else if (indexPath.row == 3){
            flag2 = 4;
            if (infoArray4.count == 0) {
                [self getGoodInfo:flag2];
            }else{
                [self.disTableView reloadData];
            }
        }else if (indexPath.row == 4){
            flag2 = 5;
            if (infoArray5.count == 0) {
                [self getGoodInfo:flag2];
            }else{
                [self.disTableView reloadData];
            }
        }else if (indexPath.row == 5){
            flag2 = 6;
            if (infoArray6.count == 0) {
                [self getGoodInfo:flag2];
            }else{
                [self.disTableView reloadData];
            }
        }else if (indexPath.row == 6){
            flag2 = 7;
            if (infoArray7.count == 0) {
                [self getGoodInfo:flag2];
            }else{
                [self.disTableView reloadData];
            }
        }else{
            flag2 = 8;
            if (infoArray8.count == 0) {
                [self getGoodInfo:flag2];
            }else{
                [self.disTableView reloadData];
            }
        }
    }
}

#pragma mark - search bar delegate


- (CGRect)destinationFrameForSearchBar:(INSSearchBar *)searchBar
{
    return CGRectMake(15.0, 28.0, CGRectGetWidth(self.view.bounds) - 30.0, 34.0);
}

- (void)searchBar:(INSSearchBar *)searchBar willStartTransitioningToState:(INSSearchBarState)destinationState{
    // Do whatever you deem necessary.
    //点击搜索按钮触发
    if (flag == 0) {
        self.pageTitle.hidden = YES;   //隐藏标题
        flag = 1;
    }else{
        flag = 0;
    }
    
}

- (void)searchBar:(INSSearchBar *)searchBar didEndTransitioningFromState:(INSSearchBarState)previousState{
    // Do whatever you deem necessary.
    //再次点击搜索按钮，关闭搜索
    if (flag == 0) {
        self.pageTitle.hidden = NO;
    }
    // self.pageTitle.hidden = NO;   //重新出现标题
    
}

- (void)searchBarDidTapReturn:(INSSearchBar *)searchBar
{
    //按return键，获取值，并进行搜索
    //  NSString * goodName = searchBar.searchField.text;
    if ([searchBar.searchField.text isEqual:@""]) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入搜索的商品名称" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        //开始搜索
    }
}

- (void)searchBarTextDidChange:(INSSearchBar *)searchBar
{
    // Do whatever you deem necessary.
    // Access the text from the search bar like searchBar.searchField.text
    //此处是随时输出输入框中得值
}


#pragma mallProtocol
//当用户删除选购商品时
-(void)deleteGoodInfo:(NSDictionary *)dic{
    //先将商品购买数减1
    [good_num setObject:[NSString stringWithFormat:@"%i",[[good_num objectForKey:[dic objectForKey:@"id"]] intValue]-1] forKey:[dic objectForKey:@"id"]];
    
    //从用户已购列表中删除该物品，并将购买总数减一
    //只有当购买数量减为0时，才将该商品从购物清单中删除
    if ([[good_num objectForKey:[dic objectForKey:@"id"]] intValue] == 0) {
        [self.buyArray removeObject:dic];
    }
    //已节省金额先去除￥；
    NSString * savedNum = [self.hasSaved.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"￥"]];
     NSString * totalNum = [self.totalNum.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"￥"]];
    //重新统计已购总金额
    self.totalNum.text = [NSString stringWithFormat:@"￥%i",[totalNum intValue]-[[dic objectForKey:@"goodPrice"] intValue]];
    //重新统计节省金额
    int a = [[dic objectForKey:@"originalPrice"] intValue] - [[dic objectForKey:@"goodPrice"] intValue];
    self.hasSaved.text = [NSString stringWithFormat:@"￥%i",[savedNum intValue]-a];
    self.hasBuyNum.text = [NSString stringWithFormat:@"%i",[self.hasBuyNum.text intValue]-1];
    if ([self.hasBuyNum.text intValue] == 0) {
        self.hasBuyNum.hidden =YES;
        //account按钮的标题进行更改
        [self.account setTitle:@"请选购" forState:UIControlStateNormal];
        //已购金额和已节省金额都隐藏
        self.totalNum.hidden = YES;
        self.hasSaved.hidden = YES;
    }
}

//当用户添加所购商品时
-(void)addGoodInfo:(NSDictionary *)dic{
    //先记录购买商品的个数
    if ([good_num objectForKey:[dic objectForKey:@"id"]]) {
        //如果不为空，则个数加1
        [good_num setObject:[NSString stringWithFormat:@"%i",[[good_num objectForKey:[dic objectForKey:@"id"]] intValue]+1] forKey:[dic objectForKey:@"id"]];
    }else{
        [good_num setObject:@"1" forKey:[dic objectForKey:@"id"]];
    }
    
    
    NSLog(@"good_num = %@",good_num);
    
    //将购买信息添加入表单(包含原价格，现价格和商品id，销量，图像，商品名称)
    //此处要保证，buyArray中得元素唯一，重复的不再添加
    if (![self.buyArray containsObject:dic]) {
        [self.buyArray addObject:dic];
    }
    //修改购买数量显示
    self.hasBuyNum.text = [NSString stringWithFormat:@"%i",[self.hasBuyNum.text intValue]+1];
    if (self.hasSaved.hidden == YES && self.totalNum.hidden == YES) {
        //显示
        self.hasBuyNum.hidden = NO;
        self.hasSaved.hidden = NO;
        self.totalNum.hidden = NO;
        [self.account setTitle:@"去结算" forState:UIControlStateNormal];
    }
    
    //已节省金额先去除￥；
    NSString * savedNum = [self.hasSaved.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"￥"]];
    NSString * totalNum = [self.totalNum.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"￥"]];
    //统计已购金额
    self.totalNum.text = [NSString stringWithFormat:@"￥%i",[[dic objectForKey:@"goodPrice"] intValue]+[totalNum intValue]];
    //统计已省下的金额
    int a = [[dic objectForKey:@"originalPrice"] intValue] - [[dic objectForKey:@"goodPrice"] intValue];
    self.hasSaved.text = [NSString stringWithFormat:@"￥%i",[savedNum intValue]+a];
}



@end
