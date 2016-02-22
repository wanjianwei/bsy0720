//
//  yueBaTableViewController.m
//  BSY0720
//
//  Created by jway on 15-7-31.
//  Copyright (c) 2015年 jway. All rights reserved.
//

#import "yueBaTableViewController.h"
#import "SDRefresh.h"
#import "AppDelegate.h"
#import "findTableCell.h"
#import "subjectViewController.h"
#import "publishViewController.h"
#import "loginViewController.h"
@interface yueBaTableViewController ()
//上拉刷新与下拉加载
@property (nonatomic, weak) SDRefreshFooterView *refreshFooter;
//@property (nonatomic, weak) SDRefreshHeaderView *refreshHeader;
//定义导航栏右边按钮
@property (nonatomic, strong)  UIBarButtonItem * rightBtn;
@end

@implementation yueBaTableViewController
//定义一个协议委托类
AppDelegate * app;
//定义一个分页
int flag;

- (void)viewDidLoad {
    [super viewDidLoad];
    //自定义导航栏
    self.rightBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"publish.png"] style:UIBarButtonItemStyleDone target:self action:@selector(publish)];
    self.navigationItem.rightBarButtonItem = self.rightBtn;
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor grayColor];
    //单元格的分割线模式
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //初始化程序委托类
    app = [UIApplication sharedApplication].delegate;
    self.infoArray = [[NSMutableArray alloc] init];
    flag = 0;
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
    __weak SDRefreshHeaderView *weakRefreshHeader = refreshHeader;
    refreshHeader.beginRefreshingOperation = ^{
        //导航栏及界面失去响应
        self.navigationItem.rightBarButtonItem = nil;
        self.view.userInteractionEnabled = YES;
        //构造发送数据
        NSDictionary * sendic;
        if ([self.flag intValue] ==1) {
            sendic = [NSDictionary dictionaryWithObjectsAndKeys:@"3",@"category_id",@"5",@"num",[NSString stringWithFormat:@"%i",flag],@"page", nil];
        }else{
            sendic = [NSDictionary dictionaryWithObjectsAndKeys:@"2",@"category_id",@"5",@"num",[NSString stringWithFormat:@"%i",flag],@"page", nil];
        }
        //若数据为空，刷新
        if (self.infoArray.count == 0) {
            
            [app.manager POST:@"http://120.25.162.238/bsy/index.php/Index/Blog/getBlogList" parameters:sendic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                //
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                //请求成功
                self.navigationItem.rightBarButtonItem = self.rightBtn;
                self.view.userInteractionEnabled = YES;
                //停止刷新
                [weakRefreshHeader endRefreshing];
                
                NSDictionary * getdic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
                
                if ([[getdic objectForKey:@"code"] isEqualToString:@"100000"]) {
                    //加载数据
                    [self.infoArray addObjectsFromArray:[[getdic objectForKey:@"result"] objectForKey:@"Blog.List"]];
                    //分页控件刷新固定为1
                    flag = 1;
                    [self.tableView reloadData];
                }else if([[getdic objectForKey:@"code"] isEqualToString:@"100001"]){
                    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请先登录" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction * action = [UIAlertAction actionWithTitle:@"提示" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                        UIStoryboard * main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                        loginViewController * loginView = [main instantiateViewControllerWithIdentifier:@"login"];
                        loginView.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
                        [self presentViewController:loginView animated:YES completion:nil];
                    }];
                    [alert addAction:action];
                    [self presentViewController:alert animated:YES completion:nil];
                }else{
                    //请求失败
                    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[getdic objectForKey:@"message"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                }
                
                NSLog(@"%@",getdic);
            }];

        }else{
            [weakRefreshHeader endRefreshing];
        }
        
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
    
    //导航栏及界面失去响应
    self.navigationItem.rightBarButtonItem = nil;
    self.view.userInteractionEnabled = YES;
    //构造发送数据
    NSDictionary * sendic;
    if ([self.flag intValue] ==1) {
        sendic = [NSDictionary dictionaryWithObjectsAndKeys:@"3",@"category_id",@"5",@"num",[NSString stringWithFormat:@"%i",flag],@"page", nil];
    }else{
        sendic = [NSDictionary dictionaryWithObjectsAndKeys:@"2",@"category_id",@"5",@"num",[NSString stringWithFormat:@"%i",flag],@"page", nil];
    }
    
    [app.manager POST:@"http://120.25.162.238/bsy/index.php/Index/Blog/getBlogList" parameters:sendic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //请求成功
        self.navigationItem.rightBarButtonItem = self.rightBtn;
        self.view.userInteractionEnabled = YES;
        //停止刷新
        [_refreshFooter endRefreshing];
        NSDictionary * getdic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        if ([[getdic objectForKey:@"code"] isEqualToString:@"100000"]) {
            //加载数据
            [self.infoArray addObjectsFromArray:[[getdic objectForKey:@"result"] objectForKey:@"Blog.List"]];
            flag++;
            [self.tableView reloadData];
        }else if([[getdic objectForKey:@"code"] isEqualToString:@"100000"]){
            UIStoryboard * main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            loginViewController * loginView = [main instantiateViewControllerWithIdentifier:@"login"];
            loginView.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            [self presentViewController:loginView animated:YES completion:nil];
        }else{
            //购买失败
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[getdic objectForKey:@"message"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    }];

    
}

