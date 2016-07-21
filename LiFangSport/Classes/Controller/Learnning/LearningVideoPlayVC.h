//
//  LearningVideoPlayVC.h
//  LiFangSport
//
//  Created by 张毅 on 16/6/22.
//  Copyright © 2016年 zhangyi. All rights reserved.
//
//  规则培训播放器

#import "BaseVC.h"

@interface LearningVideoPlayVC : BaseVC

@property (nonatomic, copy) NSString *videoId;
@property (nonatomic, strong) NSArray *videosArr;
@property (nonatomic, assign) NSInteger pageCount;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, copy) NSString *categoryID;
@property (nonatomic, copy) NSString *isOffsideHard;

@end
