//
//  changeSexViewController.m
//  BSY0720
//
//  Created by jway on 15-8-3.
//  Copyright (c) 2015年 jway. All rights reserved.
//

#import "changeSexViewController.h"
#import "AppDelegate.h"
@interface changeSexViewController (){
    AppDelegate * app;
}

@end

@implementation changeSexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化
    app = [UIApplication sharedApplication].delegate;
    self.title = @"修改性别";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//选择性别
- (IBAction)choseSex:(id)sender {
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"请选择所属性别" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        self.sex.text = @"男";
    }];
    UIAlertAction * action2 = [UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        self.sex.text = @"女";
    }];
    [alert addAction:action1];
    [alert addAction:action2];
    [self presentViewController:alert animated:YES completion:nil];
}

//保存所修改的性别
- (IBAction)save:(id)sender {
    //先判断是否网络连接正常
    if (app.Rea_manager.reachable == YES) {
        if ([self.sex.text isEqual:@""]) {
            //弹出警告
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先选择所属性别" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }else{
            NSDictionary * send = [NSDictionary dictionaryWithObject:([self.sex.text isEqualToString:@"男"])?@"1":@"2" forKey:@"sex"];
            [app.manager POST:@"http://120.25.162.238/bsy/index.php/Index/Customer/editInfo" parameters:send success:^(AFHTTPRequestOperation *operation, id responseObject) {
                //
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"dic = %@",dic);
                if ([[dic objectForKey:@"code"] isEqualToString:@"100000"]) {
                    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:[dic objectForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                        [self.navigationController popViewControllerAnimated:YES];
                    }];
                    [alert addAction:action];
                    [self presentViewController:alert animated:YES completion:nil];
                }else{
                    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[dic objectForKey:@"message"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                }
                
            }];
        }
    }else{
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请检查网络连接是否正常" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    
}
@end
