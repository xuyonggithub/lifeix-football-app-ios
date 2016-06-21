//
//  AJMediaRecordTimeHelper.h
//  AJMediaPlayerKit
//
//  Created by lixiang on 15/7/9.
//  Copyright (c) 2015年 Lesports Inc. All rights reserved.
//

@import Foundation;

@interface AJMediaRecordTimeHelper : NSObject

/**
 *  存储时间字典
 */
@property (nonatomic, strong) NSMutableDictionary *recordTimeDictionary;
/**
 *  每次启动时生成的唯一标识,用于乐视大数据统计
 */
@property(nonatomic, copy)NSString *appRunId;
/**
 *  统计事件间隔时间Helper单例
 *
 *  @return 返回Helper
 */
+ (instancetype)sharedInstance;
/**
 *  统计事件开始时间点
 *
 *  @param key
 */
- (void)recordStartTimeWithKey:(NSString *)key;
/**
 *  统计事件结束并得到时间间隔
 *
 *  @param key
 *
 *  @return 返回时间间隔
 */
- (NSInteger)getRecordEndTimeWithKey:(NSString *)key;

@end
