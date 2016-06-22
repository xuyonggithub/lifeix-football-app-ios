//
//  AJMediaPlayerViewController.h
//  AJMediaPlayerKit
//
//  Created by Zhangqibin on 15/7/7.
//  Copyright (c) 2015年 Zhangqibin. All rights reserved.
//

@import UIKit;
#import "AJMediaPlayerHeaders.h"
#import "AJMediaPlayerStyleDefines.h"
@class AJMediaPlayerViewController;
@class AJMediaPlayRequest;
@class AJMediaPlayerItem;
@class AJMediaPlayerProgressView;
@class AJMediaPlayerMessageLayerView;
@class AJMediaIndicatorView;
@class AJMediaTipsView;
@class AJMediaPlayerPlaybackControlPanel;
@class AJMediaPlayerCaptionControlPanel;
@class MPVolumeView;
@class VTBulletModel;

@protocol AJMediaViewControllerDelegate <NSObject>

@optional
/**
 *  播放器控制栏即将显示
 *
 *  @param mediaPlayerViewController
 */
- (void)mediaPlayerViewControllerPlaybackControlsWillAppear:(AJMediaPlayerViewController *)mediaPlayerViewController;
/**
 *  播放器控制栏已经消失
 *
 *  @param mediaPlayerViewController
 */
- (void)mediaPlayerViewControllerPlaybackControlsDidDisappear:(AJMediaPlayerViewController *)mediaPlayerViewController;
/**
 *  播放器即将移除
 *
 *  @param mediaPlayerViewController
 */
- (void)mediaPlayerViewControllerWillDismiss:(AJMediaPlayerViewController *)mediaPlayerViewController;
/**
 *  播放器切换选段视频回调事件 用于客户端刷新ui使用
 *
 *  @param mediaPlayerViewController
 */
- (void)mediaPlayerViewController:(AJMediaPlayerViewController *)mediaPlayerViewController didChangePlayerItem:(AJMediaPlayRequest *)playerRequest;
/**
 *  播放器全屏点击分享事件
 *
 *  @param mediaPlayerViewController 播放器
 *  @param playerItem                当前playItem
 */
- (void)mediaPlayerViewController:(AJMediaPlayerViewController *)mediaPlayerViewController didClickOnShareButton:(AJMediaPlayerItem *)playerItem;
/**
 *  播放器视频播放结束
 *
 *  @param mediaPlayerViewController
 */
- (void)mediaPlayerViewController:(AJMediaPlayerViewController *)mediaPlayerViewController videoDidPlayToEnd:(AJMediaPlayerItem *)playerItem;
/**
 *  播放器视频airPlay播放状态
 *
 *  @param mediaPlayerViewController 播放器
 *  @param airPlayState              airPlayState状态
 */
- (void)mediaPlayerViewController:(AJMediaPlayerViewController *)mediaPlayerViewController didChangeAirPlayState:(AJMediaPlayerAirPlayState )airPlayState;
/**
 *  播放器错误 需要用户登录
 *
 *  @param mediaPlayerViewController
 */
- (void)mediaPlayerViewControllerDidClickOnLoginButton:(AJMediaPlayerViewController *)mediaPlayerViewController;
/**
 *  播放器点击暂停或者播放
 *
 *  @param mediaPlayerViewController
 */
- (void)mediaPlayerViewController:(AJMediaPlayerViewController *)mediaPlayerViewController userDidClickOnPlayOrPauseButton:(BOOL)isPlay;
/**
 *  播放器错误，用户点击重试
 *
 *  @param mediaPlayerViewController
 */
- (void)mediaPlayerViewControllerDidClickOnRetryButton:(AJMediaPlayerViewController *)mediaPlayerViewController;
/**
 *  iPad播放器点击全屏
 *
 *  @param mediaPlayerViewController
 */
- (void)mediaPlayerViewController:(AJMediaPlayerViewController *)mediaPlayerViewController didSelectFullScreenMode:(BOOL )isFullScreen;
/**
 *  播放器聊天室开关回调
 *
 *  @param mediaPlayerViewController
 */
- (void)mediaPlayerViewController:(AJMediaPlayerViewController *)mediaPlayerViewController didChangeChatRoomState:(BOOL )isOn;
/**
 *  用户发送弹幕消息时触发，弹幕消息需要外部封装，并调用方法sendBulletItem:最终完成发送
 *
 *  @param mediaPlayerViewController
 *  @param message                   弹幕消息
 */
- (void)mediaPlayerViewController:(AJMediaPlayerViewController *)mediaPlayerViewController userDidSendMessage:(NSString *)message;
/**
 *  用户是否已登陆，发送弹幕时需检查用户状态
 *
 *  @param mediaPlayerViewController
 */
- (BOOL)mediaPlayerViewControllerDidUserLogin:(AJMediaPlayerViewController *)mediaPlayerViewController;
@end

