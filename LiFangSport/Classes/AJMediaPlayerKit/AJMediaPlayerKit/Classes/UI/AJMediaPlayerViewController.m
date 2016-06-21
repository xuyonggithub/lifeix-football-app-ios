//
//  AJMediaPlayerViewController.m
//  AJMediaPlayerKit
//
//  Created by lixiang on 15/7/7.
//  Copyright (c) 2015年 Gang Li. All rights reserved.
//

#import "AJMediaPlayerViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "AJMediaStreamSchedulingMetadataFetcher.h"
#import "AJMediaPlayerPlaybackControlPanel.h"
#import "AJMediaPlayerUtilities.h"
#import "AJMediaPlayerMessageLayerView.h"
#import "AJMediaPlayerVolumeControl.h"
#import "AJMediaEpisodePickerView.h"
#import "AJMediaQualityPickerView.h"
#import "AJMediaPlayerAnalyticsEventReporter.h"
#import "AJMediaPlayerCaptionControlPanel.h"
#import "AJMediaPlayerProgressView.h"
#import "AJMediaPlayRequest.h"
#import "AJMediaPlayerBackGroundView.h"
#import "AJMediaPlayerAirPlayBackGroundView.h"
#import "AJMediaPlayerInfrastructureContext_Internal.h"
#import "AJMediaPlayerUtilities.h"
#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCall.h>
#import "Reachability.h"
#import "AJMediaIndicatorView.h"
#import "AJMediaMailComposeViewController.h"
#import "AJMediaPlayerFeedback.h"
#import "AJMediaTipsView.h"
#import "AJMediaPlayerButton.h"
#import "AJMediaBulletInputView.h"
#import "VTBulletView.h"
#import "VTBulletModel.h"
#import "VTBulletItem.h"

#define BULLET_SWITCH_OFF @"bullet_switch_state"
#define USERDEFAULT_TIMESHIFT_KEY @"AJMediaPlayer_timeshift_used_times"
#define VideoPlayerEnterBackgroundTimeout   1800
#define LivePlayerEnterBackgroundTimeout    60


@interface AJMediaPlayerViewController ()<AJMediaPlayerViewDelegate, AJMediaPlayerDelegate,AJMediaPlayerControlDelegate,AJMediaPlayerCaptionControlPanelDelegate,AJMediaEpisodePickerViewDelegate, AJMediaQualityPickerViewDelegate,AJMediaPlayerErrorViewDelegate,UIAlertViewDelegate,MFMailComposeViewControllerDelegate, AJMediaBulletInputViewDelegate, VTBulletViewDataSource>
{
    NSInteger pendingSeekToTime;
    NSInteger durationTime;
    NSInteger totalTime;
    NSInteger timeshiftSeekToTime;
    BOOL isMoveSchedule;
    BOOL isSoundSlideChangeValue;
    id schedulingResult;
    BOOL isAirPlayReceviedPlayToEnd;
}

@property(nonatomic, strong) dispatch_queue_t Q;
/**
 *  播放器内核
 */
@property(nonatomic, strong) AJMediaPlayer *mediaPlayer;
/**
 *  播放器渲染视图
 */
@property(nonatomic, retain) AJMediaPlayerView *mediaPlayerView;
/**
 *  播放器调节音量视图
 */
@property(nonatomic, retain) AJMediaPlayerVolumeControl *soundControlView;
/**
 *  播放器中选集与切换码流视图
 */
@property(nonatomic, retain) UIView *rightSideViewContainer;
/**
 *  切换码流视图
 */
@property(nonatomic, retain) AJMediaQualityPickerView *qualityPickerView;
/**
 *  选段视图
 */
@property(nonatomic, retain) AJMediaEpisodePickerView *episodePickerView;
/**
 *  投屏至AirPlay后背景图
 */
@property (nonatomic, retain) AJMediaPlayerAirPlayBackGroundView *airPlayBackGroundView;
/**
 *  视频初始化背景图
 */
@property (nonatomic, strong) AJMediaPlayerBackGroundView *loadingBackGroundView;
/**
 *  3G/4G播放警告提示视图
 */
@property (nonatomic, strong) AJMediaPlayerMessageLayerView *wwanWarningView;
/**
 *  弹幕输入栏
 */
@property (nonatomic, strong) AJMediaBulletInputView *bulletInputView;
/**
 *  弹幕控件
 */
@property (nonatomic, strong) VTBulletView *bulletView;
/**
 *  弹幕编辑按钮
 */
@property (nonatomic, strong) UIButton *bulletEditButton;
/**
 *  是否全屏显示
 */
@property (nonatomic, assign) BOOL isFullScreenController;
/**
 *  播放器当前播放码流数据
 */
@property(nonatomic, retain) AJMediaPlayerItem *currentStreamItem;
/**
 *  播放器当前播放请求概要
 */
@property (nonatomic, retain) AJMediaPlayRequest *playRequest;
/**
 *  播放器网络请求类
 */
@property(nonatomic, retain) AJMediaStreamSchedulingMetadataFetcher *metadataFetcher;
/**
 *  播放器请求得到数据模型
 */
@property(nonatomic, retain) AJMediaStreamSchedulingMetadata *mediaStreamSchedulingMetadata;
/**
 *  播放器是否播放第一帧
 */
@property(nonatomic, assign) BOOL playFirstFrame;
/**
 *  播放器隐藏控制栏的定时器
 */
@property(nonatomic, strong) NSTimer *kTimer;
/**
 *  是否隐藏控制栏标示位
 */
@property(nonatomic, assign) BOOL hidePlayerControlBar;
/**
 *  储存约束数据
 */
@property(nonatomic, strong) NSMutableArray *constraintsList;
/**
 *  子视图的储存字典
 */
@property(nonatomic, strong) NSDictionary *subViewsDictionary;
/**
 *  是否处于时移回放状态
 */
@property (nonatomic, assign) BOOL isOnTimeShiftModel;
/**
 *  电话监测中心
 */
@property (nonatomic, strong) CTCallCenter *callCenter;
/**
 *  当前是否电话中
 */
@property (nonatomic, assign) BOOL isPhoneCalling;
/**
 *  播放器当前是否人为暂停
 */
@property (nonatomic ,assign) BOOL isManMadePause;
/**
 *  网络监测reachability
 */
@property (nonatomic, strong) Reachability *reachability;
/**
 *  当前网络状态
 */
@property (nonatomic, assign) NetworkStatus networkStatus;
/**
 *  是否忽略3G播放
 */
@property (nonatomic, assign) BOOL isIgnoreWWAN;
/**
 *  非WiFi网络点击继续播放标示位，防止点击继续播放，显示运营商网络提示
 */
@property (nonatomic, assign) BOOL isClickOnIgnorWWAN;
/**
 *  播放器首次加载，用于判断网络状况变化
 */
@property (nonatomic, assign) BOOL isFirstLanuch;
/**
 *  播放器是否进入后台
 */
@property (nonatomic, assign) BOOL isDidEnterBackground;
/**
 *  系统服务器时间与本地时间差
 */
@property (nonatomic, assign) NSTimeInterval timeDifference;
/**
 *  卡顿次数
 */
@property (atomic, assign) NSInteger bufferingNumbers;
/**
 *  显示卡顿的触发值
 */
@property (nonatomic, assign) NSInteger maxBufferingNumbers;
/**
 *  已经上报卡顿
 */
@property (nonatomic, assign) BOOL isAlreadySubmitBuffering;
/**
 *  是否监测到airplay
 */
@property (nonatomic, assign) BOOL isDetectedAirPlay;
/**
 *  是否需要延迟半秒播放，防止快速切换
 */
@property (nonatomic, assign) BOOL isShouldDelayToPlay;

@end

@implementation AJMediaPlayerViewController

#pragma mark - ViewController LifeCycle

- (instancetype)initWithStyle:(AJMediaPlayerAppearenceStyle )style delegate:(id)delegate {
    if (self = [super init]) {
        self.appearenceStyle = style;
        self.delegate = delegate;
    }
    return self;
}

- (void)loadView {
    [super loadView];
    _hidePlayerControlBar = NO;
    _isShouldDelayToPlay = NO;
    _playFirstFrame = NO;
    _isOnTimeShiftModel = NO;
    _isIgnoreWWAN = NO;
    _isClickOnIgnorWWAN = NO;
    _isFirstLanuch = YES;
    _isManMadePause = NO;
    _isAddtionView = NO;
    _bufferingNumbers = 0;
    _maxBufferingNumbers = 1;
    _isAlreadySubmitBuffering = NO;
    _isDetectedAirPlay = NO;
    _isChatroomActive = ![[NSUserDefaults standardUserDefaults] boolForKey:BULLET_SWITCH_OFF];

    self.mediaPlayerView = [[AJMediaPlayerView alloc] initWithFrame:self.view.bounds];
    _mediaPlayerView.translatesAutoresizingMaskIntoConstraints = NO;
    _mediaPlayerView.delegate = self;
    if (_fillMode) {
        [_mediaPlayerView setVideoFillMode:_fillMode];
    }
    if (_backgroundColor) {
        _mediaPlayerView.backgroundColor = _backgroundColor;
    }
    [self.view addSubview:_mediaPlayerView];
    
    self.Q = dispatch_queue_create("com.lesports.ajmediaplayer.kit.queue", DISPATCH_QUEUE_SERIAL);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.constraintsList = [NSMutableArray array];
    
    [self configureBulletView];
    [self configureBulletInputView];
    [self showLoadingBackGroundView:_appearenceStyle];
    [self configureNavigationBar:_appearenceStyle];
    [self configureBottomBar:_appearenceStyle];
    
    [self configureBulletEditButton];
    [self configureSoundControlView];
    [self configureTimeShiftTipsView];
    [self configureRevertTimeShiftButton];
    [self configureActivityIndicatorView:_appearenceStyle];
    [self configureBackButton];
    [self configureProgressView:_appearenceStyle];
    
    self.subViewsDictionary = NSDictionaryOfVariableBindings(_mediaPlayerView,_mediaPlayerNavigationBar,_mediaPlayerControlBar,_activityIndicatorView,_backButton,_timeshiftTipsButton,_revertTimeShiftButton, _bulletView, _bulletEditButton);
    [self addTapGestureRecognizer];
    if (_appearenceStyle == AJMediaPlayerStyleForiPad) {
        [self addPinchGestureRecognizer];
    }
    [self addCallCenterListener];
    [self setupReachabilty];
    [self fetchTimeDifferent];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self addNotification];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (!_playFirstFrame) {
        [AJMediaPlayerAnalyticsEventReporter submitCancelPlayEvent:_playRequest];
    }
    [self invalidateTimer];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self removeNotification];
}

- (void)dealloc {
    [self stop];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kReachabilityChangedNotification
                                                  object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Call Center Listener

- (void)addCallCenterListener {
    __weak typeof(self) weakSelf = self;
    self.callCenter = [[CTCallCenter alloc] init];
    _callCenter.callEventHandler = ^(CTCall* call) {
        if ([call.callState isEqualToString:CTCallStateIncoming]) {
            weakSelf.isPhoneCalling = YES;
        } else if ([call.callState isEqualToString:CTCallStateDisconnected]) {
            weakSelf.isPhoneCalling = NO;
        }
    };
}

#pragma mark - Setup Reachability

- (void)setupReachabilty {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    self.reachability = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    [self.reachability startNotifier];
}

- (void)reachabilityChanged:(NSNotification*)note {
    Reachability * reach = [note object];
    NSParameterAssert([reach isKindOfClass:[Reachability class]]);
    self.networkStatus = [reach currentReachabilityStatus];
    
    if(_networkStatus == ReachableViaWWAN){
        if (!_isFirstLanuch) {
            if (!_isIgnoreWWAN) {
                [self.mediaPlayer pause];
                [self showPlayerwwanWarningView];
            } else {
                [self showTipsViewWithText:@"您正在使用运营商网络"];
            }
        }
    } else if (_networkStatus == NotReachable) {
        if (!_isFirstLanuch) {
            if (self.wwanWarningView) {
                NSError *error = [NSError errorWithDomain:AJMediaStreamSchedulingMetadataFetchErrorDomain code:AJMediaPlayerLocalHTTPClientNetworkNotConnectedError userInfo:@{@"reason":@"未连接到服务器"}];
                [self handleWithErrorState:AJMediaPlayerLocalHTTPClientNetworkNotConnectedError errorInfo:error];
            }
        }
    }
    if (_isFirstLanuch) {
        _isFirstLanuch = NO;
    }
}

#pragma mark - Add Notification

- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerDidEnterBackground)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerWillResignActive)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerDidBecomeActive)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
}

- (void)removeNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidEnterBackgroundNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationWillResignActiveNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidBecomeActiveNotification
                                                  object:nil];
}

- (void)playerDidEnterBackground {
    if ([self isAirPlayActive]) {
        return;
    }
    aj_logMessage(AJLoggingInfo, @"Application did enter background");
    if (!_wwanWarningView) {
        self.isDidEnterBackground = YES;
        [self savePlayUrlWhenPlayerEnterBackground:_currentStreamItem];
    }
}

- (void)playerWillResignActive {
    if ([self isAirPlayActive]) {
        return;
    }
    aj_logMessage(AJLoggingInfo, @"Application will resign active, curren media player will be paused");
    if (!_wwanWarningView) {
        [self.mediaPlayer pause];
    }
}

- (void)playerDidBecomeActive {
    if ([self isAirPlayActive]) {
        return;
    }
    aj_logMessage(AJLoggingInfo, @"Application did recome active...");
    if (!_wwanWarningView) {
        [self updateSoundViewComponents];
        if (self.isDidEnterBackground) {
            if (self.currentStreamItem && self.currentStreamItem.preferredSchedulingStreamURL) {
                [self dealWithPlayUrlWhenPlayerBecomeActive];
            }
        } else {
            if (!_isManMadePause && !_isAddtionView) {
                [self.mediaPlayer play];
            }
        }
        self.isDidEnterBackground = NO;
    }
}

- (void)savePlayUrlWhenPlayerEnterBackground:(AJMediaPlayerItem *)playStreamItem {
    if (playStreamItem && playStreamItem.preferredSchedulingStreamURL) {
        NSString *videoType = playStreamItem.type==AJMediaPlayerVODStreamItem ? @"video":@"live";
        NSString *timeStamp = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
        NSDictionary *storageURLDictionary = @{@"videoType":videoType,@"playURL":playStreamItem.preferredSchedulingStreamURL,@"timeStamp":timeStamp};
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"storageURLDictionary"]) {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"storageURLDictionary"];
        }
        [[NSUserDefaults standardUserDefaults] setObject:storageURLDictionary forKey:@"storageURLDictionary"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)dealWithPlayUrlWhenPlayerBecomeActive {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"storageURLDictionary"]) {
        NSDictionary *storageURLDictionary = [[NSUserDefaults standardUserDefaults] objectForKey:@"storageURLDictionary"];
        NSString *videoType = [storageURLDictionary valueForKey:@"videoType"];
        int interval = (int)([@([[NSDate date] timeIntervalSince1970]) integerValue]-[storageURLDictionary[@"timeStamp"] integerValue]);
        if ([videoType isEqualToString:@"video"]) {
            if (interval > VideoPlayerEnterBackgroundTimeout) {
                if (storageURLDictionary[@"playURL"]) {
                    __weak typeof(self) weakSelf = self;
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        [[AJMediaPlayerInfrastructureContext cloudService] syncSecuredStreamURLWithSchedulingURL:storageURLDictionary[@"playURL"] success:^(NSError *error, NSURL *cdeLinkUrl) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                if (cdeLinkUrl) {
                                    NSTimeInterval currentPlayTime = [weakSelf.mediaPlayer currentPlaybackTime];
                                    [weakSelf.mediaPlayer restartToPlayVideoUrl:cdeLinkUrl currentTime:currentPlayTime error:error];
                                }
                            });
                        }];
                    });
                }
            } else {
                if ([[AJMediaPlayerInfrastructureContext cloudService] currentPlayURL]) {
                    NSTimeInterval currentPlayTime = [self.mediaPlayer currentPlaybackTime];
                    [self.mediaPlayer restartToPlayVideoUrl:[NSURL URLWithString:[[AJMediaPlayerInfrastructureContext cloudService] currentPlayURL]] currentTime:currentPlayTime error:nil];
                }
            }
        } else if ([videoType isEqualToString:@"live"]) {
            if (interval > LivePlayerEnterBackgroundTimeout) {
                if (storageURLDictionary[@"playURL"]) {
                    __weak typeof(self) weakSelf = self;
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        [[AJMediaPlayerInfrastructureContext cloudService] syncSecuredStreamURLWithSchedulingURL:storageURLDictionary[@"playURL"] success:^(NSError *error, NSURL *cdeLinkUrl) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                if (cdeLinkUrl) {
                                    [weakSelf.mediaPlayer restartToPlayLiveUrl:cdeLinkUrl error:error];
                                }
                            });
                        }];
                    });
                }
            } else {
                if ([[AJMediaPlayerInfrastructureContext cloudService] currentPlayURL]) {
                    [self.mediaPlayer restartToPlayLiveUrl:[NSURL URLWithString:[[AJMediaPlayerInfrastructureContext cloudService] currentPlayURL]] error:nil];
                }
            }
        }
        if (_isManMadePause || _isAddtionView) {
            [self.mediaPlayer pause];
        }
    }
}

