//
//  AJMediaPlayer.m
//  Pods
//
//  Created by Zhangqibin on 5/22/15.
//
//

@import AVFoundation;
#import "AJMediaPlayer.h"
#import <Reachability/Reachability.h>
#import "AJMediaStreamProvider.h"
#import "AJMediaPlayerInfrastructureContext_Internal.h"
#import "AJMediaPlayerView.h"
#import "AJMediaPlayerItem.h"
#import "AJMediaSessionVolume.h"
#import "AJMediaPlayerAnalyticsReporter.h"
#import "AVPlayer+AJMediaPlayerKit.h"
#import "AJMediaRecordTimeHelper.h"
#import "AJMediaPlayer+Analytics.h"
#import "AJMediaPlayer+Statistics.h"
#import "AJMediaPlayerSDKAnalyticsReporter.h"
#import "AJMediaPlayer+SDKAnalytics.h"
#import "AJFoundation.h"
//#import <SSKeychain.h>

NSString * const AJMediaPlayerErrorDomain = @"com.lesports.ajmediaplayer.error";
NSString * const AJMediaPlayerStateChangedNotificationName = @"com.lesports.ajmediaplayer.state.changed";
NSString * const AJVideoPlayerItemReadyToPlayNofiticationName = @"com.lesports.ajmediaplayer.item.readytoplay";

NSString * const AVSystemController_SystemVolumeDidChangeNotification = @"AVSystemController_SystemVolumeDidChangeNotification";

/* AVPlayer keys */
NSString * const kRateKey               = @"rate";
NSString * const kCurrentItemKey        = @"currentItem";
NSString * const kItemtracksKey         = @"currentItem.tracks";
NSString * const kAirPlayVideoActiveKey = @"externalPlaybackActive";
NSString * const kErrorKey              = @"error";

static void *AVPlayerPlaybackRateObservationContext = &AVPlayerPlaybackRateObservationContext;
static void *AVPlayerPlaybackCurrentItemObservationContext = &AVPlayerPlaybackCurrentItemObservationContext;
static void *AVPlayerPlaybackTracksObservationContext = &AVPlayerPlaybackTracksObservationContext;
static void *AVPlayerAirplayVideoActiveContext = &AVPlayerAirplayVideoActiveContext;
static void *AVPlayerPlaybackLoadedErrorObservationContext = &AVPlayerPlaybackLoadedErrorObservationContext;

/* PlayerItem keys */
NSString * const kStatusKey                 = @"status";
NSString * const kPlaybackBufferEmpty       = @"playbackBufferEmpty";
NSString * const kPlaybackLikelyToKeepUp    = @"playbackLikelyToKeepUp";
NSString * const kLoadedTimeRanges          = @"loadedTimeRanges";

static void *AVPlayerPlaybackStatusObservationContext = &AVPlayerPlaybackStatusObservationContext;
static void *AVPlayerPlaybackBufferEmptyContext = &AVPlayerPlaybackBufferEmptyContext;
static void *AVPlayerPlaybackLikelyToKeepUpContext = &AVPlayerPlaybackLikelyToKeepUpContext;
static void *AVPlayerPlaybackLoadedTimeRangesObservationContext = &AVPlayerPlaybackLoadedTimeRangesObservationContext;

static void *AVPlayerReadyForDisplay = &AVPlayerReadyForDisplay;

static dispatch_queue_t mediaplayer_processing_queue() {
    static dispatch_queue_t aj_mediaplayer_processing_queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        aj_mediaplayer_processing_queue = dispatch_queue_create("com.lesports.ajmediaplayer.processing", DISPATCH_QUEUE_CONCURRENT);
    });
    return aj_mediaplayer_processing_queue;
}

@interface AJMediaPlayer ()
/**
 *  播放器内核Player
 */
@property(nonatomic, strong, readwrite, nullable) AVPlayer *videoPlayer;
/**
 *  当前播放时间观察者
 */
@property(nonatomic, strong) id timeObserver;
/**
 *  播放器元数据
 */
@property (nonatomic, copy, readwrite) AJMediaPlayerItem *currentStreamItem;
/**
 *  是否已经上报大数据开始播放标识符
 */
@property (nonatomic, assign) BOOL isReportedBeginToPlay;
/**
 *  是否已经上报大数据开始播放标识符
 */
@property (nonatomic, strong) NSString *userId;
/**
 *  当前播放器时移位置
 */
@property (nonatomic, assign) int currentTimeshiftPosition;

@end

@implementation AJMediaPlayer

- (instancetype)init {
    AJLetvCDEStreamProviderImplementation *provider= [[AJLetvCDEStreamProviderImplementation alloc] init];
    return [self initWithStreamProvider:provider];
}

#pragma mark - Init Method

- (instancetype)initWithStreamProvider:(id<AJMediaStreamProvider>)streamProvider {
    self = [super init];
    if (self) {
        self.mediaStreamProvider = streamProvider;
        self.timeDifference = 0;
    }
    return self;
}

- (void)setDisplayView:(AJMediaPlayerView *)displayView {
    _displayView = displayView;
    _displayView.player = self;
}


#pragma mark - Public Methods

