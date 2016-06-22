//
//  AJMediaStreamSchedulingMetadata.m
//  Pods
//
//  Created by Zhangqibin on 5/22/15.
//
//

#import "AJMediaStreamSchedulingMetadata.h"
#import "AJMediaPlayerUtilities.h"
#import "AJMediaPlayerInfrastructureContext.h"
@implementation AJMediaStreamSchedulingMetadata

-(void)setResourceID:(NSString *)resourceID {
    _resourceID = resourceID;
    [self refreshStreamItems];
}

-(void)setResourceName:(NSString *)resourceName {
    _resourceName = resourceName;
    [self refreshStreamItems];
}

- (void)setEpisodeid:(NSString *)episodeid {
    _episodeid = episodeid;
    [self refreshStreamItems];
}

- (void)setChannelEname:(NSString *)channelEname {
    _channelEname = channelEname;
    [self refreshStreamItems];
}

-(void)setType:(AJMediaPlayerItemType)type {
    _type = type;
    [self refreshStreamItems];
}

- (void)setLiveStartTime:(NSString *)liveStartTime {
    _liveStartTime = liveStartTime;
    [self refreshStreamItems];
}

-(void)refreshStreamItems {
    if (self.availableQualifiedStreamItems) {
        [self.availableQualifiedStreamItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            AJMediaPlayerItem *item = obj;
            item.streamName = _resourceName;
            item.streamID = _resourceID;
            item.episodeid = _episodeid;
            item.channelEname = _channelEname;
            item.type = _type;
            item.liveStartTime = [NSDate dateFromString:_liveStartTime timeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
        }];
    }
}

@end

@implementation AJMediaLiveStreamMetadataParser

static NSDictionary *aj_live_quality_name_weight_map;

+(void)initialize {
    aj_live_quality_name_weight_map = @{
                       kAJMediaStreamLiveQualityFLV350 : @(350),
                       kAJMediaStreamLiveQualityFLV1000 : @(1000),
                       kAJMediaStreamLiveQualityFLV1300 : @(1300),
                       kAJMediaStreamLiveQualityFLV720p : @(1800),
                       kAJMediaStreamLiveQualityFLV1080p : @(3000)
                       };
}

+(instancetype)parser {
    return [[[self class] alloc] init];
}

-(AJMediaStreamSchedulingMetadata *)parseMetadata:(NSDictionary *)jsonObject {
    AJMediaStreamSchedulingMetadata *metadata = [[AJMediaStreamSchedulingMetadata alloc] init];
    metadata.type = AJMediaPlayerLiveStreamItem;
    metadata.status = [jsonObject[@"status"] integerValue];
    metadata.liveStartTime = jsonObject[@"liveStartTime"];
    
    NSMutableArray *schedulingItems = [NSMutableArray array];
    [jsonObject[@"infos"] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        AJMediaPlayerItem *metadataItem = [[AJMediaPlayerItem alloc] init];
        metadataItem.qualityName = key;
        metadataItem.isPlayable = [obj[@"code"] integerValue];
        metadataItem.schedulingStreamURLs = [NSMutableArray arrayWithObject:obj[@"url"]];
        if (metadataItem.schedulingStreamURLs.count > 0) {
            metadataItem.preferredSchedulingStreamURL = metadataItem.schedulingStreamURLs[0];
        }
        [schedulingItems addObject:metadataItem];
    }];
    NSMutableArray *sortedArray = [NSMutableArray arrayWithArray:schedulingItems];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"qualityName" ascending:NO comparator:^NSComparisonResult(id obj1, id obj2) {
        if ([aj_live_quality_name_weight_map[obj1] integerValue] < [aj_live_quality_name_weight_map[obj2] integerValue]) {
            return NSOrderedAscending;
        } else if ([aj_live_quality_name_weight_map[obj1] integerValue] > [aj_live_quality_name_weight_map[obj2] integerValue]) {
            return NSOrderedDescending;
        } else {
            return NSOrderedSame;
        }
    }];
    [sortedArray sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    metadata.availableQualifiedStreamItems = sortedArray;
    return metadata;
}

@end

@implementation AJMediaVODStreamMetadataParser

static NSDictionary *aj_vod_quality_name_weight_map;

+(void)initialize {
    aj_vod_quality_name_weight_map = @{
                                       kAJMediaStreamVODQualityMP4180 : @(180),
                                       kAJMediaStreamVODQualityMP4350 : @(350),
                                       kAJMediaStreamVODQualityMP4800 : @(1000),
                                       kAJMediaStreamVODQualityMP41300 : @(1300),
                                       kAJMediaStreamVODQualityMP4720p : @(1800),
                                       kAJMediaStreamVODQualityMP41080p : @(3000)
                                       };
}

+(instancetype)parser {
    return [[[self class] alloc] init];
}