#pragma mark - Setter Method

- (void)setNeedsNavBarInPortraitForiPad:(BOOL)needsNavBarInPortraitForiPad {
    _needsNavBarInPortraitForiPad = needsNavBarInPortraitForiPad;
}

- (void)setIsDecontrolled:(BOOL)isDecontrolled {
    _isDecontrolled = isDecontrolled;
    if (_isDecontrolled) {
        _timeshiftTipsButton.hidden = YES;
        _mediaPlayerNavigationBar.hidden = YES;
        _mediaPlayerControlBar.hidden = YES;
    } else {
        _mediaPlayerNavigationBar.hidden = NO;
        _mediaPlayerControlBar.hidden = NO;
        if (_mediaPlayerControlBar.isSupportTimeShift) {
            if (_isOnTimeShiftModel) {
                _timeshiftTipsButton.hidden = YES;
            } else {
                if (!_mediaPlayerNavigationBar.hidden) {
                    if ([[NSUserDefaults standardUserDefaults] valueForKey:USERDEFAULT_TIMESHIFT_KEY] && [[[NSUserDefaults standardUserDefaults] valueForKey:USERDEFAULT_TIMESHIFT_KEY] integerValue] > 1) {
                        _timeshiftTipsButton.hidden = YES;
                    } else {
                        _timeshiftTipsButton.hidden = NO;
                    }
                }
            }
        }
    }
    if (_mediaPlayerView) {
        _mediaPlayerView.shouldNotResponseGesture = isDecontrolled;
    }
}

#pragma mark - Add SubViews

- (void)configureBackButton {
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _backButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_backButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backButton];
}

- (void)configureBulletView
{
    self.bulletView = [[VTBulletView alloc] init];
    _bulletView.translatesAutoresizingMaskIntoConstraints = NO;
    _bulletView.userInteractionEnabled = NO;
    _bulletView.hidden = !_isFullScreenController ?: !_isChatroomActive;
    _bulletView.dataSource = self;
    [self.view addSubview:_bulletView];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_bulletView]-0-|"
                                                                                  options:0
                                                                                  metrics:nil
                                                                                    views:NSDictionaryOfVariableBindings(_bulletView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[_bulletView(104)]"
                                                                                  options:0
                                                                                  metrics:nil
                                                                                    views:NSDictionaryOfVariableBindings(_bulletView)]];
}

- (void)configureBulletEditButton
{
    self.bulletEditButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bulletEditButton setImage:[UIImage imageNamed:@"chat_button_normal_"] forState:UIControlStateNormal];
    [_bulletEditButton setImage:[UIImage imageNamed:@"chat_button_click_"] forState:UIControlStateSelected];
    [_bulletEditButton setImage:[UIImage imageNamed:@"chat_button_click_"] forState:UIControlStateHighlighted];
    [_bulletEditButton addTarget:self action:@selector(bulletEditAction:) forControlEvents:UIControlEventTouchUpInside];
    _bulletEditButton.translatesAutoresizingMaskIntoConstraints = NO;
    _bulletEditButton.hidden = YES;
    [self.view addSubview:_bulletEditButton];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_bulletEditButton(40)]-10-|"
                                                                                  options:0
                                                                                  metrics:nil
                                                                                    views:NSDictionaryOfVariableBindings(_bulletEditButton)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_bulletEditButton(40)]"
                                                                                  options:0
                                                                                  metrics:nil
                                                                                    views:NSDictionaryOfVariableBindings(_bulletEditButton)]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_bulletEditButton
                                                         attribute:NSLayoutAttributeCenterY
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self.view
                                                         attribute:NSLayoutAttributeCenterY
                                                        multiplier:1
                                                          constant:0]];
}

- (void)configureBulletInputView
{
    self.bulletInputView = [[AJMediaBulletInputView alloc] init];
    [_bulletInputView.cancelButton addTarget:self action:@selector(cancelBulletInput:) forControlEvents:UIControlEventTouchUpInside];
    [_bulletInputView.sendButton addTarget:self action:@selector(sendButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    _bulletInputView.translatesAutoresizingMaskIntoConstraints = NO;
    _bulletInputView.delegate = self;
    _bulletInputView.hidden = YES;
    [self.view addSubview:_bulletInputView];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_bulletInputView]-0-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_bulletInputView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_bulletInputView(64)]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_bulletInputView)]];
}

- (void)configureNavigationBar:(AJMediaPlayerAppearenceStyle )appearenceStyle {
    self.mediaPlayerNavigationBar = [[AJMediaPlayerCaptionControlPanel alloc] initWithAppearenceStyle:appearenceStyle];
    _mediaPlayerNavigationBar.delegate = self;
    _mediaPlayerNavigationBar.isShowInProtraitStyle = _needsNavBarInPortraitForiPad;
    _mediaPlayerNavigationBar.translatesAutoresizingMaskIntoConstraints = NO;
    _mediaPlayerNavigationBar.bufferButton.hidden = YES;
    if (appearenceStyle == AJMediaPlayerStyleForiPhone) {
        _mediaPlayerNavigationBar.streamListButton.hidden = YES;
        _mediaPlayerNavigationBar.excerptsButton.hidden = YES;
    } else if (appearenceStyle == AJMediaPlayerStyleForiPad) {
        _mediaPlayerNavigationBar.backToLiveButton.hidden = YES;
    }
    [self updateExcerptsButtonWithRequestSet:_playRequestSet];
    
    [self.view addSubview:_mediaPlayerNavigationBar];
}

- (void)updateExcerptsButtonWithRequestSet:(id)playRequestSet {
    if ([playRequestSet isKindOfClass:[NSArray class]]) {
        NSArray *tmpData = playRequestSet;
        if (tmpData && tmpData.count > 0) {
            if (_appearenceStyle == AJMediaPlayerStyleForiPhone) {
                _mediaPlayerNavigationBar.excerptsButton.hidden = NO;
                [_mediaPlayerNavigationBar setNeedsUpdateConstraints];
                [_mediaPlayerNavigationBar updateConstraintsIfNeeded];
            } else if (_appearenceStyle == AJMediaPlayerStyleForiPad) {
                _mediaPlayerControlBar.excerptsHDButton.hidden = NO;
                [_mediaPlayerControlBar setNeedsUpdateConstraints];
                [_mediaPlayerControlBar updateConstraintsIfNeeded];
            }
        } else {
            if (_appearenceStyle == AJMediaPlayerStyleForiPhone) {
                _mediaPlayerNavigationBar.excerptsButton.hidden = YES;
            } else if (_appearenceStyle == AJMediaPlayerStyleForiPad) {
                _mediaPlayerControlBar.excerptsHDButton.hidden = YES;
            }
        }
    } else if ([playRequestSet isKindOfClass:[NSDictionary class]]) {
        NSDictionary *tmpData = playRequestSet;
        if (tmpData && tmpData.count > 0) {
            if (_appearenceStyle == AJMediaPlayerStyleForiPhone) {
                _mediaPlayerNavigationBar.excerptsButton.hidden = NO;
                [_mediaPlayerNavigationBar setNeedsUpdateConstraints];
                [_mediaPlayerNavigationBar updateConstraintsIfNeeded];
            } else if (_appearenceStyle == AJMediaPlayerStyleForiPad) {
                _mediaPlayerControlBar.excerptsHDButton.hidden = NO;
                [_mediaPlayerControlBar setNeedsUpdateConstraints];
                [_mediaPlayerControlBar updateConstraintsIfNeeded];
            }
        } else {
            if (_appearenceStyle == AJMediaPlayerStyleForiPhone) {
                _mediaPlayerNavigationBar.excerptsButton.hidden = YES;
            } else if (_appearenceStyle == AJMediaPlayerStyleForiPad) {
                _mediaPlayerControlBar.excerptsHDButton.hidden = YES;
            }
        }
    }
}

- (void)configureBottomBar:(AJMediaPlayerAppearenceStyle )apperenceStyle {
    self.mediaPlayerControlBar = [[AJMediaPlayerPlaybackControlPanel alloc] initWithAppearenceStyle:apperenceStyle];
    _mediaPlayerControlBar.translatesAutoresizingMaskIntoConstraints = NO;
    
    if (apperenceStyle == AJMediaPlayerStyleForiPad) {
        _mediaPlayerControlBar.streamListHDButton.hidden = YES;
        _mediaPlayerControlBar.excerptsHDButton.hidden = YES;
    }
    
    _mediaPlayerControlBar.delegate = self;
    _mediaPlayerControlBar.position = 0;
    _mediaPlayerControlBar.isSupportChatroom = _needsChatroomSwitch;
    _mediaPlayerControlBar.chatroomSwitch.selected = _isChatroomActive;
    _mediaPlayerControlBar.isFullScreen = NO;
    [self.view addSubview:_mediaPlayerControlBar];
}

- (void)configureTimeShiftTipsView {
    self.timeshiftTipsButton = [[UIButton alloc] init];
    _timeshiftTipsButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_timeshiftTipsButton setBackgroundImage:[UIImage imageNamed:@"playback_image_bg"] forState:UIControlStateNormal];
    [_timeshiftTipsButton setTitle:@"拖动可看回放" forState:UIControlStateNormal];
    _timeshiftTipsButton.titleLabel.font = [UIFont systemFontOfSize:9];
    _timeshiftTipsButton.titleEdgeInsets = UIEdgeInsetsMake(-5, 0, 0, 0);
    _timeshiftTipsButton.hidden = YES;
    [self.view addSubview:_timeshiftTipsButton];
}

- (void)configureRevertTimeShiftButton{
    self.revertTimeShiftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _revertTimeShiftButton.layer.cornerRadius = 2;
    _revertTimeShiftButton.layer.borderWidth = 1;
    _revertTimeShiftButton.layer.borderColor = [UIColor colorWithHTMLColorMark:@"#ffffff"].CGColor;
    [_revertTimeShiftButton setTitle:@"回到直播" forState:UIControlStateNormal];
    _revertTimeShiftButton.backgroundColor = [UIColor colorWithHTMLColorMark:@"#000000" alpha:0.7f];
    _revertTimeShiftButton.titleLabel.font = [UIFont systemFontOfSize:12];
    _revertTimeShiftButton.translatesAutoresizingMaskIntoConstraints = NO;
    _revertTimeShiftButton.hidden = YES;
    [_revertTimeShiftButton addTarget:self action:@selector(revertTimeShiftButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_revertTimeShiftButton];
}

- (void)configureActivityIndicatorView:(AJMediaPlayerAppearenceStyle )apperenceStyle {
    self.activityIndicatorView = [[AJMediaIndicatorView alloc] init];
    _activityIndicatorView.backgroundColor = [UIColor clearColor];
    _activityIndicatorView.translatesAutoresizingMaskIntoConstraints = NO;
    _activityIndicatorView.hidesWhenStopped = YES;
    _activityIndicatorView.tintColor = [UIColor colorWithRed:41.f/255 green:196.f/255 blue:198.f/255 alpha:1];
    [self.mediaPlayerView addSubview:_activityIndicatorView];
    
    float activityViewHeight = apperenceStyle==AJMediaPlayerStyleForiPhone?25.0f:35.0f;
    [self.mediaPlayerView addConstraint:[NSLayoutConstraint
                                         constraintWithItem:_activityIndicatorView
                                         attribute:NSLayoutAttributeCenterX
                                         relatedBy:NSLayoutRelationEqual
                                         toItem:_mediaPlayerView
                                         attribute:NSLayoutAttributeCenterX
                                         multiplier:1
                                         constant:0]];
    [self.mediaPlayerView addConstraint:[NSLayoutConstraint
                                         constraintWithItem:_activityIndicatorView
                                         attribute:NSLayoutAttributeCenterY
                                         relatedBy:NSLayoutRelationEqual
                                         toItem:_mediaPlayerView
                                         attribute:NSLayoutAttributeCenterY
                                         multiplier:1
                                         constant:0]];
    [self.mediaPlayerView addConstraint:[NSLayoutConstraint constraintWithItem:_activityIndicatorView
                                                     attribute:NSLayoutAttributeWidth
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:nil
                                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                                    multiplier:1.0f
                                                                      constant:activityViewHeight]];
    
    [self.mediaPlayerView addConstraint:[NSLayoutConstraint constraintWithItem:_activityIndicatorView
                                                     attribute:NSLayoutAttributeHeight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:nil
                                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                                    multiplier:1.0f
                                                                      constant:activityViewHeight]];
}

- (void)configureProgressView:(AJMediaPlayerAppearenceStyle )apperenceStyle{
    self.progressView = [[AJMediaPlayerProgressView alloc] initWithAJMediaPlayerAppearenceStyle:apperenceStyle];
    _progressView.translatesAutoresizingMaskIntoConstraints = NO;
    _progressView.hidden = YES;
    [self.mediaPlayerView addSubview:_progressView];
    
    float mediaPlayerViewWidth = apperenceStyle==AJMediaPlayerStyleForiPhone?145:200;
    float mediaPlayerViewHeight = apperenceStyle==AJMediaPlayerStyleForiPhone?108:130;
    [self.mediaPlayerView addConstraint:[NSLayoutConstraint constraintWithItem:_progressView
                                                                     attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f
                                                                      constant:mediaPlayerViewWidth]];
    [self.mediaPlayerView addConstraint:[NSLayoutConstraint constraintWithItem:_progressView
                                                                     attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f
                                                                      constant:mediaPlayerViewHeight]];
    [self.mediaPlayerView addConstraint:[NSLayoutConstraint
                                         constraintWithItem:_progressView
                                         attribute:NSLayoutAttributeCenterX
                                         relatedBy:NSLayoutRelationEqual
                                         toItem:self.mediaPlayerView
                                         attribute:NSLayoutAttributeCenterX
                                         multiplier:1
                                         constant:0]];
    [self.mediaPlayerView addConstraint:[NSLayoutConstraint
                                         constraintWithItem:_progressView
                                         attribute:NSLayoutAttributeCenterY
                                         relatedBy:NSLayoutRelationEqual
                                         toItem:self.mediaPlayerView
                                         attribute:NSLayoutAttributeCenterY
                                         multiplier:1
                                         constant:0]];
}

- (void)configureSoundControlView {
    self.soundControlView = [[AJMediaPlayerVolumeControl alloc] initWithAppearenceStyle:_appearenceStyle];
    _soundControlView.translatesAutoresizingMaskIntoConstraints = NO;
    _soundControlView.hidden = YES;
    [_soundControlView.slider addTarget:self action:@selector(soundSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [_soundControlView.slider addTarget:self action:@selector(soundSlidersTouchUp:) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside|UIControlEventTouchCancel];
    [self.view addSubview:_soundControlView];
    
    if (_appearenceStyle == AJMediaPlayerStyleForiPhone) {
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_soundControlView(30)]-15-|"
                                                                          options:0
                                                                          metrics:nil
                                                                            views:NSDictionaryOfVariableBindings(_soundControlView)]];
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_soundControlView(130)]-57-|"
                                                                          options:0
                                                                          metrics:nil
                                                                            views:NSDictionaryOfVariableBindings(_soundControlView)]];
    } else if (_appearenceStyle == AJMediaPlayerStyleForiPad) {
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_soundControlView(36)]-15-|"
                                                                          options:0
                                                                          metrics:nil
                                                                            views:NSDictionaryOfVariableBindings(_soundControlView)]];
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_soundControlView(165)]-67-|"
                                                                          options:0
                                                                          metrics:nil
                                                                            views:NSDictionaryOfVariableBindings(_soundControlView)]];
    }
}

#pragma mark - Add Pinch GestureRecognizer

- (void)addPinchGestureRecognizer {
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    [self.mediaPlayerView addGestureRecognizer:pinchGesture];
}

- (void)handlePinch:(UIPinchGestureRecognizer *)pinch {
    if (pinch.state == UIGestureRecognizerStateEnded) {
        BOOL fullScreenMode;
        if (_isFullScreenController && pinch.scale < 1.f) {
            fullScreenMode = NO;
        } else if (!_isFullScreenController && pinch.scale > 1.f) {
            fullScreenMode = YES;
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(mediaPlayerViewController:didSelectFullScreenMode:)]) {
            [self.delegate mediaPlayerViewController:self didSelectFullScreenMode:fullScreenMode];
        }
    }
}

#pragma mark - Add Tap GestureRecognizer

