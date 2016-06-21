//
//  AJMediaPlayer+SDKAnalytics.m
//  Pods
//
//  Created by lixiang on 16/1/14.
//
//

#import "AJMediaPlayer+SDKAnalytics.h"
#import "AJMediaPlayerSDKAnalyticsReporter.h"
#import "AJMediaPlayerItem.h"

@implementation AJMediaPlayer (SDKAnalytics)

- (AJMediaPlayerSDKEventDetails *)getAJMediaPlayerSDKEventDetails:(AJMediaPlayerItem *)metadata {
    AJMediaPlayerSDKEventDetails *details = [[AJMediaPlayerSDKEventDetails alloc] init];
    if (metadata.type == AJMediaPlayerLiveStreamItem) {
        details.live_id = metadata.streamID;
        details.type = @"live";
    } else if (metadata.type == AJMediaPlayerVODStreamItem) {
        details.video_id = metadata.streamID;
        details.type = @"video";
    } else if (metadata.type == AJMediaPlayerStationStreamItem) {
        details.station_id = metadata.channelEname;
        details.type = @"station";
    }
    details.progress = [NSString stringWithFormat:@"%f",[self currentPlaybackTime]];
    details.stream = metadata.qualityName;
    details.network_type = [[AJMediaPlayerSDKAnalyticsReporter sharedReporter] getCurrentNetStatus];
    return details;
}

- (void)submitPlayerSDKAnalyticsReporterInitialize:(AJMediaPlayerItem *)metadata {
    [[AJMediaPlayerSDKAnalyticsReporter sharedReporter] reportWillInitialize:[self getAJMediaPlayerSDKEventDetails:metadata]];
}

- (void)submitPlayerSDKAnalyticsReporterSwitchStream:(AJMediaPlayerItem *)metadata {
    [[AJMediaPlayerSDKAnalyticsReporter sharedReporter] reportPlayerDidToggleSwitchStreamQualityWithDetails:[self getAJMediaPlayerSDKEventDetails:metadata]];
}

- (void)submitPlayerSDKAnalyticsReporterBeginToPlay:(AJMediaPlayerItem *)metadata {
    [self startToSDKHeartBeatTimer];
    [[AJMediaPlayerSDKAnalyticsReporter sharedReporter] reportPlayerDidBeginToPlayWithDetails:[self getAJMediaPlayerSDKEventDetails:metadata]];
}

- (void)submitPlayerSDKAnalyticsReporterBeginToBlock:(AJMediaPlayerItem *)metadata {
    [[AJMediaPlayerSDKAnalyticsReporter sharedReporter] reportPlayerDidBecomeBlockedWithDetails:[self getAJMediaPlayerSDKEventDetails:metadata]];
}

- (void)submitPlayerSDKAnalyticsReporterFinishToBlock:(AJMediaPlayerItem *)metadata {
    [[AJMediaPlayerSDKAnalyticsReporter sharedReporter] reportPlayerDidFinishBlockedWithDetails:[self getAJMediaPlayerSDKEventDetails:metadata]];
}

- (void)submitPlayerSDKAnalyticsReporterFinishToPlay:(AJMediaPlayerItem *)metadata {
    [[AJMediaPlayerSDKAnalyticsReporter sharedReporter] reportPlayerDidFinishPlayWithDetails:[self getAJMediaPlayerSDKEventDetails:metadata]];
}

- (void)submitPlayerSDKAnalyticsReporterInvalidate:(AJMediaPlayerItem *)metadata {
    [[AJMediaPlayerSDKAnalyticsReporter sharedReporter] reportPlayerDidInterruptWithDetails:[self getAJMediaPlayerSDKEventDetails:metadata]];
}

- (void)startToSDKHeartBeatTimer {
    if (self.fifteenSecondsTimer) {
        [self.fifteenSecondsTimer invalidate];
        self.fifteenSecondsTimer = nil;
    }
    NSTimeInterval timeInterval = 15.0 ;
    self.fifteenSecondsTimer = [NSTimer scheduledTimerWithTimeInterval:timeInterval
                                                                target:self
                                                              selector:@selector(fifteenSecondsSDKTimerTo)
                                                              userInfo:nil
                                                               repeats: NO];
    [[NSRunLoop currentRunLoop] addTimer:self.fifteenSecondsTimer forMode:NSRunLoopCommonModes];
}

- (void)fifteenSecondsSDKTimerTo {
    [self submitPlayerSDKAnalyticsReporterHeartbeatWithPlayDuration:15 streamMetadata:self.currentStreamItem];
    if (self.oneMinuteTimer) {
        [self.oneMinuteTimer invalidate];
        self.oneMinuteTimer = nil;
    }
    NSTimeInterval timeInterval = 60.0 ;
    self.oneMinuteTimer = [NSTimer scheduledTimerWithTimeInterval:timeInterval
                                                           target:self
                                                         selector:@selector(oneMinuteSDKTimerTo)
                                                         userInfo:nil
                                                          repeats: NO];
    [[NSRunLoop currentRunLoop] addTimer:self.oneMinuteTimer forMode:NSRunLoopCommonModes];
}

- (void)oneMinuteSDKTimerTo {
    [self submitPlayerSDKAnalyticsReporterHeartbeatWithPlayDuration:60 streamMetadata:self.currentStreamItem];
    if (self.threeMinuteTimer) {
        [self.threeMinuteTimer invalidate];
        self.threeMinuteTimer = nil;
    }
    NSTimeInterval timeInterval = 180.0 ;
    self.threeMinuteTimer = [NSTimer scheduledTimerWithTimeInterval:timeInterval
                                                             target:self
                                                           selector:@selector(threeMinuteTimerSDKTo)
                                                           userInfo:nil
                                                            repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.threeMinuteTimer forMode:NSRunLoopCommonModes];
}

- (void)threeMinuteTimerSDKTo {
    [self submitPlayerSDKAnalyticsReporterHeartbeatWithPlayDuration:180 streamMetadata:self.currentStreamItem];
}

- (void)submitPlayerSDKAnalyticsReporterHeartbeatWithPlayDuration:(NSInteger)time streamMetadata:(AJMediaPlayerItem *)metadata {
    if (time > 0) {
        [[AJMediaPlayerSDKAnalyticsReporter sharedReporter] reportPlayerDidFireHeartbeatWithPlayDuration:time details:[self getAJMediaPlayerSDKEventDetails:metadata]];
    }
}

- (void)invalidateSDKAnalyticsHeartbeatTimer {
    if (self.fifteenSecondsTimer) {
        [self.fifteenSecondsTimer invalidate];
        self.fifteenSecondsTimer = nil;
    }
    if (self.oneMinuteTimer) {
        [self.oneMinuteTimer invalidate];
        self.oneMinuteTimer = nil;
    }
    if (self.threeMinuteTimer) {
        [self.threeMinuteTimer invalidate];
        self.threeMinuteTimer = nil;
    }
}

@end
