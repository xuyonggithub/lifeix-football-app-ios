//
//  AJMediaStreamSchedulingMetadataRequest.m
//  AJMediaPlayerDemo
//
//  Created by Zhangqibin on 15/6/10.
//  Copyright (c) 2015年 zhangyi. All rights reserved.
//

#import "AJMediaStreamSchedulingMetadataFetcher.h"
#import "AJMediaPlayerErrorDefines.h"
#import "AJMediaRecordTimeHelper.h"
#import "AJMediaStreamSchedulingMetadata.h"
#import "AJMediaPlayerUtilities.h"
#import "AJMediaPlayerInfrastructureContext_Internal.h"
#import "AJMediaPlayerUtilities.h"
#import "AJMediaPlayerAnalyticsEventReporter.h"
//#import <SSKeychain.h>

NSString * const AJMediaStreamSchedulingMetadataFetchErrorDomain = @"com.lesports.ajmediaplayer.metadata.fetcher.error";

#define kLesportsPlayerReleaseAPIBaseURL @"http://static.api.sports.letv.com/sms/app/v1"
#define kLesportsPlayerStagingAPIBaseURL @"http://staging.api.lesports.com/sms/app/v1"

#define kFacadeVersion @"v1"
#define kMetadataVODRouter @"/play/vod"
#define kMetadataLiveRouter @"/play/live"
#define kMetadataStationVideoRouter @"/carousels/stream"

@interface AJMediaStreamSchedulingMetadataFetcher()
@property(nonatomic, strong) NSURLSessionDataTask *currentTask;
@property(nonatomic, strong) NSURLSession *URLSession;
@property(nonatomic, copy) NSDictionary *sharedParameters;
@end

@implementation AJMediaStreamSchedulingMetadataFetcher

- (instancetype)init {
    self = [super init];
    if (self) {
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.URLSession = [NSURLSession sessionWithConfiguration:sessionConfiguration];
        self.sharedParameters = @{@"caller":@"1003",@"version":@"1.0",@"from":@"8", @"hwtype" : @"iphone", @"ostype":@"un", @"termid":@"2"};
    }
    return self;
}

+ (instancetype)defaultFetcher {
    return [[[self class] alloc] init];
}

- (id<AJMediaStreamSchedulingMetadataParser>) metadataParserWithStreamType:(AJMediaPlayerItemType) type {
    switch (type) {
        case AJMediaPlayerLiveStreamItem:
            return [AJMediaLiveStreamMetadataParser parser];
            break;
        case AJMediaPlayerVODStreamItem:
            return [AJMediaVODStreamMetadataParser parser];
            break;
        case AJMediaPlayerStationStreamItem:
            return [AJMediaStationStreamMetadataParser parser];
        default:
            return nil;
            break;
    }
}

- (void)fetchStreamSchedulingMetadataWithID:(NSString *)targetID
                                 streamType:(AJMediaPlayerItemType) streamType
                                   authInfo:(NSDictionary *)authInfo
                          completionHandler:(void (^)(NSError *error, id streamItem))completionHandler {
    if (targetID && streamType) {
        [self metadataWithVideoID:targetID streamType:streamType authInfo:authInfo completionHandler:^(NSError *error, AJMediaStreamSchedulingMetadata *streamItem) {
            if (completionHandler) {
                completionHandler(error, streamItem);
            }
        }];
    }
}

- (NSString *)dateStringFromDate:(NSDate *)date
                 withFormatStyle:(NSString *)formatStyle {
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:formatStyle];
    NSString *dateStr=[dateformatter stringFromDate:date];
    return dateStr;
}

