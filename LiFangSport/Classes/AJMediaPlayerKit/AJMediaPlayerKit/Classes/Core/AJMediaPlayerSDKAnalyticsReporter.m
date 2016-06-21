//
//  AJMediaPlayerSDKAnalyticsReporter.m
//  Pods
//
//  Created by lixiang on 16/1/13.
//
//

#import "AJMediaPlayerSDKAnalyticsReporter.h"
#import <Reachability/Reachability.h>

@implementation AJMediaPlayerBigDataConfiguration

-(instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

@end

@implementation AJMediaPlayerSDKEventDetails

@end


@interface AJMediaPlayerSDKAnalyticsReporter()

@property (nonatomic, strong) AJMediaPlayerBigDataConfiguration *bigDataConfiguration;


@end

@implementation AJMediaPlayerSDKAnalyticsReporter

+ (instancetype)sharedReporter {
    static AJMediaPlayerSDKAnalyticsReporter *__bigDataSDKreporter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (__bigDataSDKreporter == nil) {
            __bigDataSDKreporter = [[AJMediaPlayerSDKAnalyticsReporter alloc] init];
        }
    });
    return __bigDataSDKreporter;
}

- (void)registerWithBigDataConfiguration:(nonnull AJMediaPlayerBigDataConfiguration *)bigDataConfiguration {
    if (bigDataConfiguration) {
        _bigDataConfiguration = bigDataConfiguration;
    }
}

- (AJMediaPlayerBigDataConfiguration *)shareAppConfiguration {
    return _bigDataConfiguration;
}

- (void)creatVideoPlay {
    
}

- (NSString *)getPlayId {
       return nil;
}

- (void)equipmentVideoPlay:(AJMediaPlayerSDKEventDetails *)details {
    
}

-(void)reportWillInitialize:(AJMediaPlayerSDKEventDetails *)details {
    
}

-(void)reportPlayerDidBeginToPlayWithDetails:(AJMediaPlayerSDKEventDetails *)details {
    
}

-(void)reportPlayerDidBecomeBlockedWithDetails:(AJMediaPlayerSDKEventDetails *)details {
    
}

-(void)reportPlayerDidFinishBlockedWithDetails:(AJMediaPlayerSDKEventDetails *)details {
   
}

-(void)reportPlayerDidFinishPlayWithDetails:(AJMediaPlayerSDKEventDetails *)details {
    
}

-(void)reportPlayerDidInterruptWithDetails:(AJMediaPlayerSDKEventDetails *)details {
    }

-(void)reportPlayerDidToggleSwitchStreamQualityWithDetails:(AJMediaPlayerSDKEventDetails *)details {
   }

-(void)reportPlayerDidFireHeartbeatWithPlayDuration:(NSTimeInterval)duration details:(AJMediaPlayerSDKEventDetails *) details {
    }

- (NSString*)getCurrentNetStatus {
    switch ([Reachability reachabilityForInternetConnection].currentReachabilityStatus) {
        case NotReachable:
            return @"wired";
            break;
        case ReachableViaWiFi:
            return @"wifi";
            break;
        case ReachableViaWWAN:
            return @"3g";
            break;
        default:
            break;
    }
    return nil;
}

@end

