//
//  AJMediaPlayerSDKAnalyticsReporter.h
//  Pods
//
//  Created by lixiang on 16/1/13.
//
//

#import <Foundation/Foundation.h>

@interface AJMediaPlayerBigDataConfiguration : NSObject <NSCopying>
@property (nonatomic, strong) NSString *appName;
@property (nonatomic, strong) NSString *version;
@end

@interface AJMediaPlayerSDKEventDetails : NSObject
@property (nonatomic, strong) NSString *video_id;
@property (nonatomic, strong) NSString *station_id;
@property (nonatomic, strong) NSString *videoLength;
@property (nonatomic, strong) NSString *live_id;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *stream;
@property (nonatomic, strong) NSString *network_type;
@property (nonatomic, strong) NSString *progress;
@end


@interface AJMediaPlayerSDKAnalyticsReporter : NSObject

+ (instancetype)sharedReporter;

- (AJMediaPlayerBigDataConfiguration *)shareAppConfiguration;

- (void)registerWithBigDataConfiguration:(AJMediaPlayerBigDataConfiguration *)playerConfiguration;

- (void)creatVideoPlay;

- (NSString *)getPlayId;

#pragma mark - SDK上报Play接口

-(void)reportWillInitialize:(AJMediaPlayerSDKEventDetails *)details;

-(void)reportPlayerDidBeginToPlayWithDetails:(AJMediaPlayerSDKEventDetails *)details;

-(void)reportPlayerDidBecomeBlockedWithDetails:(AJMediaPlayerSDKEventDetails *)details;

-(void)reportPlayerDidFinishBlockedWithDetails:(AJMediaPlayerSDKEventDetails *)details;

-(void)reportPlayerDidFinishPlayWithDetails:(AJMediaPlayerSDKEventDetails *) details;

-(void)reportPlayerDidInterruptWithDetails:(AJMediaPlayerSDKEventDetails *)details;

-(void)reportPlayerDidToggleSwitchStreamQualityWithDetails:(AJMediaPlayerSDKEventDetails *)details;

-(void)reportPlayerDidFireHeartbeatWithPlayDuration:(NSTimeInterval)duration details:(AJMediaPlayerSDKEventDetails *)details;

- (NSString*)getCurrentNetStatus;

@end