- (void)addTapGestureRecognizer {
    NSMutableArray *tapGestureArray = [NSMutableArray arrayWithCapacity:0];
    if (self.mediaPlayerView.gestureRecognizers) {
        for (id obj in self.mediaPlayerView.gestureRecognizers) {
            if ([obj isKindOfClass:[UITapGestureRecognizer class]]) {
                UITapGestureRecognizer *tapGesture = obj;
                [tapGestureArray addObject:tapGesture];
            }
        }
    }
    if (tapGestureArray.count == 0) {
        UITapGestureRecognizer* singleRecognizer;
        singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapFrom)];
        singleRecognizer.numberOfTapsRequired = 1;
        singleRecognizer.numberOfTouchesRequired = 1;
        [self.mediaPlayerView addGestureRecognizer:singleRecognizer];
    }
}

- (void)removeTapGestureRecognizer {
    if (self.mediaPlayerView.gestureRecognizers) {
        for (id obj in self.mediaPlayerView.gestureRecognizers) {
            if ([obj isKindOfClass:[UITapGestureRecognizer class]]) {
                UITapGestureRecognizer *tapGesture = obj;
                [self.mediaPlayerView removeGestureRecognizer:tapGesture];
            }
        }
    }
}

- (void)handleSingleTapFrom {
    if (!self.qualityPickerView.hidden) {
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:0.2
                         animations:^{
                             weakSelf.qualityPickerView.frame = CGRectMake(weakSelf.view.frame.size.width, 0, 200, weakSelf.view.frame.size.height);
                         } completion:^(BOOL finished) {
                             weakSelf.qualityPickerView.hidden = YES;
                         }];
    }
    
    if (!self.episodePickerView.hidden) {
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:0.2
                         animations:^{
                             weakSelf.episodePickerView.frame = CGRectMake(weakSelf.view.frame.size.width, 0, 200, weakSelf.view.frame.size.height);
                         } completion:^(BOOL finished) {
                             weakSelf.episodePickerView.hidden = YES;
                         }];
    }
    
    if (!_bulletInputView.isHidden) {
        [self cancelBulletInput:nil];
        return;
    }
    if (_hidePlayerControlBar) {
        _hidePlayerControlBar = NO;
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:0.1
                         animations:^{
                            [weakSelf showPlaybackControls];
                         } completion:^(BOOL finished) {
                             if (finished) {
                                 [weakSelf fireTimer];
                             }
                         }];
    } else {
        [self hidePlaybackControls];
    }
}

#pragma mark -  Add Auto Layout Contraints

- (void)updateViewConstraints {
    [super updateViewConstraints];
    [self.view removeConstraints:_constraintsList];
    [_constraintsList removeAllObjects];
    if (self.isFullScreenController) {
        [self addLandscapeContraints];
    } else {
        [self addPortraitConstraints];
    }
}

- (void)addPortraitConstraints {
    [self updatePortraitSubviewsHiddenState];
    [_constraintsList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_mediaPlayerView]-0-|"
                                                                                  options:0
                                                                                  metrics:nil
                                                                                   views:_subViewsDictionary]];
    [_constraintsList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_mediaPlayerView]-0-|"
                                                                                  options:0
                                                                                  metrics:nil
                                                                                views:_subViewsDictionary]];
    [_constraintsList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_mediaPlayerNavigationBar]-0-|"
                                                                                  options:0
                                                                                  metrics:nil
                                                                                views:_subViewsDictionary]];
    [_constraintsList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_mediaPlayerNavigationBar(44)]"
                                                                                  options:0
                                                                                  metrics:nil
                                                                                views:_subViewsDictionary]];
    [_constraintsList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_backButton(32)]"
                                                                                  options:0
                                                                                  metrics:nil
                                                                                views:_subViewsDictionary]];
    [_constraintsList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[_backButton(32)]"
                                                                                  options:0
                                                                                  metrics:nil
                                                                                views:_subViewsDictionary]];
    [_constraintsList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_mediaPlayerControlBar]-0-|"
                                                                                  options:0
                                                                                  metrics:nil
                                                                                views:_subViewsDictionary]];
    
    float timeShifTipsButtonHeight = 27;
    [_constraintsList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_timeshiftTipsButton(timeShifTipsButtonHeight)]-0-[_mediaPlayerControlBar(44)]-0-|"
                                                                                  options:0
                                                                        metrics:@{@"timeShifTipsButtonHeight":@(timeShifTipsButtonHeight)}
                                                                                views:_subViewsDictionary]];
    
    if (_isDetectedAirPlay) {
        [_constraintsList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_revertTimeShiftButton(60)]-60-|"
                                                                                      options:0
                                                                                      metrics:nil
                                                                                        views:_subViewsDictionary]];
    } else {
        [_constraintsList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_revertTimeShiftButton(60)]-10-|"
                                                                                      options:0
                                                                                      metrics:nil
                                                                                        views:_subViewsDictionary]];
    }
    [_constraintsList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_revertTimeShiftButton(22)]"
                                                                                  options:0
                                                                                  metrics:nil
                                                                                    views:_subViewsDictionary]];
    
    float timeShiftTipsButtonRight = _appearenceStyle==AJMediaPlayerStyleForiPhone ? 43:50;
    if (_currentStreamItem.liveStartTime) {
        NSTimeInterval localtime = [[NSDate date] timeIntervalSince1970]*1000/1000;
        NSDate *serverDate = [NSDate dateWithTimeIntervalSince1970:localtime-_timeDifference];
        NSTimeInterval timeInterval = [serverDate timeIntervalSinceDate:_currentStreamItem.liveStartTime];
        if (timeInterval > 60*60) {
            timeShiftTipsButtonRight = _appearenceStyle==AJMediaPlayerStyleForiPhone ? 53:60;
        } else {
            timeShiftTipsButtonRight = _appearenceStyle==AJMediaPlayerStyleForiPhone ? 43:50;
        }
    }
    
    float timeShifTipsButtonWidth = 68;
    [_constraintsList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_timeshiftTipsButton(timeShifTipsButtonWidth)]-timeShiftTipsButtonRight-|"
                                                                                  options:0
                                                                        metrics:@{@"timeShifTipsButtonWidth":@(timeShifTipsButtonWidth),@"timeShiftTipsButtonRight":@(timeShiftTipsButtonRight)}
                                                                                    views:_subViewsDictionary]];
    [self.view addConstraints:_constraintsList];
}

- (void)updatePortraitSubviewsHiddenState {
    [_timeshiftTipsButton setBackgroundImage:[UIImage imageNamed:@"playback_image_bg"] forState:UIControlStateNormal];
    _timeshiftTipsButton.titleLabel.font = [UIFont systemFontOfSize:9];
    NSString *backButtonNormal_ImageName_ = _displayCloseButton ? @"close_video":@"miniplayer_bt_back_nor";
    NSString *backButtonPress_ImageName_ = _displayCloseButton ? @"close_video_press":@"miniplayer_bt_back_press";
    [_backButton setImage:[UIImage imageNamed:backButtonNormal_ImageName_] forState:UIControlStateNormal];
    [_backButton setImage:[UIImage imageNamed:backButtonPress_ImageName_] forState:UIControlStateHighlighted];
    _qualityPickerView.hidden = YES;
    _episodePickerView.hidden = YES;
    _soundControlView.hidden = YES;
    if (_needsBackButtonInPortrait) {
        _backButton.hidden = NO;
    } else {
        _backButton.hidden = YES;
    }
    if (_mediaPlayerControlBar.isSupportTimeShift) {
        if (_isOnTimeShiftModel) {
            _timeshiftTipsButton.hidden = YES;
        } else {
            if (!_mediaPlayerNavigationBar.hidden) {
                if ([[NSUserDefaults standardUserDefaults] valueForKey:USERDEFAULT_TIMESHIFT_KEY] && [[[NSUserDefaults standardUserDefaults] valueForKey:USERDEFAULT_TIMESHIFT_KEY] integerValue] > 1) {
                    _timeshiftTipsButton.hidden = YES;
                } else {
                    _timeshiftTipsButton.hidden = NO;
                }
            }
        }
    }
}

- (void)addLandscapeContraints {
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (weakSelf.mediaPlayerControlBar.hidden) {
            [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
        } else {
            if (!weakSelf.revertTimeShiftButton.hidden) {
                [weakSelf.view bringSubviewToFront:weakSelf.revertTimeShiftButton];
            }
            [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
        }
    });

    [self updateLandscapeSubviewsHiddenState];
    [_constraintsList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_mediaPlayerView]-0-|"
                                                                                  options:0
                                                                                  metrics:nil
                                                                                views:_subViewsDictionary]];
    [_constraintsList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_mediaPlayerView]-0-|"
                                                                                  options:0
                                                                                  metrics:nil
                                                                                views:_subViewsDictionary]];
    [_constraintsList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_mediaPlayerNavigationBar]-0-|"
                                                                                  options:0
                                                                                  metrics:nil
                                                                                    views:_subViewsDictionary]];
    float mediaPlayerNavigationBarHeight = _appearenceStyle == AJMediaPlayerStyleForiPhone ? 60:80;
    [_constraintsList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_mediaPlayerNavigationBar(mediaPlayerNavigationBarHeight)]-15-[_revertTimeShiftButton(22)]"
                                                                                  options:0
                                                                                  metrics:@{@"mediaPlayerNavigationBarHeight":@(mediaPlayerNavigationBarHeight)}
                                                                                views:_subViewsDictionary]];
    if (_appearenceStyle == AJMediaPlayerStyleForiPhone) {
        [_constraintsList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_backButton(32)]"
                                                                                      options:0
                                                                                      metrics:nil
                                                                                        views:_subViewsDictionary]];
        [_constraintsList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[_backButton(32)]"
                                                                                      options:0
                                                                                      metrics:nil
                                                                                        views:_subViewsDictionary]];
    } else if (_appearenceStyle == AJMediaPlayerStyleForiPad) {
        [_constraintsList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_backButton(40)]"
                                                                                      options:0
                                                                                      metrics:nil
                                                                                        views:_subViewsDictionary]];
        [_constraintsList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-30-[_backButton(40)]"
                                                                                      options:0
                                                                                      metrics:nil
                                                                                        views:_subViewsDictionary]];
    }
    [_constraintsList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_mediaPlayerControlBar]-0-|"
                                                                                  options:0
                                                                                  metrics:nil
                                                                                views:_subViewsDictionary]];
    float timeShiftTipsButtonWidth = _appearenceStyle==AJMediaPlayerStyleForiPhone ? 27:38;
    float mediaPlayerControlBarWidth = _appearenceStyle==AJMediaPlayerStyleForiPhone ? 50:60;
    [_constraintsList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_timeshiftTipsButton(timeShiftTipsButtonWidth)]-0-[_mediaPlayerControlBar(mediaPlayerControlBarWidth)]-0-|"
                                                                                  options:0
                                                                                metrics:@{@"timeShiftTipsButtonWidth":@(timeShiftTipsButtonWidth),@"mediaPlayerControlBarWidth":@(mediaPlayerControlBarWidth)}
                                                                                views:_subViewsDictionary]];
    [_constraintsList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_revertTimeShiftButton(60)]-15-|"
                                                                                  options:0
                                                                                  metrics:nil
                                                                                    views:_subViewsDictionary]];
    
    float timeShiftTipsButtonRight = 78;
    if (_currentStreamItem.liveStartTime) {
        NSTimeInterval localtime = [[NSDate date] timeIntervalSince1970]*1000/1000;
        NSDate *serverDate = [NSDate dateWithTimeIntervalSince1970:localtime-_timeDifference];
        NSTimeInterval timeInterval = [serverDate timeIntervalSinceDate:_currentStreamItem.liveStartTime];
        if (_appearenceStyle == AJMediaPlayerStyleForiPad) {
            if (timeInterval > 60*60) {
                float right = [self calculateTimeshiftTipsButtonRight:YES];
                timeShiftTipsButtonRight = right;
            } else {
                float right = [self calculateTimeshiftTipsButtonRight:NO];
                timeShiftTipsButtonRight = right;
            }
        } else if (_appearenceStyle == AJMediaPlayerStyleForiPhone) {
            if (timeInterval > 60*60) {
                timeShiftTipsButtonRight = _needsChatroomSwitch ? 94+69:94;
            } else {
                timeShiftTipsButtonRight = _needsChatroomSwitch ? 78+69:78;
            }
        }
    }
    
    float timeshiftTipsButtonWidth = _appearenceStyle==AJMediaPlayerStyleForiPhone ? 68:100;
    [_constraintsList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_timeshiftTipsButton(timeshiftTipsButtonWidth)]-timeShiftTipsButtonRight-|"
                                                                                  options:0
                                                                                  metrics:@{@"timeshiftTipsButtonWidth":@(timeshiftTipsButtonWidth),@"timeShiftTipsButtonRight":@(timeShiftTipsButtonRight)}
                                                                                    views:_subViewsDictionary]];
    [self.view addConstraints:_constraintsList];
}

- (float)calculateTimeshiftTipsButtonRight:(float)isLongTimeLabel {
    float right = isLongTimeLabel ? 355:339;
    if (_mediaPlayerControlBar.streamListHDButton.hidden) {
        right = right-86;
    }
    if (_mediaPlayerControlBar.excerptsHDButton.hidden) {
        right = right-86;
    }
    if (_mediaPlayerControlBar.chatroomSwitch.hidden) {
        right = right-88;
    }
    if (_mediaPlayerControlBar.streamListHDButton.hidden && _mediaPlayerControlBar.excerptsHDButton.hidden && _mediaPlayerControlBar.chatroomSwitch.hidden) {
        right = right-16;
    }
    return right;
}

- (void)updateLandscapeSubviewsHiddenState {
    if (_appearenceStyle == AJMediaPlayerStyleForiPad) {
        [_timeshiftTipsButton setBackgroundImage:[UIImage imageNamed:@"playback_image_bg_iPad"] forState:UIControlStateNormal];
        [_timeshiftTipsButton setBackgroundImage:[UIImage imageNamed:@"playback_image_bg_iPad"] forState:UIControlStateHighlighted];
        _timeshiftTipsButton.titleLabel.font = [UIFont systemFontOfSize:12];
    }
    [_backButton setImage:[UIImage imageNamed:@"bt_back_press"] forState:UIControlStateHighlighted];
    [_backButton setImage:[UIImage imageNamed:@"bt_back"] forState:UIControlStateNormal];
    if (!self.mediaPlayerControlBar.hidden) {
        _backButton.hidden = NO;
    } else {
        _backButton.hidden = YES;
    }
    _qualityPickerView.hidden = _episodePickerView.hidden = YES;
    [self updateSoundViewComponents];
}


#pragma mark - Setter Getter Method

- (void)setPlayRequestSet:(id)playRequestSet{
    if ([playRequestSet isKindOfClass:[NSArray class]] || [playRequestSet isKindOfClass:[NSDictionary class]]) {
        _playRequestSet = playRequestSet;
    }
    [self updateExcerptsButtonWithRequestSet:_playRequestSet];
}

- (void)setNeedsChatroomSwitch:(BOOL)needsChatroomSwitch {
    _needsChatroomSwitch = needsChatroomSwitch;
    _mediaPlayerControlBar.isSupportChatroom = _needsChatroomSwitch;
    _mediaPlayerControlBar.chatroomSwitch.selected = _isChatroomActive;
    _bulletEditButton.hidden = [self shouldHideEditItem];
    [_mediaPlayerControlBar setNeedsUpdateConstraints];
    [_mediaPlayerControlBar updateConstraintsIfNeeded];
}

#pragma mark - Private Method

- (BOOL)isAirPlayActive {
    BOOL isActive = NO;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
#if !TARGET_IPHONE_SIMULATOR
    CFDictionaryRef currentRouteDescriptionDictionary = nil;
    UInt32 dataSize = sizeof(currentRouteDescriptionDictionary);
    AudioSessionGetProperty(kAudioSessionProperty_AudioRouteDescription, &dataSize, &currentRouteDescriptionDictionary);
    if (currentRouteDescriptionDictionary) {
        CFArrayRef outputs = CFDictionaryGetValue(currentRouteDescriptionDictionary, kAudioSession_AudioRouteKey_Outputs);
        if(CFArrayGetCount(outputs) > 0) {
            CFDictionaryRef currentOutput = CFArrayGetValueAtIndex(outputs, 0);
            CFStringRef outputType = CFDictionaryGetValue(currentOutput, kAudioSession_AudioRouteKey_Type);
            isActive = (CFStringCompare(outputType, kAudioSessionOutputRoute_AirPlay, 0) == kCFCompareEqualTo);
        }
    }
#endif
    aj_logMessage(AJLoggingInfo, isActive ? @"Current device detected an active AirPlay devices" : @"Current device can not find any available AirPlay devices");
    return isActive;
#pragma clang diagnostic pop
}

#pragma mark - Pulic Method

