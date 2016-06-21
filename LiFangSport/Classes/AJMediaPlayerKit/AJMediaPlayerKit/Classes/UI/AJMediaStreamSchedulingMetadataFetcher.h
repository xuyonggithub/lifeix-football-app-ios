//
//  AJMediaStreamSchedulingMetadataRequest.h
//  AJMediaPlayerDemo
//
//  Created by le_cui on 15/6/10.
//  Copyright (c) 2015年 Lesports Inc. All rights reserved.
//

@import Foundation;
#import "AJMediaPlayerHeaders.h"

extern NSString * const AJMediaStreamSchedulingMetadataFetchErrorDomain;

@interface AJMediaStreamSchedulingMetadataFetcher : NSObject

+ (instancetype)defaultFetcher;

- (void)fetchStreamSchedulingMetadataWithID:(NSString *)targetID
                                 streamType:(AJMediaPlayerItemType) streamType
                                   authInfo:(NSDictionary *)authInfo
                          completionHandler:(void (^)(NSError *error, id streamItem))completionHandler;

- (void)cancelTask;

@end
