//
//  zhuxueBDetailViewController.m
//  BSY0720
//
//  Created by jway on 15-7-26.
//  Copyright (c) 2015年 jway. All rights reserved.
//

#import "zhuxueBDetailViewController.h"
#import "AppDelegate.h"
@interface zhuxueBDetailViewController (){
    //定义一个协议委托类
    AppDelegate * app;
    //定义两个数组
    NSArray * array1;
    NSArray * array2;
    //自定义视图
    UIView * inputView;
    //输入框
    UITextField * inputField;
}


@end

@implementation zhuxueBDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //导航栏
    self.title = @"助学宝详情";
    self.automaticallyAdjustsScrollViewInsets = NO;
    // 指定协议代理
    self.detailList.dataSource = self;
    self.detailList.delegate =self;
    //自定义一个视图
    //代码构建文字输入框
    inputView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-50, [UIScreen mainScreen].bounds.size.width, 50)];
    inputView.backgroundColor = [UIColor colorWithRed:233/255 green:236/266 blue:236/233 alpha:0.1];
    //添加“立即投资”按钮
    UIButton * sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(inputView.frame)-100, 10, 90, 30)];
    sendBtn.layer.cornerRadius = 4.0f;
    sendBtn.backgroundColor = [UIColor orangeColor];
    [sendBtn setTitle:@"立即投资" forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [sendBtn addTarget:self action:@selector(investNow) forControlEvents:UIControlEventTouchUpInside];
    [inputView addSubview:sendBtn];
    
    //添加输入框
    inputField = [[UITextField alloc] initWithFrame:CGRectMake(20, 10, [UIScreen mainScreen].bounds.size.width-135, 30)];
    inputField.backgroundColor = [UIColor whiteColor];
    inputField.borderStyle = UITextBorderStyleRoundedRect;
    inputField.delegate =self;
    inputField.keyboardType = UIKeyboardTypeDecimalPad;
    [inputView addSubview:inputField];
    //初始化数组
    if ([self.flag intValue] == 1) {
        array1 = [NSArray arrayWithObjects:@"助学宝（12个月）",@"预期年化收益率",@"期限",@"起息日",@"结算周期",@"起投金额", nil];
       // array2 = [NSArray arrayWithObjects:@"",@"6.0%",@"12个月",@"成交日+1天",@"每月20日",@"5000元", nil];
    }else if ([self.flag intValue] == 2){
        array1 = [NSArray arrayWithObjects:@"助学宝（24个月）",@"预期年化收益率",@"期限",@"起息日",@"结算周期",@"起投金额", nil];
      //  array2 = [NSArray arrayWithObjects:@"",@"7.0%",@"24个月",@"成交日+1天",@"每月20日",@"5000元", nil];
    }else{
        array1 = [NSArray arrayWithObjects:@"助学宝（36个月）",@"预期年化收益率",@"期限",@"起息日",@"结算周期",@"起投金额", nil];
      //  array2 = [NSArray arrayWithObjects:@"",@"8.0%",@"36个月",@"成交日+1天",@"每月20日",@"5000元", nil];
    }
    
    //注册一个手势处理器,用于关闭键盘
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handTap)];
    tap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tap];
    
    
    //初始化程序委托类
    app = [UIApplication sharedApplication].delegate;
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
    [self.view insertSubview:inputView aboveSubview:self.detailList];
    //注册键盘出现与隐藏通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

//立即投资
-(void)investNow{
    
    if ([inputField.text intValue]<5000) {
        //提示
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"投资金额需大于起投金额" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"balance"] floatValue]< [inputField.text floatValue]){
        //投资金额要小于自己的余额
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"投资金额需要小于可用余额" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        //先关闭键盘
        [inputField resignFirstResponder];
        //直接弹出支付密码
        ZCTradeView * pwdInput = [[ZCTradeView alloc] init];
        pwdInput.delegate = self;
        [pwdInput show];
    }
    
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

//关闭键盘
-(void)handTap{
    [inputField resignFirstResponder];
}

#pragma ZCTradeViewDelegate
-(NSString*)finish:(NSString *)pwd{
    
    //构造发送数据
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:[self.transDic objectForKey:@"product_id"],@"product_id",inputField.text,@"sum",pwd,@"trade_pass", nil];
    
    //发送服务器
    [app.manager POST:@"http://120.25.162.238/bsy/index.php/Index/Finance/buyProduct" parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //接受服务器返回数据
        NSDictionary * returnDic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        if ([[returnDic objectForKey:@"code"] isEqualToString:@"100000"]) {
            //购买成功
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:[returnDic objectForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                float a = [[[NSUserDefaults standardUserDefaults] objectForKey:@"balance"] floatValue] - [inputField.text floatValue];
                //更新本地的账户余额
                [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f",a] forKey:@"balance"];
                
                //更新助学宝
                float b = [[[NSUserDefaults standardUserDefaults] objectForKey:@"zhuxue"] floatValue]+[inputField.text floatValue];
                
                [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f",b] forKey:@"zhuxue"];
                
                //返回上一页
                [self.navigationController popViewControllerAnimated:YES];
        
            }];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        }else{
            //购买失败
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[returnDic objectForKey:@"message"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    }];
    
    return pwd;
}

#pragma UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


#pragma dataSource/delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"zhuxueCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"zhuxueCell"];
    }
    cell.textLabel.text = [array1 objectAtIndex:indexPath.row];
    if (indexPath.row == 1) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%4.2f%%",[[self.transDic objectForKey:@"yield"] floatValue]*100];
    }else if (indexPath.row == 2){
        cell.detailTextLabel.text = [self.transDic objectForKey:@"duration"];
    }else if (indexPath.row == 3){
        cell.detailTextLabel.text = @"成交日+1天";
    }else if (indexPath.row == 4){
        cell.detailTextLabel.text = [self.transDic objectForKey:@"cycle"];
    }else{
        cell.detailTextLabel.text = @"5000元";
    }
    //颜色和字体
    if (indexPath.row == 0) {
        cell.textLabel.textColor = [UIColor blueColor];
    }else{
        cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:15];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
    }
    return cell;
}


@end
