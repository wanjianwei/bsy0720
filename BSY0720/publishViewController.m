//
//  publishViewController.m
//  BSY0720
//
//  Created by jway on 15-8-2.
//  Copyright (c) 2015年 jway. All rights reserved.
//

#import "publishViewController.h"
#import "AppDelegate.h"
#define a ([UIScreen mainScreen].bounds.size.width-16)
@interface publishViewController (){
    //定义应用程序委托类
    AppDelegate * app;
    //定义一个按钮，增加图片
    UIButton * btn;
    //定义一个图像选择器
    UIImagePickerController * imagePickerView;
}

@end

@implementation publishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //指定协议代理
    self.content.delegate = self;
    self.subject.delegate = self;
    app = [UIApplication sharedApplication].delegate;
    //定义一个手势处理器
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handTap)];
    tap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tap];
    //UIScrollView添加“添加图片按钮”
    btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, a/4, 82)];
    [btn setBackgroundImage:[UIImage imageNamed:@"addImg.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(addImg) forControlEvents:UIControlEventTouchUpInside];
    [self.images addSubview:btn];
    //设置话题类型
    if ([self.flag intValue] == 1) {
        self.subjectSorts.text = @"约吧";
    }else if ([self.flag intValue] == 2){
        self.subjectSorts.text = @"跳蚤市场";
    }else if ([self.flag intValue] == 3){
        self.subjectSorts.text = @"精彩活动";
    }else{
        self.subjectSorts.text = @"";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//添加图片
-(void)addImg{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"请选择图片来源" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    //从相册中获取图片
    UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"从相册中选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //打开相册
       imagePickerView = [[UIImagePickerController alloc] init];
        imagePickerView.delegate = self;
        imagePickerView.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePickerView animated:YES completion:nil];
    }];
    
    //从相机中获取图片
    UIAlertAction * action2 = [UIAlertAction actionWithTitle:@"从相机中抓取" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            imagePickerView = [[UIImagePickerController alloc] init];
            imagePickerView.delegate = self;
            imagePickerView.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:imagePickerView animated:YES completion:nil];
        }else{
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"照相机不可用" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    }];
    
    //增加一个取消按钮
    UIAlertAction * action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    //添加进入alert
    [alert addAction:action1];
    [alert addAction:action2];
    [alert addAction:action3];
    [self presentViewController:alert animated:YES completion:nil];
    
}

//关闭键盘
-(void)handTap{
    [self.subject resignFirstResponder];
    [self.content resignFirstResponder];
}

//选择话题类型
- (IBAction)chooseSubject:(id)sender {
    //只有从发现界面跳转来到发布界面，才需要选择话题类型
    if ([self.flag intValue] == 4) {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"话题分类" message:@"请选择话题类型" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"约吧" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            self.subjectSorts.text = @"约吧";
        }];
        UIAlertAction * action2 = [UIAlertAction actionWithTitle:@"精彩活动" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            self.subjectSorts.text = @"精彩活动";
        }];
        UIAlertAction * action3 = [UIAlertAction actionWithTitle:@"跳蚤市场" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            self.subjectSorts.text = @"跳蚤市场";
        }];
        //增加一个取消按钮
        UIAlertAction * action4 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        //添加入alert视图中
        [alert addAction:action1];
        [alert addAction:action2];
        [alert addAction:action3];
        [alert addAction:action4];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
}

//确认发布
- (IBAction)confirm:(id)sender {
    if([self.subjectSorts.text isEqualToString:@""]){
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先选择话题类型" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }else if ([self.subject.text isEqualToString:@""] || [self.content.text isEqualToString:@""]){
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请将信息填写完整" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        //发布信息
    }
}

#pragma UITextViewDelegate
-(void)textViewDidBeginEditing:(UITextView *)textView{
    //textView开始编辑就隐藏
    self.axuLab.hidden = YES;
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@""]) {
        self.axuLab.hidden = NO;
    }
}



#pragma UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage * originalImage = (UIImage *)[info objectForKey:@"UIImagePickerControllerOriginalImage"];
    //添加图片到滚动视图中
    UIImageView * img = [[UIImageView alloc] initWithFrame:btn.frame];
    img.image = originalImage;
    if (img.frame.origin.x>a/2) {
        [self.images setContentSize:CGSizeMake(img.frame.origin.x+180, 82)];
    }
    [self.images addSubview:img];
    [btn removeFromSuperview];
    //重新添加一个“添加按钮”
    btn.frame = CGRectMake(img.frame.origin.x+10+a/4, img.frame.origin.y, a/4, 82);
    [self.images addSubview:btn];
    imagePickerView.delegate = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
@end
