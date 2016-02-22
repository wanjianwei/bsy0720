//
//  setUpTableViewController.m
//  BSY0720
//
//  Created by jway on 15-7-30.
//  Copyright (c) 2015年 jway. All rights reserved.
//

#import "setUpTableViewController.h"
#import "aboutUsViewController.h"
#import "noticeTableViewController.h"
#import "AppDelegate.h"
#import "tabViewController.h"
#import "SDRefresh.h"
@interface setUpTableViewController (){
    //定义应用程序委托类
    AppDelegate * app;
}

@end

@implementation setUpTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置tableview的分割线样式
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.title = @"设置";
    //初始化
    app = [UIApplication sharedApplication].delegate;
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"setUpCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"setUpCell"];
    }
    
    if (indexPath.section == 0) {
        cell.textLabel.text = @"消息管理";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else if (indexPath.section == 1){
        cell.textLabel.text = @"关于我们";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else if (indexPath.section == 2){
        cell.textLabel.text = @"版本检测";
        cell.detailTextLabel.text = @"最新版本";
    }else{
        cell.textLabel.text = @"退出登录";
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
//header高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 6;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 6)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

//点击单元格跳转
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (app.Rea_manager.reachable == YES) {
            //跳转到我的消息
            UIStoryboard * main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            noticeTableViewController * noticeView = [main instantiateViewControllerWithIdentifier:@"noticeTable"];
            [self.navigationController pushViewController:noticeView animated:YES];
        }else{
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请检查网络连接是否正常" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    }else if (indexPath.section == 1){
        //跳转到关于我们
        UIStoryboard * main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        aboutUsViewController * aboutUsView = [main instantiateViewControllerWithIdentifier:@"aboutUs"];
        [self.navigationController pushViewController:aboutUsView animated:YES];
    }else if (indexPath.section == 2){
        
    }else{
        //退出
        [app.manager POST:@"http://120.25.162.238/bsy/index.php/Index/Customer/logout" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (operation.responseData != nil) {
                //解析数据
                NSDictionary * returnDic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"re = %@",returnDic);
                
                if ([[returnDic objectForKey:@"code"] isEqualToString:@"100000"]) {
                    //退出成功
                    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:0] forKey:@"state"];
                    //返回tabController首页
                    UIStoryboard * main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    tabViewController * tabView = [main instantiateViewControllerWithIdentifier:@"tabBar"];
                    tabView.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                    [self presentViewController:tabView animated:YES completion:nil];
                    
                }else{
                    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"退出操作失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                }
            }
        }];
    }
}
@end
