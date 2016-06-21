//
//  AJMediaPlayerUtilities.m
//  AJMediaPlayerDemo
//
//  Created by le_cui on 15/6/11.
//  Copyright (c) 2015年 Lesports Inc. All rights reserved.
//

#import "AJMediaPlayerUtilities.h"
#import "AJMediaPlayerErrorDefines.h"

extern NSString * aj_getFormattedCurrentSystemTime();

static NSDictionary * kAJMediaPlayerErrorInfoDictionary;
static NSDictionary * kAJMediaPlayerHumanReadableQualityNameDictionary;
@implementation AJMediaPlayerUtilities

+(void)load {
    ///\see <a href="http://wiki.letv.cn/pages/viewpage.action?pageId=46187090"/>
    kAJMediaPlayerErrorInfoDictionary = @{ @(AJMediaPlayerPlayableResourceIDNotProvidedError) : AJLocalizedString(@"播放id为空"),
                                           @(AJMediaPlayerCoreServiceError) : AJLocalizedString(@"播放器内核错误"),
                                           @(AJMediaPlayerResourceServiceError) : AJLocalizedString(@"暂未获取到可用视频资源"),
                                           @(AJMediaPlayerAirPlayServiceError) : AJLocalizedString(@"无法完成操作"),
                                           @(AJMediaPlayerCDEServiceOverLoadError) : AJLocalizedString(@"CDE服务器过载"),
                                           
                                           @(AJMediaPlayerLocalHTTPClientTimeOutError) : AJLocalizedString(@"网络请求超时错误"),
                                           @(AJMediaPlayerLocalHTTPClientNetworkNotConnectedError) : AJLocalizedString(@"未接入互联网"),
                                           @(AJMediaPlayerLocalHTTPClientRequestFailedError) : AJLocalizedString(@"网络连接失败，请检查网络设置"),
                                           @(AJMediaPlayerLocalHTTPClientResponseJSONParsingError) : AJLocalizedString(@"JSON解析错误"),
                                           
                                           @(AJMediaPlayerProxiedAPINotOKResponseError) : AJLocalizedString(@"代理服务器请求非200错误"),
                                           @(AJMediaPlayerProxiedAPIEmptyResponseDataError) : AJLocalizedString(@"代理服务器请求数据为空"),
                                           @(AJMediaStreamProxiedAPIInconsistentResponseDataError) : AJLocalizedString(@"代理服务器请求数据不一致"),
                                           @(AJMediaPlayerProxiedAPIEmptyStreamMetadataError) : AJLocalizedString(@"码流为空"),
                                           
                                           @(AJMediaPlayerSchedulingNormal) : AJLocalizedString(@"正常"),
                                           
                                           @(AJMediaPlayerVRSMainLandChinaAreaRestrictionError) : AJLocalizedString(@"大陆ip受限-点播"),
                                           @(AJMediaPlayerVRSOverseaAreaRestrictionError) : AJLocalizedString(@"海外ip受限-点播"),
                                           @(AJMediaPlayerVRSNoUserTokenProvidedError) : AJLocalizedString(@"用户没有登录"),
                                           @(AJMediaPlayerVRSResourceNotFoundError) : AJLocalizedString(@"视频下线或者不存在"),
                                           @(AJMediaPlayerVRSOnDemandVideoLicenseWasLimitedError) : AJLocalizedString(@"版权限制-点播"),
                                           @(AJMediaPlayerVRSResourceRequiresPaymentError) : AJLocalizedString(@"付费视频"),
                                           @(AJMediaPlayerVRSResourceForbidden) : AJLocalizedString(@"专辑被屏蔽"),
                                           @(AJMediaPlayerVRSWebAPIAccessFailedError) : AJLocalizedString(@"新媒资接口访问失败"),
                                           @(AJMediaPlayerVRSWebAPIAccessTimeoutError) : AJLocalizedString(@"新媒资接口访问超时"),
                                           @(AJMediaPlayerVRSWebAPIAccessInvalidResponseError) : AJLocalizedString(@"新媒资接口返回数据错误"),
                                           @(AJMediaPlayerVRSWebAPIAccessUnknownError) : AJLocalizedString(@"新媒资接口访问其它错误"),
        
                                           @(AJMediaPlayerLCSWebAPIAccessFailedError) : AJLocalizedString(@"直播接口访问失败"),
                                           @(AJMediaPlayerLCSWebAPIAccessTimeoutError) : AJLocalizedString(@"直播接口访问超时"),
                                           @(AJMediaPlayerLCSWebAPIAccessInvalidResponseError) : AJLocalizedString(@"直播接口返回数据错误"),
                                           @(AJMediaPlayerLCSWebAPIAccessUnknownError) : AJLocalizedString(@"直播接口访问其他错误"),
                                           
                                           @(AJMediaPlayerBOSSWebAPIAccessFailedError) : AJLocalizedString(@"boss接口访问失败"),
                                           @(AJMediaPlayerBOSSWebAPIAccessTimeoutError) : AJLocalizedString(@"boss接口访问超时"),
                                           @(AJMediaPlayerBOSSWebAPIAccessInvalidResponseError) : AJLocalizedString(@"boss接口返回数据错误"),
                                           @(AJMediaPlayerBOSSWebAPIAccessUnknownError) : AJLocalizedString(@"boss接口返回数据错误"),
                                           @(AJMediaPlayerBOSSOnDemandVideoAuthenticationFailedError) : AJLocalizedString(@"点播鉴权不可看"),
                                           @(AJMediaPlayerBOSSLiveStreamVideoAuthenticationFailedError) : AJLocalizedString(@"直播鉴权不可看"),
                                           @(AJMediaPlayerUnknownError) : AJLocalizedString(@"其它异常")
                                           };
    kAJMediaPlayerHumanReadableQualityNameDictionary = @{
                                                         kAJMediaStreamLiveQualityFLV350 : AJLocalizedString(@"流畅"),
                                                         kAJMediaStreamLiveQualityFLV1000 : AJLocalizedString(@"标清"),
                                                         kAJMediaStreamLiveQualityFLV1300 : AJLocalizedString(@"高清"),
                                                         kAJMediaStreamLiveQualityFLV720p : AJLocalizedString(@"超清"),
                                                         kAJMediaStreamLiveQualityFLV1080p : AJLocalizedString(@"1080P"),
                                                         
                                                         kAJMediaStreamVODQualityMP4180 : AJLocalizedString(@"极速"),
                                                         kAJMediaStreamVODQualityMP4350 : AJLocalizedString(@"流畅"),
                                                         kAJMediaStreamVODQualityMP4800 : AJLocalizedString(@"标清"),
                                                         kAJMediaStreamVODQualityMP41300 : AJLocalizedString(@"高清"),
                                                         kAJMediaStreamVODQualityMP4720p : AJLocalizedString(@"超清"),
                                                         kAJMediaStreamVODQualityMP41080p : AJLocalizedString(@"1080P"),
                                                         };
}

