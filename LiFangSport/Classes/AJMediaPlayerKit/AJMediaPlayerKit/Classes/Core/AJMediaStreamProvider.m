//
//  AJMediaStreamProvider.m
//  Pods
//
//  Created by Gang Li on 5/22/15.
//
//
@import AVFoundation;
#import "AJMediaStreamProvider.h"
#import "AJMediaPlayerInfrastructureContext_Internal.h"
#import "AJMediaPlayer.h"
#import "AJMediaPlayerItem.h"
#import "AJFoundation.h"

@implementation AJAbstractMediaStreamProvider

+(instancetype)provider
{
    @throw [NSException exceptionWithName:@"com.lesports.ajmediaplayer.subclassing.method.hook.required" reason:@"" userInfo:nil];
}

- (void)loadPlayableItemWithMetadata:(AJMediaPlayerItem *)schedulingMetadata timeshift:(int)timeshift withParameter:(NSString *)parameter completionHandler:(void (^)(NSError *, AVPlayerItem *))completionHandler
{
    @throw [NSException exceptionWithName:@"com.lesports.ajmediaplayer.subclassing.method.hook.required" reason:@"" userInfo:nil];
}

@end

@implementation AJLetvCDEStreamProviderImplementation

+(instancetype)provider {
    aj_logMessage(AJLoggingInfo, @"Initializing CDE enhanced stream provider, using CDE provided HLS server");
    return [[AJLetvCDEStreamProviderImplementation alloc] init];
}

- (void)loadPlayableItemWithMetadata:(AJMediaPlayerItem *)schedulingMetadata timeshift:(int)timeshift withParameter:(NSString *)parameter completionHandler:(void (^)(NSError *err, AVPlayerItem *item))completionHandler {
    if (schedulingMetadata.preferredSchedulingStreamURL) {
        AJCloudService *cloudService =  [AJMediaPlayerInfrastructureContext cloudService];
        NSString *urlString;
        if (timeshift > 0) {
            urlString = [NSString stringWithFormat:@"%@&timeshift=-%d",schedulingMetadata.preferredSchedulingStreamURL,timeshift];
        } else {
            urlString = schedulingMetadata.preferredSchedulingStreamURL;
        }
        NSMutableString *finnalUrlString = [NSMutableString stringWithFormat:@"%@",urlString];
        if (parameter) {
            [finnalUrlString appendString:parameter];
        }
        aj_logMessage(AJLoggingInfo, @"%@ obtained preferred scheduling stream url: %@",schedulingMetadata, finnalUrlString);

//        NSURL *cdeLinkUrl = [cloudService securedStreamURLWithSchedulingURL:finnalUrlString];
//        aj_logMessage(AJLoggingInfo, @"%@ obtained preferred playable stream url: %@", schedulingMetadata, cdeLinkUrl.absoluteString);
//        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:cdeLinkUrl];
//        completionHandler(nil,playerItem);
        
        [cloudService syncSecuredStreamURLWithSchedulingURL:finnalUrlString success:^(NSError *error, NSURL *cdeLinkUrl) {
            aj_logMessage(AJLoggingInfo, @"%@ obtained preferred playable stream url: %@", schedulingMetadata, cdeLinkUrl.absoluteString);
            AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:cdeLinkUrl];
            completionHandler(error,playerItem);
        }];
    }
}

- (void)cancelTasks {
    aj_logMessage(AJLoggingInfo, @"CDE enchanced stream provider stop url");
    [[AJMediaPlayerInfrastructureContext cloudService] stopSchedulingURL];
}

@end

@implementation AJDefaultStreamProviderImplementation

+(instancetype)provider {
    aj_logMessage(AJLoggingInfo, @"Initializing default stream provider, not using CDE provided HLS server, using CDN server IP address");
    return [[AJDefaultStreamProviderImplementation alloc] init];
}

-(void)loadPlayableItemWithMetadata:(AJMediaPlayerItem *)schedulingMetadata timeshift:(int)timeshift withParameter:(NSString *)parameter completionHandler:(void (^)(NSError *err, AVPlayerItem *item))completionHandler {
    if (schedulingMetadata.preferredSchedulingStreamURL) {
        AJCloudService *cloudService = [AJMediaPlayerInfrastructureContext cloudService];
        NSString *urlString;
        if (timeshift > 0) {
            urlString = [NSString stringWithFormat:@"%@&timeshift=-%d",schedulingMetadata.preferredSchedulingStreamURL,timeshift];
        } else {
            urlString = schedulingMetadata.preferredSchedulingStreamURL;
        }
        NSMutableString *finnalUrlString = [NSMutableString stringWithFormat:@"%@",urlString];
        if (parameter) {
            [finnalUrlString appendString:parameter];
        }
        aj_logMessage(AJLoggingInfo, @"%@ obtained preferred scheduling stream url: %@",schedulingMetadata, finnalUrlString);
        NSURL *linkshellURL = [cloudService securedSchedulingURL:finnalUrlString];
        aj_logMessage(AJLoggingInfo, @"%@ obtained preferred playable stream url: %@", schedulingMetadata, linkshellURL.absoluteString);
        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:linkshellURL];
        completionHandler(nil,playerItem);
    }
}

-(void)cancelTasks {
    aj_logMessage(AJLoggingInfo, @"Default stream provider stop url");
    [[AJMediaPlayerInfrastructureContext cloudService] stopSchedulingURL];
}

@end