- (void)switchToStream:(AJMediaPlayerItem *)metadata {
    double currentPlayTime = [self currentPlaybackTime];
    self.currentStreamItem = metadata;
    self.changeStreamCount++;
    self.ipt = 2;
    if (self.mediaStreamProvider && [self.mediaStreamProvider respondsToSelector:@selector(loadPlayableItemWithMetadata:timeshift:withParameter:completionHandler:)]) {
        __weak typeof(self) weakSelf = self;
        [self.mediaStreamProvider loadPlayableItemWithMetadata:metadata timeshift:_currentTimeshiftPosition withParameter:[weakSelf fetchBasicUrlWithMetadata:metadata] completionHandler:^(NSError *err, AVPlayerItem *item) {
            [weakSelf handleCdeError:err];
            if (err.code == AJMediaPlayerErrorCdeOverLoad || weakSelf.currentPlayerItem == item || !item) {
                return;
            }
            if (weakSelf.currentPlayerItem) {
                [weakSelf removeProgressTimeObserver];
                [weakSelf removePlayItemObserver];
            }
            weakSelf.currentPlayerItem = item;
            if (weakSelf.currentPlayerItem) {
                weakSelf.currentPlayState = AJMediaPlayerStateContentInit;
                weakSelf.canMoveProgress = NO;
                
                [weakSelf.videoPlayer replaceCurrentItemWithPlayerItem:weakSelf.currentPlayerItem];
                [weakSelf addPlayItemObserver:_currentPlayerItem];
                if (weakSelf.currentStreamItem.type == AJMediaPlayerVODStreamItem) {
                    if (currentPlayTime > 0) {
                        [weakSelf seekToTime:currentPlayTime];
                    }
                }
            }
        }];
    }
    [self submitBigdataForPlayerSwitchStream];
}

- (void)timeshiftPlayer:(int)timeshiftPosition {
    aj_logMessage(AJLoggingInfo, @"%@ seek timeshift to position %@", self.currentStreamItem, @(timeshiftPosition));
    self.currentTimeshiftPosition = timeshiftPosition;
    if (self.currentStreamItem.type == AJMediaPlayerLiveStreamItem) {
        if (self.mediaStreamProvider && [self.mediaStreamProvider respondsToSelector:@selector(loadPlayableItemWithMetadata:timeshift:withParameter:completionHandler:)]) {
            __weak typeof(self) weakSelf = self;
            [self.mediaStreamProvider loadPlayableItemWithMetadata:weakSelf.currentStreamItem timeshift:weakSelf.currentTimeshiftPosition withParameter:[weakSelf fetchBasicUrlWithMetadata:weakSelf.currentStreamItem] completionHandler:^(NSError *err, AVPlayerItem *item) {
                
                [weakSelf handleCdeError:err];
                if (err.code == AJMediaPlayerErrorCdeOverLoad || weakSelf.currentPlayerItem == item || !item) {
                    return;
                }
                if (weakSelf.currentPlayerItem) {
                    [weakSelf removeProgressTimeObserver];
                    [weakSelf removePlayItemObserver];
                }
                weakSelf.currentPlayerItem = item;
                if (weakSelf.currentPlayerItem) {
                    weakSelf.currentPlayState = AJMediaPlayerStateContentInit;
                    weakSelf.canMoveProgress = NO;
                    
                    [weakSelf.videoPlayer replaceCurrentItemWithPlayerItem:weakSelf.currentPlayerItem];
                    [weakSelf addPlayItemObserver:_currentPlayerItem];
                }
            }];
        }
    }
}

- (void)restartToPlayVideoUrl:(NSURL *)playerURL currentTime:(NSTimeInterval )currentPlayTime error:(nullable NSError *)error {
    [self handleCdeError:error];
    if (error.code == AJMediaPlayerErrorCdeOverLoad) {
        return;
    }
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:playerURL];
    if (playerItem) {
        [self removePlayItemObserver];
        self.currentPlayerItem = playerItem;
        [self.videoPlayer replaceCurrentItemWithPlayerItem:self.currentPlayerItem];
        [self addPlayItemObserver:self.currentPlayerItem];
        if (currentPlayTime > 0) {
            [self seekToTime:currentPlayTime];
            [self play];
        }
    }
}

- (void)restartToPlayLiveUrl:(NSURL *)playerURL error:(nullable NSError *)error {
    [self handleCdeError:error];
    if (error.code == AJMediaPlayerErrorCdeOverLoad) {
        return;
    }
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:playerURL];
    if (playerItem) {
        [self removePlayItemObserver];
        self.currentPlayerItem = playerItem;
        [self.videoPlayer replaceCurrentItemWithPlayerItem:self.currentPlayerItem];
        [self addPlayItemObserver:self.currentPlayerItem];
        [self play];
    }
}

-(NSTimeInterval)currentItemDuration {
    double durationTime = 0.0;
    if (self.videoPlayer) {
        durationTime = [self.videoPlayer currentItemDuration];
    }
    return durationTime;
}

- (NSTimeInterval)currentPlaybackTime {
    double time = 0.0;
    if (self.currentPlayerItem) {
        CMTime playerTime = [self.currentPlayerItem currentTime];
        if (CMTIME_IS_VALID(playerTime) && !CMTIME_IS_INDEFINITE(playerTime)) {
            time = CMTimeGetSeconds(playerTime);
        }
    }
    return time;
}