- (NSString *)getDefaultHeader {
    UIDevice *currentDevice = [UIDevice currentDevice];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    
    NSString *defaultName = [[[NSBundle mainBundle] infoDictionary] valueForKey:(id)kCFBundleNameKey];
    NSString *strUUID = @"test";
//    NSString *strUUID = [SSKeychain passwordForService:[[NSBundle mainBundle] infoDictionary][@"CFBundleIdentifier"] account:@"uuid"];
//    if (!strUUID || 1 > strUUID.length) {
//        NSUUID *uuid = [NSUUID UUID];
//        NSString *keyChainUUID = [uuid UUIDString];
//        [SSKeychain setPassword:keyChainUUID forService:[[NSBundle mainBundle] infoDictionary][@"CFBundleIdentifier"] account:@"uuid"];
//        strUUID = keyChainUUID;
//    }
    NSString *resultString = [NSString stringWithFormat:@"buildModel=%@&buildVersion=%@&systemName=%@&deviceId=%@&deviceName=%@&clientVersion=%@&clientName=%@&clientBuild=%@&nowTime=%@", currentDevice.model, currentDevice.systemVersion, currentDevice.systemName, strUUID, currentDevice.name, infoDictionary[@"CFBundleShortVersionString"], defaultName,[infoDictionary objectForKey:@"CFBundleVersion"], [self dateStringFromDate:[NSDate date] withFormatStyle:@"yyyyMMddHHmmss"]];
    return resultString;
}

