//
//  BaseDrawerVC.h
//  LiFangSport
//
//  Created by 张毅 on 16/6/13.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import "BaseVC.h"
@class CenterViewController;
@class RightViewController;
@class  LeftViewController;
@interface BaseDrawerVC : UIViewController

@property (nonatomic, strong) CenterViewController *centerV;
@property (nonatomic, strong) LeftViewController *leftV;
@property (nonatomic, strong) RightViewController *rightV;
@property (nonatomic, assign) BOOL hideCenterLeftNaviBtn;
@property (nonatomic, assign) BOOL hideCenterRightNaviBtn;

- (id)initWithCenterVC:(CenterViewController *)centerVC rightVC:(RightViewController *)rightVC leftVC:(LeftViewController *)leftVC;

@end