- (NSTimeInterval)availableDuration {
    NSTimeInterval result = 0;
    if (self.currentPlayerItem) {
        NSArray *loadedTimeRanges = [self.currentPlayerItem loadedTimeRanges];
        if (loadedTimeRanges.count > 0) {
            CMTimeRange timeRange = [loadedTimeRanges[0] CMTimeRangeValue];
            float startSeconds = CMTimeGetSeconds(timeRange.start);
            float durationSeconds = CMTimeGetSeconds(timeRange.duration);
            result = startSeconds + durationSeconds;
        }
    }
    return result;
}

- (BOOL)airPlayVideoActive {
    return self.videoPlayer.externalPlaybackActive;
}

/*
- (void)prepareToStream:(AJMediaPlayerItem *)metadata fromDuration:(NSTimeInterval )duration uid:(NSString *)uid {
    self.userId= uid;
    [self addNotificationObservers];
    _currentUUID = [[NSUUID UUID] UUIDString];
    
    if ([[AJMediaPlayerAnalyticsReporter sharedReporter] shareAppMetadata]) {
        _currentUUID = [[NSUUID UUID] UUIDString];
    } else if ([[AJMediaPlayerSDKAnalyticsReporter sharedReporter] shareAppConfiguration]) {
        [[AJMediaPlayerSDKAnalyticsReporter sharedReporter] creatVideoPlay];
    }
    
    self.changeStreamCount = 0;
    self.ipt = 0;
    _isReportedBeginToPlay = NO;
    self.currentStreamItem = metadata;
    self.currentTimeshiftPosition = 0;
    if (self.mediaStreamProvider && [self.mediaStreamProvider respondsToSelector:@selector(loadPlayableItemWithMetadata:timeshift:withParameter:completionHandler:)]) {
        __weak typeof(self) weakSelf = self;
        [self.mediaStreamProvider loadPlayableItemWithMetadata:metadata timeshift:weakSelf.currentTimeshiftPosition withParameter:[weakSelf fetchBasicUrlWithMetadata:metadata] completionHandler:^(NSError *err, AVPlayerItem *item) {
            [weakSelf handleCdeError:err];
            [[AJMediaRecordTimeHelper sharedInstance] recordStartTimeWithKey:@"cde_end_play"];
            if (err.code == AJMediaPlayerErrorCdeOverLoad || weakSelf.currentPlayerItem == item || !item) {
                return;
            }
            weakSelf.currentPlayerItem = item;
            if (weakSelf.currentPlayerItem) {
                weakSelf.currentPlayState = AJMediaPlayerStateContentInit;
                weakSelf.canMoveProgress = NO;
                weakSelf.videoPlayer = [[AVPlayer alloc] init];
                [weakSelf.videoPlayer replaceCurrentItemWithPlayerItem:weakSelf.currentPlayerItem];
                [weakSelf addPlayerObserver];
                [weakSelf addPlayItemObserver:weakSelf.currentPlayerItem];
                if (duration > 0) {
                    [weakSelf.videoPlayer seekToTime:CMTimeMakeWithSeconds(duration, NSEC_PER_SEC)];
                }
            }
        }];
    }
    [self submitBigdataForPlayerInit];
}*/

- (void)prepareToStream:(AJMediaPlayerItem *)metadata fromDuration:(NSTimeInterval )duration uid:(NSString *)uid {
    self.userId= uid;
    [self addNotificationObservers];
    _currentUUID = [[NSUUID UUID] UUIDString];
    
    if ([[AJMediaPlayerAnalyticsReporter sharedReporter] shareAppMetadata]) {
        _currentUUID = [[NSUUID UUID] UUIDString];
    } else if ([[AJMediaPlayerSDKAnalyticsReporter sharedReporter] shareAppConfiguration]) {
        [[AJMediaPlayerSDKAnalyticsReporter sharedReporter] creatVideoPlay];
    }
    
    self.changeStreamCount = 0;
    self.ipt = 0;
    _isReportedBeginToPlay = NO;
    self.currentStreamItem = metadata;
    self.currentTimeshiftPosition = 0;
    if (self.mediaStreamProvider && [self.mediaStreamProvider respondsToSelector:@selector(loadPlayableItemWithMetadata:timeshift:withParameter:completionHandler:)]) {
        __weak typeof(self) weakSelf = self;
//        [self.mediaStreamProvider loadPlayableItemWithMetadata:metadata timeshift:weakSelf.currentTimeshiftPosition withParameter:[weakSelf fetchBasicUrlWithMetadata:metadata] completionHandler:^(NSError *err, AVPlayerItem *item) {
//            [weakSelf handleCdeError:err];
//            [[AJMediaRecordTimeHelper sharedInstance] recordStartTimeWithKey:@"cde_end_play"];
//            if (err.code == AJMediaPlayerErrorCdeOverLoad || weakSelf.currentPlayerItem == item || !item) {
//                return;
//            }
        AVPlayerItem *item = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:metadata.preferredSchedulingStreamURL]];
            weakSelf.currentPlayerItem = item;
            if (weakSelf.currentPlayerItem) {
                weakSelf.currentPlayState = AJMediaPlayerStateContentInit;
                weakSelf.canMoveProgress = NO;
                weakSelf.videoPlayer = [[AVPlayer alloc] init];
                [weakSelf.videoPlayer replaceCurrentItemWithPlayerItem:weakSelf.currentPlayerItem];
                [weakSelf addPlayerObserver];
                [weakSelf addPlayItemObserver:weakSelf.currentPlayerItem];
                if (duration > 0) {
                    [weakSelf.videoPlayer seekToTime:CMTimeMakeWithSeconds(duration, NSEC_PER_SEC)];
                }
            }
