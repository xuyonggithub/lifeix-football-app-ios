//
//  AJMediaPlayerMessageLayerView.m
//  AJMediaPlayerDemo
//
//  Created by le_cui on 15/6/23.
//  Copyright (c) 2015年 Lesports Inc. All rights reserved.
//

#import "AJMediaPlayerMessageLayerView.h"
#import "AJMediaPlayerUtilities.h"

@interface AJMediaPlayerMessageLayerView()
@property (nonatomic, assign) AJMediaPlayerErrorViewStyle currentStyle;
@end

@implementation AJMediaPlayerMessageLayerView

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor blackColor];
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.errorLabel = [[UILabel alloc] init];
        _errorLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _errorLabel.font= [UIFont systemFontOfSize:15];
        _errorLabel.textColor = [UIColor colorWithHTMLColorMark:@"cccccc"];
        _errorLabel.textAlignment = NSTextAlignmentCenter;
        _errorLabel.backgroundColor = [UIColor clearColor];
        _errorLabel.numberOfLines = 6;
        _errorLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:_errorLabel];
        
        self.errorCodeLabel = [[UILabel alloc] init];
        _errorCodeLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _errorCodeLabel.hidden = YES;
        _errorCodeLabel.font= [UIFont systemFontOfSize:12];
        _errorCodeLabel.textColor = [UIColor colorWithHTMLColorMark:@"cccccc"];
        _errorCodeLabel.textAlignment = NSTextAlignmentCenter;
        _errorCodeLabel.backgroundColor = [UIColor clearColor];
        _errorCodeLabel.numberOfLines = 6;
        _errorCodeLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:_errorCodeLabel];
        
        self.retryButton = [[UIButton alloc] init];
        _retryButton.backgroundColor = [UIColor clearColor];
        _retryButton.translatesAutoresizingMaskIntoConstraints = NO;
        _retryButton.hidden = YES;
        _retryButton.layer.cornerRadius = 2;
        _retryButton.layer.borderWidth = 1;
        _retryButton.layer.borderColor = [UIColor colorWithHTMLColorMark:@"29c4c6"].CGColor;
        [_retryButton setTitle:@"重  试" forState:UIControlStateNormal];
        [_retryButton setTitleColor:[UIColor colorWithHTMLColorMark:@"29c4c6"] forState:UIControlStateNormal];
        _retryButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_retryButton addTarget:self action:@selector(retryToPlay:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_retryButton];
        
        self.ignoreButton = [[UIButton alloc] init];
        _ignoreButton.backgroundColor = [UIColor clearColor];
        _ignoreButton.translatesAutoresizingMaskIntoConstraints = NO;
        _ignoreButton.hidden = YES;
        _ignoreButton.layer.cornerRadius = 2;
        _ignoreButton.layer.borderWidth = 1;
        _ignoreButton.layer.borderColor = [UIColor colorWithHTMLColorMark:@"29c4c6"].CGColor;
        [_ignoreButton setTitle:@"继  续" forState:UIControlStateNormal];
        [_ignoreButton setTitleColor:[UIColor colorWithHTMLColorMark:@"29c4c6"] forState:UIControlStateNormal];
        _ignoreButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_ignoreButton addTarget:self action:@selector(continueToPlay:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_ignoreButton];
        
        self.feedBackButton = [[UIButton alloc] init];
        _feedBackButton.backgroundColor = [UIColor clearColor];
        _feedBackButton.translatesAutoresizingMaskIntoConstraints = NO;
        _feedBackButton.hidden = YES;
        _feedBackButton.layer.cornerRadius = 2;
        _feedBackButton.layer.borderWidth = 1;
        _feedBackButton.layer.borderColor = [UIColor colorWithHTMLColorMark:@"29c4c6"].CGColor;
        [_feedBackButton setTitle:@"反  馈" forState:UIControlStateNormal];
        [_feedBackButton setTitleColor:[UIColor colorWithHTMLColorMark:@"29c4c6"] forState:UIControlStateNormal];
        _feedBackButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_feedBackButton addTarget:self action:@selector(sendFeedBack:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_feedBackButton];
        
        self.loginButton = [[UIButton alloc] init];
        _loginButton.backgroundColor = [UIColor clearColor];
        _loginButton.translatesAutoresizingMaskIntoConstraints = NO;
        _loginButton.hidden = YES;
        _loginButton.layer.cornerRadius = 2;
        _loginButton.layer.borderWidth = 1;
        _loginButton.layer.borderColor = [UIColor colorWithHTMLColorMark:@"29c4c6"].CGColor;
        [_loginButton setTitle:@"登  录" forState:UIControlStateNormal];
        [_loginButton setTitleColor:[UIColor colorWithHTMLColorMark:@"29c4c6"] forState:UIControlStateNormal];
        _loginButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_loginButton addTarget:self action:@selector(clickOnLogin:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_loginButton];
    }
    return self;
}

