//
//  AJMediaPlayerItem.h
//  Pods
//
//  Created by Gang Li on 7/7/15.
//
//

@import Foundation;
@import AVFoundation;

@compatibility_alias AJMediaStreamQualityName NSString;

typedef NS_ENUM(NSUInteger, AJMediaPlayerItemType) {
    AJMediaPlayerVODStreamItem = 1001,  //点播
    AJMediaPlayerLiveStreamItem,        //直播
    AJMediaPlayerStationStreamItem,     //轮播台
};

NS_ASSUME_NONNULL_BEGIN

extern NSString * aj_stringValueForPlayerItemType(AJMediaPlayerItemType type);

extern AJMediaStreamQualityName * const kAJMediaStreamVODQualityMP4180;
extern AJMediaStreamQualityName * const kAJMediaStreamVODQualityMP4350;
extern AJMediaStreamQualityName * const kAJMediaStreamVODQualityMP4800;
extern AJMediaStreamQualityName * const kAJMediaStreamVODQualityMP41300;
extern AJMediaStreamQualityName * const kAJMediaStreamVODQualityMP4720p;
extern AJMediaStreamQualityName * const kAJMediaStreamVODQualityMP41080p;

extern AJMediaStreamQualityName * const kAJMediaStreamLiveQualityFLV350;
extern AJMediaStreamQualityName * const kAJMediaStreamLiveQualityFLV1000;
extern AJMediaStreamQualityName * const kAJMediaStreamLiveQualityFLV1300;
extern AJMediaStreamQualityName * const kAJMediaStreamLiveQualityFLV720p;
extern AJMediaStreamQualityName * const kAJMediaStreamLiveQualityFLV1080p;

@interface AJMediaPlayerItem : NSObject <NSCopying>
@property(nonatomic, copy) NSString *assignedStreamName;
@property(nonatomic, copy) NSString *episodeid;
@property(nonatomic, copy) NSString *channelEname;
@property(nonatomic, copy) NSString *streamName;
@property(nonatomic, copy) NSString *streamID;
@property(nonatomic, copy) NSArray *schedulingStreamURLs;
@property(nonatomic, assign) AJMediaPlayerItemType type;
@property(nonatomic, copy) AJMediaStreamQualityName *qualityName;
@property(nonatomic, assign, setter=setPlayable:) BOOL isPlayable;
@property(nonatomic, copy) NSString *preferredSchedulingStreamURL;
@property(nonatomic, copy) NSDate *liveStartTime;

- (instancetype)initWithStreamID:(NSString *)identifier
                            type:(AJMediaPlayerItemType) type
                     qualityName:(AJMediaStreamQualityName *) qualityName;

@end

NS_ASSUME_NONNULL_END
