//
//  AJMediaPlayer+Statistics.m
//  Pods
//
//  Created by Zhangqibin on 15/12/24.
//
//

#import "AJMediaPlayer+Statistics.h"
#import "AJMediaPlayerItem.h"

#define StatisticsForRelease @"http://u.api.com/user/v1/actions/play?"
#define StatisticsForDebug @"http://staging.u.api.com/user/v1/actions/play?"

#define LESPORT_BUNDLENAME @"com."
#define LESPORT_HD_BUNDLENAME @"com."

@implementation AJMediaPlayer (Statistics)

- (void)submitPlayerStatisticsWithType:(PlayActionType )type playItem:(AJMediaPlayerItem *)playItem uid:(NSString *)uid {
    NSInteger caller = 0;
    NSString *actionCode = @"";
    NSString *bundleId = [[NSBundle mainBundle] infoDictionary][@"CFBundleIdentifier"];
    if ([bundleId isEqualToString:LESPORT_BUNDLENAME]) {
        caller = 1003;
        actionCode = @"vplay_mobile_ios";
    } else if ([bundleId isEqualToString:LESPORT_HD_BUNDLENAME]) {
        caller = 1014;
        actionCode = @"vplay_ipad";
    }
    if (playItem.streamID && playItem.type && uid.length > 0 && caller > 0 && actionCode.length>0) {
        NSString *paramString = [NSString stringWithFormat:@"caller=%ld&id=%@&isLive=%@&type=%ld&uid=%@&_method=%@&actionCode=%@",(long)caller,playItem.streamID,playItem.type==AJMediaPlayerVODStreamItem?@"false":@"true",(long)type,uid,@"POST",actionCode];
        NSString *urlString = [NSString stringWithFormat:@"%@%@",StatisticsForRelease,paramString];
        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10.0f];
        [urlRequest setHTTPMethod:@"GET"];
        NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (!error) {
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                if ([httpResponse statusCode] == 200) {
                }
            }
        }];
        [dataTask resume];
    }
}

- (void)startToStatisticHeartBeatTimerWithItem:(AJMediaPlayerItem *)playerItem uid:(NSString *)uid {
    NSInteger caller = 0;
    NSString *bundleId = [[NSBundle mainBundle] infoDictionary][@"CFBundleIdentifier"];
    if ([bundleId isEqualToString:LESPORT_BUNDLENAME]) {
        caller = 1003;
    } else if ([bundleId isEqualToString:LESPORT_HD_BUNDLENAME]) {
        caller = 1014;
    }
    if (playerItem.streamID && playerItem.type && uid.length > 0 && caller > 0)  {
        if (self.fiveMinuteTimer) {
            [self.fiveMinuteTimer invalidate];
            self.fiveMinuteTimer = nil;
        }
        NSTimeInterval timeInterval = 300.0;
        NSDictionary *userInfo = @{@"playItem":playerItem,@"uid":uid};
        self.fiveMinuteTimer = [NSTimer scheduledTimerWithTimeInterval:timeInterval
                                                                target:self
                                                              selector:@selector(fiveMinuteTimerTo:)
                                                              userInfo:userInfo
                                                               repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.fiveMinuteTimer forMode:NSRunLoopCommonModes];
    }
}

- (void)fiveMinuteTimerTo:(NSTimer *)timer {
    if ([timer userInfo]) {
        AJMediaPlayerItem *playItem = [[timer userInfo] valueForKey:@"playItem"];
        NSString *uid = [[timer userInfo] valueForKey:@"uid"];
        [self submitPlayerStatisticsWithType:PlayActionHeartbeat playItem:playItem uid:uid];
    }
}

- (void)invalidateStatisticHeartbeatTimer {
    if (self.fiveMinuteTimer) {
        [self.fiveMinuteTimer invalidate];
        self.fiveMinuteTimer = nil;
    }
}

@end
