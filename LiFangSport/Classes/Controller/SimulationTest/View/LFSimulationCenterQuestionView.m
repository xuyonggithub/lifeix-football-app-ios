//
//  LFSimulationCenterQuestionView.m
//  LiFangSport
//
//  Created by Zhangqibin on 16/6/22.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import "LFSimulationCenterQuestionView.h"

@interface LFSimulationCenterQuestionView ()
{
    UIButton *_startBtn;
}
@end

@implementation LFSimulationCenterQuestionView
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor blueColor];
        
        __weak typeof(self) weakSelf = self;
        
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(closeBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeBtn];
        [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(10);
            make.right.equalTo(self.mas_right).offset(-20);
            make.width.and.height.equalTo(@50);
        }];
        
        _startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_startBtn setTitle:@"下一题" forState:UIControlStateNormal];
        [_startBtn addTarget:self action:@selector(startBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_startBtn];
        
        [_startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf);
            make.bottom.equalTo(weakSelf.mas_bottom).offset(-50);
        }];
    }
    return self;
}

- (void)refreshWithModel:(LFSimulationQuestionModel *)model andIsEnd:(BOOL)isEnd
{
    if (isEnd) {
        [_startBtn setTitle:@"继续挑战" forState:UIControlStateNormal];
    }
}

- (void)startBtnTouched:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(nextTest)]) {
        [self.delegate nextTest];
    }
}

- (void)closeBtnTouched:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(quitQuestionTest)]) {
        [self.delegate quitQuestionTest];
    }
}


@end
