//
//  VideoLearningDetVC.h
//  LiFangSport
//
//  Created by 张毅 on 16/6/16.
//  Copyright © 2016年 zhangyi. All rights reserved.
//
//  规则培训----视频列表

#import "BaseVC.h"

@interface VideoLearningDetVC : BaseVC

@property (nonatomic, assign) NSInteger learningType;
@property (nonatomic, copy) NSString *titleStr;
@property (nonatomic, strong) NSArray *catsArr;

@end
