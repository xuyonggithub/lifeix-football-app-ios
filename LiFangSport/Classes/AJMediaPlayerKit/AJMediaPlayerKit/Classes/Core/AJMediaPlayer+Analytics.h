//
//  AJMediaPlayer+Analytics.h
//  Pods
//
//  Created by Gang Li on 7/30/15.
//
//

#import "AJMediaPlayer.h"

@class AJMediaPlayerItem;
@interface AJMediaPlayer (Analytics)
//视频初始化时上报
- (void)submitPlayerAnalyticsReporterInitialize:(AJMediaPlayerItem *)metadata;
//视频切换码流时上报
- (void)submitPlayerAnalyticsReporterSwitchStream:(AJMediaPlayerItem *)metadata ;
//视频开始播放时上报
- (void)submitPlayerAnalyticsReporterBeginToPlay:(AJMediaPlayerItem *)metadata;
//视频开始拖动时上报
- (void)submitPlayerAnalyticsReporterDidSeekToPlay:(AJMediaPlayerItem *)metadata;
//视频开始卡顿时上报
- (void)submitPlayerAnalyticsReporterBeginToBlock:(AJMediaPlayerItem *)metadata;
//视频结束卡顿时上报
- (void)submitPlayerAnalyticsReporterFinishToBlock:(AJMediaPlayerItem *)metadata;
//视频结束播放时上报
- (void)submitPlayerAnalyticsReporterFinishToPlay:(AJMediaPlayerItem *)metadata;
//视频销毁时上报
- (void)submitPlayerAnalyticsReporterInvalidate:(AJMediaPlayerItem *)metadata;
//视频开始上报心跳包
- (void)submitPlayerAnalyticsReporterHeartbeatWithPlayDuration:(NSInteger)time streamMetadata:(AJMediaPlayerItem *)metadata;
//视频销毁心跳包计时器
- (void)invalidateAnalyticsHeartbeatTimer;

@end
