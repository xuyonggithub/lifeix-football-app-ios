//
//  AJMediaPlayer+SDKAnalytics.h
//  Pods
//
//  Created by Zhangqibin on 16/1/14.
//
//

#import "AJMediaPlayer.h"
@class AJMediaPlayerItem;

@interface AJMediaPlayer (SDKAnalytics)
//视频初始化时上报
- (void)submitPlayerSDKAnalyticsReporterInitialize:(AJMediaPlayerItem *)metadata;
//视频切换码流时上报
- (void)submitPlayerSDKAnalyticsReporterSwitchStream:(AJMediaPlayerItem *)metadata ;
//视频开始播放时上报
- (void)submitPlayerSDKAnalyticsReporterBeginToPlay:(AJMediaPlayerItem *)metadata;
//视频开始卡顿时上报
- (void)submitPlayerSDKAnalyticsReporterBeginToBlock:(AJMediaPlayerItem *)metadata;
//视频结束卡顿时上报
- (void)submitPlayerSDKAnalyticsReporterFinishToBlock:(AJMediaPlayerItem *)metadata;
//视频结束播放时上报
- (void)submitPlayerSDKAnalyticsReporterFinishToPlay:(AJMediaPlayerItem *)metadata;
//视频销毁时上报
- (void)submitPlayerSDKAnalyticsReporterInvalidate:(AJMediaPlayerItem *)metadata;
//视频开始上报心跳包
- (void)submitPlayerSDKAnalyticsReporterHeartbeatWithPlayDuration:(NSInteger)time streamMetadata:(AJMediaPlayerItem *)metadata;
//视频销毁心跳包计时器
- (void)invalidateSDKAnalyticsHeartbeatTimer;
@end
