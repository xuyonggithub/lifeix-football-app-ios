//
//  LFSimulationCenterPromptView.h
//  LiFangSport
//
//  Created by Zhangqibin on 16/6/22.
//  Copyright © 2016年 zhangyi. All rights reserved.
//
//  模拟测试提示View

#import <UIKit/UIKit.h>
#import "LFSimulationCategoryModel.h"

@protocol LFSimulationCenterPromptViewDelegate <NSObject>

- (void)promptViewStartTesting:(NSInteger)modeIndex;
- (void)promptViewQuitTesting;

@end

@interface LFSimulationCenterPromptView : UIView

@property (nonatomic, assign) id <LFSimulationCenterPromptViewDelegate> delegate;

- (instancetype)initWithModel:(LFSimulationCategoryModel *)model;

- (void)hiddenLoadingView;

@end
