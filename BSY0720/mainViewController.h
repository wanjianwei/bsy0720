//
//  mainViewController.h
//  BSY0720
//
//  Created by jway on 15-7-21.
//  Copyright (c) 2015年 jway. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "loginViewController.h"
@interface mainViewController : UIViewController<UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,returnToTabViewProtocol>


//广告滚动图
@property(nonatomic,strong) UIScrollView *adView;
//功能模块展示图
@property(nonatomic,strong) UICollectionView * funView;
//分页控件
@property(nonatomic,strong) UIPageControl * pageControl;
//定义一个广告栏
@property(nonatomic,strong) UIView *banner;
//定义校园地带
@property(nonatomic,strong) UIView *newsView;
@end
