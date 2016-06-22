//
//  AJMediaPlayerAnalyticsEventReporter.m
//  Pods
//
//  Created by Zhangqibin on 15/7/16.
//
//

#import "AJMediaPlayerAnalyticsEventReporter.h"
#import "AJMediaPlayerHeaders.h"
#import "AJMediaPlayRequest.h"

static NSArray *__mediaplayerAnalyticsEventDescriptors;

@implementation AJMediaPlayerAnalyticsEventReporter

+ (void)initialize
{
    static dispatch_once_t onceToken;
   
    dispatch_once(&onceToken, ^{
        NSString *metadataPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"mediaplayer_analytics_events" ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:metadataPath options:NSDataReadingMapped error:nil];
        __mediaplayerAnalyticsEventDescriptors = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    });
}

#pragma mark - MTA Statistic Method

+ (NSString *)eventNameWithIdentifier:(NSString *)identifier
{
    NSArray<NSDictionary<NSString *, NSString *> *> * that = [__mediaplayerAnalyticsEventDescriptors filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"identifier == %@", identifier]];
    NSParameterAssert(that && (that.count == 1 || that.count == 0));
    NSString *name = that.firstObject[@"name"];
    return name;
}

+ (void)submitLoadToPlayEvent:(AJMediaPlayRequest *)playRequest
{
    if (playRequest) {
//        NSString *eventName = [[self class] eventNameWithIdentifier:@"mediaplayer::begin-loading"];
//        NSParameterAssert(eventName);
//        ORAnalyticsEvent *event = [ORAnalyticsEvent eventWithName:eventName identifier:@"mediaplayer::begin_loading" parameters:@{@"id":playRequest.identifier?playRequest.identifier:@"",@"vtype":(playRequest.type==AJMediaPlayerVODStreamItem?@"vod":@"live"),@"name":playRequest.resourceName?playRequest.resourceName:@""}];
//        [ORAnalytics submitEvent:event];
    }
}

+ (void)submitLoadToLivePlayEvent:(AJMediaPlayRequest *)playRequest
{
    if (playRequest) {
//        NSString *eventName = [[self class] eventNameWithIdentifier:@"mediaplayer::begin_live_loading"];
//        ORAnalyticsEvent *event = [ORAnalyticsEvent eventWithName:eventName identifier:@"mediaplayer::begin_live_loading" parameters:@{@"id":playRequest.identifier?playRequest.identifier:@"",@"name":playRequest.resourceName?playRequest.resourceName:@""}];
//        [ORAnalytics submitEvent:event];
    }
}

+ (void)submitLoadToVodPlayEvent:(AJMediaPlayRequest *)playRequest
{
    if (playRequest) {
//        NSString *eventName = [[self class] eventNameWithIdentifier:@"mediaplayer::begin_vod_loading"];
//        ORAnalyticsEvent *event = [ORAnalyticsEvent eventWithName:eventName identifier:@"mediaplayer::begin_vod_loading" parameters:@{@"id":playRequest.identifier?playRequest.identifier:@"",@"name":playRequest.resourceName?playRequest.resourceName:@""}];
//        [ORAnalytics submitEvent:event];
    }
}

+ (void)submitLoadToStationPlayEvent:(AJMediaPlayRequest *)playRequest
{
    if (playRequest) {
//        NSString *eventName = [[self class] eventNameWithIdentifier:@"mediaplayer::begin_station_loading"];
//        ORAnalyticsEvent *event = [ORAnalyticsEvent eventWithName:eventName identifier:@"mediaplayer::begin_station_loading" parameters:@{@"id":playRequest.identifier?playRequest.identifier:@"",@"name":playRequest.resourceName?playRequest.resourceName:@""}];
//        [ORAnalytics submitEvent:event];
    }
}

+ (void)submitPlayFirstFrameEvent:(AJMediaPlayRequest *)playRequest
{
    if (playRequest) {
//        NSString *eventName = [[self class] eventNameWithIdentifier:@"mediaplayer::finished-loading"];
//        ORAnalyticsEvent *event = [ORAnalyticsEvent eventWithName:eventName identifier:@"mediaplayer::finished-loading" parameters:@{@"id":playRequest.identifier?playRequest.identifier:@"", @"vtype" : (playRequest.type == AJMediaPlayerVODStreamItem?@"vod":@"live"),@"name":playRequest.resourceName?playRequest.resourceName:@""}];
//        [ORAnalytics submitEvent:event];
    }
}

+ (void)submitRequestUrlErrorEvent:(NSString *)errorEvent withErrorCode:(NSString *)errorCode
{
    if (errorEvent) {
//        NSString *eventName = [[self class] eventNameWithIdentifier:@"mediaplayer::received-error"];
//        ORAnalyticsEvent *currentVideoloadingEvent = [ORAnalyticsEvent eventWithName:eventName identifier:@"mediaplayer::received-error" parameters:@{@"error":errorEvent?errorEvent:@"",@"code":errorCode?errorCode:@""}];
//        [ORAnalytics submitEvent:currentVideoloadingEvent];
    }
}

+ (void)recordCancelPlayEventStartTime
{
    [[AJMediaRecordTimeHelper sharedInstance] recordStartTimeWithKey:@"play_back_time"];
}

+ (void)submitCancelPlayEvent:(AJMediaPlayRequest *)playRequest
{
    NSInteger timeInterval = [[AJMediaRecordTimeHelper sharedInstance] getRecordEndTimeWithKey:@"play_back_time"];
    if (timeInterval > 0) {
//        NSString *eventName = [[self class] eventNameWithIdentifier:@"mediaplayer::cancelled-loading-manually"];
//        NSString *waiting_time = [NSString stringWithFormat:@"%ld",(long)timeInterval];
//        ORAnalyticsEvent *event = [ORAnalyticsEvent eventWithName:eventName identifier:@"mediaplayer::cancelled-loading-manually" parameters:@{@"waiting_time":waiting_time?waiting_time:@"",@"is_live":(playRequest.type == AJMediaPlayerVODStreamItem?@"true":@"false")}];
//        [ORAnalytics submitEvent:event];
    }
}

+ (void)submitBulletInputEvent:(AJMediaPlayRequest *)playRequest
{
    if (playRequest) {
//        ORAnalyticsEvent *event = [ORAnalyticsEvent eventWithIdentifier:@"iosapp.match_detail_tap_input_barrage" parameters:@{@"matchid":playRequest.episodeid ?: @"", @"userId":playRequest.uid ?: @""}];
//        [ORAnalytics submitEvent:event];
    }
}

@end
