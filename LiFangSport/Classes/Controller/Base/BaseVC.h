//
//  BaseVC.h
//  LiFangSport
//
//  Created by 张毅 on 16/6/12.
//  Copyright © 2016年 zhangyi. All rights reserved.
//
#import "JSONModel.h"
#import <UIKit/UIKit.h>
#import "INSPullToRefreshBackgroundView.h"
#import "INSAnimatable.h"

@interface BaseVC : UIViewController

- (UIView <INSPullToRefreshBackgroundViewDelegate> *)pullToRefreshViewFromCurrentStyle;
- (UIView <INSAnimatable> *)infinityIndicatorViewFromCurrentStyle;

@end
