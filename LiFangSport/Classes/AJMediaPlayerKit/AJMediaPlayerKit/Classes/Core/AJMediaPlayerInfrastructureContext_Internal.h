//
//  AJMediaPlayerInfrastructureContext+Internal.h
//  Pods
//
//  Created by Gang Li on 7/7/15.
//
//

#import "AJMediaPlayerInfrastructureContext.h"

#define kPlayerDailyLogFilePrefix @"player-daily-"

@class AJCloudService;
@class AJMediaPlayerConfiguration;
@interface AJMediaPlayerInfrastructureContext (Internal)
+ (AJCloudService *)cloudService;
+ (BOOL)isCloudServiceReady;

@end


@interface AJCloudService : NSObject

-(instancetype)initWithConfiguration:(AJMediaPlayerConfiguration *)configuration;
-(void)syncSecuredStreamURLWithSchedulingURL:(NSString *)schedulingURL success:(void (^)(NSError *error, NSURL *cdeLinkUrl))completionHandler;
-(NSURL *)securedStreamURLWithSchedulingURL:(NSString *)schedulingURL;
-(NSURL *)securedSchedulingURL:(NSString *)schedulingURL;
-(void)stopSchedulingURL;

@end

@interface AJCloudService (StatusStorage)
@property(nonatomic, copy, readonly) NSString * currentPlayURL;
@property(nonatomic, copy, readonly) NSString * currentLinkshellURL;
@end