- (void)setNeedsBackButtonInPortrait:(BOOL)needsBackButtonInPortrait {
    _needsBackButtonInPortrait = needsBackButtonInPortrait;
    _backButton.hidden = !_needsBackButtonInPortrait;
}

- (void)setDisplayCloseButton:(BOOL)displayCloseButton {
    _displayCloseButton = displayCloseButton;
    NSString *backButtonNormal_ImageName_ = _displayCloseButton ? @"close_video":@"miniplayer_bt_back_nor";
    NSString *backButtonPress_ImageName_ = _displayCloseButton ? @"close_video_press":@"miniplayer_bt_back_press";
    [_backButton setImage:[UIImage imageNamed:backButtonNormal_ImageName_] forState:UIControlStateNormal];
    [_backButton setImage:[UIImage imageNamed:backButtonPress_ImageName_] forState:UIControlStateHighlighted];
}

- (void)transitionToFullScreenModel:(BOOL)isFullScreen {
    self.isFullScreenController = isFullScreen;
    
    _bulletEditButton.hidden = [self shouldHideEditItem];
    _bulletView.hidden = !isFullScreen ?: !_isChatroomActive;
    self.mediaPlayerControlBar.isFullScreen = isFullScreen;
    [self.mediaPlayerControlBar setNeedsUpdateConstraints];
    [self.mediaPlayerControlBar updateConstraintsIfNeeded];
    
    self.mediaPlayerNavigationBar.isFullScreen = isFullScreen;
    [self.mediaPlayerNavigationBar setNeedsUpdateConstraints];
    [self.mediaPlayerNavigationBar updateConstraintsIfNeeded];
    if (!isFullScreen) {
        [self cancelBulletInput:nil];
        [_bulletView clearBuffer];
    }
    
    [self.view setNeedsUpdateConstraints];
    [self.view updateConstraintsIfNeeded];
}

- (void)play {
    if (!_isManMadePause && !_isAddtionView) {
        [self.mediaPlayer play];
    }
}

- (void)pause {
    [self.mediaPlayer pause];
}

- (void)playByAdditionView {
    self.isAddtionView = NO;
    if (!_isManMadePause && !_isAddtionView) {
        [self.mediaPlayer play];
    }
}

- (void)pauseByAdditionView {
    self.isAddtionView = YES;
    [self.mediaPlayer pause];
}

- (NSTimeInterval)currentPlaybackTime {
    return [self.mediaPlayer currentPlaybackTime];
}

- (void)startToPlay:(AJMediaPlayRequest *)playRequest {
    [self startToPlay:playRequest fromDuration:0];
}

- (void)startToPlay:(AJMediaPlayRequest *)playRequest fromDuration:(NSTimeInterval )duration {
    isAirPlayReceviedPlayToEnd = NO;
    if (playRequest) {
        self.playRequest = playRequest;
        if (self.episodePickerView && !self.episodePickerView.hidden) {
            if (_playRequest.identifier) {
                self.episodePickerView.streamID = _playRequest.identifier;
            }
            [self.episodePickerView.tableView reloadData];
        }
        if (_mediaPlayerNavigationBar) {
            _mediaPlayerNavigationBar.titleLabel.text = _playRequest.resourceName;
        }
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(delayStartToPlayFromDuration:) object:@(duration)];
    if (_isShouldDelayToPlay == NO) {
        [self performSelector:@selector(delayStartToPlayFromDuration:) withObject:@(duration) afterDelay:0];
    } else {
        [self performSelector:@selector(delayStartToPlayFromDuration:) withObject:@(duration) afterDelay:0.5];
    }
    _isShouldDelayToPlay = YES;
}

- (void)stop {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(delayStartToPlayFromDuration:) object:nil];
    [self dismissLoadingBackGroundView];
    if (self.metadataFetcher) {
        [self.metadataFetcher cancelTask];
    }
    if (self.mediaPlayer) {
        [self.mediaPlayer invalidate];
        self.mediaPlayer = nil;
    }
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
}

#pragma mark - Private Method

- (void)delayStartToPlayFromDuration:(NSNumber *)time {
    if (self.mediaPlayer) {
        [self.mediaPlayer invalidate];
        self.mediaPlayer = nil;
    }
    aj_logMessage(AJLoggingInfo, @"Recieved %@", _playRequest);
    if ([self isAirPlayActive]) {
        if (_delegate && [_delegate respondsToSelector:@selector(mediaPlayerViewController:didChangeAirPlayState:)]) {
            [_delegate mediaPlayerViewController:self didChangeAirPlayState:AJMediaPlayerAirPlayActive];
        }
        aj_logMessage(AJLoggingInfo, @"Play %@ on AirPlay devices (Apple TV)", _playRequest);
        id defaultStreamProvider = [AJDefaultStreamProviderImplementation provider];
        self.mediaPlayer = [[AJMediaPlayer alloc] initWithStreamProvider:defaultStreamProvider];
        _mediaPlayer.delegate = self;
        [self.mediaPlayer setDisplayView:self.mediaPlayerView];
        
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf showAirPlayBackGroundView];
        });
    } else {
        if (_delegate && [_delegate respondsToSelector:@selector(mediaPlayerViewController:didChangeAirPlayState:)]) {
            [_delegate mediaPlayerViewController:self didChangeAirPlayState:AJMediaPlayerAirPlayInActive];
        }
        id cdeStreamProvider = [AJLetvCDEStreamProviderImplementation provider];
        self.mediaPlayer = [[AJMediaPlayer alloc] initWithStreamProvider:cdeStreamProvider];
        _mediaPlayer.delegate = self;
        [self.mediaPlayer setDisplayView:self.mediaPlayerView];
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf dismissAirPlayBackGroundView];
        });
    }
    self.mediaStreamSchedulingMetadata = nil;
    [self resetSubViewStatus];
    _currentMediaPlayerState = AJMediaPlayerStateContentInit;
    [self showLoadingBackGroundView:_appearenceStyle];
    
    if ((self.networkStatus != ReachableViaWWAN) || _isIgnoreWWAN) {
        if (_isIgnoreWWAN && self.networkStatus == ReachableViaWWAN && !_isClickOnIgnorWWAN) {
            [self showTipsViewWithText:@"您正在使用运营商网络"];
        }
        _isClickOnIgnorWWAN = NO;
        
        if (self.playRequest) {
            [AJMediaPlayerAnalyticsEventReporter recordCancelPlayEventStartTime];
            [AJMediaPlayerAnalyticsEventReporter submitLoadToPlayEvent:_playRequest];
            if (_playRequest.type == AJMediaPlayerVODStreamItem) {
                [AJMediaPlayerAnalyticsEventReporter submitLoadToVodPlayEvent:_playRequest];
            } else if (_playRequest.type == AJMediaPlayerLiveStreamItem) {
                [AJMediaPlayerAnalyticsEventReporter submitLoadToLivePlayEvent:_playRequest];
            } else if (_playRequest.type == AJMediaPlayerStationStreamItem) {
                [AJMediaPlayerAnalyticsEventReporter submitLoadToStationPlayEvent:_playRequest];
            }
            [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
            if (_playRequest.type == AJMediaPlayerLiveStreamItem || _playRequest.type == AJMediaPlayerStationStreamItem) {
                _mediaPlayerControlBar.isLiveModel = YES;
                [_mediaPlayerControlBar setNeedsUpdateConstraints];
                [_mediaPlayerControlBar updateConstraintsIfNeeded];
            } else {
                _mediaPlayerControlBar.isLiveModel = NO;
                [_mediaPlayerControlBar setNeedsUpdateConstraints];
                [_mediaPlayerControlBar updateConstraintsIfNeeded];
            }
            if (nil == _playRequest.identifier || _playRequest.identifier.length <= 0) {
                [self handleWithErrorState:AJMediaPlayerPlayableResourceIDNotProvidedError errorInfo:nil];
                [AJMediaPlayerAnalyticsEventReporter submitRequestUrlErrorEvent:@"resourceIDNotProvider" withErrorCode:[NSString stringWithFormat:@"%@",@(AJMediaPlayerPlayableResourceIDNotProvidedError)]];
                return;
            }
            [self fetchStreamItemWithRequest:_playRequest fromDuration:[time doubleValue]];
        } else {
            if (self.networkStatus == NotReachable) {
                NSError *error = [NSError errorWithDomain:AJMediaStreamSchedulingMetadataFetchErrorDomain code:AJMediaPlayerLocalHTTPClientNetworkNotConnectedError userInfo:@{@"reason":@"未连接到服务器"}];
                [self handleWithErrorState:AJMediaPlayerLocalHTTPClientNetworkNotConnectedError errorInfo:error];
            }
        }
    } else {
        [self performSelector:@selector(showPlayerwwanWarningView) withObject:self afterDelay:0.5];
    }
}

/*
- (void)fetchStreamItemWithRequest:(AJMediaPlayRequest *)playRequest fromDuration:(NSTimeInterval )duration {
    if (!self.metadataFetcher) {
        self.metadataFetcher = [[AJMediaStreamSchedulingMetadataFetcher alloc] init];
    }
    
    NSDictionary *authinfo = nil;
    if (playRequest.uid) {
        authinfo = @{@"uid":playRequest.uid};
    }
    [[AJMediaRecordTimeHelper sharedInstance] recordStartTimeWithKey:@"requestPlayUrlWithVid"];
    
    __weak typeof(self) weakSelf = self;
    [self.metadataFetcher fetchStreamSchedulingMetadataWithID:playRequest.identifier streamType:playRequest.type authInfo:authinfo completionHandler:^(NSError *error, AJMediaStreamSchedulingMetadata *schedulingMetadata) {
        if (schedulingMetadata) {
            schedulingMetadata.resourceID = playRequest.identifier;
            schedulingMetadata.resourceName = playRequest.resourceName;
            schedulingMetadata.episodeid = playRequest.episodeid;
            schedulingMetadata.channelEname = playRequest.channelEname;
            schedulingMetadata.type = playRequest.type;
            weakSelf.mediaStreamSchedulingMetadata = schedulingMetadata;
            if (schedulingMetadata.status == AJMediaPlayerSchedulingNormal) {
                
                NSInteger requestUrlTime = [[AJMediaRecordTimeHelper sharedInstance] getRecordEndTimeWithKey:@"requestPlayUrlWithVid"];
                [[NSUserDefaults standardUserDefaults] setObject:@(requestUrlTime) forKey:@"AJMediaPlayer_RequestUrlTime"];
                [[AJMediaRecordTimeHelper sharedInstance] recordStartTimeWithKey:@"get_play_url"];
                
                weakSelf.currentStreamItem = [weakSelf startToFetchCurrentStreamItemWith:weakSelf.mediaStreamSchedulingMetadata];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (weakSelf.currentStreamItem.type == AJMediaPlayerLiveStreamItem) {
                        if ([weakSelf checkIsSupportTimeshift]) {
                            weakSelf.mediaPlayerControlBar.isSupportTimeShift = YES;
                            [weakSelf.mediaPlayerControlBar setNeedsUpdateConstraints];
                            [weakSelf.mediaPlayerControlBar updateConstraintsIfNeeded];
                        }
                    }
                    [weakSelf updateStreamListButtonTitleWith:weakSelf.currentStreamItem];
                });
                if (weakSelf.currentStreamItem && weakSelf.currentStreamItem.preferredSchedulingStreamURL) {
                    [weakSelf.loadingBackGroundView updateTipsLabelTitle:@"正在缓冲，请稍候"];
                    [weakSelf.mediaPlayer prepareToStream:weakSelf.currentStreamItem fromDuration:duration uid:playRequest.uid];
                } else {
                    [weakSelf handleWithErrorState:AJMediaPlayerProxiedAPIEmptyStreamMetadataError errorInfo:error];
                    [AJMediaPlayerAnalyticsEventReporter submitRequestUrlErrorEvent:@"webapi_bussiness_err" withErrorCode:[NSString stringWithFormat:@"%@",@(AJMediaPlayerProxiedAPIEmptyStreamMetadataError)]];
                }
            } else {
                [weakSelf handleWithErrorState:schedulingMetadata.status errorInfo:error];
                [AJMediaPlayerAnalyticsEventReporter submitRequestUrlErrorEvent:@"webapi_bussiness_err" withErrorCode:[NSString stringWithFormat:@"%@",@(schedulingMetadata.status)]];
            }
        } else {
            [weakSelf handleWithErrorState:[error code] errorInfo:error];
        }
    }];
}
*/
 
- (void)fetchStreamItemWithRequest:(AJMediaPlayRequest *)playRequest fromDuration:(NSTimeInterval )duration {
    if (!self.metadataFetcher) {
        self.metadataFetcher = [[AJMediaStreamSchedulingMetadataFetcher alloc] init];
    }
    
    NSDictionary *authinfo = nil;
    if (playRequest.uid) {
        authinfo = @{@"uid":playRequest.uid};
    }
    [[AJMediaRecordTimeHelper sharedInstance] recordStartTimeWithKey:@"requestPlayUrlWithVid"];
    
    __weak typeof(self) weakSelf = self;
    //    [self.metadataFetcher fetchStreamSchedulingMetadataWithID:playRequest.identifier streamType:playRequest.type authInfo:authinfo completionHandler:^(NSError *error, AJMediaStreamSchedulingMetadata *schedulingMetadata) {
    //        if (schedulingMetadata) {
    //            schedulingMetadata.resourceID = playRequest.identifier;
    //            schedulingMetadata.resourceName = playRequest.resourceName;
    //            schedulingMetadata.episodeid = playRequest.episodeid;
    //            schedulingMetadata.channelEname = playRequest.channelEname;
    //            schedulingMetadata.type = playRequest.type;
    //            weakSelf.mediaStreamSchedulingMetadata = schedulingMetadata;
    //            if (schedulingMetadata.status == AJMediaPlayerSchedulingNormal) {
    
    NSInteger requestUrlTime = [[AJMediaRecordTimeHelper sharedInstance] getRecordEndTimeWithKey:@"requestPlayUrlWithVid"];
    [[NSUserDefaults standardUserDefaults] setObject:@(requestUrlTime) forKey:@"AJMediaPlayer_RequestUrlTime"];
    [[AJMediaRecordTimeHelper sharedInstance] recordStartTimeWithKey:@"get_play_url"];
    
    
    AJMediaPlayerItem *metadataItem = [[AJMediaPlayerItem alloc] init];
    metadataItem.qualityName = @"高清";
    metadataItem.isPlayable = YES;
    metadataItem.type = AJMediaPlayerVODStreamItem;
    metadataItem.preferredSchedulingStreamURL = playRequest.identifier;
    //    if (metadataItem.schedulingStreamURLs.count > 0) {
    //        metadataItem.preferredSchedulingStreamURL = metadataItem.schedulingStreamURLs[0];
    //    }
    
    
    weakSelf.currentStreamItem = [weakSelf startToFetchCurrentStreamItemWith:weakSelf.mediaStreamSchedulingMetadata];
    weakSelf.currentStreamItem = metadataItem;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (weakSelf.currentStreamItem.type == AJMediaPlayerLiveStreamItem) {
            if ([weakSelf checkIsSupportTimeshift]) {
                weakSelf.mediaPlayerControlBar.isSupportTimeShift = YES;
                [weakSelf.mediaPlayerControlBar setNeedsUpdateConstraints];
                [weakSelf.mediaPlayerControlBar updateConstraintsIfNeeded];
            }
        }
        [weakSelf updateStreamListButtonTitleWith:weakSelf.currentStreamItem];
    });
    //                if (weakSelf.currentStreamItem && weakSelf.currentStreamItem.preferredSchedulingStreamURL) {
    [weakSelf.loadingBackGroundView updateTipsLabelTitle:@"正在缓冲，请稍候"];
    [weakSelf.mediaPlayer prepareToStream:weakSelf.currentStreamItem fromDuration:duration uid:playRequest.uid];
    //                } else {
    //                    [weakSelf handleWithErrorState:AJMediaPlayerProxiedAPIEmptyStreamMetadataError errorInfo:error];
    //                    [AJMediaPlayerAnalyticsEventReporter submitRequestUrlErrorEvent:@"webapi_bussiness_err" withErrorCode:[NSString stringWithFormat:@"%@",@(AJMediaPlayerProxiedAPIEmptyStreamMetadataError)]];
    //                }
    //            } else {
    //                [weakSelf handleWithErrorState:schedulingMetadata.status errorInfo:error];
    //                [AJMediaPlayerAnalyticsEventReporter submitRequestUrlErrorEvent:@"webapi_bussiness_err" withErrorCode:[NSString stringWithFormat:@"%@",@(schedulingMetadata.status)]];
    //            }
    //        } else {
    //            [weakSelf handleWithErrorState:[error code] errorInfo:error];
    //        }
    //    }];
}


