//
//  AJMediaPlayerMessageLayerView.h
//  AJMediaPlayerDemo
//
//  Created by Zhangqibin on 15/6/23.
//  Copyright (c) 2015年 zhangyi. All rights reserved.
//

@import UIKit;

#import "AJMediaPlayerErrorDefines.h"

typedef NS_ENUM (NSInteger, AJMediaPlayerErrorViewStyle) {
    AJMediaPlayerErrorViewLabelStyle = 0,       //显示Label模式
    AJMediaPlayerErrorViewFeedBackStyle = 1,   //显示feedBack模式
    AJMediaPlayerErrorViewRetryStyle = 2,       //显示retry模式
    AJMediaPlayerErrorViewIgnoreStyle = 3,       //显示ignore模式
    AJMediaPlayerErrorViewLoginStyle = 4       //显示登录模式
};
@protocol AJMediaPlayerErrorViewDelegate <NSObject>
@optional
- (void)mediaPlayerErrorViewClickOnFeedBack;
- (void)mediaPlayerErrorViewShouldRetryToPlay;
- (void)mediaPlayerErrorViewShouldContinueToPlay;
- (void)mediaPlayerErrorViewClickOnLogin;
@end

IB_DESIGNABLE
@interface AJMediaPlayerMessageLayerView : UIControl

@property (nonatomic, copy) IBInspectable NSString *playErrorInfo;
@property (nonatomic, strong) UILabel *errorLabel;
@property (nonatomic, strong) UILabel *errorCodeLabel;
@property (nonatomic, strong) UIButton *retryButton;
@property (nonatomic, strong) UIButton *ignoreButton;
@property (nonatomic, strong) UIButton *feedBackButton;
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, weak) id<AJMediaPlayerErrorViewDelegate>delegate;

- (void)showWithIgnoreStyle;
- (void)showWithAJMediaPlayerErrorIdentifier:(AJMediaPlayerErrorIdentifier )errorState;

@end