-(AJMediaStreamSchedulingMetadata *)parseMetadata:(NSDictionary *)jsonObject {
    AJMediaStreamSchedulingMetadata *metadata = [[AJMediaStreamSchedulingMetadata alloc] init];
    metadata.type = AJMediaPlayerVODStreamItem;
    metadata.status = [jsonObject[@"status"] integerValue];
    NSMutableArray *schedulingItems = [NSMutableArray array];
    [jsonObject[@"infos"] enumerateKeysAndObjectsUsingBlock:^(id key, id obj1, BOOL *stop) {
        AJMediaPlayerItem *metadataItem = [[AJMediaPlayerItem alloc] init];
        __block NSMutableArray *streams = nil;
        metadataItem.qualityName = key;
        
        [obj1 enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            if ([key isEqualToString:@"code"]) {
                metadataItem.isPlayable = [obj integerValue];
            } else {
                if (streams == nil) {
                    streams = [NSMutableArray arrayWithObject:@{key:obj}];
                } else {
                    [streams addObject:@{key:obj}];
                }
            }
        }];
        metadataItem.schedulingStreamURLs = streams;
        [metadataItem.schedulingStreamURLs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dic = obj;
                if ([dic valueForKey:@"mainUrl"]) {
                    metadataItem.preferredSchedulingStreamURL = [dic valueForKey:@"mainUrl"];
                    *stop = YES;
                }
            }
        }];
        [schedulingItems addObject:metadataItem];
    }];
    NSMutableArray *sortedArray = [NSMutableArray arrayWithArray:schedulingItems];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"qualityName" ascending:NO comparator:^NSComparisonResult(id obj1, id obj2) {
        if ([aj_vod_quality_name_weight_map[obj1] integerValue] < [aj_vod_quality_name_weight_map[obj2] integerValue]) {
            return NSOrderedAscending;
        } else if ([aj_vod_quality_name_weight_map[obj1] integerValue]> [aj_vod_quality_name_weight_map[obj2] integerValue]) {
            return NSOrderedDescending;
        } else {
            return NSOrderedSame;
        }
    }];
    [sortedArray sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    metadata.availableQualifiedStreamItems = sortedArray;
    return metadata;
}

@end

@implementation AJMediaStationStreamMetadataParser

static NSDictionary *aj_station_quality_name_weight_map;

+(void)initialize {
    aj_station_quality_name_weight_map = @{
                                        kAJMediaStreamLiveQualityFLV350 : @(350),
                                        kAJMediaStreamLiveQualityFLV1000 : @(1000),
                                        kAJMediaStreamLiveQualityFLV1300 : @(1300),
                                        kAJMediaStreamLiveQualityFLV720p : @(1800),
                                        kAJMediaStreamLiveQualityFLV1080p : @(3000)
                                        };
}

+(instancetype)parser {
    return [[[self class] alloc] init];
}

-(AJMediaStreamSchedulingMetadata *)parseMetadata:(id)jsonObject {
    AJMediaStreamSchedulingMetadata *metadata = [[AJMediaStreamSchedulingMetadata alloc] init];
    metadata.type = AJMediaPlayerStationStreamItem;
    metadata.status = jsonObject[@"status"] ? [jsonObject[@"status"] integerValue] : 10000;
    NSMutableArray *schedulingItems = [NSMutableArray array];
    NSArray * streamInfos = jsonObject[@"rows"];
    [streamInfos enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        AJMediaPlayerItem *metadataItem = [[AJMediaPlayerItem alloc] init];
        metadataItem.qualityName = obj[@"rateType"];
        metadataItem.assignedStreamName = obj[@"streamName"];
        metadataItem.schedulingStreamURLs = [NSMutableArray arrayWithObject:obj[@"streamUrl"]];
        if (metadataItem.schedulingStreamURLs.count > 0) {
            metadataItem.preferredSchedulingStreamURL =  [NSString stringWithFormat:@"%@&splatid=%@&platid=%@",metadataItem.schedulingStreamURLs[0],[[AJMediaPlayerInfrastructureContext settings] liveBackendSubplatID],[[AJMediaPlayerInfrastructureContext settings] liveBackendPlatID]] ;
        }
        [schedulingItems addObject:metadataItem];
    }];
    NSMutableArray *sortedArray = [NSMutableArray arrayWithArray:schedulingItems];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"qualityName" ascending:NO comparator:^NSComparisonResult(id obj1, id obj2) {
        if ([aj_station_quality_name_weight_map[obj1] integerValue]< [aj_station_quality_name_weight_map[obj2] integerValue]) {
            return NSOrderedAscending;
        } else if ([aj_station_quality_name_weight_map[obj1] integerValue]> [aj_station_quality_name_weight_map[obj2] integerValue]) {
            return NSOrderedDescending;
        } else {
            return NSOrderedSame;
        }
    }];
    [sortedArray sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    metadata.availableQualifiedStreamItems = sortedArray;
    return metadata;
}

@end