+(NSString *)localizedDetailMessages:(AJMediaPlayerErrorIdentifier) errorIdentifier {
    NSString *localizedDetailMessages = kAJMediaPlayerErrorInfoDictionary[@(errorIdentifier)];
    if (!localizedDetailMessages) {
#if DEBUG
        localizedDetailMessages = AJLocalizedString(@"N/A (需要补充)");
#else
        localizedDetailMessages = AJLocalizedString(@"未知错误");
#endif
    }
    return localizedDetailMessages;
}


+(NSString *)humanReadableTitleWithQualityName:(AJMediaStreamQualityName *)qualityName {
    return kAJMediaPlayerHumanReadableQualityNameDictionary[qualityName];
}

+ (NSString*)convertUtf:(NSString*)str_utf8
{
    NSString * _convert_str = nil;
    @try
    {
        _convert_str = [str_utf8 stringByReplacingOccurrencesOfString:@"\\U" withString:@"\\u"];
        _convert_str = [_convert_str stringByReplacingOccurrencesOfString:@"\\n" withString:@"\\u000A"];
        NSMutableString * _mutable_str = [NSMutableString stringWithFormat:@"%@",_convert_str];
        CFStringTransform((CFMutableStringRef)_mutable_str, NULL,  (CFStringRef)@"Any-Hex/Java", true);
        _convert_str = [_mutable_str stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    }
    @catch (NSException *exception)
    {
        _convert_str = nil;
    }
    @finally
    {
        return _convert_str;
    }
}

///MARK: Logging stuff

+(NSAttributedString *)attributeStringWithTypeIdentifier:(NSString *)identifier message:(NSString *)message {
    UIColor *markColor = nil;
    if ([identifier isEqualToString:@"DEBUG"]) {
        markColor = [UIColor greenColor];
    } else if ([identifier isEqualToString:@"WARN"]) {
        markColor = [UIColor orangeColor];
    } else if ([identifier isEqualToString:@"ERROR"]) {
        markColor = [UIColor redColor];
    } else {
        markColor = [UIColor whiteColor];
    }
    NSMutableAttributedString *logging = [[NSMutableAttributedString alloc] initWithString:@"INFO:" attributes: @{NSForegroundColorAttributeName: markColor, NSFontAttributeName : [UIFont boldSystemFontOfSize:10.f]}];
    NSString *extra = [NSString stringWithFormat:@"[%@]-%@\n", aj_getFormattedCurrentSystemTime(), message];
    NSAttributedString *attributedMessage = [[NSAttributedString alloc] initWithString:extra attributes: @{NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName : [UIFont italicSystemFontOfSize:10.f]}];
    [logging appendAttributedString:attributedMessage];
    return logging;
}


+(NSAttributedString *)infoWithString:(NSString *)infoString {
    return [self.class attributeStringWithTypeIdentifier:@"INFO" message:infoString];
}

+(NSAttributedString *)debugWithString:(NSString *)debugString {
    return [self.class attributeStringWithTypeIdentifier:@"DEBUG" message:debugString];
}

+(NSAttributedString *)warningWithString:(NSString *)warningString {
    return [self.class attributeStringWithTypeIdentifier:@"WARN" message:warningString];
}

+(NSAttributedString *)errorWithString:(NSString *)errorString {
    return [self.class attributeStringWithTypeIdentifier:@"ERROR" message:errorString];
}

+ (NSString *)translateToHHMMSSText:(NSTimeInterval)totalTime {
    int time = (int)floor(totalTime);
    int hour = time/3600;
    int munites = time%3600/60;
    int second = time%3600%60;
    return [NSString stringWithFormat:@"%02d:%02d:%02d", hour, munites, second];
}

+ (NSString *)translateToMMSSText:(NSTimeInterval)totalTime {
    int time = (int)floor(totalTime);
    int munites = time%3600/60;
    int second = time%3600%60;
    return [NSString stringWithFormat:@"%02d:%02d", munites, second];
}
@end

void aj_setCurrentUserStreamItem(NSString* stream,BOOL islive){
    
    if (stream && [stream isKindOfClass:[NSString class]]) {
        [[NSUserDefaults standardUserDefaults] setValue:stream forKey:[NSString stringWithFormat:@"%@%d",@"current_User_Stream",islive]];
    }
}
NSString *aj_getCurrentUserStreamItem(BOOL islive){
    NSString *steam =  [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@%d",@"current_User_Stream",islive]];
    return steam;
}
    
NSString * aj_getFormattedCurrentSystemTime(){
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.sss"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT+08:00"]]; // 取北京时间
    NSString *dateTimeString = [formatter stringFromDate:[NSDate date]];
    return dateTimeString;
}