//发布信息
-(void)publish{
    UIStoryboard * main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    publishViewController * pubView = [main instantiateViewControllerWithIdentifier:@"publishView"];
    pubView.title = @"发布";
    if ([self.flag intValue] == 1) {
        //约吧
        pubView.flag = [NSNumber numberWithInt:1];
    }else{
        //精彩活动
        pubView.flag = [NSNumber numberWithInt:3];
    }
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
    
    findTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"yuebaCell"];
    
    NSDictionary*dic = [self.infoArray objectAtIndex:indexPath.section];
    //头像
    cell.portrait.image = [UIImage imageNamed:@"portrait"];
    //设置时间
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:[[dic objectForKey:@"time"] intValue]];
    cell.time.text = [formatter stringFromDate:date];
    //用户名
    cell.username.text = [dic objectForKey:@"name"];
    
    //博客图片
    //此处图片必须缓存，并且异步加载
    NSFileManager * fm = [NSFileManager defaultManager];
    NSArray * fileArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * filetemp = [fileArray objectAtIndex:0];
    NSString * filePath = [filetemp stringByAppendingPathComponent:[NSString stringWithFormat:@"blogImg_%@.jpg",[dic objectForKey:@"blog_id"]]];
    if ([fm fileExistsAtPath:filePath]) {
        //如果缓存存在
        cell.image.image = [UIImage imageWithContentsOfFile:filePath];
    }else{
        //缓存不存在
        //异步缓存图片
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            //从网络获取图像数据
            NSData * data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[dic objectForKey:@"picture"]]];
            //将网络数据初始化为UIImage对象
            UIImage * image = [[UIImage alloc] initWithData:data];
            if (image != nil) {
                //存入本地缓存，成功就重载数据
                if([UIImageJPEGRepresentation(image, 0.5) writeToFile:filePath atomically:YES]){
                    //返回主线程
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.tableView reloadData];
                    });
                }
                
            }
        });
    }
   // cell.image.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[dic objectForKey:@"picture"]]]];
    cell.praiseNum.text = [dic objectForKey:@"praise_count"];
    cell.commentNum.text = [dic objectForKey:@"comment_count"];
    
    //content的内容是不固定的。对应label的高度应当动态改变
    cell.content.text = [dic objectForKey:@"summary"];
    
    //点赞及评论tag设置为动态的id，以便于记住
    cell.praise.tag = [[dic objectForKey:@"blog_id"] intValue];
    cell.comment.tag = [[dic objectForKey:@"blog_id"] intValue];
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
    NSString * content = [[self.infoArray objectAtIndex:indexPath.section] objectForKey:@"summary"];
    CGRect rect = [content boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width-98, 500) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:14]} context:nil];
    CGFloat height = rect.size.height-72;
    //返回单元格的高度
    return height+270;
}

//点击单元格跳转
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //跳转需要将id传递给下一个界面，以作为其请求数据
    //此处只是作为测试
    UIStoryboard * main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    subjectViewController * subjectView = [main instantiateViewControllerWithIdentifier:@"subjectView"];
    subjectView.title = @"话题详情";
    //subjectView.hidesBottomBarWhenPushed = NO;
    [self.navigationController pushViewController:subjectView animated:YES];
}

@end
