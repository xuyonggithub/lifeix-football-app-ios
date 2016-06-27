//
//  LFSimulationCenterQuestionView.h
//  LiFangSport
//
//  Created by Zhangqibin on 16/6/22.
//  Copyright © 2016年 zhangyi. All rights reserved.
//
//  模拟测试答题界面

#import <Foundation/Foundation.h>
#import "LFSimulationQuestionModel.h"

@protocol LFSimulationCenterQuestionViewDelegate <NSObject>

- (void)questionViewNextQuestion;
- (void)questionViewQuitQuesiotn;

@end

typedef NS_ENUM(NSInteger, LFQuestionMode){
    LFQuestionModeDefaultFoul = 0,     // 犯规
    LFQuestionModeDefaultOffsideEasy,   //  越位容易
    LFQuestionModeDefaultOffsideHard    //  越位复杂
};

@interface LFSimulationCenterQuestionView : UIView

@property (nonatomic, assign) id <LFSimulationCenterQuestionViewDelegate> delegate;

- (instancetype)initWithQuestionMode:(LFQuestionMode)questionMode questionCnt:(NSInteger)questionCnt;

- (void)refreshWithModel:(LFSimulationQuestionModel *)questionModel;
- (void)refreshLastContentView;

@end
