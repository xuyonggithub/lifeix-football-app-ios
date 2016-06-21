//
//  AJMediaPlayer+Statistics.h
//  Pods
//
//  Created by lixiang on 15/12/24.
//
//

#import "AJMediaPlayer.h"
@class AJMediaPlayerItem;
typedef NS_ENUM(NSInteger, PlayActionType){
    PlayActionStart = 1,
    PlayActionPause = 2,
    PlayActionResume = 3,
    PlayActionEnd = 4,
    PlayActionHeartbeat = 5,
    PlayActionDestory = 6,
};
@interface AJMediaPlayer (Statistics)

- (void)submitPlayerStatisticsWithType:(PlayActionType )type playItem:(AJMediaPlayerItem *)playItem uid:(NSString *)uid;

- (void)startToStatisticHeartBeatTimerWithItem:(AJMediaPlayerItem *)playerItem uid:(NSString *)uid;

- (void)invalidateStatisticHeartbeatTimer;

@end