//        }];
    }
    [self submitBigdataForPlayerInit];
}

- (void)handleCdeError:(NSError *)err {
    if (err.code == AJMediaPlayerErrorCdeOverLoad || err.code == AJMediaPlayerErrorCdeSwitchStream) {
        if (err.code == AJMediaPlayerErrorCdeOverLoad) {
            if (self.mediaStreamProvider) {
                [self.mediaStreamProvider cancelTasks];
            }
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(mediaPlayer:didBecomeInvalidWithError:)]) {
            [self.delegate mediaPlayer:self didBecomeInvalidWithError:err];
        }
    }
}

#pragma mark - Get Basic Parameter Report to CDN

- (NSString *)fetchBasicUrlWithMetadata:(AJMediaPlayerItem *)schedulingMetadata {
    NSMutableString *basicUrl = nil;
    if ([[AJMediaPlayerAnalyticsReporter sharedReporter] shareAppMetadata]) {
        AJAnalyticsAppMetadata *metadata = [[AJMediaPlayerAnalyticsReporter sharedReporter] shareAppMetadata];
        if (metadata.firstLevelID && metadata.secondLevelID) {
            basicUrl = [NSMutableString stringWithFormat:@"&p1=%@&p2=%@",metadata.firstLevelID,metadata.secondLevelID];
            if (schedulingMetadata.type == AJMediaPlayerVODStreamItem) {
                [basicUrl appendString:[NSString stringWithFormat:@"&vid=%@",schedulingMetadata.streamID]];
            } else if (schedulingMetadata.type == AJMediaPlayerLiveStreamItem) {
                [basicUrl appendString:[NSString stringWithFormat:@"&liveid=%@",schedulingMetadata.streamID]];
            }
            if (_currentUUID) {
                [basicUrl appendString:[NSString stringWithFormat:@"&uuid=%@_%@",_currentUUID, @(_changeStreamCount)]];
            }
        }
    } else if ([[AJMediaPlayerSDKAnalyticsReporter sharedReporter] shareAppConfiguration]) {
        AJMediaPlayerBigDataConfiguration *configuration = [[AJMediaPlayerSDKAnalyticsReporter sharedReporter] shareAppConfiguration];
        if (configuration.appName && configuration.version) {
            basicUrl = [NSMutableString stringWithFormat:@"&app_name=%@&app_ver=%@",configuration.appName,configuration.version];
            if (schedulingMetadata.type == AJMediaPlayerVODStreamItem) {
                [basicUrl appendString:[NSString stringWithFormat:@"&vid=%@",schedulingMetadata.streamID]];
            } else if (schedulingMetadata.type == AJMediaPlayerLiveStreamItem) {
                [basicUrl appendString:[NSString stringWithFormat:@"&liveid=%@",schedulingMetadata.streamID]];
            } 
            if ([[AJMediaPlayerSDKAnalyticsReporter sharedReporter] getPlayId]) {
                NSString *uuid = [[AJMediaPlayerSDKAnalyticsReporter sharedReporter] getPlayId];
                [basicUrl appendString:[NSString stringWithFormat:@"&uuid=%@",uuid]];
            }
        }
    }
    return basicUrl;
}

#pragma mark - AVPlayerItem Observer Manipulation

- (void)addPlayItemObserver:(AVPlayerItem *)playerItem {
    if (self.currentPlayerItem) {
        [self.currentPlayerItem addObserver:self
                                 forKeyPath:kStatusKey
                                    options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                                    context:AVPlayerPlaybackStatusObservationContext];
        [self.currentPlayerItem addObserver:self
                                 forKeyPath:kPlaybackBufferEmpty
                                    options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                                    context:AVPlayerPlaybackBufferEmptyContext];
        [self.currentPlayerItem addObserver:self
                                 forKeyPath:kPlaybackLikelyToKeepUp
                                    options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                                    context:AVPlayerPlaybackLikelyToKeepUpContext];
        [self.currentPlayerItem addObserver:self
                                 forKeyPath:kLoadedTimeRanges
                                    options:NSKeyValueObservingOptionNew
                                    context:AVPlayerPlaybackLoadedTimeRangesObservationContext];
        NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
        [defaultCenter addObserver:self
                          selector:@selector(playerItemDidPlayToEndTime:)
                              name:AVPlayerItemDidPlayToEndTimeNotification
                            object:nil];
        
        [defaultCenter addObserver:self
                          selector:@selector(playerItemFailToPlayToEndTime:)
                              name:AVPlayerItemFailedToPlayToEndTimeNotification
                            object:nil];
    }
}

