//
//  AJMediaPlayer.h
//  Pods
//
//  Created by Gang Li on 5/22/15.
//
//

@import Foundation;
@import AVFoundation;

#ifndef NS_DESIGNATED_INITIALIZER
#if __has_attribute(objc_designated_initializer)
#define NS_DESIGNATED_INITIALIZER __attribute__((objc_designated_initializer))
#else
#define NS_DESIGNATED_INITIALIZER
#endif
#endif

typedef NS_ENUM(NSInteger, AJMediaPlayerState) {
    AJMediaPlayerStateContentInit,      //初始化状态
    AJMediaPlayerStateContentLoading,   //加载状态
    AJMediaPlayerStateContentPlaying,   //播放状态
    AJMediaPlayerStateContentPaused,    //暂停状态
    AJMediaPlayerStateContentSeeking,   //seek状态
    AJMediaPlayerStateContentBuffering, //缓冲状态
    AJMediaPlayerStateContentFinished,  //完成状态
    AJMediaPlayerStateError,            //错误状态
    AJMediaPlayerStateUnknown,          //未知状态
    AJMediaPlayerStateSuspend,          //
    AJMediaPlayerStateDismissed         //
};

typedef NS_ENUM(NSInteger, AJMediaPlayerControlSwipeEvent) {
    AJMediaPlayerControlSwipeForward,
    AJMediaPlayerControlSwipeBackward,
    AJMediaPlayerControlSwipeUpward,
    AJMediaPlayerControlSwipeDownward
};

typedef NS_ENUM(NSInteger, AJMediaPlayerAirPlayState) {
    AJMediaPlayerAirPlayActive,     //airPlay激活状态
    AJMediaPlayerAirPlayInActive    //airPlay不激活状态
};

typedef NS_ENUM(NSInteger, AJMediaPlayerErrorCode) {
    // cde service over load
    AJMediaPlayerErrorCdeOverLoad = 444,
    
    // cde service supply low stream
    AJMediaPlayerErrorCdeSwitchStream = 445,
    
    // The video was flagged as blocked due to licensing restrictions (linkshell blocked stuff).
    AJMediaPlayerErrorVideoBlocked = -8000,
    
    // There was an error fetching the stream.
    AJMediaPlayerErrorFetchStreamError = -8001,
    
    // Could not find the stream type for video.
    AJMediaPlayerErrorStreamNotFound = -8002,
    
    // There was an error loading the video as an asset.
    AJMediaPlayerErrorAssetLoadError = -8003,
    
    // There was an error loading the video's duration.
    AJMediaPlayerErrorDurationLoadError = -8004,
    
    // AVPlayer failed to load the asset.
    AJMediaPlayerErrorAVPlayerFail = -8005,
    
    // AVPlayerItem failed to load the asset.
    AJMediaPlayerErrorAVPlayerItemFail = -8006,
    
    // DLNA/UPnP failed to load the stream.
    AJMediaPlayerErrorDLNAtLoadFail = -8007,
    
    // There was an unknown error.
    AJMediaPlayerErrorUnknown = -8008,
};

NS_ASSUME_NONNULL_BEGIN

extern NSString * const AJMediaPlayerStateChangedNotificationName;
extern NSString * const AJVideoPlayerItemReadyToPlayNofiticationName;

@class AJMediaPlayer;
@class AJMediaPlayerItem;

@protocol AJMediaPlayerDelegate <NSObject>

@optional
/**
 *  播放器起播方法回调
 *
 *  @param mediaPlayer     播放器
 *  @param mediaPlayerItem 播放器PlayerItem
 */
-(void)mediaPlayer:(AJMediaPlayer *)mediaPlayer willPlayMediaItem:(AJMediaPlayerItem *)mediaPlayerItem;
/**
 *  播放器视频播放结束
 *
 *  @param mediaPlayer     播放器
 *  @param mediaPlayerItem 播放器PlayerItem
 */
-(void)mediaPlayer:(AJMediaPlayer *)mediaPlayer didVideoPlayToEnd:(AJMediaPlayerItem *)mediaPlayerItem;
/**
 *  播放器播放状态改变回调方法
 *
 *  @param mediaPlayer   播放器
 *  @param previousState 播放器原状态
 *  @param currentState  播放器当前状态
 */
-(void)mediaPlayer:(AJMediaPlayer *)mediaPlayer didChangeStateFrom:(AJMediaPlayerState)previousState to:(AJMediaPlayerState)currentState;
/**
 *  播放器播放失败回调方法
 *
 *  @param mediaPlayer 播放器
 *  @param playerError 播放器播放失败NSError实例
 */
-(void)mediaPlayer:(AJMediaPlayer *)mediaPlayer didBecomeInvalidWithError:(NSError *)playerError;
/**
 *  播放器拖动进度条完成回调
 *
 *  @param mediaPlayer  播放器
 *  @param progressTime 播放器拖动至进度条时长
 *  @param availableTime 播放器缓冲进度条时长
 */
-(void)mediaPlayer:(AJMediaPlayer *)mediaPlayer didArriveProgressTime:(NSTimeInterval)progressTime availableTime:(NSTimeInterval )availableTime;
/**
 *  播放器直播时移动回调
 *
 *  @param mediaPlayer  播放器
 *  @param IntervalTime 直播当前播放时长
 */
-(void)mediaPlayer:(AJMediaPlayer *)mediaPlayer didArriveTimeShiftIntervalTime:(NSTimeInterval)IntervalTime;

/**
 *  播放器音量变化时调用
 *
 *  @param volume 音量值范围（0~1）
 */
