//
//  AJMediaPlayerAnalyticsReporter.m
//  Pods
//
//  Created by Zhangqibin on 6/9/15.
//
//

#import "AJMediaPlayerAnalyticsReporter.h"
#import <objc/runtime.h>
#import <Reachability/Reachability.h>
#import "AJFoundation.h"

#define kLetvPlayerAnalyticsBaseURLForRelease   @"http://apple.www.letv.com"
#define kLetvPlayerAnalyticsBaseURLForDebug     @"http://develop.bigdata.leshiren.com/0ge4"

@interface AJMediaPlayerAnalyticsReporter () {
    AJAnalyticsAppMetadata *__appMetadata;
    __strong NSURLSession *__currentSession;
    id __notificationObserver;
}
@end

@implementation AJMediaPlayerAnalyticsReporter

+(instancetype)sharedReporter {
    static AJMediaPlayerAnalyticsReporter *__reporter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reporter = [[AJMediaPlayerAnalyticsReporter alloc] init];
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.timeoutIntervalForRequest = 10.f;
        __reporter->__currentSession = [NSURLSession sessionWithConfiguration:configuration];
    });
    return __reporter;
}

-(void)registerWithMetadata:(AJAnalyticsAppMetadata *)appMetadata {
    __appMetadata = appMetadata;
    __notificationObserver = [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillEnterForegroundNotification
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification *note) {

                                                  }];
}

- (AJAnalyticsAppMetadata *)shareAppMetadata {
    return __appMetadata;
}

- (void)dealloc {
    if (__notificationObserver) {
        [[NSNotificationCenter defaultCenter] removeObserver:__notificationObserver name:UIApplicationWillEnterForegroundNotification object:nil];
    }
}

-(NSDictionary *)detailsDictionaryWithEventType:(AJMediaPlayerAnalyticsEventType)eventType parameters:(NSDictionary *)parameters{
    NSMutableDictionary *queries = [NSMutableDictionary dictionary];
    queries[@"p1"] = __appMetadata.firstLevelID;
    queries[@"p2"] = __appMetadata.secondLevelID;
    queries[@"p3"] = __appMetadata.thirdLevelID;
    switch (eventType) {
        case AJMediaPlayerLaunch:
            queries[@"ac"] = @"launch";
            break;
        case AJMediaPlayerInitializing:
            queries[@"ac"] = @"init";
            break;
        case AJMediaPlayerDidPlay:
            queries[@"ac"] = @"play";
            break;
        case AJMediaPlayerHeartbeat:
            queries[@"ac"] = @"time";
            break;
        case AJMediaPlayerDidBlock:
            queries[@"ac"] = @"block";
            break;
        case AJMediaPlayerDidFinishBlock:
            queries[@"ac"] = @"eblock";
            break;
        case AJMediaPlayerDidFinish:
            queries[@"ac"] = @"finish";
            break;
        case AJMediaPlayerDidInvalidate:
            queries[@"ac"] = @"end";
            break;
        case AJMediaPlayerDidSeek:
            queries[@"ac"] = @"drag";
            break;
        case AJMediaPlayerSwitchStreamQuality:
            queries[@"ac"] = @"tg";
            break;
        default:
            break;
    }
    [queries addEntriesFromDictionary:parameters];
    return queries;
}

-(NSDictionary *)detailsDictionaryWithEventTypeWithParameters:(NSDictionary *)parameters{
    NSMutableDictionary *queries = [NSMutableDictionary dictionary];
    queries[@"p1"] = __appMetadata.firstLevelID;
    queries[@"p2"] = __appMetadata.secondLevelID;
    queries[@"p3"] = __appMetadata.thirdLevelID;
    [queries addEntriesFromDictionary:parameters];
    return queries;
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

- (NSMutableURLRequest *)requestWithPath:(NSString *)path parameters:(NSDictionary<NSString *, NSString *> *)parameters
{
    NSMutableString *requestURLString = [NSMutableString stringWithFormat:@"%@/%@?",kLetvPlayerAnalyticsBaseURLForRelease, path];
    [parameters enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
        [requestURLString appendFormat:@"%@=%@&", key, obj];
    }];
    NSURL *requestURL = [NSURL URLWithString:[requestURLString substringToIndex:requestURLString.length - 1]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestURL];
    return request;
}

-(void)sendPlayerEvent:(AJMediaPlayerAnalyticsEventType)eventType parameters:(NSDictionary *)parameters {
    if ( __appMetadata == nil ) {
        return;
    }
    NSDictionary *aggreatedParameters = [self detailsDictionaryWithEventType:eventType parameters:parameters];
    NSMutableURLRequest *request = [self requestWithPath:@"pl/" parameters:aggreatedParameters];
    __weak typeof(self) weakSelf = self;
    NSURLSessionDataTask *dataTask = [__currentSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if ((error || [[response valueForKey:@"statusCode"] integerValue] != 200) && weakSelf.failureHandler) {
            weakSelf.failureHandler(error);
        }
    }];
    [dataTask resume];
}