//- (void)fetchStreamItemWithRequest:(AJMediaPlayRequest *)playRequest fromDuration:(NSTimeInterval )duration {
//    if (!self.metadataFetcher) {
//        self.metadataFetcher = [[AJMediaStreamSchedulingMetadataFetcher alloc] init];
//    }
//
//    NSDictionary *authinfo = nil;
//    if (playRequest.uid) {
//        authinfo = @{@"uid":playRequest.uid};
//    }
//    [[AJMediaRecordTimeHelper sharedInstance] recordStartTimeWithKey:@"requestPlayUrlWithVid"];
//    
//    __weak typeof(self) weakSelf = self;
//    [self.metadataFetcher fetchStreamSchedulingMetadataWithID:playRequest.identifier streamType:playRequest.type authInfo:authinfo completionHandler:^(NSError *error, AJMediaStreamSchedulingMetadata *schedulingMetadata) {
//        if (schedulingMetadata) {
//            schedulingMetadata.resourceID = playRequest.identifier;
//            schedulingMetadata.resourceName = playRequest.resourceName;
//            schedulingMetadata.episodeid = playRequest.episodeid;
//            schedulingMetadata.channelEname = playRequest.channelEname;
//            schedulingMetadata.type = playRequest.type;
//            weakSelf.mediaStreamSchedulingMetadata = schedulingMetadata;
//            if (schedulingMetadata.status == AJMediaPlayerSchedulingNormal) {
//                
//                NSInteger requestUrlTime = [[AJMediaRecordTimeHelper sharedInstance] getRecordEndTimeWithKey:@"requestPlayUrlWithVid"];
//                [[NSUserDefaults standardUserDefaults] setObject:@(requestUrlTime) forKey:@"AJMediaPlayer_RequestUrlTime"];
//                [[AJMediaRecordTimeHelper sharedInstance] recordStartTimeWithKey:@"get_play_url"];
//                
//                weakSelf.currentStreamItem = [weakSelf startToFetchCurrentStreamItemWith:weakSelf.mediaStreamSchedulingMetadata];
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    if (weakSelf.currentStreamItem.type == AJMediaPlayerLiveStreamItem) {
//                        if ([weakSelf checkIsSupportTimeshift]) {
//                            weakSelf.mediaPlayerControlBar.isSupportTimeShift = YES;
//                            [weakSelf.mediaPlayerControlBar setNeedsUpdateConstraints];
//                            [weakSelf.mediaPlayerControlBar updateConstraintsIfNeeded];
//                        }
//                    }
//                    [weakSelf updateStreamListButtonTitleWith:weakSelf.currentStreamItem];
//                });
//                if (weakSelf.currentStreamItem && weakSelf.currentStreamItem.preferredSchedulingStreamURL) {
//                    [weakSelf.loadingBackGroundView updateTipsLabelTitle:@"正在缓冲，请稍候"];
//                    [weakSelf.mediaPlayer prepareToStream:weakSelf.currentStreamItem fromDuration:duration uid:playRequest.uid];
//                } else {
//                    [weakSelf handleWithErrorState:AJMediaPlayerProxiedAPIEmptyStreamMetadataError errorInfo:error];
//                    [AJMediaPlayerAnalyticsEventReporter submitRequestUrlErrorEvent:@"webapi_bussiness_err" withErrorCode:[NSString stringWithFormat:@"%@",@(AJMediaPlayerProxiedAPIEmptyStreamMetadataError)]];
//                }
//            } else {
//                [weakSelf handleWithErrorState:schedulingMetadata.status errorInfo:error];
//                [AJMediaPlayerAnalyticsEventReporter submitRequestUrlErrorEvent:@"webapi_bussiness_err" withErrorCode:[NSString stringWithFormat:@"%@",@(schedulingMetadata.status)]];
//            }
//        } else {
//            [weakSelf handleWithErrorState:[error code] errorInfo:error];
//        }
//    }];
//}

#pragma mark - NetWork

- (AJMediaPlayerItem *)startToFetchCurrentStreamItemWith:(AJMediaStreamSchedulingMetadata *)metadata {
    NSArray *itemArray = [metadata availableQualifiedStreamItems];
    if (itemArray && itemArray.count > 0) {
        NSString *streamType = nil;
        if (metadata.type == AJMediaPlayerLiveStreamItem || metadata.type == AJMediaPlayerStationStreamItem) {
            streamType = aj_getCurrentUserStreamItem(YES);
        }
        if (metadata.type == AJMediaPlayerVODStreamItem) {
            streamType = aj_getCurrentUserStreamItem(NO);
        }
        AJMediaPlayerItem *currentPlayItem = nil;
        for (AJMediaPlayerItem *item  in itemArray) {
            if (streamType && [streamType isEqualToString:item.qualityName]) {
                currentPlayItem = item;
                break;
            }
        }
        if (!currentPlayItem) {
            for (AJMediaPlayerItem *item  in itemArray) {
                if (metadata.type == AJMediaPlayerLiveStreamItem || metadata.type == AJMediaPlayerStationStreamItem) {
                    if ([item.qualityName isEqualToString:kAJMediaStreamLiveQualityFLV1000]) {
                        currentPlayItem = item;
                        break;
                    }
                } else if (metadata.type == AJMediaPlayerVODStreamItem) {
                    if ([item.qualityName isEqualToString:kAJMediaStreamVODQualityMP4800]) {
                        currentPlayItem = item;
                        break;
                    }
                }
            }
            if (!currentPlayItem && itemArray.count > 0) {
                currentPlayItem = itemArray[0];
            }
            if (currentPlayItem) {
                aj_setCurrentUserStreamItem(currentPlayItem.qualityName,!(metadata.type == AJMediaPlayerVODStreamItem));
            }
        }
        return currentPlayItem;
    }
    return nil;
}

- (void)updateStreamListButtonTitleWith:(AJMediaPlayerItem *)currentItem {
    NSArray *streamArray = [self.mediaStreamSchedulingMetadata availableQualifiedStreamItems];
    if (streamArray && streamArray.count > 0) {
        if (_appearenceStyle == AJMediaPlayerStyleForiPhone) {
            _mediaPlayerNavigationBar.streamListButton.hidden = NO;
            [_mediaPlayerNavigationBar setNeedsUpdateConstraints];
            [_mediaPlayerNavigationBar updateConstraintsIfNeeded];
        } else if (_appearenceStyle == AJMediaPlayerStyleForiPad) {
            _mediaPlayerControlBar.streamListHDButton.hidden = NO;
            [_mediaPlayerControlBar setNeedsUpdateConstraints];
            [_mediaPlayerControlBar updateConstraintsIfNeeded];
        }
        for (AJMediaPlayerItem  *item in streamArray) {
            NSString *streamItem = aj_getCurrentUserStreamItem(currentItem.type == AJMediaPlayerLiveStreamItem || currentItem.type == AJMediaPlayerStationStreamItem);
            if ([streamItem isEqualToString:item.qualityName]) {
                NSString *streamName = nil;
                streamName = [AJMediaPlayerUtilities humanReadableTitleWithQualityName:streamItem];
                if (_appearenceStyle == AJMediaPlayerStyleForiPhone) {
                    [_mediaPlayerNavigationBar.streamListButton setTitle:streamName forState:UIControlStateNormal];
                } else if (_appearenceStyle == AJMediaPlayerStyleForiPad) {
                    [_mediaPlayerControlBar.streamListHDButton setTitle:streamName forState:UIControlStateNormal];
                }
                
                break;
            }
        }
    }
    else {
        if (_appearenceStyle == AJMediaPlayerStyleForiPhone) {
            _mediaPlayerNavigationBar.streamListButton.hidden = YES;
        } else if (_appearenceStyle == AJMediaPlayerStyleForiPad) {
            _mediaPlayerControlBar.streamListHDButton.hidden = YES;
        }
    }
}

- (void)handleWithErrorState:(AJMediaPlayerErrorIdentifier )errorState errorInfo:(NSError *)errorInfo {
    self.currentMediaPlayerState = AJMediaPlayerStateError;
    if (self.mediaPlayer) {
        self.mediaPlayer.currentPlayState = AJMediaPlayerStateError;
    }
    if (_playRequest) {
         [self performSelectorInBackground:@selector(fetchCDEInfoWithContactNumber:) withObject:@""];
        aj_logMessage(AJLoggingError, @"An error (%@) occurred while playing stream %@ reason:%@, error details: %@", @(errorState), self.playRequest,[AJMediaPlayerUtilities localizedDetailMessages:errorState], errorInfo);
    }
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf stopActivity];
        [weakSelf showPlayerErrorView];
        [weakSelf.playErrorView showWithAJMediaPlayerErrorIdentifier:errorState];
    });
}

- (void)fetchTimeDifferent {
    self.timeDifference = 0;
    NSURL *url = [NSURL URLWithString:@"http://api.letv.com/time"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:2.0f];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *serviceTimetask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            if ([httpResponse statusCode] == 200) {
                if (dict && [dict isKindOfClass:[NSDictionary class]]) {
                    if (dict[@"stime"]) {
                        NSTimeInterval timeInterval = [dict[@"stime"] doubleValue];
                        if (timeInterval) {
                            NSTimeInterval localtime = [[NSDate date] timeIntervalSince1970]*1000/1000;
                            self.timeDifference = localtime - timeInterval;
                            self.mediaPlayer.timeDifference = _timeDifference;
                        }
                    }
                }
            }
        }
    }];
    [serviceTimetask resume];
}

- (void)fetchCDEInfoWithContactNumber:(NSString *)contactNumber {
    dispatch_async(self.Q, ^{
        NSString *supportUrl = [AJMediaPlayerInfrastructureContext supportUrlWithContactNumber:contactNumber];
        if (supportUrl) {
            NSData* data = [supportUrl dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            if (dict && [dict isKindOfClass:[NSDictionary class]]) {
                NSString *errorCode = [NSString stringWithFormat:@"%@",[dict objectForKey:@"errorCode"]];
                if (errorCode && [errorCode isEqualToString:@"0"]) {
                    NSString *serviceNumber = [[dict objectForKey:@"serviceNumber"] description];
                    aj_logMessage(AJLoggingInfo, @"obtain CDE service code : %@, contact identifier: %@", serviceNumber, contactNumber);
                    [[NSUserDefaults standardUserDefaults] setObject:serviceNumber forKey:@"CDEInfo"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
            }
        }
    });
}

- (void)fetchCDNInfo {
    dispatch_async(self.Q, ^{
        NSString *statsUrl = [AJMediaPlayerInfrastructureContext stateUrl];
        if (statsUrl) {
            NSURL *url = [NSURL URLWithString:statsUrl];
            NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:2.0f];
            NSURLSession *session = [NSURLSession sharedSession];
            NSURLSessionDataTask *cdntask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                if (!error) {
                    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                    NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                    if ([httpResponse statusCode] == 200) {
                        aj_logMessage(AJLoggingInfo, @"obtain CDN info: %@", dict);
                        if (dict && [dict isKindOfClass:[NSDictionary class]]) {
                            id data = dict[@"data"];
                            if (data && [data isKindOfClass:[NSDictionary class]]) {
                                schedulingResult = data;
                            }
                        }
                    }
                }
            }];
            [cdntask resume];
        }
    });
}

#pragma mark - Reset subView status

- (void)resetSubViewStatus {
    if (self.playErrorView) {
        [self.playErrorView removeFromSuperview];
        //这里不能注释，会导致不能3G下不能启播
        self.playErrorView = nil;
    }
    if (self.wwanWarningView) {
        [self.wwanWarningView removeFromSuperview];
        //这里不能注释，会导致不能3G下不能启播
        self.wwanWarningView = nil;
    }
    
    _playFirstFrame = NO;
    _isOnTimeShiftModel = NO;
    _isManMadePause = NO;
    _isAddtionView = NO;
    _bufferingNumbers = 0;
    _maxBufferingNumbers = 1;
    _isAlreadySubmitBuffering = NO;
    
    [self stopActivity];
    
    if (_mediaPlayerNavigationBar) {
        [_mediaPlayerNavigationBar.streamListButton setTitle:@"标清" forState:UIControlStateNormal];
        _mediaPlayerNavigationBar.bufferButton.hidden = YES;
        _mediaPlayerNavigationBar.streamListButton.hidden = YES;
        [_mediaPlayerNavigationBar setNeedsUpdateConstraints];
        [_mediaPlayerNavigationBar updateConstraintsIfNeeded];
    }
    
    if (_mediaPlayerControlBar) {
        if (_appearenceStyle == AJMediaPlayerStyleForiPad) {
            [_mediaPlayerControlBar.streamListHDButton setTitle:@"标清" forState:UIControlStateNormal];
        }
        _mediaPlayerControlBar.playOrPauseButton.enabled = NO;
        _mediaPlayerControlBar.progressScubber.enabled = NO;
        _mediaPlayerControlBar.progressScubber.value = 0;
        _mediaPlayerControlBar.seekTime = 0;
        
        _mediaPlayerControlBar.availableProgressScubber.enabled = NO;
        _mediaPlayerControlBar.availableProgressScubber.value = 0;
        
        _mediaPlayerControlBar.timeShiftProgressScubber.enabled = NO;
        _mediaPlayerControlBar.timeShiftProgressScubber.value = 0;
        _mediaPlayerControlBar.timeshiftPosition = 0;
        
        _mediaPlayerControlBar.startTimeLabel.text = @"00:00";
        _mediaPlayerControlBar.totalDurationLabel.text = @"00:00";
        _mediaPlayerControlBar.timeShiftStartTimeLabel.text = @"00:00";
        _mediaPlayerControlBar.timeShiftTotalTimeLabel.text = @"00:00";
        _mediaPlayerControlBar.playOrPauseButton.selected = NO;
        _mediaPlayerControlBar.isSupportTimeShift = NO;
    }
    if (_timeshiftTipsButton) {
        _timeshiftTipsButton.hidden = YES;
    }
    
    if (_appearenceStyle == AJMediaPlayerStyleForiPhone) {
        if (_revertTimeShiftButton) {
            _revertTimeShiftButton.hidden = YES;
        }
    } else if (_appearenceStyle == AJMediaPlayerStyleForiPad) {
        if (_mediaPlayerNavigationBar.backToLiveButton) {
            _mediaPlayerNavigationBar.backToLiveButton.hidden = YES;
            [_mediaPlayerNavigationBar setNeedsUpdateConstraints];
            [_mediaPlayerNavigationBar updateConstraintsIfNeeded];
        }
    }
}

#pragma mark - Hidden Controls

- (void)fireTimer {
    [self invalidateTimer];
    NSTimeInterval timeInterval = 6.0;
    self.kTimer = [NSTimer scheduledTimerWithTimeInterval:timeInterval
                                                   target:self
                                                 selector:@selector(hidePlaybackControls)
                                                 userInfo:nil
                                                  repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:_kTimer forMode:NSDefaultRunLoopMode];
}

- (void)invalidateTimer {
    if (_kTimer) {
        [_kTimer invalidate];
        _kTimer = nil;
    }
}

- (void)hidePlaybackControls {
    if (!_isDecontrolled) {
        [self setShouldHidePlayerControls:YES];
    }
}

- (void)showPlaybackControls {
    if (!_isDecontrolled) {
        [self setShouldHidePlayerControls:NO];
    }
}

- (void)setShouldHidePlayerControls:(BOOL)shouldHide {
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.hidePlayerControlBar = shouldHide;
        weakSelf.mediaPlayerControlBar.hidden = shouldHide;
        weakSelf.mediaPlayerNavigationBar.hidden = shouldHide;
        weakSelf.bulletEditButton.hidden = [weakSelf shouldHideEditItem];
        if (weakSelf.mediaPlayerControlBar.isSupportTimeShift) {
            if (weakSelf.isOnTimeShiftModel) {
                if (_appearenceStyle == AJMediaPlayerStyleForiPhone) {
                    if (shouldHide == NO) {
                        [weakSelf.view bringSubviewToFront:_revertTimeShiftButton];
                    }
                    weakSelf.revertTimeShiftButton.hidden = shouldHide;
                } else if (_appearenceStyle == AJMediaPlayerStyleForiPad) {
                    weakSelf.mediaPlayerNavigationBar.backToLiveButton.hidden = shouldHide;
                    [weakSelf.mediaPlayerNavigationBar setNeedsUpdateConstraints];
                    [weakSelf.mediaPlayerNavigationBar updateConstraintsIfNeeded];
                }
            } else {
                if ([[NSUserDefaults standardUserDefaults] valueForKey:USERDEFAULT_TIMESHIFT_KEY] && [[[NSUserDefaults standardUserDefaults] valueForKey:USERDEFAULT_TIMESHIFT_KEY] integerValue] > 1) {
                    weakSelf.timeshiftTipsButton.hidden = YES;
                } else {
                    weakSelf.timeshiftTipsButton.hidden = shouldHide;
                }
            }
        }
        if (weakSelf.mediaPlayerControlBar.isFullScreen) {
            [[UIApplication sharedApplication] setStatusBarHidden:shouldHide withAnimation:NO];
            weakSelf.backButton.hidden = shouldHide;
            if (shouldHide) {
                weakSelf.soundControlView.hidden = YES;
                [weakSelf.mediaPlayerControlBar updateVolume:weakSelf.soundControlView.slider.value isHidden:weakSelf.soundControlView.hidden];
            }
            if (shouldHide == NO && weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(mediaPlayerViewControllerPlaybackControlsWillAppear:)]) {
                [weakSelf.delegate mediaPlayerViewControllerPlaybackControlsWillAppear:weakSelf];
                return;
            }
            if (shouldHide == YES && weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(mediaPlayerViewControllerPlaybackControlsDidDisappear:)]) {
                [weakSelf.delegate mediaPlayerViewControllerPlaybackControlsDidDisappear:weakSelf];
                return;
            }
        } else {
            if (_needsBackButtonInPortrait) {
                weakSelf.backButton.hidden = NO;
            } else {
                weakSelf.backButton.hidden = YES;
            }
        }
    });
}

