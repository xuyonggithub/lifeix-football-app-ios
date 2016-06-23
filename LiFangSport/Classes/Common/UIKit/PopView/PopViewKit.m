//
//  PopViewKit.m
//  LiFangSport
//
//  Created by 张毅 on 16/6/23.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import "PopViewKit.h"

@interface PopViewKit () <UIGestureRecognizerDelegate>
{
    UIView *_backgroudView;
    UIView *_contentView;
    PopAniType _aniType;
    
    FinishBlock _finishBlock;
}


@end

@implementation PopViewKit

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        _bTapDismiss = YES;
        _bInnerTapDismiss = NO;
        
        _backgroudView = [[UIView alloc] init];
        _backgroudView.backgroundColor = [UIColor blackColor];
        _backgroudAlpha = 0.3;
        _contentOrigin = CGPointMake(CGFLOAT_MAX, CGFLOAT_MAX);
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedCancel)];
        tapGesture.delegate = self;
        [self addGestureRecognizer:tapGesture];
    }
    
    return self;
}

- (void)dealloc
{
    NSLog(@"dealloc");
}

- (void)tappedCancel
{
    if (self.bTapDismiss) {
        [self dismiss:_aniType != PAT_None];
    }
}

- (void)popView:(UIView *)view animateType:(PopAniType)animateType
{
    _contentView = view;
    _aniType = animateType;
    
    UIView *rootView = [APP_DELEGATE window];
    self.frame = rootView.bounds;
    [rootView addSubview:self];
    
    if (CGRectIsEmpty(_backgroudMaskFrame)) {
        _backgroudView.frame = self.bounds;
    }
    else{
        _backgroudView.frame = _backgroudMaskFrame;
    }
    [self addSubview:_backgroudView];
    
    
    if (_contentOrigin.x == CGFLOAT_MAX || _contentOrigin.y == CGFLOAT_MAX) {
        _contentView.center = CGPointMake(self.width/2, self.height/2);
    }
    else{
        _contentView.origin = _contentOrigin;
    }
    [self addSubview:_contentView];
    
    _backgroudView.alpha = _backgroudAlpha;
    if (animateType != PAT_None) {
        if (_aniType == PAT_Scale) {
            _contentView.transform = CGAffineTransformScale(self.transform, 0.8, 0.8);
            NSUInteger options = UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveEaseIn;
            [UIView animateWithDuration:0.15 delay:0 options:options
                             animations:^{
                                 _contentView.transform = CGAffineTransformScale(self.transform, 1.0, 1.0);
                             }
                             completion:^(BOOL finished) {
                             }
             ];
        }
        else if (_aniType == PAT_HeightUpToDown){
            CGFloat preHeight = _contentView.height;
            _contentView.height = 0;
            _contentView.clipsToBounds = YES;
            NSUInteger options = UIViewAnimationOptionTransitionNone;
            [UIView animateWithDuration:0.3 delay:0 options:options
                             animations:^{
                                 _contentView.height = preHeight;
                             }
                             completion:^(BOOL finished) {
                             }
             ];
        }
        else if (_aniType == PAT_HeightDownToUp){
            CGFloat preHeight = _contentView.height;
            CGFloat preTop = _contentView.top;
            _contentView.top = _contentView.bottom;
            _contentView.height = 0;
            _contentView.clipsToBounds = YES;
            NSUInteger options = UIViewAnimationOptionTransitionNone;
            [UIView animateWithDuration:0.3 delay:0 options:options
                             animations:^{
                                 _contentView.top = preTop;
                                 _contentView.height = preHeight;
                             }
                             completion:^(BOOL finished) {
                             }
             ];
        }
        else if (_aniType == PAT_Alpha){
            _contentView.alpha = 0.0f;
            NSUInteger options = UIViewAnimationOptionTransitionNone;
            [UIView animateWithDuration:0.3 delay:0 options:options
                             animations:^{
                                 _contentView.alpha = 1.0f;
                             }
                             completion:^(BOOL finished) {
                             }
             ];
        }
    }
}

- (void)finishPop
{
    if (_dismissBlock) {
        _dismissBlock();
        _dismissBlock = nil;
    }
    [self removeFromSuperview];
}

- (void)dismiss:(BOOL)animated
{
    if (animated) {
        _backgroudView.alpha = _backgroudAlpha;
        
        if (_aniType == PAT_Scale) {
            NSUInteger options = UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveEaseIn;
            [UIView animateWithDuration:0.15 delay:0 options:options
                             animations:^{
                                 _backgroudView.alpha = 0.0f;
                                 _contentView.alpha = 0.0;
                                 _contentView.transform = CGAffineTransformScale(self.transform, 0.8, 0.8);
                             }
                             completion:^(BOOL finished) {
                                 [self finishPop];
                             }
             ];
        }
        else if (_aniType == PAT_HeightUpToDown) {
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionAllowUserInteraction
                             animations:^{
                                 _backgroudView.alpha = 0.0f;
                                 _contentView.alpha = 0.0;
                                 _contentView.height = 0;
                             }
                             completion:^(BOOL finished) {
                                 [self finishPop];
                             }
             ];
        }
        else if(_aniType == PAT_HeightDownToUp){
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionAllowUserInteraction
                             animations:^{
                                 _backgroudView.alpha = 0.0f;
                                 _contentView.top = _contentView.bottom;
                                 _contentView.height = 0;
                             }
                             completion:^(BOOL finished) {
                                 [self finishPop];
                             }
             ];
        }
        else if(_aniType == PAT_Alpha){
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 _contentView.alpha = 0.0f;
                             }
                             completion:^(BOOL finished) {
                                 [self finishPop];
                             }];
        }
        else{
            [self finishPop];
        }
    }
    else{
        [self finishPop];
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    CGPoint touchPoint = [gestureRecognizer locationInView:_contentView];
    if (!_bInnerTapDismiss && CGRectContainsPoint(_contentView.bounds, touchPoint)) {
        return NO;
    }
    
    return YES;
}

@end
