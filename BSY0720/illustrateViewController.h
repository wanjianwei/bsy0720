//
//  illustrateViewController.h
//  BSY0720
//
//  Created by jway on 15-7-27.
//  Copyright (c) 2015年 jway. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface illustrateViewController : UIViewController
//标志，以区分是助学宝和助学宝
//flag=1是助学宝，flag=2是学费宝
@property (nonatomic,strong) NSNumber * flag;
@end