- (BOOL)shouldHideEditItem
{
    return !(_isChatroomActive && _isFullScreenController && _needsChatroomSwitch) || _hidePlayerControlBar;
}

#pragma mark - Show StreamAndExcerptsView

- (void)showQualityPicker {
    float qualityPickViewWidth = _appearenceStyle==AJMediaPlayerStyleForiPhone?150:280;
    if (self.qualityPickerView == nil) {
        self.qualityPickerView = [[AJMediaQualityPickerView alloc] initWithFrame:CGRectMake(self.view.frame.size.width, 0, qualityPickViewWidth, self.view.frame.size.height)];
        _qualityPickerView.appearenceStyle = _appearenceStyle;
        _qualityPickerView.hidden = YES;
        _qualityPickerView.delegate = self;
        [self.view addSubview:_qualityPickerView];
    }

    NSArray *streamArray = [self.mediaStreamSchedulingMetadata availableQualifiedStreamItems];
    if (streamArray && streamArray.count > 0) {
        self.qualityPickerView.frame = CGRectMake(self.view.frame.size.width, 0, qualityPickViewWidth, self.view.frame.size.height);
        [self.view bringSubviewToFront:_qualityPickerView];
        [self.qualityPickerView setQualifiedItems:streamArray];
    } else {
        return;
    }
    
    if (self.qualityPickerView.hidden) {
        [self hidePlaybackControls];
        self.qualityPickerView.hidden = NO;
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:0.2
                         animations:^{
                             weakSelf.qualityPickerView.frame = CGRectMake(weakSelf.view.frame.size.width-qualityPickViewWidth, 0, weakSelf.qualityPickerView.frame.size.width, weakSelf.view.frame.size.height);
                         } completion:^(BOOL finished) {
                         }];
    }
}

- (void)dismissQualityPicker {
    float qualityPickViewWidth = _appearenceStyle==AJMediaPlayerStyleForiPhone?150:280;
    if (!self.qualityPickerView.hidden) {
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:0.2
                         animations:^{
                             weakSelf.qualityPickerView.frame = CGRectMake(weakSelf.view.frame.size.width, 0, qualityPickViewWidth, weakSelf.view.frame.size.height);
                         } completion:^(BOOL finished) {
                             if (finished) {
                                 weakSelf.qualityPickerView.hidden = YES;
                             }
                         }];}
}

- (void)showEpisodePicker {
    float episodePickerViewWidth = _appearenceStyle==AJMediaPlayerStyleForiPhone?300:350;
    if (self.episodePickerView == nil) {
        self.episodePickerView = [[AJMediaEpisodePickerView alloc] initWithFrame:CGRectMake(self.view.frame.size.width, 0, episodePickerViewWidth, self.view.frame.size.height)];
        _episodePickerView.hidden = YES;
        _episodePickerView.delegate = self;
        _episodePickerView.appearenceStyle = _appearenceStyle;
        [self.view addSubview:_episodePickerView];
    }
    self.episodePickerView.frame = CGRectMake(self.view.frame.size.width, 0, episodePickerViewWidth, self.view.frame.size.height);
    if (_playRequest.identifier) {
        self.episodePickerView.streamID = _playRequest.identifier;
    }
    [self.view bringSubviewToFront:_episodePickerView];
    [self.episodePickerView setEpisodeItems:_playRequestSet];
    
    if (self.episodePickerView.hidden) {
        [self hidePlaybackControls];
        self.episodePickerView.hidden = NO;
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:0.2
                         animations:^{
                             weakSelf.episodePickerView.frame = CGRectMake(weakSelf.view.frame.size.width-episodePickerViewWidth, 0, weakSelf.episodePickerView.frame.size.width, weakSelf.view.frame.size.height);
                         } completion:^(BOOL finished) {
        }];
    }
}

- (void)dismissEpisodePicker {
    float episodePickerViewWidth = _appearenceStyle==AJMediaPlayerStyleForiPhone?300:350;
    if (!self.episodePickerView.hidden) {
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:0.2
                         animations:^{
                             weakSelf.episodePickerView.frame = CGRectMake(weakSelf.view.frame.size.width, 0, episodePickerViewWidth, weakSelf.view.frame.size.height);
                         } completion:^(BOOL finished) {
                             weakSelf.episodePickerView.hidden = YES;
                         }];}
}

- (void)showSubmitBufferAlertView {
    if ([[UIDevice currentDevice].systemVersion floatValue] < 8.0) {
        UIAlertView *submitBufferAlertView = [[UIAlertView alloc] initWithTitle:@"投诉卡顿" message:@"请填写手机号码，协助我们解决问题" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"提交", nil];
        submitBufferAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        UITextField *textfield = [submitBufferAlertView textFieldAtIndex:0];
        textfield.keyboardType = UIKeyboardTypeNumberPad;
        [submitBufferAlertView show];
    } else {
        UIAlertController *alertViewController = [UIAlertController alertControllerWithTitle:@"投诉卡顿" message:@"请填写手机号码，协助我们解决问题" preferredStyle:UIAlertControllerStyleAlert];
        __weak typeof(self) weakSelf = self;
        UIAlertAction *submitAction = [UIAlertAction actionWithTitle:@"提交" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            UITextField *textfield = [alertViewController.textFields objectAtIndex:0];
            [weakSelf performSelectorInBackground:@selector(fetchCDEInfoWithContactNumber:) withObject:textfield.text];
            weakSelf.isAlreadySubmitBuffering = YES;
            weakSelf.mediaPlayerNavigationBar.bufferButton.hidden = YES;
            [weakSelf.mediaPlayerNavigationBar setNeedsUpdateConstraints];
            [weakSelf.mediaPlayerNavigationBar updateConstraintsIfNeeded];
        }];
        [alertViewController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [alertViewController addAction:submitAction];
        [alertViewController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.keyboardType = UIKeyboardTypeNumberPad;
        }];
        [self presentViewController:alertViewController animated:YES completion:nil];
    }
}

#pragma mark - UIAlertView Delegate 

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        UITextField *textfield=[alertView textFieldAtIndex:0];
        [self performSelectorInBackground:@selector(fetchCDEInfoWithContactNumber:) withObject:textfield.text];
        _isAlreadySubmitBuffering = YES;
        _mediaPlayerNavigationBar.bufferButton.hidden = YES;
        [_mediaPlayerNavigationBar setNeedsUpdateConstraints];
        [_mediaPlayerNavigationBar updateConstraintsIfNeeded];
    }
}

#pragma mark - Show LoadingBackGroundVIew

- (void)showLoadingBackGroundView:(AJMediaPlayerAppearenceStyle )apperenceStyle {
    if (!self.loadingBackGroundView) {
        self.loadingBackGroundView = [[AJMediaPlayerBackGroundView alloc] initWithAppearenceStyle:apperenceStyle];
        _loadingBackGroundView.translatesAutoresizingMaskIntoConstraints = NO;
        [_mediaPlayerView addSubview:_loadingBackGroundView];
        [_mediaPlayerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_loadingBackGroundView]-0-|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:NSDictionaryOfVariableBindings(_loadingBackGroundView)]];
        [_mediaPlayerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_loadingBackGroundView]-0-|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:NSDictionaryOfVariableBindings(_loadingBackGroundView)]];
    } else {
        [self.loadingBackGroundView updateTipsLabelTitle:@"正在建立连接"];
    }
}

- (void)dismissLoadingBackGroundView {
    if (self.loadingBackGroundView) {
        [self.loadingBackGroundView removeFromSuperview];
        self.loadingBackGroundView = nil;
    }
}

#pragma mark - Show ErrorView

- (void)showPlayerErrorView {
    if (!self.playErrorView) {
        if (self.wwanWarningView) {
            [self.wwanWarningView removeFromSuperview];
            //这里不能注释，会导致不能3G下不能启播
            self.wwanWarningView = nil;
        }
        self.playErrorView = [[AJMediaPlayerMessageLayerView alloc] init];
        _playErrorView.delegate = self;
        _playErrorView.translatesAutoresizingMaskIntoConstraints = NO;
        [_mediaPlayerView addSubview:_playErrorView];
        [_mediaPlayerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_playErrorView]-0-|"
                                                                                     options:0
                                                                                     metrics:nil
                                                                                       views:NSDictionaryOfVariableBindings(_playErrorView)]];
        [_mediaPlayerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_playErrorView]-0-|"
                                                                                     options:0
                                                                                     metrics:nil
                                                                                       views:NSDictionaryOfVariableBindings(_playErrorView)]];
    }
}

- (void)dismissPlayErrorView {
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (weakSelf.playErrorView) {
            [weakSelf.playErrorView removeFromSuperview];
            //这里不能注释，会导致不能3G下不能启播
            weakSelf.playErrorView = nil;
        }
    });
}

#pragma mark - Show wwanTipsView

- (void)showTipsViewWithText:(NSString *)text {
    if (_tipsView) {
        [_tipsView removeFromSuperview];
        //这里不能注释，会导致不能3G下不能启播
        _tipsView = nil;
    }
    self.tipsView = [[AJMediaTipsView alloc] initWithAppearenceStyle:_appearenceStyle text:text];
    _tipsView.backgroundColor = [UIColor blackColor];
    _tipsView.translatesAutoresizingMaskIntoConstraints = NO;
    [_mediaPlayerView addSubview:_tipsView];
    
    float tipsViewWidth = _appearenceStyle==AJMediaPlayerStyleForiPhone?150:180;
    float tipsViewHeight = _appearenceStyle==AJMediaPlayerStyleForiPhone?30:50;
    
    [_mediaPlayerView addConstraint:[NSLayoutConstraint constraintWithItem:_tipsView
                                                                     attribute:NSLayoutAttributeCenterX
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:_mediaPlayerView
                                                                     attribute:NSLayoutAttributeCenterX
                                                                    multiplier:1
                                                                      constant:0]];
    [_mediaPlayerView addConstraint:[NSLayoutConstraint constraintWithItem:_tipsView
                                                                     attribute:NSLayoutAttributeCenterY
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:_mediaPlayerView
                                                                     attribute:NSLayoutAttributeCenterY
                                                                    multiplier:1
                                                                      constant:0]];
    [_mediaPlayerView addConstraint:[NSLayoutConstraint constraintWithItem:_tipsView
                                                                     attribute:NSLayoutAttributeWidth
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:nil
                                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                                    multiplier:1.0f
                                                                      constant:tipsViewWidth]];
    [_mediaPlayerView addConstraint:[NSLayoutConstraint constraintWithItem:_tipsView
                                                                     attribute:NSLayoutAttributeHeight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:nil
                                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                                    multiplier:1.0f
                                                                      constant:tipsViewHeight]];
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:5.0f animations:^{
        weakSelf.tipsView.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [weakSelf.tipsView removeFromSuperview];
            //这里不能注释，会导致不能3G下不能启播
            weakSelf.tipsView = nil;
        }
    }];
}

#pragma mark - Show wwanWarningView

- (void)showPlayerwwanWarningView {
    if (!self.wwanWarningView) {
        if (self.playErrorView) {
            [self.playErrorView removeFromSuperview];
            //这里不能注释，会导致不能3G下不能启播
            self.playErrorView = nil;
        }
        self.wwanWarningView = [[AJMediaPlayerMessageLayerView alloc] init];
        _wwanWarningView.delegate = self;
        _wwanWarningView.translatesAutoresizingMaskIntoConstraints = NO;
        [_mediaPlayerView addSubview:_wwanWarningView];
        [_mediaPlayerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_wwanWarningView]-0-|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:NSDictionaryOfVariableBindings(_wwanWarningView)]];
        [_mediaPlayerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_wwanWarningView]-0-|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:NSDictionaryOfVariableBindings(_wwanWarningView)]];
        [_wwanWarningView showWithIgnoreStyle];
        if (_currentStreamItem) {
            _mediaPlayerControlBar.playOrPauseButton.enabled = NO;
            _mediaPlayerControlBar.progressScubber.enabled = NO;
            _mediaPlayerControlBar.timeShiftProgressScubber.enabled = NO;
        }
    }
}

- (void)dismisswwanWarningView {
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (weakSelf.wwanWarningView) {
            [weakSelf.wwanWarningView removeFromSuperview];
            //这里不能注释，会导致不能3G下不能启播
            weakSelf.wwanWarningView = nil;
            if (_currentStreamItem) {
                _mediaPlayerControlBar.playOrPauseButton.enabled = YES;
                _mediaPlayerControlBar.progressScubber.enabled = YES;
                _mediaPlayerControlBar.timeShiftProgressScubber.enabled = YES;
            }
        }
    });
}

#pragma mark - Show AirPlayBackGround

- (void)showAirPlayBackGroundView {
    if (!self.airPlayBackGroundView) {
        self.airPlayBackGroundView = [[AJMediaPlayerAirPlayBackGroundView alloc] init];
        _airPlayBackGroundView.translatesAutoresizingMaskIntoConstraints = NO;
        [_mediaPlayerView addSubview:_airPlayBackGroundView];
        [_mediaPlayerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_airPlayBackGroundView]-0-|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:NSDictionaryOfVariableBindings(_airPlayBackGroundView)]];
        [_mediaPlayerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_airPlayBackGroundView]-0-|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:NSDictionaryOfVariableBindings(_airPlayBackGroundView)]];
    }
}

- (void)dismissAirPlayBackGroundView {
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (weakSelf.airPlayBackGroundView) {
            [weakSelf.airPlayBackGroundView removeFromSuperview];
            //这里不能注释，会导致不能3G下不能启播
            weakSelf.airPlayBackGroundView = nil;
        }
    });
}

#pragma mark - send bullet
- (void)sendBullet:(VTBulletModel *)bullet
{
    if (_isChatroomActive && !_bulletView.isHidden) {
        [_bulletView shootBullet:bullet];
    }
}

#pragma mark - ActivityIndicatorView animating

- (void)startActivity {
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.activityIndicatorView startAnimating];
    });
}

- (void)stopActivity {
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.activityIndicatorView stopAnimating];
    });
}

#pragma mark - Action Method

- (void)switchToStreamItem:(AJMediaPlayerItem *)playerStreamItem {
    _mediaPlayerControlBar.playOrPauseButton.enabled = NO;
    _mediaPlayerControlBar.progressScubber.enabled = NO;
    _mediaPlayerControlBar.timeShiftProgressScubber.enabled = NO;
    
    self.currentStreamItem = playerStreamItem;
    [self dismissPlayErrorView];
    
    _currentMediaPlayerState = AJMediaPlayerStateContentInit;
    [self showLoadingBackGroundView:_appearenceStyle];
    NSArray *streamArray = [self.mediaStreamSchedulingMetadata availableQualifiedStreamItems];
    if (streamArray && streamArray.count > 0) {
        NSString *name = [AJMediaPlayerUtilities humanReadableTitleWithQualityName:playerStreamItem.qualityName];
        if (_appearenceStyle == AJMediaPlayerStyleForiPhone) {
            [_mediaPlayerNavigationBar.streamListButton setTitle:name forState:UIControlStateNormal];
        } else if (_appearenceStyle == AJMediaPlayerStyleForiPad) {
            [_mediaPlayerControlBar.streamListHDButton setTitle:name forState:UIControlStateNormal];
        }
        [_loadingBackGroundView updateTipsLabelTitle:@"正在缓冲，请稍候"];
        [self.mediaPlayer switchToStream:_currentStreamItem];
    }
}

- (void)backButtonAction:(UIButton *)button {
    if (_appearenceStyle == AJMediaPlayerStyleForiPhone) {
        if (self.mediaPlayerControlBar.isFullScreen) {
            [self resignFullScreen];
        } else {
            if (self.delegate && [self.delegate respondsToSelector:@selector(mediaPlayerViewControllerWillDismiss:)]) {
                [self invalidateTimer];
                [self.delegate mediaPlayerViewControllerWillDismiss:self];
            }
        }
    } else if (_appearenceStyle == AJMediaPlayerStyleForiPad) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(mediaPlayerViewController:didSelectFullScreenMode:)]) {
            [self.delegate mediaPlayerViewController:self didSelectFullScreenMode:NO];
        }
    }
}