- (void)updateConstraints {
    [super updateConstraints];
    if (self.currentStyle == AJMediaPlayerErrorViewLabelStyle) {
        _errorCodeLabel.hidden = NO;
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_errorLabel]-0-|"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:NSDictionaryOfVariableBindings(_errorLabel)]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_errorLabel
                                                         attribute:NSLayoutAttributeHeight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:nil
                                                         attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f
                                                          constant:15]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_errorLabel
                                                         attribute:NSLayoutAttributeCenterY
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeCenterY
                                                        multiplier:1.0f
                                                          constant:-20]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_errorCodeLabel]-0-|"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:NSDictionaryOfVariableBindings(_errorCodeLabel)]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_errorCodeLabel
                                                         attribute:NSLayoutAttributeHeight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:nil
                                                         attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f
                                                          constant:15]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_errorCodeLabel
                                                         attribute:NSLayoutAttributeCenterY
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeCenterY
                                                        multiplier:1.0f
                                                          constant:0]];
        
    } else {
        float errorLabelCenterY;
        if (self.currentStyle == AJMediaPlayerErrorViewFeedBackStyle || self.currentStyle == AJMediaPlayerErrorViewRetryStyle) {
            errorLabelCenterY = -40;
        } else {
            errorLabelCenterY = -20;
        }
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_errorLabel]-0-|"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:NSDictionaryOfVariableBindings(_errorLabel)]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_errorLabel
                                                         attribute:NSLayoutAttributeHeight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:nil
                                                         attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f
                                                          constant:15]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_errorLabel
                                                         attribute:NSLayoutAttributeCenterY
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeCenterY
                                                        multiplier:1.0f
                                                          constant:errorLabelCenterY]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_errorCodeLabel]-0-|"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:NSDictionaryOfVariableBindings(_errorCodeLabel)]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_errorCodeLabel
                                                         attribute:NSLayoutAttributeHeight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:nil
                                                         attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f
                                                          constant:15]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_errorCodeLabel
                                                         attribute:NSLayoutAttributeCenterY
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeCenterY
                                                        multiplier:1.0f
                                                          constant:-20]];
        
        if (self.currentStyle == AJMediaPlayerErrorViewFeedBackStyle) {
            _errorCodeLabel.hidden = NO;
            _feedBackButton.hidden = NO;
            _retryButton.hidden = NO;
            [self addConstraint:[NSLayoutConstraint constraintWithItem:_feedBackButton
                                                             attribute:NSLayoutAttributeWidth
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:nil
                                                             attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f
                                                              constant:65]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:_feedBackButton
                                                             attribute:NSLayoutAttributeHeight
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:nil
                                                             attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f
                                                              constant:24]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:_feedBackButton
                                                             attribute:NSLayoutAttributeCenterX
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self
                                                             attribute:NSLayoutAttributeCenterX
                                                            multiplier:1.0f
                                                              constant:-50]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:_feedBackButton
                                                             attribute:NSLayoutAttributeCenterY
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self
                                                             attribute:NSLayoutAttributeCenterY
                                                            multiplier:1.0f
                                                              constant:16]];
            
            [self addConstraint:[NSLayoutConstraint constraintWithItem:_retryButton
                                                             attribute:NSLayoutAttributeWidth
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:nil
                                                             attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f
                                                              constant:65]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:_retryButton
                                                             attribute:NSLayoutAttributeHeight
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:nil
                                                             attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f
                                                              constant:24]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:_retryButton
                                                             attribute:NSLayoutAttributeCenterX
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self
                                                             attribute:NSLayoutAttributeCenterX
                                                            multiplier:1.0f
                                                              constant:50]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:_retryButton
                                                             attribute:NSLayoutAttributeCenterY
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self
                                                             attribute:NSLayoutAttributeCenterY
                                                            multiplier:1.0f
                                                              constant:16]];
            
        } else if (self.currentStyle == AJMediaPlayerErrorViewRetryStyle) {
            _retryButton.hidden = NO;
            _errorCodeLabel.hidden = NO;
            [self addConstraint:[NSLayoutConstraint constraintWithItem:_retryButton
                                                             attribute:NSLayoutAttributeWidth
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:nil
                                                             attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f
                                                              constant:75]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:_retryButton
                                                             attribute:NSLayoutAttributeHeight
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:nil
                                                             attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f
                                                              constant:24]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:_retryButton
                                                             attribute:NSLayoutAttributeCenterX
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self
                                                             attribute:NSLayoutAttributeCenterX
                                                            multiplier:1.0f
                                                              constant:0]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:_retryButton
                                                             attribute:NSLayoutAttributeCenterY
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self
                                                             attribute:NSLayoutAttributeCenterY
                                                            multiplier:1.0f
                                                              constant:16]];
        } else if (self.currentStyle == AJMediaPlayerErrorViewIgnoreStyle) {
            _ignoreButton.hidden = NO;
            [self addConstraint:[NSLayoutConstraint constraintWithItem:_ignoreButton
                                                             attribute:NSLayoutAttributeWidth
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:nil
                                                             attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f
                                                              constant:75]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:_ignoreButton
                                                             attribute:NSLayoutAttributeHeight
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:nil
                                                             attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f
                                                              constant:24]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:_ignoreButton
                                                             attribute:NSLayoutAttributeCenterX
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self
                                                             attribute:NSLayoutAttributeCenterX
                                                            multiplier:1.0f
                                                              constant:0]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:_ignoreButton
                                                             attribute:NSLayoutAttributeCenterY
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self
                                                             attribute:NSLayoutAttributeCenterY
                                                            multiplier:1.0f
                                                              constant:16]];
        } else if (self.currentStyle == AJMediaPlayerErrorViewLoginStyle) {
            _loginButton.hidden = NO;
            [self addConstraint:[NSLayoutConstraint constraintWithItem:_loginButton
                                                             attribute:NSLayoutAttributeWidth
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:nil
                                                             attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f
                                                              constant:75]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:_loginButton
                                                             attribute:NSLayoutAttributeHeight
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:nil
                                                             attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f
                                                              constant:24]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:_loginButton
                                                             attribute:NSLayoutAttributeCenterX
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self
                                                             attribute:NSLayoutAttributeCenterX
                                                            multiplier:1.0f
                                                              constant:0]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:_loginButton
                                                             attribute:NSLayoutAttributeCenterY
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self
                                                             attribute:NSLayoutAttributeCenterY
                                                            multiplier:1.0f
                                                              constant:16]];
        }
    }
}

