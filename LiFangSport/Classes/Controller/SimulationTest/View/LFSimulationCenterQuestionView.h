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

- (void)nextTest;
- (void)quitQuestionTest;

@end

@interface LFSimulationCenterQuestionView : UIView

@property (nonatomic, assign) id <LFSimulationCenterQuestionViewDelegate> delegate;

- (void)refreshWithModel:(LFSimulationQuestionModel *)model andIsEnd:(BOOL)isEnd;

@end