- (void)removePlayItemObserver{
    if (self.currentPlayerItem) {
        @try {
            [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
            [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemFailedToPlayToEndTimeNotification object:nil];
            [self.currentPlayerItem removeObserver:self forKeyPath:kStatusKey];
            [self.currentPlayerItem removeObserver:self forKeyPath:kPlaybackBufferEmpty];
            [self.currentPlayerItem removeObserver:self forKeyPath:kPlaybackLikelyToKeepUp];
            [self.currentPlayerItem removeObserver:self forKeyPath:kLoadedTimeRanges];

        }
        @catch (NSException *exception) {
            aj_logMessage(AJLoggingWarn, @"An exception raised while attempting to remove AVPlayerItem's observers, %@", exception);
        }
    }
}

- (void)playerItemDidPlayToEndTime:(NSNotification *)notification {
    if (self.delegate && [self.delegate respondsToSelector:@selector(mediaPlayer:didChangeStateFrom:to:)]) {
        [self.delegate mediaPlayer:self didChangeStateFrom:self.currentPlayState to:AJMediaPlayerStateContentFinished];
        self.currentPlayState = AJMediaPlayerStateContentFinished;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(mediaPlayer:didVideoPlayToEnd:)]) {
        [self.delegate mediaPlayer:self didVideoPlayToEnd:self.currentStreamItem];
    }
    [self submitBigdataForPlayerFinishToPlay];
    [self submitPlayerStatisticsWithType:PlayActionEnd playItem:_currentStreamItem uid:_userId];
}

- (void)playerItemFailToPlayToEndTime:(NSNotification *)notification {
    if (self.delegate && [self.delegate respondsToSelector:@selector(mediaPlayer:didChangeStateFrom:to:)]) {
        [self.delegate mediaPlayer:self didChangeStateFrom:self.currentPlayState to:AJMediaPlayerStateError];
        self.currentPlayState = AJMediaPlayerStateError;
    }
}

#pragma mark - AVPlayer Observer Manipulation

- (void)addPlayerObserver {
    if (self.videoPlayer) {
        [self.videoPlayer addObserver:self
                           forKeyPath:kRateKey
                              options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                              context:AVPlayerPlaybackRateObservationContext];
        
        [self.videoPlayer addObserver:self
                           forKeyPath:kCurrentItemKey
                              options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                              context:AVPlayerPlaybackCurrentItemObservationContext];
        
        [self.videoPlayer addObserver:self
                           forKeyPath:kItemtracksKey options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:AVPlayerPlaybackTracksObservationContext];
        
        [self.videoPlayer addObserver:self
                           forKeyPath:kAirPlayVideoActiveKey
                              options:NSKeyValueObservingOptionNew
                              context:AVPlayerAirplayVideoActiveContext];
        
        [self.videoPlayer addObserver:self
                           forKeyPath:kErrorKey
                              options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
                              context:AVPlayerPlaybackLoadedErrorObservationContext];
    }
}

- (void)removePlayerObserver {
    if (self.videoPlayer) {
        @try {
            [self.videoPlayer removeObserver:self forKeyPath:kRateKey context:AVPlayerPlaybackRateObservationContext];
            [self.videoPlayer removeObserver:self forKeyPath:kCurrentItemKey context:AVPlayerPlaybackCurrentItemObservationContext];
            [self.videoPlayer removeObserver:self forKeyPath:kItemtracksKey context:AVPlayerPlaybackTracksObservationContext];
            [self.videoPlayer removeObserver:self forKeyPath:kAirPlayVideoActiveKey context:AVPlayerAirplayVideoActiveContext];
            [self.videoPlayer removeObserver:self forKeyPath:kErrorKey context:AVPlayerPlaybackLoadedErrorObservationContext];
        }
        @catch (NSException *exception) {
            aj_logMessage(AJLoggingWarn, @"An exception raised while removing AVPlayer's observers %@", exception);
        }
    }
}

#pragma mark - NotificationCenter Observer Manipulation

- (void)addNotificationObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerAudioSessionRouteDidChange:) name:kMediaAudioSessionRouteDidChangeNotificationName object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerAudioSessionVolumeDidChange:) name:kMediaAudioSessionVolumeDidChangeNotificationName object:nil];
}

- (void)removeNotificationObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kMediaAudioSessionRouteDidChangeNotificationName object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kMediaAudioSessionVolumeDidChangeNotificationName object:nil];
}


- (void)playerAudioSessionRouteDidChange:(NSNotification *)notification {
    if (notification.userInfo && [[notification.userInfo valueForKey:@"state"] isEqualToString:@"Speaker"]) {
        aj_logMessage(AJLoggingInfo, @"Current device detected user using speaker route");
        if (self.delegate && [self.delegate respondsToSelector:@selector(mediaPlayer:didChangeStateFrom:to:)]) {
            [self.delegate mediaPlayer:self didChangeStateFrom:self.currentPlayState to:AJMediaPlayerStateContentPaused];
            self.currentPlayState = AJMediaPlayerStateContentPaused;
        }
    } else if (notification.userInfo && [[notification.userInfo valueForKey:@"state"] isEqualToString:@"Headphone"]) {
        aj_logMessage(AJLoggingInfo, @"Current device detected user plugs in headphone");
        if (self.delegate && [self.delegate respondsToSelector:@selector(mediaPlayer:didChangeStateFrom:to:)]) {
            if (self.currentPlayState == AJMediaPlayerStateContentPaused) {
                [self play];
            }
        }
    }
}

- (void)playerAudioSessionVolumeDidChange:(NSNotification *)notification {
    if (self.delegate && [self.delegate respondsToSelector:@selector(mediaPlayer:didChangeOutputVolume:)]) {
        float volume = [notification.object floatValue];
        [self.delegate mediaPlayer:self didChangeOutputVolume:volume];
    }
}

