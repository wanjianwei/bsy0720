//
//  myAccountTableViewController.m
//  BSY0720
//
//  Created by jway on 15-7-31.
//  Copyright (c) 2015年 jway. All rights reserved.
//

#import "myAccountTableViewController.h"
#import "AppDelegate.h"
#import "SDRefresh.h"
#import "accountSafeTableViewController.h"
#import "changeMyInfoViewController.h"
#import "changeSexViewController.h"
#import "changeAddressViewController.h"
#import "loginViewController.h"
@interface myAccountTableViewController ()
//设置上拉刷新
@property (nonatomic, weak) SDRefreshHeaderView *refreshHeader;
//设置一个图片选择器
@property (nonatomic,strong) UIImagePickerController * pickImageView;
@end

@implementation myAccountTableViewController
//定义一个应用程序委托类
AppDelegate * app;

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化
    app = [UIApplication sharedApplication].delegate;
    //下拉刷新
    [self setupHeader];
}


//下拉刷新
- (void)setupHeader
{
    SDRefreshHeaderView *refreshHeader = [SDRefreshHeaderView refreshView];
    // 默认是在navigationController环境下，如果不是在此环境下，请设置 refreshHeader.isEffectedByNavigationController = NO;
    [refreshHeader addToScrollView:self.tableView];
    __weak SDRefreshHeaderView *weakRefreshHeader = refreshHeader;
    refreshHeader.beginRefreshingOperation = ^{
        //界面失去响应
        self.view.userInteractionEnabled = NO;
        //获取数据
        [app.manager POST:@"http://120.25.162.238/bsy/index.php/Index/Customer/getInfo" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            //界面恢复响应
            self.view.userInteractionEnabled = YES;
            if (operation.responseData != nil) {
                //解析数据
                NSDictionary * returnDic_temp = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"info = %@",returnDic_temp);
                if ([[returnDic_temp objectForKey:@"code"] isEqualToString:@"100000"]) {
                    //提取用户个人信息
                    self.returnDic = [[returnDic_temp objectForKey:@"result"] objectForKey:@"Customer"];
                    [self.tableView reloadData];
                    [weakRefreshHeader endRefreshing];
                }else if([[returnDic_temp objectForKey:@"code"] isEqualToString:@"100001"]){
                    //请求失败
                    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:[returnDic_temp objectForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                        [weakRefreshHeader endRefreshing];
                        UIStoryboard * main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                        loginViewController * loginView = [main instantiateViewControllerWithIdentifier:@"login"];
                        loginView.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
                        [self presentViewController:loginView animated:YES completion:nil];
                    }];
                    //取消按钮
                    UIAlertAction * action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                    [alert addAction:action1];
                    [alert addAction:action2];
                    [self presentViewController:alert animated:YES completion:nil];
                }else{
                    //请求失败
                    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:[returnDic_temp objectForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                        [weakRefreshHeader endRefreshing];
                    }];
                    [alert addAction:action];
                    [self presentViewController:alert animated:YES completion:nil];
                }
            }else{
                UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请求超时，请检查网络连接是否正常" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    [weakRefreshHeader endRefreshing];
                }];
                [alert addAction:action];
                [self presentViewController:alert animated:YES completion:nil];
            }
            
        }];
    };
    // 进入页面自动加载一次数据
    [refreshHeader beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma dataSource/Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }else if (section == 1){
        return 7;
    }else{
        return 1;
    }
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"accountCell"];    //配置cell
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"头像";
            UIImageView * portrait = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-60, 10, 40, 40)];
            if ([[self.returnDic objectForKey:@"picture"] isEqual:@""]) {
                //获取本地图片
                NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString * filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"portrait.png"];
                portrait.image = [UIImage imageWithContentsOfFile:filePath];
            }else{
                portrait.image = [UIImage imageNamed:[self.returnDic objectForKey:@"picture"]];
            }
            [cell addSubview:portrait];
        }else{
            cell.textLabel.text = @"昵称";
            cell.detailTextLabel.text = [self.returnDic objectForKey:@"name"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }else if (indexPath.section == 2){
        cell.textLabel.text = @"账号安全";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else{
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"姓名";
                cell.detailTextLabel.text = [self.returnDic objectForKey:@"realname"];
                cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
                break;
            case 1:
                cell.textLabel.text = @"性别";
                if ([[self.returnDic objectForKey:@"sex"] intValue] == 0) {
                    cell.detailTextLabel.text = @"保密";
                }else if ([[self.returnDic objectForKey:@"sex"] intValue] == 1){
                    cell.detailTextLabel.text = @"男";
                }else{
                    cell.detailTextLabel.text = @"女";
                }
                cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
                break;
            case 2:
                cell.textLabel.text = @"院系";
                cell.detailTextLabel.text = [self.returnDic objectForKey:@"department"];
                cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
                break;
            case 3:
                cell.textLabel.text = @"学号";
                cell.detailTextLabel.text = [self.returnDic objectForKey:@"student_number"];
                //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                break;
            case 4:
                cell.textLabel.text = @"手机号";
                cell.detailTextLabel.text = [self.returnDic objectForKey:@"phonenum"];
                //cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
                break;
            case 5:
                cell.textLabel.text = @"证件号";
                cell.detailTextLabel.text = [self.returnDic objectForKey:@"idcard"];
                //cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
                break;
            case 6:
                cell.textLabel.text = @"收货地址";
                cell.detailTextLabel.text = [self.returnDic objectForKey:@"address"];
                cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
                break;
            default:
                break;
        }
    }
    cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:14];
    //有数据就有分割线，无数据就无分割线
    if (tableView.dataSource>0) {
        tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
        [self setExtraCellLineHidden:tableView];
    }else{
        tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    }
    return cell;
}