- (void)bulletEditAction:(UIButton *)button {
    if (_delegate && [_delegate respondsToSelector:@selector(mediaPlayerViewControllerDidUserLogin:)]) {
        BOOL hasLogged = [_delegate mediaPlayerViewControllerDidUserLogin:self];
        if (hasLogged) {
            [self hidePlaybackControls];
            [self.view bringSubviewToFront:_bulletInputView];
            [_bulletInputView.textField becomeFirstResponder];
            _bulletInputView.hidden = NO;
        }
        [AJMediaPlayerAnalyticsEventReporter submitBulletInputEvent:_playRequest];
    }
}

- (void)cancelBulletInput:(UIButton *)button
{
    [_bulletInputView.textField resignFirstResponder];
    _bulletInputView.hidden = YES;
}

- (void)sendButtonAction:(UIButton *)button
{
    [self cancelBulletInput:nil];
    NSString *message = _bulletInputView.textField.text;
    _bulletInputView.textField.text = nil;
    if (_delegate && [_delegate respondsToSelector:@selector(mediaPlayerViewController:userDidSendMessage:)]) {
        [_delegate mediaPlayerViewController:self userDidSendMessage:message];
    }
}

- (void)revertTimeShiftButtonClicked:(UIButton *)button {
    [_mediaPlayerControlBar updateTotal:_mediaPlayerControlBar.totalTime timeshiftPosition:_mediaPlayerControlBar.totalTime];
    [_mediaPlayerControlBar endTimeshift:0];
}

- (void)seekToPosition:(float)position {
    [self.mediaPlayer seekToTime:[self.mediaPlayer currentItemDuration] * position];
}

- (void)seekToTimeShiftPostion:(float)timeShiftPostion {
    [self dismissPlayErrorView];
    _currentMediaPlayerState = AJMediaPlayerStateContentInit;
    [self showLoadingBackGroundView:_appearenceStyle];
    [_loadingBackGroundView updateTipsLabelTitle:@"正在缓冲，请稍候"];
    [self.mediaPlayer timeshiftPlayer:(int)timeShiftPostion];
}

- (void)soundSliderValueChanged:(UISlider *)sender {
    isSoundSlideChangeValue = YES;
    [self invalidateTimer];
    if (sender.value >= 0 || sender.value <= 1) {
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Wdeprecated-declarations"
            [[MPMusicPlayerController iPodMusicPlayer] setVolume:sender.value];
        #pragma clang diagnostic pop
    }
    [self.mediaPlayerControlBar updateVolume:sender.value isHidden:_soundControlView.hidden];
}

- (void)soundSlidersTouchUp:(UISlider *)sender {
    [self performSelector:@selector(updateSoundSlideValue) withObject:self afterDelay:1];
    [self fireTimer];
}

- (void)updateSoundSlideValue {
    isSoundSlideChangeValue = NO;
}

- (void)showFullScreen {
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = UIInterfaceOrientationLandscapeRight;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

- (void)resignFullScreen {
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = UIInterfaceOrientationPortrait;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

#pragma mark - AJMediaPlayerViewDelegate

- (void)mediaPlayerView:(AJMediaPlayerView * __nonnull)mediaPlayerView moveVolumeWithType:(ProgessType)type
{
    [self removeTapGestureRecognizer];
}

- (void)mediaPlayerView:(AJMediaPlayerView * __nonnull)mediaPlayerView moveScheduleWithType:(ProgessType)type screenPercent:(float)percent
{
    [self removeTapGestureRecognizer];
    if (_currentStreamItem.type == AJMediaPlayerVODStreamItem) {
        _progressView.hidden = NO;
        if (!isMoveSchedule) {
            isMoveSchedule = YES;
            durationTime = [self.mediaPlayer currentItemDuration];
            pendingSeekToTime = [self.mediaPlayer currentPlaybackTime];
        }
        if (type == Addition) {
            NSInteger additionTime;
            if (percent == 0 || durationTime*percent < 1) {
                additionTime = 1;
            } else {
                additionTime = durationTime*percent;
            }
            pendingSeekToTime += additionTime;
            if (pendingSeekToTime >= durationTime) {
                pendingSeekToTime = durationTime;
            }
        } else {
            NSInteger reduceTime;
            if (percent == 0 || durationTime*percent < 1) {
                reduceTime = 1;
            } else {
                reduceTime = durationTime*percent;
            }
            pendingSeekToTime -= reduceTime;
            if (pendingSeekToTime <= 0) {
                pendingSeekToTime = 0;
            }
        }
        [_progressView updatePendTimeLabel:pendingSeekToTime withDurationLabel:durationTime];
        [_progressView updateDirectionImageViewWithType:type];
        [_mediaPlayerControlBar updateDuration:durationTime pendingTime:pendingSeekToTime];
    } else if (_currentStreamItem.type == AJMediaPlayerLiveStreamItem && [self checkIsSupportTimeshift]) {
        _progressView.hidden = NO;
        if (!isMoveSchedule) {
            isMoveSchedule = YES;
            totalTime = _mediaPlayerControlBar.totalTime;
            timeshiftSeekToTime = _mediaPlayerControlBar.totalTime - _mediaPlayerControlBar.timeshiftPosition;
        }
        if (type == Addition) {
            NSInteger additionTime;
            if (percent == 0 || totalTime*percent < 1) {
                additionTime = 1;
            } else {
                additionTime = totalTime*percent;
            }
            timeshiftSeekToTime += additionTime;
            if (timeshiftSeekToTime >= totalTime) {
                timeshiftSeekToTime = totalTime;
            }
        } else {
            NSInteger reduceTime;
            if (percent == 0 || totalTime*percent < 1) {
                reduceTime = 1;
            } else {
                reduceTime = totalTime*percent;
            }
            timeshiftSeekToTime -= reduceTime;
            if (timeshiftSeekToTime <= 0) {
                timeshiftSeekToTime = 0;
            }
        }
        [_progressView updatePendTimeLabel:timeshiftSeekToTime withDurationLabel:totalTime];
        [_progressView updateDirectionImageViewWithType:type];
        [_mediaPlayerControlBar updateTotal:totalTime timeshiftPosition:timeshiftSeekToTime];
    }
}

- (BOOL)checkIsSupportTimeshift {
    NSTimeInterval localtime = [[NSDate date] timeIntervalSince1970]*1000/1000;
    NSDate *serverDate = [NSDate dateWithTimeIntervalSince1970:localtime-_timeDifference];
    if (_currentStreamItem.liveStartTime && [serverDate timeIntervalSinceDate:_currentStreamItem.liveStartTime] > 0) {
        return YES;
    }
    return NO;
}

- (void)mediaPlayerViewGestureDidEndMoved {
    [self addTapGestureRecognizer];
    if (_currentStreamItem.type == AJMediaPlayerVODStreamItem) {
        _progressView.hidden = YES;
        if (isMoveSchedule) {
            [_mediaPlayerControlBar endPendingTime:pendingSeekToTime];
        }
        isMoveSchedule = NO;
    } else if (_currentStreamItem.type == AJMediaPlayerLiveStreamItem && [self checkIsSupportTimeshift]) {
        _progressView.hidden = YES;
        if (isMoveSchedule) {
            [_mediaPlayerControlBar endTimeshift:(totalTime-timeshiftSeekToTime)];
        }
        isMoveSchedule = NO;
    }
}

#pragma mark - AJMediaPlayerDelegate

- (void)mediaPlayer:(AJMediaPlayer * __nonnull)mediaPlayer didChangeStateFrom:(AJMediaPlayerState)previousState to:(AJMediaPlayerState)currentState {
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.currentMediaPlayerState = currentState;
        if (currentState == AJMediaPlayerStateContentFinished) {
            _bufferingNumbers = 0;
            _maxBufferingNumbers = 1;
            _isAlreadySubmitBuffering = NO;
            [weakSelf.mediaPlayerControlBar updatePlayState:NO];
            [weakSelf stopActivity];
        }
        if (currentState == AJMediaPlayerStateContentBuffering) {
            if (previousState == AJMediaPlayerStateContentPlaying) {
                _bufferingNumbers++;
                if (_bufferingNumbers > _maxBufferingNumbers && !_isAlreadySubmitBuffering) {
                    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
                        _mediaPlayerNavigationBar.bufferButton.hidden = NO;
                        [_mediaPlayerNavigationBar setNeedsUpdateConstraints];
                        [_mediaPlayerNavigationBar updateConstraintsIfNeeded];
                    }
                }
            }
            if (weakSelf.networkStatus == NotReachable) {
                if (_playFirstFrame) {
                    NSError *error = [NSError errorWithDomain:AJMediaStreamSchedulingMetadataFetchErrorDomain code:AJMediaPlayerLocalHTTPClientNetworkNotConnectedError userInfo:@{@"reason":@"未连接到服务器"}];
                    [weakSelf handleWithErrorState:AJMediaPlayerLocalHTTPClientNetworkNotConnectedError errorInfo:error];
                }
            } else {
                if (!_loadingBackGroundView) {
                    [weakSelf startActivity];
                }
            }
        }
        if (currentState == AJMediaPlayerStateContentPlaying) {
            if (previousState != AJMediaPlayerStateContentSeeking) {
                [weakSelf dismissPlayErrorView];
            }
            [weakSelf dismissLoadingBackGroundView];
            if (!_isManMadePause && !_isAddtionView) {
                [weakSelf.mediaPlayerControlBar updatePlayState:YES];
            }
            [weakSelf stopActivity];
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(mediaPlayerViewController:userDidClickOnPlayOrPauseButton:)]) {
                [weakSelf.delegate mediaPlayerViewController:self userDidClickOnPlayOrPauseButton:YES];
            }
        }
        if (currentState == AJMediaPlayerStateContentPaused) {
            [weakSelf.mediaPlayerControlBar updatePlayState:NO];
            [weakSelf stopActivity];
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(mediaPlayerViewController:userDidClickOnPlayOrPauseButton:)]) {
                [weakSelf.delegate mediaPlayerViewController:self userDidClickOnPlayOrPauseButton:NO];
            }
        }
    });
}

- (void)mediaPlayer:(AJMediaPlayer *)mediaPlayer willPlayMediaItem:(AJMediaPlayerItem *)mediaPlayerItem {
    [self dismissPlayErrorView];
    if (!_isPhoneCalling && !_isManMadePause && !_isAddtionView && !_wwanWarningView) {
        [self.mediaPlayer play];
    }
    if (_isManMadePause) {
        //防止点击暂停切换码流,按钮，进度条状态不可选
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.mediaPlayerControlBar.playOrPauseButton.enabled = YES;
            weakSelf.mediaPlayerControlBar.progressScubber.enabled = YES;
            weakSelf.mediaPlayerControlBar.timeShiftProgressScubber.enabled = YES;
        });
    }
    if (!_playFirstFrame) {
        _playFirstFrame = YES;
        
        if (_playRequest) {
            [AJMediaPlayerAnalyticsEventReporter submitPlayFirstFrameEvent:_playRequest];
        }
        [self fetchCDNInfo];
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf fireTimer];
            if (weakSelf.mediaPlayerControlBar.isSupportTimeShift) {
                [weakSelf.view setNeedsUpdateConstraints];
                [weakSelf.view updateConstraintsIfNeeded];
            }
        });
    };
}

- (void)mediaPlayer:(AJMediaPlayer *)mediaPlayer didVideoPlayToEnd:(AJMediaPlayerItem *)mediaPlayerItem {
    if (self.delegate && [self.delegate respondsToSelector:@selector(mediaPlayerViewController:videoDidPlayToEnd:)]) {
        if ([self isAirPlayActive]) {
            if (!isAirPlayReceviedPlayToEnd) {
                [self.delegate mediaPlayerViewController:self videoDidPlayToEnd:self.currentStreamItem];
                isAirPlayReceviedPlayToEnd = YES;
            }
        } else {
            [self.delegate mediaPlayerViewController:self videoDidPlayToEnd:self.currentStreamItem];
        }
    }
}

- (void)mediaPlayer:(AJMediaPlayer *)mediaPlayer didBecomeInvalidWithError:(NSError *)playerError {
    if (self.mediaPlayerView == mediaPlayer.displayView) {
        /**
         *  由于播放器造成播放失败无法区分是断网造成的,所以在这里发一个网络请求，去判断网络状态。（为什么不用Reachability,因为Reachability有延迟造成 http://jira.letv.cn/browse/SPORTSPLAY-71
         */
        NSURL *url = [NSURL URLWithString:@"http://api.letv.com/time"];
        NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:2.0f];
        NSURLSession *session = [NSURLSession sharedSession];
        __weak typeof(self) weakSelf = self;
        NSURLSessionDataTask *serviceTimetask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (!error) {
                if (playerError.code == AJMediaPlayerErrorAVPlayerItemFail) {
                    [weakSelf handleWithErrorState:AJMediaPlayerResourceServiceError errorInfo:playerError];
                } else if (playerError.code == AJMediaPlayerErrorAVPlayerFail) {
                    [weakSelf handleWithErrorState:AJMediaPlayerAirPlayServiceError errorInfo:playerError];
                } else if (playerError.code == AJMediaPlayerErrorCdeOverLoad) {
                    [weakSelf handleWithErrorState:AJMediaPlayerCDEServiceOverLoadError errorInfo:playerError];
                } else if (playerError.code == AJMediaPlayerErrorCdeSwitchStream) {
                    __weak typeof(self) weakSelf = self;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf showTipsViewWithText:@"已为您切换至流畅码流"];
                    });
                } else {
                    [weakSelf handleWithErrorState:AJMediaPlayerCoreServiceError errorInfo:playerError];
                }
            } else {
                [weakSelf handleWithErrorState:AJMediaPlayerLocalHTTPClientNetworkNotConnectedError errorInfo:playerError];
            }
        }];
        [serviceTimetask resume];
    }

}

- (void)mediaPlayer:(AJMediaPlayer *)mediaPlayer didArriveProgressTime:(NSTimeInterval)progressTime availableTime:(NSTimeInterval)availableTime {
    if (!_wwanWarningView) {
        if (_currentStreamItem.type == AJMediaPlayerVODStreamItem) {
            NSTimeInterval duration = [self.mediaPlayer currentItemDuration];
            [self.mediaPlayerControlBar updateDuration:duration currentPlayTime:progressTime availableTime:availableTime];
        }
    }
}

- (void)mediaPlayer:(AJMediaPlayer *)mediaPlayer didArriveTimeShiftIntervalTime:(NSTimeInterval)IntervalTime {
    if (!_wwanWarningView) {
        if (_currentStreamItem.type == AJMediaPlayerLiveStreamItem) {
            [self.mediaPlayerControlBar updateTimeShiftTime:IntervalTime];
        } else if (_currentStreamItem.type == AJMediaPlayerStationStreamItem) {
            self.mediaPlayerControlBar.playOrPauseButton.enabled = YES;
        }
    }
}

- (void)mediaPlayer:(AJMediaPlayer *)mediaPlayer didChangeOutputVolume:(float)volume {
    [self.mediaPlayerControlBar updateVolume:volume isHidden:_soundControlView.hidden];
    if (_soundControlView && !isSoundSlideChangeValue) {
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.soundControlView.slider setValue:volume animated:YES];
        });
    }
}

- (void)mediaPlayer:(AJMediaPlayer *)mediaPlayer didChangeAirPlayState:(AJMediaPlayerAirPlayState)state{
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (state == AJMediaPlayerAirPlayActive) {
            if ([weakSelf.mediaPlayer.mediaStreamProvider isKindOfClass:[AJLetvCDEStreamProviderImplementation class]]) {
                [weakSelf restartToPlayForAirPlayStateChanged];
            }
        } else {
            if ([weakSelf.mediaPlayer.mediaStreamProvider isKindOfClass:[AJDefaultStreamProviderImplementation class]]) {
                [weakSelf restartToPlayForAirPlayStateChanged];
            }
        }
    });
}

- (void)restartToPlayForAirPlayStateChanged {
    if (_playRequest.type == AJMediaPlayerVODStreamItem && [self currentPlaybackTime] > 0) {
        [self startToPlay:_playRequest fromDuration:[self currentPlaybackTime]];
    } else {
        [self startToPlay:_playRequest];
    }
}

#pragma mark - AJMediaPlayerCaptionControlPanelDelegate

- (void)playerCaptionControlPanel:(AJMediaPlayerCaptionControlPanel *)playbackControl didTapOnStreamListButton:(UIButton *)streamListButton {
    if (self.mediaStreamSchedulingMetadata && self.mediaStreamSchedulingMetadata.availableQualifiedStreamItems && self.mediaStreamSchedulingMetadata.availableQualifiedStreamItems.count > 0) {
        [self showQualityPicker];
    }
}