- (void)metadataWithVideoID:(NSString *)videoID
                 streamType:(AJMediaPlayerItemType)streamType
                   authInfo:(NSDictionary *)authInfo
          completionHandler:(void (^)(NSError *error, AJMediaStreamSchedulingMetadata *streamItem))completionHandler {
    [self cancelTask];
    [self.URLSession invalidateAndCancel];
    self.URLSession = nil;
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    self.URLSession = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    
    NSString *requestURL = nil;
    NSMutableDictionary *queries = [NSMutableDictionary dictionaryWithDictionary:_sharedParameters];
    if (authInfo) {
        [queries addEntriesFromDictionary:authInfo];
    }
    
    NSString *baseURL = [[AJMediaPlayerInfrastructureContext settings] useDistributionNetworkingApi] ? kLesportsPlayerReleaseAPIBaseURL : kLesportsPlayerStagingAPIBaseURL;
    switch (streamType) {
        case AJMediaPlayerLiveStreamItem:
            requestURL = [baseURL stringByAppendingString:kMetadataLiveRouter];
            queries[@"splatid"] = [[AJMediaPlayerInfrastructureContext settings] liveBackendSubplatID];
            queries[@"platid"] = [[AJMediaPlayerInfrastructureContext settings] liveBackendPlatID];
            queries[@"liveid"] = videoID;
            queries[@"flag"] = @"34557879234sdf";
            break;
        case AJMediaPlayerVODStreamItem:
            requestURL = [baseURL stringByAppendingString:kMetadataVODRouter];;
            queries[@"vtype"] = @"58,21,13,22,51,52";
            queries[@"splatid"] = [[AJMediaPlayerInfrastructureContext settings] vrsBackendSubplatID];
            queries[@"platid"] = [[AJMediaPlayerInfrastructureContext settings] vrsBackendPlatID];
            queries[@"tss"] = [[AJMediaPlayerInfrastructureContext settings] streamFormat] == AJMediaStreamFormatM3u8 ? @"m3u8" : @"mp4";
            queries[@"vid"] = videoID;
            break;
        case AJMediaPlayerStationStreamItem:
            requestURL = [baseURL stringByAppendingString:kMetadataStationVideoRouter];;
            queries[@"clientId"] = [[AJMediaPlayerInfrastructureContext settings] liveBackendSubplatID];
            queries[@"channelId"] = videoID;
            break;
        default:
            break;
    }
    NSString *(^__makeParametersBlock)(NSDictionary *parameters) = ^NSString *(NSDictionary *parameters) {
        if (nil == parameters) {
            return @"";
        }
        NSMutableArray *tempArray = [[NSMutableArray alloc]init];
        [parameters enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [tempArray addObject:[NSString stringWithFormat:@"%@=%@",key,obj]];
        }];
        return [tempArray componentsJoinedByString:@"&"];
    };
    
    requestURL = [NSString stringWithFormat:@"%@?%@", requestURL, __makeParametersBlock(queries)];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:requestURL]
                                                                cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                            timeoutInterval:10];
    
    NSMutableDictionary *header = [NSMutableDictionary dictionaryWithDictionary:request.allHTTPHeaderFields];
    [header setObject:[self getDefaultHeader] forKey:@"DEVICE_INFO"];
    request.allHTTPHeaderFields = header;
    
    aj_logMessage(AJLoggingInfo, @"Will request for facade server to retrieve stream metadata (G3 url) <%@|%@>: %@", aj_stringValueForPlayerItemType(streamType), videoID, requestURL);
    request.HTTPMethod = @"GET";
    __block AJMediaPlayerItemType __streamTypeRef = streamType;
    [[AJMediaRecordTimeHelper sharedInstance] recordStartTimeWithKey:@"dataTaskWithRequest"];
    id<AJMediaStreamSchedulingMetadataParser> parser = [self metadataParserWithStreamType:streamType];
    self.currentTask = [self.URLSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSInteger requestTime = [[AJMediaRecordTimeHelper sharedInstance] getRecordEndTimeWithKey:@"dataTaskWithRequest"];
        NSString *identifier = nil;
        switch (__streamTypeRef) {
            case AJMediaPlayerLiveStreamItem:
                identifier = @"视频直播接口";
                break;
            case AJMediaPlayerVODStreamItem:
                identifier = @"视频点播接口";
                break;
            case AJMediaPlayerStationStreamItem:
                identifier = @"轮播台接口";
                break;
            default:
                break;
        }
//        ORAnalyticsApiStatus *apiStatus = [[ORAnalyticsApiStatus alloc] initWithName:identifier];
//        [apiStatus setConsumingTimeIntervalInMilliseconds:requestTime];
        if (error) {
            if ([error code] == NSURLErrorCancelled) {
                return;
            }
            NSError *errorInfo;
            if ([error code] == NSURLErrorNotConnectedToInternet) {
                errorInfo = [[NSError alloc] initWithDomain:error.domain code:AJMediaPlayerLocalHTTPClientNetworkNotConnectedError userInfo:error.userInfo];
            } else if ([error code] == NSURLErrorTimedOut) {
                errorInfo = [[NSError alloc] initWithDomain:error.domain code:AJMediaPlayerLocalHTTPClientTimeOutError userInfo:error.userInfo];
            } else {
                errorInfo = [[NSError alloc] initWithDomain:error.domain code:AJMediaPlayerLocalHTTPClientRequestFailedError userInfo:error.userInfo];
            }
            
//            if ([error code]) {
//                [apiStatus setReturnCode:(int)[error code]];
//            }
//            [apiStatus setResultType:API_FAILED_TYPE];
//            [ORAnalytics submitAPIStatus:apiStatus];
            if (completionHandler) {
                [AJMediaPlayerAnalyticsEventReporter submitRequestUrlErrorEvent:@"client_err" withErrorCode:[NSString stringWithFormat:@"%ld",(long)errorInfo.code]];
                completionHandler(errorInfo, nil);
            }
        } else {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            if (httpResponse.statusCode == 200) {
                aj_logMessage(AJLoggingInfo, @"Received response from facade server <%@|%@>: %@", aj_stringValueForPlayerItemType(streamType), videoID, requestURL);
                NSError *jsonError = nil;
                NSDictionary *metadata = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
//                [apiStatus setReturnCode:(int32_t)[httpResponse statusCode]];
//                [apiStatus setResponseSize:(data.length + [httpResponse.description length])];
                
                if (jsonError) {
                    NSError *errorInfo = [[NSError alloc] initWithDomain:jsonError.domain code:AJMediaPlayerLocalHTTPClientResponseJSONParsingError userInfo:jsonError.userInfo];
//                    [apiStatus setResultType:API_FAILED_TYPE];
//                    [ORAnalytics submitAPIStatus:apiStatus];
                    if (completionHandler) {
                        [AJMediaPlayerAnalyticsEventReporter submitRequestUrlErrorEvent:@"webapi_bussiness_err" withErrorCode:[NSString stringWithFormat:@"%ld",(long)errorInfo.code]];
                        completionHandler(errorInfo, nil);
                    }
                    return;
                }
//                BOOL isValidResponseMetadata = [self validateResponseData:metadata apiStatus:apiStatus completionHandler:^(NSError *error) {
//                    if (completionHandler) {
//                        [AJMediaPlayerAnalyticsEventReporter submitRequestUrlErrorEvent:@"webapi_bussiness_err" withErrorCode:[NSString stringWithFormat:@"%ld",(long)error.code]];
//                        completionHandler(error, nil);
//                    }
//                }];
                BOOL isValidResponseMetadata = YES;
                if (isValidResponseMetadata && parser && [parser respondsToSelector:@selector(parseMetadata:)]) {
                    aj_logMessage(AJLoggingInfo, @"Parsed response with contains stream metadata (G3 url) from facade server <%@|%@>: %@ details response body {%@}", aj_stringValueForPlayerItemType(streamType), videoID, requestURL, metadata);
                    AJMediaStreamSchedulingMetadata *schedulingMetadata = [parser parseMetadata:metadata[@"data"]];
                    if (schedulingMetadata && completionHandler) {
//                        [apiStatus setResultType:API_SUCCESS_TYPE];
//                        [ORAnalytics submitAPIStatus:apiStatus];
                        completionHandler(nil, schedulingMetadata);
                    }
                }
            } else {
                if (completionHandler) {
                    NSError *errorInfo = [NSError errorWithDomain:AJMediaStreamSchedulingMetadataFetchErrorDomain code:AJMediaPlayerProxiedAPINotOKResponseError userInfo:@{@"reason":@"代理服务器请求非200错误"}];
                    [AJMediaPlayerAnalyticsEventReporter submitRequestUrlErrorEvent:@"transport_err" withErrorCode:[NSString stringWithFormat:@"%ld",(long)errorInfo.code]];
//                    [apiStatus setResultType:API_FAILED_TYPE];
//                    [ORAnalytics submitAPIStatus:apiStatus];
                    completionHandler(errorInfo, nil);
                }
            }
        }
    }];
    [self.currentTask resume];
}