#pragma mark - Add Progress Observer Methods

- (void)prepareProgressTimeObserver {
    NSTimeInterval periodic = .5f;
    CMTime playerItemDuration = [self.videoPlayer.currentItem duration];
    if (CMTIME_IS_INVALID(playerItemDuration)){
        return;
    }
    /* Update the scrubber during normal playback. */
    if (!self.timeObserver) {
        __weak typeof(self) weakSelf = self;
        self.timeObserver = [self.videoPlayer addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(periodic, NSEC_PER_SEC) queue:NULL usingBlock: ^(CMTime time) {
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(mediaPlayer:didArriveProgressTime:availableTime:)]) {
                NSTimeInterval currentTime = CMTimeGetSeconds(time);
                NSTimeInterval availableTime = [weakSelf availableDuration];
                if (CMTIME_IS_INDEFINITE(time) || CMTIME_IS_INVALID(time)) {
                    currentTime = -1.f;
                }
                weakSelf.canMoveProgress = YES;
                [weakSelf.delegate mediaPlayer:weakSelf didArriveProgressTime:currentTime availableTime:availableTime];
            }
            
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(mediaPlayer:didArriveTimeShiftIntervalTime:)]) {
                NSDate *liveStartDate = weakSelf.currentStreamItem.liveStartTime;
                NSTimeInterval localtime = [[NSDate date] timeIntervalSince1970]*1000/1000;
                NSDate *serverDate = [NSDate dateWithTimeIntervalSince1970:localtime-_timeDifference];
                NSTimeInterval intervalTime = [serverDate timeIntervalSinceDate:liveStartDate];
                [weakSelf.delegate mediaPlayer:weakSelf didArriveTimeShiftIntervalTime:intervalTime];
            }
        }];
    }
}

- (void)removeProgressTimeObserver {
    if (self.timeObserver) {
        [self.videoPlayer removeTimeObserver:self.timeObserver];
        self.timeObserver = nil;
    }
}

#pragma mark - KVO Observe Methods

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context == AVPlayerPlaybackStatusObservationContext) {
        AVPlayerItemStatus status = [change[NSKeyValueChangeNewKey] integerValue];
        switch (status) {
            case AVPlayerItemStatusUnknown:
                self.currentPlayState = AJMediaPlayerStateUnknown;
                break;
            case AVPlayerItemStatusFailed:
                if (self.delegate && [self.delegate respondsToSelector:@selector(mediaPlayer:didBecomeInvalidWithError:)]) {
                    AVPlayerItem *item = (AVPlayerItem*)object;
                    NSError *error = [NSError errorWithDomain:AJMediaPlayerErrorDomain code:AJMediaPlayerErrorAVPlayerItemFail userInfo:item.error.userInfo];
                    __weak typeof(self) weakSelf = self;
                    dispatch_async(mediaplayer_processing_queue(), ^{
                        [weakSelf.delegate mediaPlayer:weakSelf didBecomeInvalidWithError:error];
                    });
                    self.currentPlayState = AJMediaPlayerStateError;
                }
                break;
            case AVPlayerItemStatusReadyToPlay:
                [self prepareProgressTimeObserver];
                if (self.delegate && [self.delegate respondsToSelector:@selector(mediaPlayer:willPlayMediaItem:)]) {
                     __weak typeof(self) weakSelf = self;
                    dispatch_async(mediaplayer_processing_queue(), ^{
                        [weakSelf.delegate mediaPlayer:weakSelf willPlayMediaItem:self.currentStreamItem];
                    });
                    self.currentPlayState = AJMediaPlayerStateContentPlaying;
                }
                if (!_isReportedBeginToPlay) {
                    [self submitBigdataForPlayerBeginToPlay];
                    [self submitPlayerStatisticsWithType:PlayActionStart playItem:_currentStreamItem uid:_userId];
                    [self startToStatisticHeartBeatTimerWithItem:_currentStreamItem uid:_userId];
                    _isReportedBeginToPlay = YES;
                }
                break;
            default:
                break;
        }
        return;
    } else if (context == AVPlayerPlaybackLikelyToKeepUpContext) {
        BOOL isKeepUp = [change[NSKeyValueChangeNewKey] boolValue];
        if (self.delegate && [self.delegate respondsToSelector:@selector(mediaPlayer:didChangeStateFrom:to:)]) {
                if (isKeepUp) {
                    [self.delegate mediaPlayer:self didChangeStateFrom:self.currentPlayState to:AJMediaPlayerStateContentPlaying];
                    self.currentPlayState = AJMediaPlayerStateContentPlaying;
                    [self submitBigdataForPlayerFinishToBlock];
                } else {
                    [self.delegate mediaPlayer:self didChangeStateFrom:self.currentPlayState to:AJMediaPlayerStateContentBuffering];
                    if (self.currentPlayState == AJMediaPlayerStateContentPlaying) {
                        [self submitBigdataForPlayerBeginToBlock];
                    }
                    self.currentPlayState = AJMediaPlayerStateContentBuffering;
                }
        }
        return;
    } else if (context == AVPlayerPlaybackBufferEmptyContext) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(mediaPlayer:didChangeStateFrom:to:)]) {
            [self.delegate mediaPlayer:self didChangeStateFrom:self.currentPlayState to:AJMediaPlayerStateContentLoading];
            self.currentPlayState = AJMediaPlayerStateContentLoading;
        }
        return;
    } else if (context == AVPlayerPlaybackLoadedTimeRangesObservationContext) {
        return;
    } else if (context == AVPlayerPlaybackRateObservationContext) {
        return;
    } else if (context == AVPlayerPlaybackCurrentItemObservationContext) {
        AVPlayerItem *newPlayerItem = change[NSKeyValueChangeNewKey];
        if (newPlayerItem == (id)[NSNull null]) {
        } else {
            [_displayView prepareToDisplay];
        }
        return;
    } else if (context == AVPlayerPlaybackTracksObservationContext) {
        return;
    } else if (context == AVPlayerAirplayVideoActiveContext) {
        NSInteger airPlayStatus = [change[NSKeyValueChangeNewKey] integerValue];
        AJMediaPlayerAirPlayState currentAirPlayState = airPlayStatus? AJMediaPlayerAirPlayActive:AJMediaPlayerAirPlayInActive;
        if (self.delegate && [self.delegate respondsToSelector:@selector(mediaPlayer:didChangeAirPlayState:)]) {
            __weak typeof(self) weakSelf = self;
            dispatch_async(mediaplayer_processing_queue(), ^{
                [weakSelf.delegate mediaPlayer:weakSelf didChangeAirPlayState:currentAirPlayState];
            });
        }
        return;
    } else if (context == AVPlayerPlaybackLoadedErrorObservationContext) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(mediaPlayer:didBecomeInvalidWithError:)]) {
            AVPlayer *player = (AVPlayer *)object;
            NSError *error = [NSError errorWithDomain:AJMediaPlayerErrorDomain code:AJMediaPlayerErrorAVPlayerFail userInfo:player.error.userInfo];
            __weak typeof(self) weakSelf = self;
            dispatch_async(mediaplayer_processing_queue(), ^{
                [weakSelf.delegate mediaPlayer:weakSelf didBecomeInvalidWithError:error];
            });
            self.currentPlayState = AJMediaPlayerStateError;
        }
        return;
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - Player Control Methods