- (void)showWithIgnoreStyle {
    _errorLabel.text = @"非WiFi网络，土豪请随意~";
    self.currentStyle = AJMediaPlayerErrorViewIgnoreStyle;
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

- (void)showWithAJMediaPlayerErrorIdentifier:(AJMediaPlayerErrorIdentifier )errorState {
    _errorLabel.text = [self errorInfoByErrorCode:errorState];
    _errorCodeLabel.text = [self errorCodeMessageByErrorCode:errorState];
    switch (errorState) {
        case AJMediaPlayerPlayableResourceIDNotProvidedError:
            self.currentStyle = AJMediaPlayerErrorViewLabelStyle;
            break;
        case AJMediaPlayerCoreServiceError:
            self.currentStyle = AJMediaPlayerErrorViewFeedBackStyle;
            break;
        case AJMediaPlayerCDEServiceOverLoadError:
            self.currentStyle = AJMediaPlayerErrorViewLabelStyle;
            break;
        case AJMediaPlayerLocalHTTPClientTimeOutError:
            self.currentStyle = AJMediaPlayerErrorViewRetryStyle;
            break;
        case AJMediaPlayerLocalHTTPClientNetworkNotConnectedError:
            self.currentStyle = AJMediaPlayerErrorViewRetryStyle;
            break;
        case AJMediaPlayerLocalHTTPClientRequestFailedError:
            self.currentStyle = AJMediaPlayerErrorViewRetryStyle;
            break;
        case AJMediaPlayerLocalHTTPClientResponseJSONParsingError:
            self.currentStyle = AJMediaPlayerErrorViewLabelStyle;
            break;
        case AJMediaPlayerVRSMainLandChinaAreaRestrictionError:
            self.currentStyle = AJMediaPlayerErrorViewLabelStyle;
            break;
        case AJMediaPlayerVRSOverseaAreaRestrictionError:
            self.currentStyle = AJMediaPlayerErrorViewLabelStyle;
            break;
        case AJMediaPlayerVRSNoUserTokenProvidedError:
            self.currentStyle = AJMediaPlayerErrorViewLabelStyle;
            break;
        case AJMediaPlayerVRSResourceNotFoundError:
            self.currentStyle = AJMediaPlayerErrorViewLabelStyle;
            break;
        case AJMediaPlayerVRSOnDemandVideoLicenseWasLimitedError:
            self.currentStyle = AJMediaPlayerErrorViewLabelStyle;
            break;
        case AJMediaPlayerVRSResourceRequiresPaymentError:
            self.currentStyle = AJMediaPlayerErrorViewLabelStyle;
            break;
        case AJMediaPlayerVRSResourceForbidden:
            self.currentStyle = AJMediaPlayerErrorViewLabelStyle;
            break;
        case AJMediaPlayerBOSSOnDemandVideoAuthenticationFailedError:
            self.currentStyle = AJMediaPlayerErrorViewLabelStyle;
            break;
        case AJMediaPlayerBOSSLiveStreamVideoAuthenticationFailedError:
            self.currentStyle = AJMediaPlayerErrorViewLabelStyle;
            break;
        case AJMediaPlayerUnknownError:
            self.currentStyle = AJMediaPlayerErrorViewFeedBackStyle;
            break;
        default:
            self.currentStyle = AJMediaPlayerErrorViewFeedBackStyle;
            break;
    }
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

- (NSString *)errorInfoByErrorCode:(AJMediaPlayerErrorIdentifier )errorState{
    switch (errorState) {
        case AJMediaPlayerPlayableResourceIDNotProvidedError:
            return @"播放地址为空，看看其他节目呗~";
            break;
        case AJMediaPlayerCoreServiceError:
            return @"解码失败，告诉工程师整改！";
            break;
        case AJMediaPlayerResourceServiceError:
            return @"暂未获取到可用视频资源";
            break;
        case AJMediaPlayerAirPlayServiceError:
            return @"无法完成操作";
            break;
        case AJMediaPlayerCDEServiceOverLoadError:
            return @"服务器压力山大，请您稍后重试";
            break;
        case AJMediaPlayerLocalHTTPClientTimeOutError:
            return @"网络真心不给力啊";
            break;
        case AJMediaPlayerLocalHTTPClientNetworkNotConnectedError:
            return @"断网了，亲，检查一下吧";
            break;
        case AJMediaPlayerLocalHTTPClientRequestFailedError:
            return @"网络连接失败，请检查网络设置";
            break;
        case AJMediaPlayerLocalHTTPClientResponseJSONParsingError:
            return @"视频加载失败，请稍后重试";
            break;
        case AJMediaPlayerProxiedAPINotOKResponseError:
            return @"请求失败，重试一次？";
            break;
        case AJMediaPlayerProxiedAPIEmptyResponseDataError:
            return @"未获取到数据，重试一次？";
            break;
        case AJMediaPlayerProxiedAPIEmptyStreamMetadataError:
            return @"未获取到播放地址，重试一次？";
            break;
        case AJMediaPlayerVRSMainLandChinaAreaRestrictionError:
            return @"您所在的区域没有播放版权额~";
            break;
        case AJMediaPlayerVRSOverseaAreaRestrictionError:
            return @"您所在的区域没有播放版权额~";
            break;
        case AJMediaPlayerVRSNoUserTokenProvidedError:
            return @"该内容需要登录才能播放哦~";
            break;
        case AJMediaPlayerVRSResourceNotFoundError:
            return @"该视频已经下线或者不存在啦~";
            break;
        case AJMediaPlayerVRSOnDemandVideoLicenseWasLimitedError:
            return @"版权限制，伦家不能给你看唉";
            break;
        case AJMediaPlayerVRSResourceRequiresPaymentError:
            return @"喂，客官，没给钱就想看呐？";
            break;
        case AJMediaPlayerVRSResourceForbidden:
            return @"本节目暂时下线，请更换其他节目。";
            break;
        case AJMediaPlayerVRSWebAPIAccessFailedError:
            return @"服务器接口不给力哇~重试一次？";
            break;
        case AJMediaPlayerVRSWebAPIAccessTimeoutError:
            return @"访！问！超！时！~重试一次？";
            break;
        case AJMediaPlayerVRSWebAPIAccessInvalidResponseError:
            return @"数！据！错！误！~重试一次？";
            break;
        case AJMediaPlayerVRSWebAPIAccessUnknownError:
            return @"服务器接口不给力哇~重试一次？";
            break;
        case AJMediaPlayerLCSWebAPIAccessFailedError:
            return @"服务器接口不给力哇~重试一次？";
            break;
        case AJMediaPlayerLCSWebAPIAccessTimeoutError:
            return @"访！问！超！时！~重试一次？";
            break;
        case AJMediaPlayerLCSWebAPIAccessInvalidResponseError:
            return @"数！据！错！误！~重试一次？";
            break;
        case AJMediaPlayerLCSWebAPIAccessUnknownError:
            return @"服务器接口不给力哇~重试一次？";
            break;
        case AJMediaPlayerBOSSWebAPIAccessFailedError:
            return @"服务器接口不给力哇~重试一次？";
            break;
        case AJMediaPlayerBOSSWebAPIAccessTimeoutError:
            return @"访！问！超！时！~重试一次？";
            break;
        case AJMediaPlayerBOSSWebAPIAccessInvalidResponseError:
            return @"数！据！错！误！~重试一次？";
            break;
        case AJMediaPlayerBOSSWebAPIAccessUnknownError:
            return @"有点不对劲，重试一次？";
            break;
        case AJMediaPlayerBOSSOnDemandVideoAuthenticationFailedError:
            return @"客官，掌柜的说了，不让看唉";
            break;
        case AJMediaPlayerBOSSLiveStreamVideoAuthenticationFailedError:
            return @"客官，掌柜的说了，不让看唉";
            break;
        case AJMediaPlayerUnknownError:
            return @"系统抽风ing~";
            break;
        default:
            break;
    }
    return @"视频加载失败，请稍后重试。";
}

- (NSString *)errorCodeMessageByErrorCode:(AJMediaPlayerErrorIdentifier )errorState{
    switch (errorState) {
        case AJMediaPlayerVRSMainLandChinaAreaRestrictionError:
            return @"错误码：010001";
            break;
        case AJMediaPlayerVRSOverseaAreaRestrictionError:
            return @"错误码：010002";
            break;
        case AJMediaPlayerVRSNoUserTokenProvidedError:
            return @"错误码：010003";
            break;
        case AJMediaPlayerVRSResourceNotFoundError:
            return @"错误码：010004";
            break;
        case AJMediaPlayerVRSOnDemandVideoLicenseWasLimitedError:
            return @"错误码：010005";
            break;
        case AJMediaPlayerVRSResourceRequiresPaymentError:
            return @"错误码：010006";
            break;
        case AJMediaPlayerVRSResourceForbidden:
            return @"错误码：010007";
            break;
        case AJMediaPlayerVRSWebAPIAccessFailedError:
            return @"错误码：011001";
            break;
        case AJMediaPlayerVRSWebAPIAccessTimeoutError:
            return @"错误码：011002";
            break;
        case AJMediaPlayerVRSWebAPIAccessInvalidResponseError:
            return @"错误码：011003";
            break;
        case AJMediaPlayerVRSWebAPIAccessUnknownError:
            return @"错误码：011004";
            break;
        case AJMediaPlayerLCSWebAPIAccessFailedError:
            return @"错误码：012001";
            break;
        case AJMediaPlayerLCSWebAPIAccessTimeoutError:
            return @"错误码：012002";
            break;
        case AJMediaPlayerLCSWebAPIAccessInvalidResponseError:
            return @"错误码：012003";
            break;
        case AJMediaPlayerLCSWebAPIAccessUnknownError:
            return @"错误码：012004";
            break;
        case AJMediaPlayerBOSSWebAPIAccessFailedError:
            return @"错误码：013001";
            break;
        case AJMediaPlayerBOSSWebAPIAccessTimeoutError:
            return @"错误码：013002";
            break;
        case AJMediaPlayerBOSSWebAPIAccessInvalidResponseError:
            return @"错误码：013003";
            break;
        case AJMediaPlayerBOSSWebAPIAccessUnknownError:
            return @"错误码：013004";
            break;
        case AJMediaPlayerBOSSOnDemandVideoAuthenticationFailedError:
            return @"错误码：013005";
            break;
        case AJMediaPlayerBOSSLiveStreamVideoAuthenticationFailedError:
            return @"错误码：013006";
            break;
        case AJMediaPlayerUnknownError:
            return @"错误码：019999";
            break;
        case AJMediaPlayerLocalHTTPClientNetworkNotConnectedError:
            return @"错误码：020001";
            break;
        case AJMediaPlayerLocalHTTPClientTimeOutError:
            return @"错误码：020002";
            break;
        case AJMediaPlayerLocalHTTPClientRequestFailedError:
            return @"错误码：020003";
            break;
        case AJMediaPlayerCoreServiceError:
            return @"错误码：030001";
            break;
        case AJMediaPlayerResourceServiceError:
            return @"错误码：030002";
            break;
        case AJMediaPlayerAirPlayServiceError:
            return @"错误码：030003";
            break;
        case AJMediaPlayerCDEServiceOverLoadError:
            return @"错误码：030004";
            break;
        case AJMediaPlayerPlayableResourceIDNotProvidedError:
            return @"错误码：040001";
            break;
        case AJMediaPlayerLocalHTTPClientResponseJSONParsingError:
            return @"错误码：040002";
            break;
        case AJMediaPlayerProxiedAPINotOKResponseError:
            return @"错误码：040003";
            break;
        case AJMediaPlayerProxiedAPIEmptyResponseDataError:
            return @"错误码：040004";
            break;
        case AJMediaPlayerProxiedAPIEmptyStreamMetadataError:
            return @"错误码：040005";
            break;
        default:
            break;
    }
    return @"错误码：050001";
}

- (void)retryToPlay:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(mediaPlayerErrorViewShouldRetryToPlay)]) {
        [_delegate mediaPlayerErrorViewShouldRetryToPlay];
    }
}

- (void)continueToPlay:(id)sender{
    if (_delegate && [_delegate respondsToSelector:@selector(mediaPlayerErrorViewShouldContinueToPlay)]) {
        [_delegate mediaPlayerErrorViewShouldContinueToPlay];
    }
}

- (void)sendFeedBack:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(mediaPlayerErrorViewClickOnFeedBack)]) {
        [_delegate mediaPlayerErrorViewClickOnFeedBack];
    }
}

- (void)clickOnLogin:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(mediaPlayerErrorViewClickOnLogin)]) {
        [_delegate mediaPlayerErrorViewClickOnLogin];
    }
}

@end
