//  LiFangSport
//
//  Created by 张毅 on 16/6/12.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import "BaseVC.h"

#import <UIKit/UIKit.h>

@interface CenterViewController : UIViewController
@property(nonatomic,assign)BOOL hideLeftNaviBtnGesture;
@property(nonatomic,assign)BOOL hideRightNaviBtnGesture;

- (UIView <INSPullToRefreshBackgroundViewDelegate> *)pullToRefreshViewFromCurrentStyle;
- (UIView <INSAnimatable> *)infinityIndicatorViewFromCurrentStyle;

@end