- (void)play {
    if (_currentPlayState != AJMediaPlayerStateError) {
        if (self.videoPlayer) {
            if (_isReportedBeginToPlay) {
                [self submitPlayerStatisticsWithType:PlayActionResume playItem:_currentStreamItem uid:_userId];
            }
            [self.videoPlayer play];
            if (self.delegate && [self.delegate respondsToSelector:@selector(mediaPlayer:didChangeStateFrom:to:)]) {
                [self.delegate mediaPlayer:self didChangeStateFrom:self.currentPlayState to:AJMediaPlayerStateContentPlaying];
                self.currentPlayState = AJMediaPlayerStateContentPlaying;
            }
        }
    }
}

- (void)pause {
    if (_currentPlayState != AJMediaPlayerStateError) {
        if (self.videoPlayer) {
            [self submitPlayerStatisticsWithType:PlayActionPause playItem:_currentStreamItem uid:_userId];
            [self.videoPlayer pause];
            if (self.delegate && [self.delegate respondsToSelector:@selector(mediaPlayer:didChangeStateFrom:to:)]) {
                [self.delegate mediaPlayer:self didChangeStateFrom:self.currentPlayState to:AJMediaPlayerStateContentPaused];
                self.currentPlayState = AJMediaPlayerStateContentPaused;
            }
        }
    }
}

- (void)seekToTime:(NSTimeInterval)time {
    self.currentPlayState = AJMediaPlayerStateContentSeeking;
    NSTimeInterval totalTime = [self currentItemDuration];
    aj_logMessage(AJLoggingInfo, @"%@: seek to time %@ total time %@", self.currentStreamItem, @(time), @(totalTime));
    if (time == -1 || (time > totalTime && time != 0 && totalTime != 0)) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(mediaPlayer:didChangeStateFrom:to:)]) {
            [self.delegate mediaPlayer:self didChangeStateFrom:self.currentPlayState to:AJMediaPlayerStateContentFinished];
            self.currentPlayState = AJMediaPlayerStateContentFinished;
        }
    } else {
        __weak typeof(self) weakSelf = self;
        [self.videoPlayer seekToTimeInSeconds:time completionHandler:^(BOOL finished) {
            if ([weakSelf.delegate respondsToSelector:@selector(mediaPlayer:didChangeStateFrom:to:)]) {
                AJMediaPlayerState currentState = finished ? AJMediaPlayerStateContentPlaying : AJMediaPlayerStateContentBuffering;
                [weakSelf.delegate mediaPlayer:weakSelf didChangeStateFrom:AJMediaPlayerStateContentSeeking to:currentState];
                if (finished) {
                    [weakSelf submitBigdataForPlayerDidSeekToPlay];
                }
            }
        }];
    }
    if (self.currentPlayState == AJMediaPlayerStateContentPaused || self.currentPlayState == AJMediaPlayerStateContentFinished) {
        [self play];
    }
}

#pragma mark - Destory Methods

