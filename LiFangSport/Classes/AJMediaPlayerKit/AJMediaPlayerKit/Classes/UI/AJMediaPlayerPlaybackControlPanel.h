//
//  AJMediaPlayerPlaybackControlPanel.h
//  AJMediaPlayerShowcase
//
//  Created by Zhangqibin on 5/23/15.
//  Copyright (c) 2015 LeTV Sports Culture Develop (Beijing) Co., Ltd. All rights reserved.
//

@import UIKit;
#import "AJMediaPlayerStyleDefines.h"
#import "AJMediaPlayerButton.h"
typedef NS_ENUM(NSInteger, AJMediaPlayerPresentationMode) {
    AJMediaPlayerFullscreenPresentation,
    AJMediaPlayerEmbeddedPresentation
};

@class AJMediaPlayerPlaybackControlPanel;
@protocol AJMediaPlayerControlDelegate <NSObject>
/**
 *  播放器触发播放按钮
 */
-(void)playbackControl:(AJMediaPlayerPlaybackControlPanel *)playbackControl didTapPlay:(UIButton *)playButton;
/**
 *  播放器触发暂停按钮
 */
-(void)playbackControl:(AJMediaPlayerPlaybackControlPanel *)playbackControl didTapPause:(UIButton *)pauseButton;
/**
 *  播放器触发全屏按钮
 */
-(void)playbackControl:(AJMediaPlayerPlaybackControlPanel *)playbackControl didSelectPresentationMode:(AJMediaPlayerPresentationMode)presentationMode;
/**
 *  播放器触发音量按钮
 */
-(void)playbackControl:(AJMediaPlayerPlaybackControlPanel *)playbackControl didTapVolume:(UIButton *)volumeButton;
/**
 *  播放器完成调整进度条
 */
-(void)playbackControl:(AJMediaPlayerPlaybackControlPanel *)playbackControl didScrubToPosition:(float)scrubberPosition;
/**
 *  播放器完成调整直播时移进度条
 */
- (void)playbackControl:(AJMediaPlayerPlaybackControlPanel *)playbackControl didTimeShiftToPosition:(float)timeShiftToPosition;
/**
 *  播放器正在拖动进度条
 */
-(void)playbackControlScrubbing:(AJMediaPlayerPlaybackControlPanel *)playbackControl;
/**
 *  播放器停止拖动进度条
 */
-(void)playbackControlEndScrubbing:(AJMediaPlayerPlaybackControlPanel *)playbackControl;
/**
 *  iPad播放器点击切换码流
 */
- (void)playbackControlPanel:(AJMediaPlayerPlaybackControlPanel *)playbackControlPanel didTapOnStreamListHDButton:(UIButton *)streamListHDButton;
/**
 *  iPad播放器点击相关视频
 */
- (void)playbackControlPanel:(AJMediaPlayerPlaybackControlPanel *)playbackControlPanel didTapOnExcerptsHDButton:(UIButton *)excerptsHDButton;
/**
 *  全屏播放器聊天室开关
 */
- (void)playbackControl:(AJMediaPlayerPlaybackControlPanel *)playbackControl didChangeSwitchValue:(BOOL)isOn;

@end

IB_DESIGNABLE
@interface AJMediaPlayerPlaybackControlPanel : UIControl
/**
 *  播放器底部控制器委托
 */
@property (nonatomic, weak) IBInspectable id<AJMediaPlayerControlDelegate> delegate;
/**
 *  播放暂停按钮
 */
@property (nonatomic, strong) IBInspectable UIButton *playOrPauseButton;
/**
 *  视频播放时长Label
 */
@property (nonatomic, strong) IBInspectable UILabel *startTimeLabel;
/**
 *  视频总时长Label
 */
@property (nonatomic, strong) IBInspectable UILabel *totalDurationLabel;
/**
 *  播放进度条
 */
@property (nonatomic, strong) IBInspectable UISlider *progressScubber;
/**
 *  缓冲进度条
 */
@property (nonatomic, strong) IBInspectable UISlider *availableProgressScubber;
/**
 *  直播时移时长Label
 */
@property (nonatomic, strong) IBInspectable UILabel *timeShiftStartTimeLabel;
/**
 *  直播总时长Label
 */
@property (nonatomic, strong) IBInspectable UILabel *timeShiftTotalTimeLabel;
/**
 *  直播时移进度条
 */
@property (nonatomic, strong) IBInspectable UISlider *timeShiftProgressScubber;
/**
 *  切换全屏按钮
 */
@property (nonatomic, strong) IBInspectable UIButton *presentationSelectionButton;
/**
 *  iPad播放器切换码流按钮
 */
@property (nonatomic, strong) IBInspectable AJMediaPlayerButton *streamListHDButton;
/**
 *  iPad播放器相关视频按钮
 */
@property (nonatomic, strong) IBInspectable AJMediaPlayerButton *excerptsHDButton;
/**
 *  音量控制按钮
 */
@property (nonatomic, strong) IBInspectable UIButton *volumenControlButton;
/**
 *  聊天室按钮
 */
@property (nonatomic, strong) UIButton *chatroomSwitch;
/**
 *  是否支持聊天室
 */
@property (nonatomic, assign) BOOL isSupportChatroom;
/**
 *  背景图
 */
@property (nonatomic ,strong) IBInspectable UIImageView *backGroundImageView;
/**
 *  全屏标示符
 */
@property (nonatomic, assign) BOOL isFullScreen;
/**
 *  播放模式标示符
 */
@property (nonatomic, assign) BOOL isLiveModel;
/**
 *  播放是否支持时移
 */
@property (nonatomic, assign) BOOL isSupportTimeShift;
/**
 *  播放进度条位置
 */
@property (nonatomic, assign) IBInspectable float position;
/**
 *  播放进度条拖动位置
 */
@property (nonatomic, assign) IBInspectable float seekTime;
/**
 *  时移回访位置
 */
@property (nonatomic, assign) IBInspectable float timeshiftPosition;
/**
 *  直播当前播放时间
 */
@property (nonatomic, assign) IBInspectable float totalTime;
/**
 *  播放器播控栏初始化方法
 */
- (instancetype)initWithAppearenceStyle:(AJMediaPlayerAppearenceStyle )appearenceStyle;

- (void)updatePlayState:(BOOL)playState;
- (void)updateDuration:(double)duration currentPlayTime:(double)playTime availableTime:(double)availableTime;
- (void)updateVolume:(float)valume isHidden:(BOOL)isHidden;
- (void)updateDuration:(double)duration pendingTime:(double)pendingTime;
- (void)updateTotal:(double)totalTime timeshiftPosition:(double)timeshiftPosition;
- (void)endPendingTime:(double)pendingTime;
- (void)endTimeshift:(double)timeshift;
- (void)updateTimeShiftTime:(double)timeShiftTotalTime;
@end
