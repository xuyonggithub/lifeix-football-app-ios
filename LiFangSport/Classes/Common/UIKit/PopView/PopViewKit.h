//
//  PopViewKit.h
//  LiFangSport
//
//  Created by 张毅 on 16/6/23.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PopAniType){
    PAT_None,
    PAT_Scale,
    PAT_HeightUpToDown,
    PAT_HeightDownToUp,
    PAT_Alpha,
    PAT_WidthRightToLeft,
};


@interface PopViewKit : UIView

@property (nonatomic, readonly) UIView *backgroudView;
@property (nonatomic, assign) CGFloat backgroudAlpha;
@property (nonatomic, assign) CGRect  backgroudMaskFrame;
@property (nonatomic, assign) BOOL bTapDismiss;
@property (nonatomic, assign) BOOL bInnerTapDismiss;


@property (nonatomic, readonly) UIView *contentView;
@property (nonatomic, assign) CGPoint contentOrigin;

@property (nonatomic, strong) FinishBlock dismissBlock;

- (void)popView:(UIView *)view animateType:(PopAniType)animateType;
- (void)dismiss:(BOOL)animated;


@end
