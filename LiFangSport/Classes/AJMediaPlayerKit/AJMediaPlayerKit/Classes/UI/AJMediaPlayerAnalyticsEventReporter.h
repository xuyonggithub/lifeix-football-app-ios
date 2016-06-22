//
//  AJMediaPlayerAnalyticsEventReporter.h
//  Pods
//
//  Created by Zhangqibin on 15/7/16.
//
//

@import Foundation;
@class AJMediaPlayRequest;
@interface AJMediaPlayerAnalyticsEventReporter : NSObject

#pragma mark - ORAnalytics Reporting Wrapper Method
/**
 *  上报MTA中 开始播放事件（airjordanpalyer.load）
 *
 *  @param playInfo 播放元数据信息
 */
+ (void)submitLoadToPlayEvent:(AJMediaPlayRequest *)playRequest;

+ (void)submitLoadToLivePlayEvent:(AJMediaPlayRequest *)playRequest;
+ (void)submitLoadToVodPlayEvent:(AJMediaPlayRequest *)playRequest;
+ (void)submitLoadToStationPlayEvent:(AJMediaPlayRequest *)playRequest;

/**
 *  上报MTA中 播放成功事件（airjordanpalyer.play_first_frame）
 *
 *  @param playInfo 播放元数据信息
 */
+ (void)submitPlayFirstFrameEvent:(AJMediaPlayRequest *)playRequest;
/**
 *  上报MTA中 播放地址请求失败事件（airjordanplayer.request_play_url_error）
 *
 *  @param errorEvent    错误类型
 *  @param errorCode     请求错误码
 */
+ (void)submitRequestUrlErrorEvent:(NSString *)errorEvent withErrorCode:(NSString *)errorCode;
/**
 *  上报MTA中 播放器未播放第一帧，取消播放视频事件，开始统计起播时间戳方法
 */
+ (void)recordCancelPlayEventStartTime;
/**
 *  上报MTA中 播放器未播放第一帧，取消播放视频事件（airjordanpalyer.cancel_play）并统计时间间隔
 */
+ (void)submitCancelPlayEvent:(AJMediaPlayRequest *)playRequest;
/**
 *  上报MTA中 用户点击弹幕编辑按钮
 */
+ (void)submitBulletInputEvent:(AJMediaPlayRequest *)playRequest;
@end
