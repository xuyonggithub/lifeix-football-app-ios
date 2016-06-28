//
//  LearningPlayControlView.h
//  LiFangSport
//
//  Created by 张毅 on 16/6/23.
//  Copyright © 2016年 zhangyi. All rights reserved.
//
#import "VideoSingleInfoModel.h"
#import <UIKit/UIKit.h>
typedef void(^LearningPlayControlViewBlock)(void);

@interface LearningPlayControlView : UIView
@property (nonatomic, copy) LearningPlayControlViewBlock replayBlock;
@property (nonatomic, copy) LearningPlayControlViewBlock factorsBlock;
@property (nonatomic, copy) LearningPlayControlViewBlock decisionBlock;
@property (nonatomic, copy) LearningPlayControlViewBlock detailBlock;
@property (nonatomic, copy) LearningPlayControlViewBlock ruleBlock;
@property (nonatomic, strong) VideoSingleInfoModel *model;

-(instancetype)initWithFrame:(CGRect)frame WithModel:(VideoSingleInfoModel *)model;

@end