-(void)sendPlayerEventWithParameters:(NSDictionary *)parameters {
    if ( __appMetadata == nil ) {
        return;
    }
    NSDictionary *aggreatedParameters = [self detailsDictionaryWithEventTypeWithParameters:parameters];
    NSMutableURLRequest *request = [self requestWithPath:@"env/" parameters:aggreatedParameters];
    __weak typeof(self) weakSelf = self;
    NSURLSessionDataTask *dataTask = [__currentSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if ((error || [[response valueForKey:@"statusCode"] integerValue] != 200) && weakSelf.failureHandler) {
            weakSelf.failureHandler(error);
        }
    }];
    [dataTask resume];
}

-(void)playerDidFinishLaunchingWithDetails:(AJMediaPlayerEventDetails *) details {
    [self sendPlayerEvent:AJMediaPlayerLaunch parameters:[details availableDictionaryRepresetation]];
}

-(void)playerWillInitializeWithDetails:(AJMediaPlayerEventDetails *) details {
    [self sendPlayerEvent:AJMediaPlayerInitializing parameters:[details availableDictionaryRepresetation]];
}

-(void)playerDidBeginToPlayWithDetails:(AJMediaPlayerEventDetails *) details {
    [self sendPlayerEvent:AJMediaPlayerDidPlay parameters:[details availableDictionaryRepresetation]];
}

-(void)playerDidBecomeBlockedWithDetails:(AJMediaPlayerEventDetails *) details {
    [self sendPlayerEvent:AJMediaPlayerDidBlock parameters:[details availableDictionaryRepresetation]];
}

-(void)playerDidFinishBlockedWithDetails:(AJMediaPlayerEventDetails *) details {
    [self sendPlayerEvent:AJMediaPlayerDidFinishBlock parameters:[details availableDictionaryRepresetation]];
}

-(void)playerDidFinishPlayWithDetails:(AJMediaPlayerEventDetails *) details {
    [self sendPlayerEvent:AJMediaPlayerDidFinish parameters:[details availableDictionaryRepresetation]];
}

-(void)playerDidInterruptWithDetails:(AJMediaPlayerEventDetails *)details {
    [self sendPlayerEvent:AJMediaPlayerDidInvalidate parameters:[details availableDictionaryRepresetation]];
}

-(void)playerDidToggleSwitchStreamQualityWithDetails:(AJMediaPlayerEventDetails *) details {
    [self sendPlayerEvent:AJMediaPlayerSwitchStreamQuality parameters:[details availableDictionaryRepresetation]];
}
-(void)playerDidFinishSeekWithDetails:(AJMediaPlayerEventDetails *) details {
    [self sendPlayerEvent:AJMediaPlayerDidSeek parameters:[details availableDictionaryRepresetation]];
}
-(void)playerDidFireHeartbeatWithPlayDuration:(NSTimeInterval)duration details:(AJMediaPlayerEventDetails *) details {
    [self sendPlayerEvent:AJMediaPlayerHeartbeat parameters:[details availableDictionaryRepresetation]];
}
- (void)applicationSubmitEnvWithDetails:(AJMediaPlayerEventDetails *)details {
    [self sendPlayerEventWithParameters:[details availableDictionaryRepresetation]];
}

@end


@implementation AJAnalyticsAppMetadata

+(instancetype)metadata {
    return [[[self class] alloc] init];
}

@end

@implementation AJMediaPlayerEventDetails

#define INVALID_INT_VALUE -1

-(instancetype)init {
    self = [super init];
    if (self) {
        self.pt = INVALID_INT_VALUE;
        self.ut = INVALID_INT_VALUE;
        self.vlen = INVALID_INT_VALUE;
        self.ry = INVALID_INT_VALUE;
        self.ty = INVALID_INT_VALUE;
        self.ilu = INVALID_INT_VALUE;
        self.ctime = INVALID_INT_VALUE;
        self.prl = INVALID_INT_VALUE;
        self.joint = INVALID_INT_VALUE;
        self.ipt = INVALID_INT_VALUE;
        self.pay = INVALID_INT_VALUE;
    }
    return self;
}

-(NSDictionary *)availableDictionaryRepresetation {
    unsigned int outCount;
    NSMutableArray *availableKeys = [NSMutableArray array];
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (int i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        const char *prop_name = property_getName(property);
        if (prop_name) {
            NSString *propertyName = [NSString stringWithCString:prop_name encoding:[NSString defaultCStringEncoding]];
            
            id value = [self valueForKey:propertyName];
            if ([value isKindOfClass:[NSNumber class]]) {
                NSInteger intValue = [(NSNumber *)value integerValue];
                if (intValue == INVALID_INT_VALUE) {
                    continue;
                }
            }
            
            if (value == nil) {
                continue;
            }
            
            [availableKeys addObject:propertyName];
        }
    }
    free(properties);
    return [self dictionaryWithValuesForKeys:availableKeys];
}


@end