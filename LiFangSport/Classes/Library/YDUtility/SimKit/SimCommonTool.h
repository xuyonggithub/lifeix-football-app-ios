//
//  SimCommonTool.h
//  TKnowBox
//
//  Created by Xubin Liu on 14-9-17.
//  Copyright (c) 2014年 Xubin Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^GrantedBlock)(BOOL granted);

#define DateFromString(string, format)  [SimCommonTool dateFromString:string format:format]
#define StringFromDate(date, format)    [SimCommonTool stringFromDate:date format:format]

@interface SimCommonTool : NSObject

+ (BOOL)skipICloud:(NSString*)urlString;
+ (void)checkRecordPermission:(GrantedBlock)grantedBlock;

+ (void)saveStatusBarStyle;
+ (void)restoreStatusBarStyle;

+ (CGFloat)visibleKeyboardHeight;

+ (NSDate *)dateFromString:(NSString *)string format:(NSString *)format;
+ (NSString *)stringFromDate:(NSDate *)date format:(NSString *)format;


uint64_t NanosecondsFromTimeInterval(uint64_t timeInterval);
uint64_t tickCountOfCPU(void);

NSString * mdsString(NSString *string);

@end