//- (BOOL)validateResponseData:(id)responseData apiStatus:(ORAnalyticsApiStatus *)apiStatus completionHandler:(void (^)(NSError *error)) completionHandler {
//    AJMediaPlayerErrorIdentifier errorIdentifier = -1;
//    BOOL isValid = YES;
//    if (responseData == nil) {
//        errorIdentifier = AJMediaPlayerProxiedAPIEmptyResponseDataError;
//        isValid = NO;
//    } else if (![responseData isKindOfClass:[NSDictionary class]]) {
//        errorIdentifier = AJMediaStreamProxiedAPIInconsistentResponseDataError;
//        isValid = NO;
//    } else {
//        id dataFragment = responseData[@"data"];
//        if (!dataFragment) {
//            errorIdentifier = AJMediaPlayerProxiedAPIEmptyResponseDataError;
//            isValid = NO;
//        } else if (![dataFragment isKindOfClass:[NSDictionary class]]) {
//            errorIdentifier = AJMediaStreamProxiedAPIInconsistentResponseDataError;
//            isValid = NO;
//        } else if ([dataFragment isKindOfClass:[NSDictionary class]]) {
//            NSDictionary *dic = dataFragment;
//            if (dic.count == 0) {
//                errorIdentifier = AJMediaPlayerProxiedAPIEmptyResponseDataError;
//                isValid = NO;
//            }
//        }
//    }
//    if (!isValid) {
//        NSDictionary *userInfo = nil;
//        if (errorIdentifier == AJMediaPlayerProxiedAPIEmptyResponseDataError) {
//            userInfo = @{@"reason":@"数据请求为空"};
//        } else if (errorIdentifier == AJMediaStreamProxiedAPIInconsistentResponseDataError){
//            userInfo = @{@"reason":@"数据请求不一致"};
//        }
//        NSError *error = [NSError errorWithDomain:AJMediaStreamSchedulingMetadataFetchErrorDomain code:errorIdentifier userInfo:userInfo];
//        [apiStatus setResultType:API_FAILED_TYPE];
//        [ORAnalytics submitAPIStatus:apiStatus];
//        if (completionHandler) {
//            completionHandler(error);
//        }
//    }
//    return isValid;
//}


- (void)cancelTask {
    if (self.currentTask) {
        [self.currentTask suspend];
        [self.currentTask cancel];
        aj_logMessage(AJLoggingInfo, @"Cancelled retrieving task from facade server %@", self.currentTask.currentRequest.URL);
    }
}

@end
