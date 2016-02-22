//
//  changeAddressViewController.m
//  BSY0720
//
//  Created by jway on 15-8-3.
//  Copyright (c) 2015年 jway. All rights reserved.
//

#import "changeAddressViewController.h"
#import "AppDelegate.h"
#import "loginViewController.h"
#import "TFIndicatorView.h"
@interface changeAddressViewController (){
    AppDelegate * app;
    //收货人输入框
    UITextField * name;
    //手机号输入框
    UITextField * phonenum;
    //所在地区输入框
    UITextField * city;
    //详细地址输入框
    UITextField * details;
    //邮编输入框
    UITextField * postcode;
    //定义一个字典类型数据，用于接收服务器返回数据
    NSDictionary * returnDic;
    //定义一个活动指示器
    TFIndicatorView * TFIndicator;
    //定义一个标志，用来判断是编辑操作还是保存操作
    int flag;
}

@end

@implementation changeAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    //初始化
    self.inputList.dataSource = self;
    self.inputList.delegate = self;
    //默认是查看地址，不可修改
    self.inputList.userInteractionEnabled = NO;
    self.title = @"修改地址";
    
    //初始化
    app = [UIApplication sharedApplication].delegate;
    flag = 0;
    //构建活动指示器
    TFIndicator = [[TFIndicatorView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-25, self.inputList.frame.size.height/2-25, 50, 50)];
    [self.inputList addSubview:TFIndicator];
    [TFIndicator startAnimating];
    //向服务器请求数据
    [app.manager POST:@"http://120.25.162.238/bsy/index.php/Index/Address/getAddress" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //关闭活动指示器
        TFIndicator.hidden = YES;
        if (operation.responseData != nil) {
            NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
            if ([[dic objectForKey:@"code"] isEqualToString:@"100000"]) {
                returnDic = [[dic objectForKey:@"result"] objectForKey:@"Address"];
                [self.inputList reloadData];
            }else if([[dic objectForKey:@"code"] isEqualToString:@"100001"]){
                //请先登录
                UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请先登录" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    UIStoryboard * main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    loginViewController * loginView = [main instantiateViewControllerWithIdentifier:@"login"];
                    loginView.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
                    [self presentViewController:loginView animated:YES completion:nil];
                }];
                UIAlertAction * action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                [alert addAction:action1];
                [alert addAction:action2];
                [self presentViewController:alert animated:YES completion:nil];
            }else{
                //请求收货地址失败
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"收货地址尚未设置" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
        }else{
            //请求服务器出错
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"请求超时" message:@"请检查网络连接是否正常" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    }];
    
    //定义一个手势处理器
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handTap)];
    tap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//关闭键盘
-(void)handTap{
    [name resignFirstResponder];
    [phonenum resignFirstResponder];
    [city resignFirstResponder];
    [details resignFirstResponder];
    [postcode resignFirstResponder];
}

//保存操作
- (IBAction)save:(id)sender {
     UIButton * btn = (UIButton *)sender;
    if (flag == 0) {
        //编辑
        btn = (UIButton *)sender;
        [btn setTitle:@"保存" forState:UIControlStateNormal];
        //表示图恢复可编辑
        self.inputList.userInteractionEnabled = YES;
        flag = 1;
    }else{
        //先对填写的信息进行判断
        TFIndicator.hidden = NO;
        //请求服务器时，按钮失去响应
        btn.userInteractionEnabled = NO;
        //保存操作，构造请求数据
        NSDictionary * send = [NSDictionary dictionaryWithObjectsAndKeys:name.text,@"name",phonenum.text,@"phonenum",postcode.text,@"postcode",details.text,@"details",city.text,@"area",@"1",@"type", nil];
        //发送给服务器
        [app.manager POST:@"http://120.25.162.238/bsy/index.php/Address/modifyAddress" parameters:send success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            //请求服务器成功了
            TFIndicator.hidden = YES;
            btn.userInteractionEnabled = YES;
            [btn setTitle:@"编辑" forState:UIControlStateNormal];
            flag = 0;
            //判断操作是否成功
            NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
            if ([[dic objectForKey:@"code"] isEqualToString:@"100000"]) {
                //保存操作成功,禁止修改
                UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"信息修改保存成功" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    //self.inputList.userInteractionEnabled = NO;
                    [self.navigationController popViewControllerAnimated:YES];
                }];
                [alert addAction:action];
                [self presentViewController:alert animated:YES completion:nil];
            }else{
                //保存操作失败
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[dic objectForKey:@"message"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
        }];
        
    }
}



#pragma dataSource/delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [[UITableViewCell alloc] init];
    if (indexPath.row == 0) {
        cell.textLabel.text = @"收货人";
        //定义收货人输入框
        name = [[UITextField alloc] initWithFrame:CGRectMake(90, 12, [UIScreen mainScreen].bounds.size.width-106, 20)];
        name.delegate = self;
        name.text = [returnDic objectForKey:@"name"];
        name.textAlignment = NSTextAlignmentLeft;
        name.font = [UIFont boldSystemFontOfSize:15];
        [cell addSubview:name];
    }else if (indexPath.row == 1){
        cell.textLabel.text = @"手机号";
        //定义手机号输入框
        phonenum = [[UITextField alloc] initWithFrame:CGRectMake(90, 12, [UIScreen mainScreen].bounds.size.width-106, 20)];
        phonenum.delegate = self;
        phonenum.text = [returnDic objectForKey:@"phonenum"];
        phonenum.textAlignment = NSTextAlignmentLeft;
        phonenum.font = [UIFont boldSystemFontOfSize:15];
        [cell addSubview:phonenum];
    }else if (indexPath.row == 2){
        cell.textLabel.text = @"所在地区";
        //定义所在地区输入框
        city = [[UITextField alloc] initWithFrame:CGRectMake(90, 12, [UIScreen mainScreen].bounds.size.width-106, 20)];
        city.delegate = self;
        city.text = [returnDic objectForKey:@"area"];
        city.textAlignment = NSTextAlignmentLeft;
        city.font = [UIFont boldSystemFontOfSize:15];
        [cell addSubview:city];
    }else if (indexPath.row == 3){
        cell.textLabel.text = @"详细地址";
        //定义详细地址输入框
        details = [[UITextField alloc] initWithFrame:CGRectMake(90, 12, [UIScreen mainScreen].bounds.size.width-106, 20)];
        details.delegate = self;
        details.text = [returnDic objectForKey:@"details"];
        details.textAlignment = NSTextAlignmentLeft;
        details.font = [UIFont boldSystemFontOfSize:15];
        [cell addSubview:details];
    }else{
        cell.textLabel.text = @"邮政编码";
        //定义邮政编码输入框
        postcode = [[UITextField alloc] initWithFrame:CGRectMake(90, 12, [UIScreen mainScreen].bounds.size.width-106, 20)];
        postcode.delegate = self;
        postcode.text = [returnDic objectForKey:@"postcode"];
        postcode.textAlignment = NSTextAlignmentLeft;
        postcode.font = [UIFont boldSystemFontOfSize:15];
        [cell addSubview:postcode];
    }
    //取消选中时候的高亮状态
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
    return cell;
}


#pragma UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
@end
