//
//  AJMediaStreamSchedulingMetadataRequest.h
//  AJMediaPlayerDemo
//
//  Created by Zhangqibin on 15/6/10.
//  Copyright (c) 2015年 zhangyi. All rights reserved.
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