//去除tableView 的分割线
- (void)setExtraCellLineHidden: (UITableView *)tableView

{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 60;
        }else{
            return 40;
        }
    }else{
        return 40;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 2) {
        return 30;
    }else{
        return 15;
    }
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 2) {
        UIView * view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 30)];
        view1.backgroundColor = [UIColor clearColor];
        return view1;
    }else{
        UIView * view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 15)];
        view1.backgroundColor = [UIColor clearColor];
        return view1;
    }
}

//点击单元格跳转
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            //昵称修改页面
            UIStoryboard * main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            changeMyInfoViewController * changeView = [main instantiateViewControllerWithIdentifier:@"changeInfo"];
            changeView.flag = [NSNumber numberWithInt:1];
            [self.navigationController pushViewController:changeView animated:YES];
        }else{
            //上传头像
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"上传头像" message:@"请选择图片来源" preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"从相册中选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                //打开相册
                _pickImageView = [[UIImagePickerController alloc] init];
                _pickImageView.delegate = self;
                _pickImageView.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                _pickImageView.allowsEditing = YES;
                [self presentViewController:_pickImageView animated:YES completion:nil];
            }];
            
            UIAlertAction * action2 = [UIAlertAction actionWithTitle:@"从相机中抓取" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                //打开相机
                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                    _pickImageView = [[UIImagePickerController alloc] init];
                    _pickImageView.delegate = self;
                    _pickImageView.sourceType = UIImagePickerControllerSourceTypeCamera;
                    _pickImageView.allowsEditing = YES;
                    [self presentViewController:_pickImageView animated:YES completion:nil];
                }
            }];
            
            UIAlertAction * action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:action1];
            [alert addAction:action2];
            [alert addAction:action3];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            //修改姓名
            UIStoryboard * main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            changeMyInfoViewController * changeView = [main instantiateViewControllerWithIdentifier:@"changeInfo"];
            changeView.flag = [NSNumber numberWithInt:2];
            [self.navigationController pushViewController:changeView animated:YES];
        }else if (indexPath.row == 1) {
            //性别修改页面
            UIStoryboard * main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            changeSexViewController * sexView =  [main instantiateViewControllerWithIdentifier:@"changeSex"];
            [self.navigationController pushViewController:sexView animated:YES];
        }else if (indexPath.row == 2){
            //院系修改页面
            UIStoryboard * main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            changeMyInfoViewController * changeView = [main instantiateViewControllerWithIdentifier:@"changeInfo"];
            changeView.flag = [NSNumber numberWithInt:3];
            [self.navigationController pushViewController:changeView animated:YES];
        }else if (indexPath.row == 6){
            //进入收货地址修改页面
            UIStoryboard * main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            changeAddressViewController * changeAdd = [main instantiateViewControllerWithIdentifier:@"changeAddress"];
            [self.navigationController pushViewController:changeAdd animated:YES];
        }
        
    }else{
        //跳转进入账户安全界面
        UIStoryboard * main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        accountSafeTableViewController * safeView = [main instantiateViewControllerWithIdentifier:@"accountSafe"];
        [self.navigationController pushViewController:safeView animated:YES];
    }
}

#pragma UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    //获取原图片，并压缩上传
    UIImage * originalImage = (UIImage *) [info objectForKey:UIImagePickerControllerOriginalImage];
    //将图片缓存在本地
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //注意文件名后面要加后缀，表示类型
    NSString * filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"portrait.png"];
    //存入本地
    [UIImagePNGRepresentation(originalImage) writeToFile:filePath atomically:YES];
    picker.delegate = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

@end
