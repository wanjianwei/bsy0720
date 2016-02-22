//
//  TFIndicatorView.h
//  Tiffany
//
//  Created by ff on 13-7-5.
//  Copyright (c) 2013年 ff. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TFIndicatorView : UIView

@property (nonatomic,assign) NSUInteger numOfObjects;
@property (nonatomic,assign) CGSize objectSize;
@property (nonatomic,retain) UIColor *color;


-(void)startAnimating;
-(void)stopAnimating;


@end
