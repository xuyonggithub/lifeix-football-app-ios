//
//  AJMediaPlayerUtilities.h
//  AJMediaPlayerDemo
//
//  Created by le_cui on 15/6/11.
//  Copyright (c) 2015年 Lesports Inc. All rights reserved.
//

@import Foundation;
#import "AJMediaPlayerHeaders.h"
#import "AJMediaPlayerErrorDefines.h"

extern void aj_setCurrentUserStreamItem(NSString* stream,BOOL islive);
extern NSString *aj_getCurrentUserStreamItem(BOOL islive);

@interface AJMediaPlayerUtilities : NSObject
+(NSString *)humanReadableTitleWithQualityName:(AJMediaStreamQualityName *)qualityName;
+(NSString *)localizedDetailMessages:(AJMediaPlayerErrorIdentifier) errorIdentifier;
@end

@interface AJMediaPlayerUtilities (Logging)

+(NSAttributedString *)infoWithString:(NSString *)infoString;
+(NSAttributedString *)debugWithString:(NSString *)debugString;
+(NSAttributedString *)warningWithString:(NSString *)warningString;
+(NSAttributedString *)errorWithString:(NSString *)errorString;

@end


@interface AJMediaPlayerUtilities (DateFormatter)
+ (NSString *)translateToHHMMSSText:(NSTimeInterval)totalTime;
+ (NSString *)translateToMMSSText:(NSTimeInterval)totalTime;

@end

@interface UIImage (UIColorCreation)
+(UIImage *)imageWithColor:(UIColor *)color;
@end

@interface UIColor (HTML)
+(UIColor *)colorWithHTMLColorMark:(NSString *)hexColorString;
+(UIColor *)colorWithHTMLColorMark:(NSString *)hexColorString alpha:(CGFloat)alpha;
@end

@interface NSDate (AJMediaPlayerKit)
+(instancetype)dateFromString:(NSString *)dateString timeZone:(NSTimeZone *)timeZone;
@end