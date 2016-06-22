//
//  AJMediaStreamSchedulingMetadata.h
//  Pods
//
//  Created by Zhangqibin on 5/22/15.
//
//

@import Foundation;
#import "AJMediaPlayerItem.h"
@class AJMediaStreamSchedulingMetadata;
@protocol AJMediaStreamSchedulingMetadataParser <NSObject>
-(AJMediaStreamSchedulingMetadata *)parseMetadata:(id)metadata;
@end

/**
 *  播放元数据
 */
@interface AJMediaStreamSchedulingMetadata : NSObject
@property(nonatomic, copy) NSString *resourceID;
@property(nonatomic, copy) NSString *resourceName;
@property(nonatomic, assign) AJMediaPlayerItemType type;
@property(nonatomic, copy) NSString *schedulingToken;
@property(nonatomic, copy) NSArray *availableQualifiedStreamItems; //!\note AJMediaPlayerItem inside
@property(nonatomic, assign) NSInteger status;
@property(nonatomic, copy) NSString *liveStartTime;
@property(nonatomic, copy) NSString *episodeid;
@property(nonatomic, copy) NSString *channelEname;

@end

@interface AJMediaVODStreamMetadataParser : NSObject <AJMediaStreamSchedulingMetadataParser>
+(instancetype)parser;
@end

@interface AJMediaLiveStreamMetadataParser : NSObject <AJMediaStreamSchedulingMetadataParser>
+(instancetype)parser;
@end

@interface AJMediaStationStreamMetadataParser : NSObject <AJMediaStreamSchedulingMetadataParser>
+(instancetype)parser;
@end


