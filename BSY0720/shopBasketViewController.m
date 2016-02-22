//
//  shopBasketViewController.m
//  BSY0720
//
//  Created by jway on 15-8-4.
//  Copyright (c) 2015年 jway. All rights reserved.
//

#import "shopBasketViewController.h"
#import "AppDelegate.h"
#import "orderSucViewController.h"
#import "changeAddressViewController.h"
@interface shopBasketViewController (){
    //定义应用程序代理
    AppDelegate * app;
    //定义一个字典，用来存放收货地址
    NSDictionary * address;
    //定义一个字典，用来存放订单信息
    NSArray * orderInfo;
}

@end

@implementation shopBasketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //指定协议代理
    self.goodList.dataSource = self;
    self.goodList.delegate = self;
    //禁止自动调整size
    self.automaticallyAdjustsScrollViewInsets = NO;
    //初始化
    app = [UIApplication sharedApplication].delegate;
    //求出所购商品的总价格
    self.totalNum.text = [NSString stringWithFormat:@"%i元",[self getTotalNum]];
    //定义一个返回按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(back_now)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//返回操作
-(void)back_now{
    //弹出提示，是否放弃本次交易
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否放弃本次交易" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self dismissViewControllerAnimated:YES completion:^{
            //
        }];
    }];
    UIAlertAction * action2 = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDefault handler:nil];
    
    [alert addAction:action1];
    [alert addAction:action2];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)pay:(id)sender {
    //先判断是否网络可用
    if (app.Rea_manager.reachable == YES) {
        if ([self.totalNum.text intValue] > 0) {
            //先获取用户提交的地址，如果用户未设置，则先跳转到地址设置页面
            [app.manager POST:@"http://120.25.162.238/bsy/index.php/Index/Address/getAddress" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                //获取服务器数据
                NSDictionary * getDic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
                
                if ([[getDic objectForKey:@"code"] isEqualToString:@"100000"]) {
                    //存储地址
                    address = [NSDictionary dictionaryWithDictionary:[[getDic objectForKey:@"result"] objectForKey:@"Address"]];
                    //提交订单给服务器
                    [app.manager POST:@"http://120.25.162.238/bsy/index.php/Index/Order/submitOrderForward" parameters:[self makeSendDic] success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        //
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        //解析数据
                        NSDictionary * getDic1 = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
                        if ([[getDic1 objectForKey:@"code"] isEqualToString:@"100000"]) {
                            //存放订单信息
                            orderInfo = [[getDic1 objectForKey:@"result"] objectForKey:@"Order.List"];
                            //弹出支付密码
                            ZCTradeView * pwdInput = [[ZCTradeView alloc] init];
                            pwdInput.delegate = self;
                            [pwdInput show];
                        }else{
                            //提交订单失败
                            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[getDic1 objectForKey:@"message"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                            [alert show];
                        }
                      //  NSLog(@"getDic1 = %@",getDic1);
                        
                    }];
                    
                   // NSLog(@"senddic = %@",[self makeSendDic]);
                    
                }else{
                    //收货地址未设置
                    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您目前尚未设置收货地址" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                        //跳转到修改地址界面
                        UIStoryboard * main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                        changeAddressViewController * addressView = [main instantiateViewControllerWithIdentifier:@"changeAddress"];
                        [self.navigationController pushViewController:addressView animated:YES];
                    }];
                    
                    UIAlertAction * action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                    [alert addAction:action1];
                    [alert addAction:action2];
                    [self presentViewController:alert animated:YES completion:nil];
                }
            }];
        }else{
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"购买商品不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }

    }else{
        //网络连接不可用
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"请求错误" message:@"请先检查网络连接是否正常" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}

//构造发送数据
-(NSDictionary *) makeSendDic{
    //定义一个字典
    NSDictionary * sendDic;
    //先定义一个可变数组
    NSMutableArray * array = [[NSMutableArray alloc] initWithObjects:nil, nil];
    [self.goodnum enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:key,@"product_id",obj,@"quantity", nil];
        [array addObject:dic];
    }];
    
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:nil];
    NSString * jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    sendDic = [NSDictionary dictionaryWithObjectsAndKeys:jsonStr,@"product_list",[address objectForKey:@"name"],@"name",[address objectForKey:@"postcode"],@"postcode",[address objectForKey:@"phonenum"],@"phonenum",[address objectForKey:@"details"],@"details",[address objectForKey:@"area"],@"area", nil];
    return sendDic;
}

#pragma ZCTradeViewDelegate
-(NSString*)finish:(NSString *)pwd{
    
   // NSLog(@"orderinfo = %@",orderInfo);
    
    //构造发送数据--订单号
    NSMutableArray * orderNum = [[NSMutableArray alloc] initWithObjects:nil, nil];
    for (int i =0; i<orderInfo.count; i++) {
        [orderNum addObject:[[orderInfo objectAtIndex:i] objectForKey:@"order_id"]];
    }
    
    //数组转化为json字符串
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:orderNum options:NSJSONWritingPrettyPrinted error:nil];
    NSString * jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    //构造发送json
    NSDictionary * sendpay = [NSDictionary dictionaryWithObjectsAndKeys:jsonStr,@"order_id_list",@"0",@"payment",pwd,@"trade_pass", nil];
    NSLog(@"sendPay = %@",sendpay);
    
    //付款
    [app.manager POST:@"http://120.25.162.238/bsy/index.php/Index/Order/payForOrder" parameters:sendpay success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //解析数据
        NSDictionary * getDic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
        
        if ([[getDic objectForKey:@"code"] isEqualToString:@"100000"]) {
    
            //先将本地的余额减少
            float a = [[[NSUserDefaults standardUserDefaults] objectForKey:@"balance"] floatValue] - [self getTotalNum];
            //更新本地的账户余额
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f",a] forKey:@"balance"];
            //交易成功页面
            orderSucViewController * sucView = [[orderSucViewController alloc] init];
            sucView.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            sucView.view.backgroundColor = [UIColor whiteColor];
            //将购买的商品信息传递给交易详情页面
            //先获取当前时间
            NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
            //设定时间格式
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString * currentTime = [formatter stringFromDate:[NSDate date]];
            NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:[[orderInfo objectAtIndex:0] objectForKey:@"number"],@"orderNum",[self getGoodsName],@"goodName",@"交易成功",@"state",currentTime,@"time",[NSString stringWithFormat:@"%i",[self getTotalNum]],@"totalNum", nil];
            //以广播方式传递数据
            [[NSNotificationCenter defaultCenter] postNotificationName:@"orderDetailNotification" object:self userInfo:dic];
            [self.navigationController pushViewController:sucView animated:YES];
        }else{
            //支出失败
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[getDic objectForKey:@"message"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        NSLog(@"%@",getDic);
        
    }];
        return pwd;
}