IB_DESIGNABLE
@interface AJMediaPlayerViewController : UIViewController
/**
 *  播放器当前播放状态
 */
@property(nonatomic, assign) AJMediaPlayerState currentMediaPlayerState;
/**
 *  播放器委托
 */
@property (nonatomic, assign) IBInspectable id<AJMediaViewControllerDelegate>delegate;
/**
 *  播放器顶部控制栏
 */
@property (nonatomic, retain) IBInspectable AJMediaPlayerCaptionControlPanel  *mediaPlayerNavigationBar;
/**
 *  播放器底部控制栏
 */
@property (nonatomic, retain) IBInspectable AJMediaPlayerPlaybackControlPanel  *mediaPlayerControlBar;
/**
 *  加载状态视图
 */
@property (nonatomic, retain) IBInspectable AJMediaIndicatorView *activityIndicatorView;
/**
 *  时移提示视图
 */
@property (nonatomic, retain) IBInspectable UIButton *timeshiftTipsButton;
/**
 *  取消时移按钮
 */
@property (nonatomic, retain) IBInspectable UIButton *revertTimeShiftButton;
/**
 *  播放器展示错误视图
 */
@property(nonatomic, retain) AJMediaPlayerMessageLayerView *playErrorView;
/**
 *  快进快退视图
 */
@property (nonatomic, retain) IBInspectable AJMediaPlayerProgressView *progressView;
/**
 *  3G提示视图
 */
@property (nonatomic, retain) IBInspectable AJMediaTipsView *tipsView;
/**
 *  播放器返回按钮
 */
@property (nonatomic, retain) IBInspectable UIButton *backButton;
/**
 *  播放器背景颜色
 */
@property (nonatomic, retain) IBInspectable UIColor *backgroundColor;
/**
 *  播放器展示比例
 */
@property (nonatomic, assign) AJMediaPlayerOverlayViewFillMode fillMode;
/**
 *  是否调出邮件反馈
 */
@property (nonatomic, assign) BOOL isMailViewControler;
/**
 *  竖屏模式是否显示backButton,默认不显示
 */
@property (nonatomic, assign) BOOL needsBackButtonInPortrait;
/**
 *  竖屏模式返回按钮为显示关闭图标
 */
@property (nonatomic, assign) BOOL displayCloseButton;
/**
 *  播放器外观显示模式
 */
@property (nonatomic, assign) AJMediaPlayerAppearenceStyle appearenceStyle;
/**
 *  全屏模式是否显示聊天室内开关,默认不显示
 */
@property (nonatomic, assign) BOOL needsChatroomSwitch;
/**
 *  聊天室内开关状态
 */
@property (nonatomic, assign,readonly) BOOL isChatroomActive;
/**
 *  iPad播放器小屏是否显示NavBar,默认为NO
 */
@property (nonatomic, assign) BOOL needsNavBarInPortraitForiPad;
/**
 *  iPad播放器不可控制模式
 */
@property (nonatomic, assign) BOOL isDecontrolled;
/**
 *  播放器当前是否人为添加视图
 */
@property (nonatomic, assign) BOOL isAddtionView;
/**
 *  待定的播放数组
 */
@property (nonatomic, strong) id playRequestSet;
/**
 *  播放器显示全屏或半屏模式更新约束方法
 *
 *  @param isFullScreen 是否全屏标示符
 */
- (void)transitionToFullScreenModel:(BOOL)isFullScreen;
/**
 *  播放器终止
 */
- (void)stop;
/**
 *  播放器播放
 */
- (void)play;
/**
 *  播放器暂停
 */
- (void)pause;
/**
 *  播放器上视图移除而播放
 */
- (void)playByAdditionView;
/**
 *  播放器上视图添加而暂停
 */
- (void)pauseByAdditionView;
/**
 *  播放器显示错误模式
 */
- (void)showPlayerErrorView;
/**
 *  播放器移除错误模式
 */
- (void)dismissPlayErrorView;
/**
 *  播放器当前播放时间
 *
 *  @return 当前播放时间
 */
- (NSTimeInterval)currentPlaybackTime;
/**
 *  播放器播放方法
 *
 *  @param AJMediaPlayRequest
 */
- (void)startToPlay:(AJMediaPlayRequest *)playRequest;
/**
 *  播放器从某个时间点开始播放
 *
 *  @param AJMediaPlayRequest
 *  @param 开始播放的时间点
 */
- (void)startToPlay:(AJMediaPlayRequest *)playRequest fromDuration:(NSTimeInterval )duration;
/**
 *  播放器初始化方法
 *
 *  @param style
 *  @param delegate
 */
- (instancetype)initWithStyle:(AJMediaPlayerAppearenceStyle )style delegate:(id)delegate;
/**
 *  发送弹幕消息
 *
 *  @param bullet 弹幕模型对象
 */
- (void)sendBullet:(VTBulletModel *)bullet;

@end

