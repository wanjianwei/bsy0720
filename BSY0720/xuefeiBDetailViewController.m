//
//  xuefeiBDetailViewController.m
//  BSY0720
//
//  Created by jway on 15-7-26.
//  Copyright (c) 2015年 jway. All rights reserved.
//

#import "xuefeiBDetailViewController.h"
#import "AppDelegate.h"
@interface xuefeiBDetailViewController (){
    //定义两个数组
    NSArray * array1;
    NSArray * array2;
    //用来存放计算的“需购买金额”
    int totalNum;
    //用来存放预期减免金额
    NSString * beginNum;
    //定义应用程序委托
    AppDelegate * app;
}

@end

@implementation xuefeiBDetailViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // 指定代理
    self.detailList.dataSource = self;
    self.detailList.delegate = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"学费宝详情";
    //修饰按钮外观
    self.invest.layer.cornerRadius = 5.0f;

    //判断是几年的学费宝
    if ([self.flag intValue] ==1) {
        array1 = [NSArray arrayWithObjects:@"学费宝（1年）",@"预期年化收益率",@"期限",@"起息日",@"结算周期",@"预期减免学费金额",@"需购买金额", nil];
       // array2 = [NSArray arrayWithObjects:@"",@"8%",@"1年",@"成交日+1天",@"自然日(365天)",nil];
        
    }else if ([self.flag intValue] ==2){
        array1 = [NSArray arrayWithObjects:@"学费宝（2年）",@"预期年化收益率",@"期限",@"起息日",@"结算周期",@"预期减免学费金额",@"需购买金额", nil];
       // array2 = [NSArray arrayWithObjects:@"",@"9%",@"2年",@"成交日+1天",@"自然日(365天)",nil];
    }else{
        array1 = [NSArray arrayWithObjects:@"学费宝（3年）",@"预期年化收益率",@"期限",@"起息日",@"结算周期",@"预期减免学费金额",@"需购买金额", nil];
       // array2 = [NSArray arrayWithObjects:@"",@"10%",@"3年",@"成交日+1天",@"自然日(365天)",nil];
    }
    totalNum = 0;
    beginNum = @"";
    //初始化
    app = [UIApplication sharedApplication].delegate;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//立即投资
- (IBAction)invest:(id)sender {
    //先判断是否已填写购买金额
    if (totalNum == 0) {
        //弹出提示
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先选择购买金额" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }else if (totalNum>[[[NSUserDefaults standardUserDefaults] objectForKey:@"balance"] floatValue]){
        //投资金额大于可用余额
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"投资金额大于可用余额" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
    }else{
        //直接弹出支付密码
        ZCTradeView * pwdInput = [[ZCTradeView alloc] init];
        pwdInput.delegate = self;
        [pwdInput show];
    }
    
}
#pragma ZCTradeViewDelegate
-(NSString*)finish:(NSString *)pwd{
    //构造发送数据
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:[self.transDic objectForKey:@"product_id"],@"product_id",[NSString stringWithFormat:@"%i",totalNum],@"sum",pwd,@"trade_pass", nil];
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
                float a = [[[NSUserDefaults standardUserDefaults] objectForKey:@"balance"] floatValue] - totalNum;
                //更新本地的账户余额
                [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f",a] forKey:@"balance"];
                
                //更新学费宝金额
                float b = [[[NSUserDefaults standardUserDefaults] objectForKey:@"xuefei"] floatValue]+totalNum;
                //更新学费宝投资金额
                [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f",b] forKey:@"xuefei"];
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
    //支付
    return pwd;
}
#pragma dataSource/delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 7;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"detailCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"detailCell"];
    }
    
    
    cell.textLabel.text = [array1 objectAtIndex:indexPath.row];
    if (indexPath.row == 0) {
        cell.textLabel.textColor = [UIColor blueColor];
    }else if (indexPath.row == 1){
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%4.2f%%",[[self.transDic objectForKey:@"yield"] floatValue]*100];
    }else if (indexPath.row == 2){
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[self.transDic objectForKey:@"duration"]];
    }else if (indexPath.row == 3){
        cell.detailTextLabel.text = @"成交日+1";
    }else if (indexPath.row == 4){
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[self.transDic objectForKey:@"cycle"]];
    }else if (indexPath.row == 5){
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.detailTextLabel.text = beginNum;
    }else{
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%i元",totalNum];
    }

    //修饰字体大小
    if (indexPath.row !=0) {
        cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
    }
    cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:15];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 5) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择学费金额" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"5000元/年" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            beginNum = @"5000元/年";
            totalNum = 10000;
            [self.detailList reloadData];
        }];
        UIAlertAction * action2 = [UIAlertAction actionWithTitle:@"8000元/年" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            beginNum = @"8000元/年";
            totalNum = 20000;
            [self.detailList reloadData];
        }];
        
        UIAlertAction * action3 = [UIAlertAction actionWithTitle:@"10000元/年" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            beginNum = @"10000元/年";
            totalNum = 30000;
            [self.detailList reloadData];
        }];
        
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action1];
        [alert addAction:action2];
        [alert addAction:action3];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

@end