#pragma dataSource/delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.goodArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    shopBasketTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"shopBasketCell"];
    NSDictionary * dic = [self.goodArray objectAtIndex:indexPath.row];
    //从本地缓存中获取图片
    
    NSArray * documentDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * fileDir = [documentDir objectAtIndex:0];
    NSString * filePath = [fileDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",[dic objectForKey:@"id"]]];
    cell.goodImg.image = [UIImage imageWithContentsOfFile:filePath];
    
   // cell.goodImg.image = [UIImage imageNamed:@"goodImage.png"];
    
    cell.layer.cornerRadius = 4.0f;
    cell.layer.masksToBounds = YES;
    cell.goodName.text = [dic objectForKey:@"goodName"];
    cell.price.text = [NSString stringWithFormat:@"￥%@",[dic objectForKey:@"goodPrice"]];
    cell.originalPrice.text = [NSString stringWithFormat:@"￥%@",[dic objectForKey:@"originalPrice"]];
    cell.originalPrice.lineType = LineTypeMiddle;
    cell.hasSold.text = [dic objectForKey:@"hasSold"];
    //已购商品的个数
    cell.hasBuy.text = [NSString stringWithFormat:@"%i",[[self.goodnum objectForKey:[dic objectForKey:@"id"]] intValue]];
    cell.hasBuy.layer.borderColor = [UIColor grayColor].CGColor;
    cell.hasBuy.layer.borderWidth = 1.0f;
    //设置按钮的tag为商品的id
    cell.delete1.tag = [[dic objectForKey:@"id"] intValue];
    cell.add.tag = [[dic objectForKey:@"id"] intValue];
    //指定协议代理
    cell.delegate = self;
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
- (void)setExtraCellLineHidden: (UITableView *)tableView{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}

#pragma shopBasketProtocol

//删除购物车商品
-(void)deleteGood:(NSDictionary *)dic{
   //先将某个商品的购买数减一
    [self.goodnum setObject:[NSString stringWithFormat:@"%i",[[self.goodnum objectForKey:[dic objectForKey:@"id"]] intValue]-1] forKey:[dic objectForKey:@"id"]];
    //在判断是否将该商品信息删除
    if ([[self.goodnum objectForKey:[dic objectForKey:@"id"]] intValue] == 0) {
        [self.goodArray removeObject:dic];
        //如果为0，goonnum里面的数据也删除
        [self.goodnum removeObjectForKey:[dic objectForKey:@"id"]];
        //重新统计总金额
        self.totalNum.text = [NSString stringWithFormat:@"%i元",[self getTotalNum]];
        //将缓存图片删除
        [self deleteCacheImg:[[dic objectForKey:@"id"] intValue]];
        //然后重载表示图
        [self.goodList reloadData];
    }else{
        //如果购物清单中还有该商品,则只需要更新总金额
        self.totalNum.text = [NSString stringWithFormat:@"%i",[self getTotalNum]];
    }
    
    
}

//增加购物车商品
-(void)addGood:(NSDictionary *)dic{
    //将购买数加1
    [self.goodnum setObject:[NSString stringWithFormat:@"%i",[[self.goodnum objectForKey:[dic objectForKey:@"id"]] intValue]+1] forKey:[dic objectForKey:@"id"]];
    //重新统计所需金额
    self.totalNum.text = [NSString stringWithFormat:@"%i",[self getTotalNum]];
}

//自定义函数，用来求所购商品的总价格
-(int)getTotalNum{
    int totalNum = 0;
    //枚举
    for (NSDictionary * dic in self.goodArray) {
        int a = [[dic objectForKey:@"goodPrice"] intValue];
        int b = [[self.goodnum objectForKey:[dic objectForKey:@"id"]] intValue];
        totalNum = totalNum + a*b;
    }
    return totalNum;
}

//自定义函数，获取购买商品名称
-(NSString *)getGoodsName{
    NSString * name = [NSString stringWithFormat:@""];
    for (int i = 0; i<self.goodArray.count; i++) {
        NSDictionary * dic = [self.goodArray objectAtIndex:i];
        name = [NSString stringWithFormat:@"%@;%@",[dic objectForKey:@"goodName"],name];
    }
    return name;
}

//自定义函数，删除缓存图片
-(void)deleteCacheImg:(int)goodId{
    //如果为0，将缓存中得图片去除
    NSFileManager * fm = [NSFileManager defaultManager];
    NSArray * documentDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * fileDir = [documentDir objectAtIndex:0];
    NSString * filePath = [fileDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%i.jpg",goodId]];
    //删除缓存
    [fm removeItemAtPath:filePath error:nil];
}

@end
