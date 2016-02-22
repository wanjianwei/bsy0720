//
//  findTableViewController.m
//  BSY0720
//
//  Created by jway on 15-7-31.
//  Copyright (c) 2015年 jway. All rights reserved.
//

#import "findTableViewController.h"
#import "AppDelegate.h"
#import "SDRefresh.h"
#import "findTableCell.h"
#import "subjectViewController.h"
#import "publishViewController.h"
@interface findTableViewController ()
//上拉刷新与下拉加载
@property (nonatomic, weak) SDRefreshFooterView *refreshFooter;
//@property (nonatomic, weak) SDRefreshHeaderView *refreshHeader;
//定义导航栏右边按钮
@property (nonatomic, strong)  UIBarButtonItem * rightBtn;
@end

@implementation findTableViewController
//定义一个协议委托类
AppDelegate * app;

- (void)viewDidLoad {
    [super viewDidLoad];
    //tableview分隔符
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    //自定义UIbarbuttonItem
    self.rightBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"publish.png"] style:UIBarButtonItemStyleDone target:self action:@selector(publish)];
    self.navigationItem.rightBarButtonItem = self.rightBtn;
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor grayColor];
    self.title = @"发现";
      //初始化程序委托类
    app = [UIApplication sharedApplication].delegate;
    //初始化可变数组
    self.infoArray = [[NSMutableArray alloc] initWithObjects:nil, nil];
    //设置上拉刷新与下拉加载
    [self setupHeader];
    [self setupFooter];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//下拉刷新
- (void)setupHeader
{
    SDRefreshHeaderView *refreshHeader = [SDRefreshHeaderView refreshView];
    
    // 默认是在navigationController环境下，如果不是在此环境下，请设置 refreshHeader.isEffectedByNavigationController = NO;
    [refreshHeader addToScrollView:self.tableView];
    
    //这里是为了造成循环引用
    
    __weak SDRefreshHeaderView *weakRefreshHeader = refreshHeader;
    refreshHeader.beginRefreshingOperation = ^{
        //界面失去响应
        self.view.userInteractionEnabled = NO;
        self.navigationItem.rightBarButtonItem = nil; //按钮也消失
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //界面恢复响应
            self.view.userInteractionEnabled = YES;
            self.navigationItem.rightBarButtonItem = self.rightBtn;  //按钮出现
            for (int i =0; i<5; i++) {
                [self.infoArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"portrait.png",@"portrait",@"wanjianwei",@"username",@"2015-12-23",@"time",@"菜单项可自定义，由数组组成3423rthdrtd3434563456234623463454562456",@"content",@"main_ad.png",@"image",@"123",@"praiseNum",@"23",@"commentNum",@"14",@"id", nil]];
            }
            [self.tableView reloadData];
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
    [refreshFooter addToScrollView:self.tableView];
    [refreshFooter addTarget:self refreshAction:@selector(footerRefresh)];
    _refreshFooter = refreshFooter;
    
}

//再次向服务器请求数据，并重新加载
-(void)footerRefresh{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.infoArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"portrait.png",@"portrait",@"wanjianwei",@"username",@"2015-12-23",@"time",@"菜单项可自定23462546re阿斯顿发噶的时候嘎多喝水噶阿萨德了噶是的哈嘎色的格拉维的概率是豆腐干啥都发过来水电费色的供货商的分公司的规划三娃儿我二哥好失望的让他感受到了更好身体还告诉我的更好的头发2gertw45t5twq3445义，由数组组成",@"content",@"main_ad.png",@"image",@"123",@"praiseNum",@"23",@"commentNum",@"23",@"id", nil]];
        [self.tableView reloadData];
        [self.refreshFooter endRefreshing];
    });
    
}
//发布信息
-(void)publish{
    UIStoryboard * main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    publishViewController * pubView = [main instantiateViewControllerWithIdentifier:@"publishView"];
    pubView.title = @"发布";
    pubView.flag = [NSNumber numberWithInt:4];
    pubView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:pubView animated:YES];
}

#pragma mark - dataSource/Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.infoArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
//配置cell
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    findTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"findTableCell"];
    
    NSDictionary*dic = [self.infoArray objectAtIndex:indexPath.section];
    cell.portrait.image = [UIImage imageNamed:[dic objectForKey:@"portrait"]];
    cell.time.text = [dic objectForKey:@"time"];
    cell.username.text = [dic objectForKey:@"username"];
    cell.image.image = [UIImage imageNamed:[dic objectForKey:@"image"]];
    cell.praiseNum.text = [dic objectForKey:@"praiseNum"];
    cell.commentNum.text = [dic objectForKey:@"commentNum"];
    
    //content的内容是不固定的。对应label的高度应当动态改变
    cell.content.text = [dic objectForKey:@"content"];
    
    //点赞及评论tag设置为动态的id，以便于记住
    cell.praise.tag = [[dic objectForKey:@"id"] intValue];
    cell.comment.tag = [[dic objectForKey:@"id"] intValue];
    return cell;
}

//单元格间距
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

//构造footer
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView*view = [[UIView alloc] initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, 10)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //动态计算单元格的高度
    NSString * content = [[self.infoArray objectAtIndex:indexPath.section] objectForKey:@"content"];
    CGRect rect = [content boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width-98, 500) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:14]} context:nil];
    CGFloat height = rect.size.height-75;
    //返回单元格的高度
    return height+270;
}

//点击单元格跳转页面
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //跳转需要将id传递给下一个界面，以作为其请求数据
    //此处只是作为测试
    UIStoryboard * main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    subjectViewController * subjectView = [main instantiateViewControllerWithIdentifier:@"subjectView"];
    subjectView.title = @"话题详情";
    subjectView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:subjectView animated:YES];
}

@end