- (void)mediaPlayer:(AJMediaPlayer *)mediaPlayer didChangeOutputVolume:(float)volume;
/**
 *  播放器airPlay激活状态变动回调
 *
 *  @param mediaPlayer 播放器
 *  @param state       airPlay激活状态
 */
- (void)mediaPlayer:(AJMediaPlayer *)mediaPlayer didChangeAirPlayState:(AJMediaPlayerAirPlayState)state;

@end

@class AVPlayer;
@class AJMediaPlayerView;
@class AJMediaPlayerRemoteDisplay;
@protocol AJMediaStreamProvider;
@protocol AJMediaPlayerRemoteDisplayable;
@interface AJMediaPlayer : NSObject
/**
 *  CDE模块
 */
@property(nonatomic, strong) id<AJMediaStreamProvider> mediaStreamProvider;
/**
 *  AVPlayer实例对象
 */
@property (nonatomic, strong, readonly, nullable) AVPlayer *videoPlayer;
/**
 *  播放器展示视图
 */
@property (nonatomic, strong) AJMediaPlayerView *displayView;
/**
 *  播放器当前playItem
 */
@property (nonatomic, strong, nullable) AVPlayerItem *currentPlayerItem;
/**
 *  播放码流数据
 */
@property (nonatomic, copy, readonly) AJMediaPlayerItem *currentStreamItem;
/**
 *  播放器delegate
 */
@property (nonatomic, weak) id<AJMediaPlayerDelegate> delegate;
/**
 *  如果是登录用户 需要赋值uid
 */
@property (nonatomic, strong) NSString *uid;
/**
 *  当前播放器播放状态
 */
@property (nonatomic, assign) AJMediaPlayerState currentPlayState;
/**
 *  可拖动进度
 */
@property (nonatomic, assign) BOOL canMoveProgress;
/**
 *  改变码流的次数
 */
@property (nonatomic, assign) NSInteger changeStreamCount;
/**
 *  服务器时间与本地时间差
 */
@property (nonatomic, assign) NSTimeInterval timeDifference;

@property (nonatomic, weak) AJMediaPlayerRemoteDisplay<AJMediaPlayerRemoteDisplayable> *remoteDisplay;

/**
 *  播放器初始化方法
 *
 *  @param streamProvider
 *
 *  @return 播放器Player
 */
- (instancetype)initWithStreamProvider:(id<AJMediaStreamProvider>)streamProvider NS_DESIGNATED_INITIALIZER;
/**
 *  播放器点播，直播调用方法
 *
 *  @param metadata 播放元数据
 *  @param duration 起播时间点
 */
- (void)prepareToStream:(AJMediaPlayerItem *)metadata fromDuration:(NSTimeInterval )duration uid:(NSString *)uid;
/**
 *  播放器点播，直播切换码流调用方法
 *
 *  @param metadata 播放元数据
 */
- (void)switchToStream:(AJMediaPlayerItem *)metadata;
/**
 *  获取视频总时长
 *
 *  @return 视频总时长
 */
@property (NS_NONATOMIC_IOSONLY, readonly) NSTimeInterval currentItemDuration;
/**
 *  获取视频当前播放时长
 *
 *  @return 视频当前播放时长
 */
@property (NS_NONATOMIC_IOSONLY, readonly) NSTimeInterval currentPlaybackTime;
/**
 *  获取播放器airPlay当前激活状态
 */
@property (NS_NONATOMIC_IOSONLY, readonly) BOOL airPlayVideoActive;
/**
 *  单次播放的UUID,用于数据上报
 */
@property (nonatomic, copy) NSString *currentUUID;

@end

@interface AJMediaPlayer (PlaybackControl)
/**
 *  播放器起播
 */
-(void)play;
/**
 *  播放器暂停
 */
-(void)pause;
/**
 *  播放器移动到某时间点播放
 *
 *  @param time 移动到的时间点
 */
- (void)seekToTime:(NSTimeInterval)time;
/**
 *  播放器时移回访
 *
 *  @param timeshift 时移回放时间
 */
- (void)timeshiftPlayer:(int)timeshiftPosition;
/**
 *  播放器直播后台进入前台播放url
 *
 *  @param playUrl 直播播放地址
 *  @param error cde错误信息
 */
- (void)restartToPlayLiveUrl:(NSURL *)playerURL error:(nullable NSError *)error;
/**
 *  播放器点播后台进入前台播放url
 *
 *  @param playerURL   点播播放地址
 *  @param currentTime 上次播放时间点
 *  @param error cde错误信息
 */
- (void)restartToPlayVideoUrl:(NSURL *)playerURL currentTime:(NSTimeInterval )currentPlayTime error:(nullable NSError *)error;
/**
 *  销毁播放器
 */
-(void)invalidate;

@end

@interface AJMediaPlayer ()
/**
 *  起播类型：0：直接点播 1：连播 2：切换码流 （暂时不涉及连播)
 */
@property (nonatomic, assign) int ipt;
/**
 *  心跳15秒计时器
 */
@property (nonatomic, strong, nullable) NSTimer *fifteenSecondsTimer;
/**
 *  心跳60秒计时器
 */
@property (nonatomic ,strong, nullable) NSTimer *oneMinuteTimer;
/**
 *  心跳180秒计时器
 */
@property (nonatomic, strong, nullable) NSTimer *threeMinuteTimer;
/**
 *  心跳300秒计时器
 */
@property (nonatomic, strong, nullable) NSTimer *fiveMinuteTimer;

@end

@class RACScheduler;
@class RACSignal;

@interface AJMediaPlayer (RACSignalSupport)

-(RACSignal *)rac_SignalForPlayerState:(AJMediaPlayerState)playerState;

@end

NS_ASSUME_NONNULL_END

