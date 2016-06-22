//
//  CommonRequest.h
//  LiFangSport
//
//  Created by 张毅 on 16/6/12.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
typedef NS_ENUM(NSInteger, RequestLoadType){
    RLT_None,
    RLT_EmptyLoad,
    RLT_OverlayLoad,
};

typedef NS_ENUM(NSInteger, RequestServerType){
    RST_Default,
    RST_New,
    RST_PHP_NEW
};

typedef NS_ENUM(NSInteger, CacheDataReturnType){
    CDRT_FailureReturn,
    CDRT_ImmediateReturn,
};

typedef NS_ENUM(NSInteger, ServerErrorCode){
    SEC_Success = 99999,

};

#define ServerErrorStr(__code__)            [CommonRequest serverErrorStringForCode:__code__]

#define kLoadingType @"kLoadingType"
#define kLoadingView @"kLoadingView"
#define kRequestType @"kRequestType"
#define kReturnType @"kReturnType"
#define kRtData @"data"

#define kCommonRequestTimeOut 30
#define kWWANRequesTimeOut 60

//服务器地址
#if (defined(Env_Online))
#define kServerAddress      @"http://ssapi.knowbox.cn/v/1_2_0/"
//#define kServerAddressDomin  [CommonRequest serverAddressDomin]

#elif defined(Env_Dev_Test)
#define kServerAddress      @"http://192.168.50.154:8000/football/"
//#define kServerAddressDomin  @"http://192.168.1. "
#endif
/*路径地址*/
#define kcategoryPath       @"category/menus/app" //类目
#define kChinaMatchSchdulePath       @"games/competitions/5/matches?teamId=1" //中国队赛程
#define kMatchSuggestPath       @"games/competitions/5" //赛事介绍
#define kHeroListPath       @"games/competitions/5/teams/1/competitionTeam" //英雄榜
#define ksinglepagePath  @"wemedia/posts/"

#define kvideoListPath @"elearning/training_categories" //视频列表
#define kvideoSinglePath @"elearning/videos/"//点击单个视频

#define kQiNiuHeaderPath @"http://7xumx6.com1.z0.glb.clouddn.com/" //七牛

typedef void(^FetchCachedJson)(NSDictionary *json);
typedef void(^CompleteBlock)(BOOL success);

@interface CommonRequest : AFHTTPRequestOperationManager
@property (nonatomic, strong) NSString *relativePath;

+ (AFHTTPRequestOperation *)requstPath:(NSString *)path
                            loadingDic:(NSDictionary *)loadingDic
                            queryParam:(NSDictionary *)param
                               success:(void (^)(CommonRequest *request,  id jsonDict))success
                               failure:(void (^)(CommonRequest *request, NSError *error))failure;

//+ (AFHTTPRequestOperation *)requstPath:(NSString *)path
//                            loadingDic:(NSDictionary *)loadingDic
//                             postParam:(NSDictionary *)param
//                               success:(void (^)(CommonRequest *request,  id jsonDict))success
//                               failure:(void (^)(CommonRequest *request, NSError *error))failure;
//
//+ (AFHTTPRequestOperation *)requstPath:(NSString *)path
//                            loadingDic:(NSDictionary *)loadingDic
//                            queryParam:(NSDictionary *)param
//                                 cache:(BOOL)cache
//                               success:(void (^)(CommonRequest *request,  id jsonDict))success
//                               failure:(void (^)(CommonRequest *request, NSError *error))failure;
//
//+ (AFHTTPRequestOperation *)requstPath:(NSString *)path
//                            loadingDic:(NSDictionary *)loadingDic
//                             postParam:(NSDictionary *)postParam
//                              getParam:(NSDictionary *)getParam
//                                 cache:(BOOL)cache
//                               success:(void (^)(CommonRequest *request,  id jsonDict))success
//                               failure:(void (^)(CommonRequest *request, NSError *error))failure;

+ (AFHTTPRequestOperation *)download:(NSString *)urlStr toPath:(NSString *)filePath progressBlock:(void (^)(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead))grogressBlock complete:(CompleteBlock)complete;

+ (AFHTTPRequestOperation *)pauseDownload:(NSString *)urlStr toPath:(NSString *)filePath downloadedByte:(unsigned long long)downloadedByte progressBlock:(void (^)(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead))grogressBlock complete:(CompleteBlock)complete ;

//+ (NSMutableString *)queryStrWithParam:(NSDictionary *)queryParam;
//+ (NSString *)keyForURLString:(NSString *)urlString;
//+ (void)clearCache;
//
//+ (void)showCommonErrorInfo:(NSError *)error;
//+ (NSString *)errorInfoForError:(NSError *)error;
//
//+ (NSString *)serverErrorStringForCode:(ServerErrorCode)code;
//
//+ (NSString *)serverAddressDomin;



@end
