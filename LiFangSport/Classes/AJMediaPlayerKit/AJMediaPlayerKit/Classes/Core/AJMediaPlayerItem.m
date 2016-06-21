//
//  AJMediaPlayerItem.m
//  Pods
//
//  Created by Gang Li on 7/7/15.
//
//

#import "AJMediaPlayerItem.h"

/*点播码流*/
AJMediaStreamQualityName * const kAJMediaStreamVODQualityMP4180  =  @"mp4_180";//130+32 kbps 极速
AJMediaStreamQualityName * const kAJMediaStreamVODQualityMP4350  =  @"mp4_350";//230+32 kbps 流畅
AJMediaStreamQualityName * const kAJMediaStreamVODQualityMP4800  =  @"mp4_800";//480+32 kbps 标清
AJMediaStreamQualityName * const kAJMediaStreamVODQualityMP41300  =  @"mp4_1300";//880+32 kbps 高清
AJMediaStreamQualityName * const kAJMediaStreamVODQualityMP4720p  =  @"mp4_720p";//1800+96 kbps 超清
AJMediaStreamQualityName * const kAJMediaStreamVODQualityMP41080p  =  @"mp4_1080p3m";//3000+128 kbps 1080p

/*直播码流*/
AJMediaStreamQualityName * const kAJMediaStreamLiveQualityFLV350  =  @"flv_350";//350 流畅
AJMediaStreamQualityName * const kAJMediaStreamLiveQualityFLV1000  =  @"flv_1000";//800 标清
AJMediaStreamQualityName * const kAJMediaStreamLiveQualityFLV1300  =  @"flv_1300";//1300 高清
AJMediaStreamQualityName * const kAJMediaStreamLiveQualityFLV720p  =  @"flv_720p";//1800 超清
AJMediaStreamQualityName * const kAJMediaStreamLiveQualityFLV1080p  =  @"flv_1080p3m";//3000 1080p

NSString *aj_stringValueForPlayerItemType(AJMediaPlayerItemType type) {
    switch (type) {
        case AJMediaPlayerVODStreamItem:
            return @"VOD";
            break;
        case AJMediaPlayerLiveStreamItem:
            return @"LIVE";
            break;
        case AJMediaPlayerStationStreamItem:
            return @"STATION";
            break;
        default:
            return @"N/A";
            break;
    }
}

@interface AJMediaPlayerItem ()
@end

@implementation AJMediaPlayerItem

-(instancetype)initWithStreamID:(NSString *) identifier type:(AJMediaPlayerItemType) type qualityName:(NSString *) qualityName {
    self = [super init];
    if (self) {
        self.streamID = identifier;
        self.type= type;
        self.qualityName = qualityName;
        self.assignedStreamName = @"";
        self.episodeid = @"";
        self.channelEname = @"";
    }
    return self;
}

-(instancetype)copyWithZone:(NSZone *)zone {
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"PlayerItem: %@ <%@:%@|%@>", self.streamName, aj_stringValueForPlayerItemType(self.type), self.streamID, self.qualityName];
}


@end
