//
//  CommonRequest.m
//  LiFangSport
//
//  Created by 张毅 on 16/6/12.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import "CommonRequest.h"
#import "CommonLoading.h"

static dispatch_queue_t dispatchQueue;
static NSMutableSet *requestURLKeys;

@interface CommonRequest()

@end
@implementation CommonRequest

- (void)dealloc
{
    NSLog(@"dealloc");
}

- (void)showloading:(NSString *)loadingStr{

    UIScreen *view = [[UIScreen alloc]init];
    [CommonLoading showEmptyLoadingInView:view];
}

//请求的底层封装post/get
+ (AFHTTPRequestOperation *)requstPath:(NSString *)path
                            loadingDic:(NSDictionary *)loadingDic
                             postParam:(NSDictionary *)postParam
                              getParam:(NSDictionary *)getParam
                                 cache:(BOOL)cache
                               success:(void (^)(CommonRequest *request,  id jsonDict))success
                               failure:(void (^)(CommonRequest *request, NSError *error))failure
{
    RequestServerType serverType = loadingDic[kRequestType] ? [loadingDic[kRequestType] integerValue] : RST_Default;
//    CacheDataReturnType returnType = loadingDic[kReturnType] ? [loadingDic[kReturnType] integerValue] : CDRT_FailureReturn;
    
    //Loading
    RequestLoadType loadingType = loadingDic ? [loadingDic[kLoadingType] integerValue] : RLT_None;
    UIView *loadingView = loadingDic[kLoadingView];
    
    if(loadingType != RLT_None){
        if (loadingType == RLT_EmptyLoad) {
            [CommonLoading showEmptyLoadingInView:loadingView];
        }
        else{
            [CommonLoading showOverlayLoadingInView:loadingView];
        }
    }
    
    NSString *serverAdr = kServerAddress;//RST_Default
    
    NSString *urlPath = [serverAdr stringByAppendingString:path];//拼接请求url
    CommonRequest *manager = [CommonRequest manager];
    
    if ([[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus] == AFNetworkReachabilityStatusReachableViaWWAN) {
        [manager.requestSerializer setTimeoutInterval:kWWANRequesTimeOut];
    }
    else{
        [manager.requestSerializer setTimeoutInterval:kCommonRequestTimeOut];
    }
    
    NSDictionary *uploadFiliParams = nil;
    
    NSMutableDictionary *queryParams = nil;
    NSMutableDictionary *postParams = [NSMutableDictionary dictionaryWithDictionary:postParam];
    NSString *cacheKeyStr = urlPath;
    if (serverType == RST_Default) {
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        NSMutableSet *mutSet = [NSMutableSet setWithSet:manager.responseSerializer.acceptableContentTypes];
        [mutSet addObject:@"text/html"];
        manager.responseSerializer.acceptableContentTypes = mutSet;
        
        NSRange foundObj = [urlPath rangeOfString:@"?" options:NSCaseInsensitiveSearch];
        if(foundObj.length > 0){
            urlPath = [urlPath stringByAppendingString:@"&"];
        }else{
            urlPath = [urlPath stringByAppendingString:@"?"];
        }
        urlPath = [urlPath stringByAppendingString:@"key=visitor"];
    }
    
    void (^SuccessBlock)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject){
        if(loadingType != RLT_None){
            [CommonLoading dismissInView:loadingView];
        }
        NSDictionary *jsonDict = nil;
        jsonDict = responseObject;
//         jsonDict=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        success(manager, jsonDict);
    };
    
    void (^FailureBlock)(AFHTTPRequestOperation *, NSError *) = ^(AFHTTPRequestOperation *operation, NSError *error){
        if(loadingType != RLT_None){
            [CommonLoading dismissInView:loadingView];
        }
        failure(manager, error);

    };
    
    
    AFHTTPRequestOperation *operation = nil;
    if ([postParams count]) {
        if (!uploadFiliParams) {
            operation = [manager POST:urlPath
                           parameters:postParams
                              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                  SuccessBlock(operation, responseObject);
                              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                  FailureBlock(operation, error);
                              }];
        }
        else{
            operation = [manager POST:urlPath
                           parameters:postParams
            constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                for (NSString *fileName in [uploadFiliParams allKeys]) {
                    [formData appendPartWithFileData:uploadFiliParams[fileName]
                                                name:fileName
                                            fileName:fileName
                                            mimeType:@"image/jpeg"];
                }
                
            } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                SuccessBlock(operation, responseObject);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                FailureBlock(operation, error);
            }];
        }
    }
    else{
        operation = [manager GET:urlPath
                      parameters:queryParams
                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
                             SuccessBlock(operation, responseObject);
                             
                         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                             FailureBlock(operation, error);
                         }];
    }
    
    return operation;
}

