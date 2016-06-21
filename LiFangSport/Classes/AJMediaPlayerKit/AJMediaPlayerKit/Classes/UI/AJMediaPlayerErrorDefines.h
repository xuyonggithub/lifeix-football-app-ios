//
//  AJMediaPlayerError.h
//  Pods
//
//  Created by Gang Li on 7/30/15.
//
//

#import <Foundation/Foundation.h>


typedef NS_ENUM (NSInteger, AJMediaPlayerErrorIdentifier) {
    AJMediaPlayerPlayableResourceIDNotProvidedError = 10,       //播放id为空
    AJMediaPlayerCoreServiceError,                              //播放器内核错误
    AJMediaPlayerResourceServiceError,                          //暂未获取到可用视频资源
    AJMediaPlayerAirPlayServiceError,                           //无法完成操作
    AJMediaPlayerCDEServiceOverLoadError,                       //CDE服务器过载
    
    // Errors for identifying Player HTTP client failures
    AJMediaPlayerLocalHTTPClientTimeOutError = 20,              //网络请求超时错误
    AJMediaPlayerLocalHTTPClientNetworkNotConnectedError,       //未接入互联网
    AJMediaPlayerLocalHTTPClientRequestFailedError,             //网络连接失败，请检查网络设置
    AJMediaPlayerLocalHTTPClientResponseJSONParsingError,       //JSON解析错误
    
    // Errors for identifying Proxied API service failures
    AJMediaPlayerProxiedAPINotOKResponseError = 30,             //代理服务器请求非200错误
    AJMediaPlayerProxiedAPIEmptyResponseDataError,              //代理服务器请求数据为空
    AJMediaStreamProxiedAPIInconsistentResponseDataError,       //代理服务器请求数据不一致
    AJMediaPlayerProxiedAPIEmptyStreamMetadataError,            //码流为空
    
    AJMediaPlayerSchedulingNormal = 10000,
    
    ///\see <a href="http://wiki.letv.cn/pages/viewpage.action?pageId=46187090"/>
    // Errors for identifying VRS service failures
    AJMediaPlayerVRSMainLandChinaAreaRestrictionError = 1,      //大陆ip受限-点播 0001
    AJMediaPlayerVRSOverseaAreaRestrictionError,                //0002	海外ip受限-点播
    AJMediaPlayerVRSNoUserTokenProvidedError,                   //0003 用户没有登录
    AJMediaPlayerVRSResourceNotFoundError,                      //0004视频下线或者不存在
    AJMediaPlayerVRSOnDemandVideoLicenseWasLimitedError,        //0005版权限制-点播
    AJMediaPlayerVRSResourceRequiresPaymentError,               //0006付费视频
    AJMediaPlayerVRSResourceForbidden,                          //0007专辑被屏蔽
    
    // Errors for identifying VRS access failures
    AJMediaPlayerVRSWebAPIAccessFailedError = 1001,             //新媒资接口访问失败
    AJMediaPlayerVRSWebAPIAccessTimeoutError,                   //新媒资接口访问超时
    AJMediaPlayerVRSWebAPIAccessInvalidResponseError,           //新媒资接口返回数据错误
    AJMediaPlayerVRSWebAPIAccessUnknownError,                   //新媒资接口访问其它错误
    
    // Errors for identifying Live Control System access failures
    AJMediaPlayerLCSWebAPIAccessFailedError = 2001,             //直播接口访问失败
    AJMediaPlayerLCSWebAPIAccessTimeoutError,                   //直播接口访问超时
    AJMediaPlayerLCSWebAPIAccessInvalidResponseError,           //直播接口返回数据错误
    AJMediaPlayerLCSWebAPIAccessUnknownError,                   //直播接口访问其他错误
    
    // Errors for identifying BOSS access failures
    AJMediaPlayerBOSSWebAPIAccessFailedError = 3001,            //boss接口访问失败
    AJMediaPlayerBOSSWebAPIAccessTimeoutError,                  //boss接口访问超时
    AJMediaPlayerBOSSWebAPIAccessInvalidResponseError,          //boss接口返回数据错误
    AJMediaPlayerBOSSWebAPIAccessUnknownError,                  //boss接口返回数据错误
    AJMediaPlayerBOSSOnDemandVideoAuthenticationFailedError,    //点播鉴权不可看
    AJMediaPlayerBOSSLiveStreamVideoAuthenticationFailedError,  //直播鉴权不可看
    
    AJMediaPlayerUnknownError = -8888,                          //其它异常
};