- (void)playerCaptionControlPanel:(AJMediaPlayerCaptionControlPanel *)playerCaptionControlPanel didTapOnBackToLiveButton:(UIButton *)backToLiveButton {
    [_mediaPlayerControlBar updateTotal:_mediaPlayerControlBar.totalTime timeshiftPosition:_mediaPlayerControlBar.totalTime];
    [_mediaPlayerControlBar endTimeshift:0];
}

- (void)playerCaptionControlPanel:(AJMediaPlayerCaptionControlPanel *)playbackControl didTapOnShareButton:(UIButton *)shareButton {
    if (self.delegate && [self.delegate respondsToSelector:@selector(mediaPlayerViewController:didClickOnShareButton:)]) {
        [self hidePlaybackControls];
        [self.delegate mediaPlayerViewController:self didClickOnShareButton:_currentStreamItem];
    }
}

- (void)playerCaptionControlPanel:(AJMediaPlayerCaptionControlPanel *)playbackControl didTapOnExcerptsButton:(UIButton *)excerptsButton {
    [self showEpisodePicker];
}

- (void)playerCaptionControlPanel:(AJMediaPlayerCaptionControlPanel *)playerCaptionControlPanel didTapOnBufferButton:(UIButton *)bufferButton {
    [self showSubmitBufferAlertView];
}

- (void)playerCaptionControlPanel:(AJMediaPlayerCaptionControlPanel *)playerCaptionControlPanel airPlayIsDetected:(BOOL)isDetected {
    if (self.isDetectedAirPlay == !isDetected) {
        self.isDetectedAirPlay = isDetected;
        [self.view setNeedsUpdateConstraints];
        [self.view updateConstraintsIfNeeded];
    }
}

#pragma mark - AJMediaPlayerControlDelegate

- (void)playbackControl:(AJMediaPlayerPlaybackControlPanel *)playbackControl didTapPlay:(UIButton *)playButton {
    if (_currentMediaPlayerState == AJMediaPlayerStateContentFinished) {
        [self seekToPosition:0.f];
        _maxBufferingNumbers = 2;
        [self.mediaPlayer play];
    } else if (_currentMediaPlayerState == AJMediaPlayerStateContentPlaying || _currentMediaPlayerState == AJMediaPlayerStateError || _currentMediaPlayerState == AJMediaPlayerStateContentPaused || _currentMediaPlayerState == AJMediaPlayerStateContentBuffering || _currentMediaPlayerState == AJMediaPlayerStateContentLoading) {
        [self.mediaPlayer play];
    }
    self.isManMadePause = NO;
}

- (void)playbackControl:(AJMediaPlayerPlaybackControlPanel *)playbackControl didTapPause:(UIButton *)pauseButton {
    if (_currentMediaPlayerState == AJMediaPlayerStateContentFinished) {
        [self seekToPosition:0.f];
        [self.mediaPlayer pause];
    } else if (_currentMediaPlayerState == AJMediaPlayerStateContentPlaying || _currentMediaPlayerState == AJMediaPlayerStateError || _currentMediaPlayerState == AJMediaPlayerStateContentBuffering || _currentMediaPlayerState == AJMediaPlayerStateContentLoading) {
        [self.mediaPlayer pause];
    }
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    self.isManMadePause = YES;
}

- (void)playbackControl:(AJMediaPlayerPlaybackControlPanel *)playbackControl didScrubToPosition:(float)scrubberPosition {
    if (_isManMadePause) {
        _isManMadePause = NO;
    }
    [self seekToPosition:scrubberPosition];
}

- (void)playbackControl:(AJMediaPlayerPlaybackControlPanel *)playbackControl didTimeShiftToPosition:(float)timeShiftToPosition {
    if (_isManMadePause) {
        _isManMadePause = NO;
    }
    if (timeShiftToPosition > 0) {
        _isOnTimeShiftModel = YES;
        if (!_mediaPlayerNavigationBar.hidden) {
            if (_appearenceStyle == AJMediaPlayerStyleForiPhone) {
                [self.view bringSubviewToFront:_revertTimeShiftButton];
                _revertTimeShiftButton.hidden = NO;
            } else if (_appearenceStyle == AJMediaPlayerStyleForiPad) {
                _mediaPlayerNavigationBar.backToLiveButton.hidden = NO;
                [_mediaPlayerNavigationBar setNeedsUpdateConstraints];
                [_mediaPlayerNavigationBar updateConstraintsIfNeeded];
            }
        }
        _timeshiftTipsButton.hidden = YES;
        
        if (![[NSUserDefaults standardUserDefaults] valueForKey:USERDEFAULT_TIMESHIFT_KEY]) {
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:USERDEFAULT_TIMESHIFT_KEY];
            [[NSUserDefaults standardUserDefaults] synchronize];
        } else {
            if ([[[NSUserDefaults standardUserDefaults] valueForKey:USERDEFAULT_TIMESHIFT_KEY] integerValue] == 1) {
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:USERDEFAULT_TIMESHIFT_KEY];
                [[NSUserDefaults standardUserDefaults] setObject:@"2" forKey:USERDEFAULT_TIMESHIFT_KEY];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }
    } else {
        _isOnTimeShiftModel = NO;
        if (!_mediaPlayerNavigationBar.hidden) {
            if ([[NSUserDefaults standardUserDefaults] valueForKey:USERDEFAULT_TIMESHIFT_KEY] && [[[NSUserDefaults standardUserDefaults] valueForKey:USERDEFAULT_TIMESHIFT_KEY] integerValue] > 1) {
                _timeshiftTipsButton.hidden = YES;
            } else {
                _timeshiftTipsButton.hidden = NO;
            }
        }
        if (_appearenceStyle == AJMediaPlayerStyleForiPhone) {
            _revertTimeShiftButton.hidden = YES;
        } else if (_appearenceStyle == AJMediaPlayerStyleForiPad) {
            _mediaPlayerNavigationBar.backToLiveButton.hidden = YES;
            [_mediaPlayerNavigationBar setNeedsUpdateConstraints];
            [_mediaPlayerNavigationBar updateConstraintsIfNeeded];
        }
    }
    timeshiftSeekToTime = timeShiftToPosition;
    [self seekToTimeShiftPostion:timeShiftToPosition];
}

- (void)playbackControlScrubbing:(AJMediaPlayerPlaybackControlPanel *)playbackControl {
    [self invalidateTimer];
}

- (void)playbackControlEndScrubbing:(AJMediaPlayerPlaybackControlPanel *)playbackControl {
    [self fireTimer];
}

- (void)playbackControl:(AJMediaPlayerPlaybackControlPanel *)playbackControl didSelectPresentationMode:(AJMediaPlayerPresentationMode)presentationMode {
    BOOL isFullscreened = presentationMode == AJMediaPlayerFullscreenPresentation;
    if (_appearenceStyle == AJMediaPlayerStyleForiPhone) {
        if (isFullscreened) {
            [self showFullScreen];
        } else {
            [self resignFullScreen];
        }
    } else if (_appearenceStyle == AJMediaPlayerStyleForiPad) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(mediaPlayerViewController:didSelectFullScreenMode:)]) {
            [self.delegate mediaPlayerViewController:self didSelectFullScreenMode:isFullscreened];
        }
    }
}

- (void)playbackControl:(AJMediaPlayerPlaybackControlPanel *)playbackControl didTapVolume:(UIButton *)volumeButton {
    if (self.mediaPlayerControlBar.isFullScreen) {
        if (_soundControlView.hidden) {
            [self.view bringSubviewToFront:_soundControlView];
            _soundControlView.hidden = NO;
            _bulletEditButton.hidden = YES;
        } else {
            _soundControlView.hidden = YES;
            _bulletEditButton.hidden = [self shouldHideEditItem];
        }
        [self updateSoundViewComponents];
    }
}

- (void)playbackControlPanel:(AJMediaPlayerPlaybackControlPanel *)playbackControlPanel didTapOnExcerptsHDButton:(UIButton *)excerptsHDButton {
    [self showEpisodePicker];
}

- (void)playbackControlPanel:(AJMediaPlayerPlaybackControlPanel *)playbackControlPanel didTapOnStreamListHDButton:(UIButton *)streamListHDButton {
    if (self.mediaStreamSchedulingMetadata && self.mediaStreamSchedulingMetadata.availableQualifiedStreamItems && self.mediaStreamSchedulingMetadata.availableQualifiedStreamItems.count > 0) {
        [self showQualityPicker];
    }
}

- (void)playbackControl:(AJMediaPlayerPlaybackControlPanel *)playbackControl didChangeSwitchValue:(BOOL)isOn {
    _isChatroomActive = isOn;
    _bulletView.hidden = !isOn;
    _bulletEditButton.hidden = !isOn;
    _soundControlView.hidden = YES;
    [self updateSoundViewComponents];
    [[NSUserDefaults standardUserDefaults] setBool:!isOn forKey:BULLET_SWITCH_OFF];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if (_delegate && [_delegate respondsToSelector:@selector(mediaPlayerViewController:didChangeChatRoomState:)]) {
        [_delegate mediaPlayerViewController:self didChangeChatRoomState:isOn];
    }
}

- (void)updateSoundViewComponents {
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Wdeprecated-declarations"
        _soundControlView.slider.value = [MPMusicPlayerController iPodMusicPlayer].volume;
    #pragma clang diagnostic pop
    [self.mediaPlayerControlBar updateVolume:_soundControlView.slider.value isHidden:_soundControlView.hidden];
}

#pragma mark - Picker delegate

- (void)episodePickerView:(AJMediaEpisodePickerView *)pickerView didSelectWithPlayRequest:(AJMediaPlayRequest *)playRequest {
    [self dismissEpisodePicker];
    if (playRequest) {
        [self startToPlay:playRequest];
        if (self.delegate && [self.delegate respondsToSelector:@selector(mediaPlayerViewController:didChangePlayerItem:)]) {
            [self.delegate mediaPlayerViewController:self didChangePlayerItem:playRequest];
        }
    }
}

- (void)qualityPickerView:(AJMediaQualityPickerView *)pickerView didSelectAtIndex:(NSUInteger)index {
    [self dismissQualityPicker];
    AJMediaPlayerItem *playerItem = self.mediaStreamSchedulingMetadata.availableQualifiedStreamItems[index];
    NSParameterAssert(playerItem);
    [self switchToStreamItem:playerItem];
}

#pragma mark - AJMediaPlayerErrorViewDelegate 

- (void)mediaPlayerErrorViewShouldRetryToPlay {
    if (_playRequest) {
        [self resumeToPlayRequest:_playRequest];
    } else {
        if (_delegate && [_delegate respondsToSelector:@selector(mediaPlayerViewControllerDidClickOnRetryButton:)]) {
            [_delegate mediaPlayerViewControllerDidClickOnRetryButton:self];
        }
    }
}

- (void)mediaPlayerErrorViewShouldContinueToPlay {
    if (_playRequest) {
        [self dismisswwanWarningView];
        _isIgnoreWWAN = YES;
        if (_currentMediaPlayerState == AJMediaPlayerStateContentPaused) {
            _isManMadePause = NO;
            _isAddtionView = NO;
            [self.mediaPlayer play];
        } else {
            _isClickOnIgnorWWAN = YES;
            [self resumeToPlayRequest:_playRequest];
        }
    }
}

- (void)resumeToPlayRequest:(AJMediaPlayRequest *)playRequest {
    if (playRequest.type == AJMediaPlayerLiveStreamItem) {
        if (_currentStreamItem.liveStartTime) {
            if (timeshiftSeekToTime > 0) {
                [self seekToTimeShiftPostion:timeshiftSeekToTime];
            } else {
                [self startToPlay:playRequest];
            }
        } else {
            [self startToPlay:playRequest];
        }
    } else if (playRequest.type == AJMediaPlayerStationStreamItem) {
        [self startToPlay:playRequest];
    } else if (playRequest.type == AJMediaPlayerVODStreamItem) {
        NSTimeInterval duration = [self currentPlaybackTime];
        [self startToPlay:playRequest fromDuration:duration];
    }
}

- (void)mediaPlayerErrorViewClickOnFeedBack {
    Class mailClass = (NSClassFromString(@"AJMediaMailComposeViewController"));
    if (!mailClass) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message: @"当前系统版本不支持应用内发送邮件功能" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }

    if (![mailClass canSendMail]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message: @"需要设置邮件帐号" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    id info = [self integrateWithData:schedulingResult] ? : @"N/A";
    NSDictionary *passInfo = [NSMutableDictionary dictionary];
    [passInfo setValue:info forKey:@"CDN_info"];
    id s = [[NSUserDefaults standardUserDefaults] objectForKey:@"CDEInfo"];
    [passInfo setValue:s forKey:@"CDE_code"];
    AJMediaPlayerFeedback *feedback = [[AJMediaPlayerFeedback alloc] initWithSchedulingUri:self.currentStreamItem.preferredSchedulingStreamURL cdnInfo:passInfo];
    AJMediaMailComposeViewController *mailPicker = [[AJMediaMailComposeViewController alloc] init];
    mailPicker.mailComposeDelegate = self;
    [mailPicker setSubject:[NSString stringWithFormat:@"反馈来自 `%@`", [[UIDevice currentDevice] name]]];
    [mailPicker setToRecipients:[feedback mailRecipients]];
    [mailPicker setMessageBody:[feedback feedbackEmailContent] isHTML:YES];
    [mailPicker setModalPresentationStyle:UIModalPresentationFullScreen];
    NSFileManager* fileManager = [NSFileManager defaultManager];
    
    NSString *logFileFolder = [[AJMediaPlayerInfrastructureContext settings] logMessageFileDirectoryPath];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF ENDSWITH %@", @".log"];
    NSArray* logFileNames = [[fileManager contentsOfDirectoryAtPath:logFileFolder error:nil] filteredArrayUsingPredicate:predicate];
    for (NSString* fileName in logFileNames) {
        NSString* fullPath = [logFileFolder stringByAppendingPathComponent:fileName];
        if ([fileManager fileExistsAtPath:fullPath isDirectory:nil]) {
            NSFileHandle *file = [NSFileHandle fileHandleForUpdatingAtPath:fullPath];
            if (file) {
                NSData *data = [file readDataToEndOfFile];
                if (data) {
                    [mailPicker addAttachmentData:data mimeType:@"text/plain" fileName:fileName];
                }
            }
        }
    }
    [self presentViewController:mailPicker animated:YES completion:^{
        self.isMailViewControler = YES;
    }];
}

- (NSString *)integrateWithData:(id)data {
    if (data && [data isKindOfClass:[NSDictionary class]]) {
        NSDictionary *gslbData = data[@"gslbData"];
        if (gslbData && [gslbData isKindOfClass:[NSDictionary class]]) {
            NSArray *nodelist = gslbData[@"nodelist"];
            if (nodelist && [nodelist isKindOfClass:[NSArray class]]) {
                NSMutableString *nodeString = [NSMutableString string];
                if (_playRequest.resourceName) {
                    [nodeString appendString:[NSString stringWithFormat:@"播放标题:%@<br>",_playRequest.resourceName]];
                }
                [nodeString appendString:@"CDN信息:<br>"];
                for (NSDictionary *nodedic in nodelist) {
                    if (nodedic) {
                        NSString *cdnString = [NSString stringWithFormat:@"节点地区:%@ <br> 播放级别:%@ <br> 切片时长:%@ <br>",nodedic[@"name"],nodedic[@"playlevel"],nodedic[@"slicetime"]];
                        [nodeString appendString:cdnString];
                    }
                }
                return nodeString;
            }
        }
    }
    return nil;
}

- (void)mediaPlayerErrorViewClickOnLogin {
    if (_delegate && [_delegate respondsToSelector:@selector(mediaPlayerViewControllerDidClickOnLoginButton:)]) {
        [_delegate mediaPlayerViewControllerDidClickOnLoginButton:self];
    }
}

#pragma mark - AJMediaBulletInputViewDelegate
- (void)bulletInputView:(AJMediaBulletInputView *)inputView didReturnMessage:(NSString *)message
{
    [self sendButtonAction:nil];
}

#pragma mark - VTBulletViewDataSource
- (UIView *)bulletView:(VTBulletView *)bulletView itemForModel:(LEBubbletModel *)model
{
    VTBulletItem *bulletItem = [[VTBulletItem alloc] init];
    bulletItem.model = model;
    return bulletItem;
}

#pragma mark - feed back mail
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    switch (result) {
        case MFMailComposeResultCancelled: {
            break;
        }
        case MFMailComposeResultSaved: {
            break;
        }
        case MFMailComposeResultSent: {
            break;
        }
        case MFMailComposeResultFailed: {
            break;
        }
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:^{
        self.isMailViewControler = NO;
    }];
}

@end