+ (AFHTTPRequestOperation *)requstPath:(NSString *)path
                            loadingDic:(NSDictionary *)loadingDic
                            queryParam:(NSDictionary *)param
                                 cache:(BOOL)cache
                               success:(void (^)(CommonRequest *request,  id jsonDict))success
                               failure:(void (^)(CommonRequest *request, NSError *error))failure
{
    return [self requstPath:path
                 loadingDic:loadingDic
                  postParam:nil
                   getParam:param
                      cache:cache
                    success:success
                    failure:failure];
}


+ (AFHTTPRequestOperation *)requstPath:(NSString *)path
                            loadingDic:(NSDictionary *)loadingDic
                            queryParam:(NSDictionary *)param
                               success:(void (^)(CommonRequest *request,  id jsonDict))success
                               failure:(void (^)(CommonRequest *request, NSError *error))failure
{
    return [self requstPath:path
                 loadingDic:loadingDic
                 queryParam:param
                      cache:NO
                    success:success
                    failure:failure];
}

+ (AFHTTPRequestOperation *)requstPath:(NSString *)path
                            loadingDic:(NSDictionary *)loadingDic
                             postParam:(NSDictionary *)param
                               success:(void (^)(CommonRequest *request,  id jsonDict))success
                               failure:(void (^)(CommonRequest *request, NSError *error))failure
{
    return [self requstPath:path
                 loadingDic:loadingDic
                  postParam:param
                   getParam:nil
                      cache:NO
                    success:success
                    failure:failure];
}


#pragma mark - download
+ (AFHTTPRequestOperation *)download:(NSString *)urlStr toPath:(NSString *)filePath progressBlock:(void (^)(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead))grogressBlock complete:(CompleteBlock)complete
{
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.inputStream  = [NSInputStream inputStreamWithURL:url];
    operation.outputStream = [NSOutputStream outputStreamToFileAtPath:filePath append:NO];
    [operation setDownloadProgressBlock:grogressBlock];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (complete) {
            complete(YES);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (complete) {
            complete(NO);
        }
    }];
    [operation start];
    return operation;
}

+ (AFHTTPRequestOperation *)pauseDownload:(NSString *)urlStr toPath:(NSString *)filePath downloadedByte:(unsigned long long)downloadedByte progressBlock:(void (^)(NSUInteger, long long, long long))grogressBlock complete:(CompleteBlock)complete
{
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //检查文件是否已经下载了一部分
    if (downloadedByte > 0) {
        NSMutableURLRequest *mutableURLRequest = [request mutableCopy];
        NSString *requestRange = [NSString stringWithFormat:@"bytes=%llu-", downloadedByte];
        [mutableURLRequest setValue:requestRange forHTTPHeaderField:@"Range"];
        request = mutableURLRequest;
    }
    
    //关闭缓存
    [[NSURLCache sharedURLCache] removeCachedResponseForRequest:request];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.inputStream  = [NSInputStream inputStreamWithURL:url];
    operation.outputStream = [NSOutputStream outputStreamToFileAtPath:filePath append:YES];
    [operation setDownloadProgressBlock:grogressBlock];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (complete) {
            complete(YES);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (complete) {
            complete(NO);
        }
    }];
    [operation start];
    
    return operation;
}

@end