@implementation UIColor (HTML)
+(UIColor *)colorWithHTMLColorMark:(NSString *)hexColorString {
    return [UIColor colorWithHTMLColorMark:hexColorString alpha:1.f];
}

+(UIColor *)colorWithHTMLColorMark:(NSString *)hexColorString alpha:(CGFloat)alpha {
    if ([hexColorString length] <6){//长度不合法
        return [UIColor blackColor];
    }
    NSString *tempString=[hexColorString lowercaseString];
    if ([tempString hasPrefix:@"0x"]){//检查开头是0x
        tempString = [tempString substringFromIndex:2];
    }else if ([tempString hasPrefix:@"#"]){//检查开头是#
        tempString = [tempString substringFromIndex:1];
    }
    if ([tempString length] !=6){
        return [UIColor blackColor];
    }
    //分解三种颜色的值
    NSRange range;
    range.location =0;
    range.length =2;
    NSString *rString = [tempString substringWithRange:range];
    range.location =2;
    NSString *gString = [tempString substringWithRange:range];
    range.location =4;
    NSString *bString = [tempString substringWithRange:range];
    //取三种颜色值
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString]scanHexInt:&r];
    [[NSScanner scannerWithString:gString]scanHexInt:&g];
    [[NSScanner scannerWithString:bString]scanHexInt:&b];
    return [UIColor colorWithRed:((float) r /255.0f)
                           green:((float) g /255.0f)
                            blue:((float) b /255.0f)
                           alpha:alpha];
}

@end

@implementation UIImage (UIColorCreation)
+(UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

@end

@implementation NSDate (AJMediaPlayerKit)

+ (instancetype)dateFromString:(NSString *)dateString timeZone:(NSTimeZone *)timeZone {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    if (timeZone) {
        [dateFormatter setTimeZone:timeZone];
    }
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    return destDate;
}

@end
