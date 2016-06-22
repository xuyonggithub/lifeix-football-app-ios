//
//  AJMediaRecordTimeHelper.m
//  AJMediaPlayerKit
//
//  Created by Zhangqibin on 15/7/9.
//  Copyright (c) 2015年 zhangyi. All rights reserved.
//

#import "AJMediaRecordTimeHelper.h"
#import "AJFoundation.h"

@interface TimeModel : NSObject

@property (nonatomic, copy) NSString * startTimeString;

@property (nonatomic, copy) NSString * stopTimeString;

@property (NS_NONATOMIC_IOSONLY, readonly) NSInteger calculationTimeInterval;

@end

@implementation TimeModel

- (instancetype)init {
    if (self = [super init]) {
        self.startTimeString = nil;
        self.stopTimeString  = nil;
    }
    return self;
}

- (NSInteger)calculationTimeInterval {
    int distance = 0;
    if (self.startTimeString && self.stopTimeString)
    {
        double startTime = [self.startTimeString doubleValue];
        double endTime = [self.stopTimeString doubleValue];
        distance = (int)((endTime - startTime) * 1000);
    }
    return distance;
}

@end

@implementation AJMediaRecordTimeHelper

+ (instancetype) sharedInstance {
    static dispatch_once_t once;
    static AJMediaRecordTimeHelper * sharedSingleton_;
    dispatch_once(&once, ^ {
        sharedSingleton_ = [[AJMediaRecordTimeHelper alloc] init];
    });
    return sharedSingleton_;
}

- (instancetype)init {
    if (self = [super init]) {
        self.recordTimeDictionary = [NSMutableDictionary dictionary];
        self.appRunId = nil;
    }
    return self;
}

- (void)recordStartTimeWithKey:(NSString *)key {
    NSString *startTimeString = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
    TimeModel *timeModel = [[TimeModel alloc] init];
    [timeModel setStartTimeString:startTimeString];
    [self.recordTimeDictionary setValue:timeModel forKey:key];
}

- (NSInteger)getRecordEndTimeWithKey:(NSString *)key {
    TimeModel *timeModel = [self.recordTimeDictionary valueForKey:key];
    if (timeModel) {
        [self.recordTimeDictionary removeObjectForKey:key];
        NSString *stopTimeString = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
        [timeModel setStopTimeString:stopTimeString];
        NSInteger timeInterval = [timeModel calculationTimeInterval];
        return timeInterval;
    }
    return 0;
}

@end