- (void)invalidate {
    if (self.mediaStreamProvider) {
        [self.mediaStreamProvider cancelTasks];
    }
    if (self.videoPlayer && self.currentPlayerItem) {
        aj_logMessage(AJLoggingInfo, @"%@ is finished or interrupted normally, mediaplayer will be invalidated", self.currentStreamItem);
        [self submitPlayerAnalyticsReporterHeartbeatWithPlayDuration:0.f streamMetadata:_currentStreamItem];
        [self submitPlayerStatisticsWithType:PlayActionDestory playItem:_currentStreamItem uid:_userId];
        [self submitBigdataForPlayerInvalidate];
        [self invalidateAnalyticsHeartbeatTimer];
        [self invalidateStatisticHeartbeatTimer];
        
        [self.videoPlayer setRate:0.f];
        [self removeProgressTimeObserver];
        [self removePlayerObserver];
        [self removePlayItemObserver];
        if (self.videoPlayer) {
            [self.videoPlayer replaceCurrentItemWithPlayerItem:nil];
        }
        self.videoPlayer = nil;
        self.currentPlayerItem = nil;
        [self removeNotificationObservers];
        aj_logMessage(AJLoggingInfo, @"%@ has been finished or interupted normally, mediaplayer has been invalidated", self.currentStreamItem.description);
    }
}

- (void)dealloc
{
    [self invalidate];
}

#pragma mark - 大数据上报
//视频初始化时上报
- (void)submitBigdataForPlayerInit {
    if ([[AJMediaPlayerAnalyticsReporter sharedReporter] shareAppMetadata]) {
        [self submitPlayerAnalyticsReporterInitialize:self.currentStreamItem];
    } else if ([[AJMediaPlayerSDKAnalyticsReporter sharedReporter] shareAppConfiguration]) {
        [self submitPlayerSDKAnalyticsReporterInitialize:self.currentStreamItem];
    }
}
//视频切换码流时上报
- (void)submitBigdataForPlayerSwitchStream {
    if ([[AJMediaPlayerAnalyticsReporter sharedReporter] shareAppMetadata]) {
        [self submitPlayerAnalyticsReporterSwitchStream:self.currentStreamItem];
    } else if ([[AJMediaPlayerSDKAnalyticsReporter sharedReporter] shareAppConfiguration]) {
        [self submitPlayerSDKAnalyticsReporterSwitchStream:self.currentStreamItem];
    }
}

//视频开始播放时上报
- (void)submitBigdataForPlayerBeginToPlay {
    if ([[AJMediaPlayerAnalyticsReporter sharedReporter] shareAppMetadata]) {
        [self submitPlayerAnalyticsReporterBeginToPlay:self.currentStreamItem];
    } else if ([[AJMediaPlayerSDKAnalyticsReporter sharedReporter] shareAppConfiguration]) {
        [self submitPlayerSDKAnalyticsReporterBeginToPlay:self.currentStreamItem];
    }
}

//视频开始拖动时上报
- (void)submitBigdataForPlayerDidSeekToPlay {
    if ([[AJMediaPlayerAnalyticsReporter sharedReporter] shareAppMetadata]) {
        [self submitPlayerAnalyticsReporterDidSeekToPlay:self.currentStreamItem];
    } else if ([[AJMediaPlayerSDKAnalyticsReporter sharedReporter] shareAppConfiguration]) {
        //大数据SDK暂不上报此项目
    }
}

//视频开始卡顿时上报
- (void)submitBigdataForPlayerBeginToBlock {
    if ([[AJMediaPlayerAnalyticsReporter sharedReporter] shareAppMetadata]) {
        [self submitPlayerAnalyticsReporterBeginToBlock:self.currentStreamItem];
    } else if ([[AJMediaPlayerSDKAnalyticsReporter sharedReporter] shareAppConfiguration]) {
        [self submitPlayerSDKAnalyticsReporterBeginToBlock:self.currentStreamItem];
    }
}

//视频结束卡顿时上报
- (void)submitBigdataForPlayerFinishToBlock {
    if ([[AJMediaPlayerAnalyticsReporter sharedReporter] shareAppMetadata]) {
        [self submitPlayerAnalyticsReporterFinishToBlock:self.currentStreamItem];
    } else if ([[AJMediaPlayerSDKAnalyticsReporter sharedReporter] shareAppConfiguration]) {
        [self submitPlayerSDKAnalyticsReporterFinishToBlock:self.currentStreamItem];
    }
}

//视频结束播放时上报
- (void)submitBigdataForPlayerFinishToPlay {
    if ([[AJMediaPlayerAnalyticsReporter sharedReporter] shareAppMetadata]) {
        [self submitPlayerAnalyticsReporterFinishToPlay:self.currentStreamItem];
    } else if ([[AJMediaPlayerSDKAnalyticsReporter sharedReporter] shareAppConfiguration]) {
        [self submitPlayerSDKAnalyticsReporterFinishToPlay:self.currentStreamItem];
    }
}

//视频销毁时上报
- (void)submitBigdataForPlayerInvalidate {
    if ([[AJMediaPlayerAnalyticsReporter sharedReporter] shareAppMetadata]) {
        [self submitPlayerAnalyticsReporterInvalidate:self.currentStreamItem];
    } else if ([[AJMediaPlayerSDKAnalyticsReporter sharedReporter] shareAppConfiguration]) {
        [self submitPlayerSDKAnalyticsReporterInvalidate:self.currentStreamItem];
    }
}


@end
