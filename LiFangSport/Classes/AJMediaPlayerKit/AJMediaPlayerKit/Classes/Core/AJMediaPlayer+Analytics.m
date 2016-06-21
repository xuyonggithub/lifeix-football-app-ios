//
//  AJMediaPlayer+Analytics.m
//  Pods
//
//  Created by Gang Li on 7/30/15.
//
//

#import "AJMediaPlayer+Analytics.h"
#import "AJMediaPlayerAnalyticsReporter.h"
#import "AJMediaRecordTimeHelper.h"
#import "AJMediaPlayerInfrastructureContext_Internal.h"
#import "AJMediaPlayerItem.h"
#import "AJFoundation.h"
//#import <SSKeychain.h>

@implementation AJMediaPlayer (Analytics)

- (AJMediaPlayerEventDetails *)getAJMediaPlayerEventDetails:(AJMediaPlayerItem *)metadata{
    AJMediaPlayerEventDetails *details = [[AJMediaPlayerEventDetails alloc] init];
    details.uid = self.uid;
    NSString *strUUID = @"test";
//    NSString *strUUID = [SSKeychain passwordForService:[[NSBundle mainBundle] infoDictionary][@"CFBundleIdentifier"] account:@"uuid"];
//    if (!strUUID || 1 > strUUID.length) {
//        NSUUID *uuid = [NSUUID UUID];
//        NSString *keyChainUUID = [uuid UUIDString];
//        [SSKeychain setPassword:keyChainUUID forService:[[NSBundle mainBundle] infoDictionary][@"CFBundleIdentifier"] account:@"uuid"];
//        strUUID = keyChainUUID;
//    }
//    if (strUUID) {
//        strUUID = [strUUID stringByReplacingOccurrencesOfString:@"-" withString:@""];
//    }
//    details.auid = strUUID;
    
    if (metadata.type == AJMediaPlayerLiveStreamItem) {
        details.lid = metadata.streamID;
        details.episodeid = metadata.episodeid;
    } else if (metadata.type == AJMediaPlayerVODStreamItem) {
        details.vid = metadata.streamID;
    } else if (metadata.type == AJMediaPlayerStationStreamItem) {
        details.st = metadata.channelEname;
    }
    
    NSString *uuid  = [NSString stringWithFormat:@"%@_%@",self.currentUUID, @(self.changeStreamCount)];
    details.uuid = uuid;

    if (![AJMediaRecordTimeHelper sharedInstance].appRunId) {
        [AJMediaRecordTimeHelper sharedInstance].appRunId = [@([[NSDate date] timeIntervalSince1970]) stringValue];
    }
    details.apprunid = [NSString stringWithFormat:@"%@_%@",strUUID,[AJMediaRecordTimeHelper sharedInstance].appRunId];
    
    if (metadata.type == AJMediaPlayerLiveStreamItem) {
        details.ty = 1;
    } else if (metadata.type == AJMediaPlayerStationStreamItem) {
        details.ty = 2;
    } else {
        details.ty = 0;
    }
    
    details.vt = [self getVideoType:metadata];
    
    AJCloudService *cloudService =  [AJMediaPlayerInfrastructureContext cloudService];
    NSString *currentPlayCdeUrl = cloudService.currentPlayURL;
    if (currentPlayCdeUrl && currentPlayCdeUrl.length > 0) {
        NSString * encodingString = [currentPlayCdeUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        details.url = encodingString;
    }
    
    details.pv = @"1.0.0";

    if (self.uid && self.uid.length > 0) {
        details.ilu = 0;
    } else {
        details.ilu = 1;
    }
    //乐视体育公司下的客户端该参数写死为4
    details.cid = 4;
    
    details.prg = [NSString stringWithFormat:@"%f",[self currentPlaybackTime]];
    
    details.nt = [[AJMediaPlayerAnalyticsReporter sharedReporter] getCurrentNetStatus];
    
    details.prl = 0;
    
    details.ctime = (long)[[NSDate date] timeIntervalSince1970] * 1000;
    
    details.ipt = self.ipt;
    
    int x = arc4random() % 100000;
    details.r = [NSString stringWithFormat:@"%d",x];
    
    details.ver = @"3.0";
    
    if (metadata.type == AJMediaPlayerLiveStreamItem || metadata.type == AJMediaPlayerStationStreamItem) {
        details.vlen = 6000;
    } else{
        double duration = [self currentItemDuration];
        details.vlen = duration != -1 ? duration : 6000;
    }
    return details;
}

- (NSString *)getVideoType:(AJMediaPlayerItem *)metadata {
    NSString *vt = @"";
    NSString *streamType;
    if (metadata && metadata.qualityName) {
        streamType = metadata.qualityName;
    }
    if (metadata.type == AJMediaPlayerVODStreamItem) {
        if (streamType && [streamType isEqualToString:@"mp4_800"]) {
            return @"13";
        }
        if (streamType && [streamType isEqualToString:@"mp4_180"]) {
            return @"58";
        }
        if (streamType && [streamType isEqualToString:@"mp4_350"]) {
            return @"21";
        }
        if (streamType && [streamType isEqualToString:@"mp4_1300"]) {
            return @"22";
        }
        if (streamType && [streamType isEqualToString:@"mp4_720p"]) {
            return @"51";
        }
        if (streamType && [streamType isEqualToString:@"mp4_1080p3m"]) {
            return @"52";
        }
    } else {
        return streamType;
    }
    return vt;
}

- (void)submitPlayerAnalyticsReporterInitialize:(AJMediaPlayerItem *)metadata {
    AJMediaPlayerEventDetails *details = [self getAJMediaPlayerEventDetails:metadata];
    details.cdev = [NSString stringWithFormat:@"%d",[AJMediaPlayerInfrastructureContext cdeVersionNumber]];
    details.caid = [AJMediaPlayerInfrastructureContext applicationIdentifier];
    [[AJMediaPlayerAnalyticsReporter sharedReporter] playerWillInitializeWithDetails:details];
}

- (void)submitPlayerAnalyticsReporterSwitchStream:(AJMediaPlayerItem *)metadata {
    AJMediaPlayerEventDetails *details = [self getAJMediaPlayerEventDetails:metadata];
    [[AJMediaPlayerAnalyticsReporter sharedReporter] playerDidToggleSwitchStreamQualityWithDetails:details];
}

- (void)submitPlayerAnalyticsReporterBeginToPlay:(AJMediaPlayerItem *)metadata {
    [self startToHeartBeatTimer];
    
    AJMediaPlayerEventDetails *details = [self getAJMediaPlayerEventDetails:metadata];
    details.joint = 0;
    details.pay = 0;
    
    NSNumber *requestUrlTime = [[NSUserDefaults standardUserDefaults] objectForKey:@"AJMediaPlayer_RequestUrlTime"];
    NSInteger currentPlayUrlTime = [requestUrlTime integerValue]; //t6 获取正式播放地址时长=>从请求调用真实播放开始到接口数据返回的时间
    NSInteger currentPlayLoadingTime = [[AJMediaRecordTimeHelper sharedInstance] getRecordEndTimeWithKey:@"get_play_url"];//t8 视频加载时长=>拿到url播放地址到第一帧画面出现的时长
    NSInteger currentPlayTime = [[AJMediaRecordTimeHelper sharedInstance] getRecordEndTimeWithKey:@"cde_end_play"];//t9 正片加载时长=>拿到正片最终播放地址到出现正片第一帧画面的时长
    NSString *stc = [NSString stringWithFormat:@"t6=%ld&t8=%ld&t9=%ld",(long)currentPlayUrlTime,(long)currentPlayLoadingTime,(long)currentPlayTime];
    details.stc = stc;
    [[AJMediaPlayerAnalyticsReporter sharedReporter] playerDidBeginToPlayWithDetails:details];
}

- (void)submitPlayerAnalyticsReporterDidSeekToPlay:(AJMediaPlayerItem *)metadata {
    AJMediaPlayerEventDetails *details = [self getAJMediaPlayerEventDetails:metadata];
    [[AJMediaPlayerAnalyticsReporter sharedReporter] playerDidFinishSeekWithDetails:details];
}

- (void)submitPlayerAnalyticsReporterBeginToBlock:(AJMediaPlayerItem *)metadata {
    AJMediaPlayerEventDetails *details = [self getAJMediaPlayerEventDetails:metadata];
    [[AJMediaPlayerAnalyticsReporter sharedReporter] playerDidBecomeBlockedWithDetails:details];
}

- (void)submitPlayerAnalyticsReporterFinishToBlock:(AJMediaPlayerItem *)metadata {
    AJMediaPlayerEventDetails *details = [self getAJMediaPlayerEventDetails:metadata];
    [[AJMediaPlayerAnalyticsReporter sharedReporter] playerDidFinishBlockedWithDetails:details];
}

- (void)submitPlayerAnalyticsReporterFinishToPlay:(AJMediaPlayerItem *)metadata {
    AJMediaPlayerEventDetails *details = [self getAJMediaPlayerEventDetails:metadata];
    [[AJMediaPlayerAnalyticsReporter sharedReporter] playerDidFinishPlayWithDetails:details];
}

- (void)submitPlayerAnalyticsReporterInvalidate:(AJMediaPlayerItem *)metadata {
    AJMediaPlayerEventDetails *details = [self getAJMediaPlayerEventDetails:metadata];
    [[AJMediaPlayerAnalyticsReporter sharedReporter] playerDidInterruptWithDetails:details];
}

- (void)startToHeartBeatTimer {
    if (self.fifteenSecondsTimer) {
        [self.fifteenSecondsTimer invalidate];
        self.fifteenSecondsTimer = nil;
    }
    
    NSTimeInterval timeInterval = 15.0 ;
    self.fifteenSecondsTimer = [NSTimer scheduledTimerWithTimeInterval:timeInterval
                                                                target:self
                                                              selector:@selector(fifteenSecondsTimerTo)
                                                              userInfo:nil
                                                               repeats: NO];
    [[NSRunLoop currentRunLoop] addTimer:self.fifteenSecondsTimer forMode:NSRunLoopCommonModes];
}

- (void)fifteenSecondsTimerTo {
    [self submitPlayerAnalyticsReporterHeartbeatWithPlayDuration:15 streamMetadata:self.currentStreamItem];
    if (self.oneMinuteTimer) {
        [self.oneMinuteTimer invalidate];
        self.oneMinuteTimer = nil;
    }
    NSTimeInterval timeInterval = 60.0 ;
    self.oneMinuteTimer = [NSTimer scheduledTimerWithTimeInterval:timeInterval
                                                           target:self
                                                         selector:@selector(oneMinuteTimerTo)
                                                         userInfo:nil
                                                          repeats: NO];
    [[NSRunLoop currentRunLoop] addTimer:self.oneMinuteTimer forMode:NSRunLoopCommonModes];
}

- (void)oneMinuteTimerTo {
    [self submitPlayerAnalyticsReporterHeartbeatWithPlayDuration:60 streamMetadata:self.currentStreamItem];
    if (self.threeMinuteTimer) {
        [self.threeMinuteTimer invalidate];
        self.threeMinuteTimer = nil;
    }
    NSTimeInterval timeInterval = 180.0 ;
    self.threeMinuteTimer = [NSTimer scheduledTimerWithTimeInterval:timeInterval
                                                             target:self
                                                           selector:@selector(threeMinuteTimerTo)
                                                           userInfo:nil
                                                            repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.threeMinuteTimer forMode:NSRunLoopCommonModes];
}

- (void)threeMinuteTimerTo {
    [self submitPlayerAnalyticsReporterHeartbeatWithPlayDuration:180 streamMetadata:self.currentStreamItem];
}

- (void)submitPlayerAnalyticsReporterHeartbeatWithPlayDuration:(NSInteger)time streamMetadata:(AJMediaPlayerItem *)metadata{
    AJMediaPlayerEventDetails *duration_details = [self getAJMediaPlayerEventDetails:metadata];
    if (time > 0) {
        duration_details.pt = time;
        [[AJMediaPlayerAnalyticsReporter sharedReporter] playerDidFireHeartbeatWithPlayDuration:[self currentPlaybackTime] details:duration_details];
    }
}

- (void)invalidateAnalyticsHeartbeatTimer {
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
