//
//  LFSimulationCenterPromptView.m
//  LiFangSport
//
//  Created by Zhangqibin on 16/6/22.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import "LFSimulationCenterPromptView.h"

@implementation LFSimulationCenterPromptView

- (instancetype)initWithModel:(LFSimulationCategoryModel *)model
{
    self = [super init];
    if (self) {
        UITextView *promptLabel = [UITextView new];
        promptLabel.font = [UIFont systemFontOfSize:25];
        promptLabel.editable = NO;
        promptLabel.selectable = NO;
        [self addSubview:promptLabel];
        [promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(60);
            make.left.equalTo(self.mas_left).offset(230);
            make.right.equalTo(self.mas_right).offset(-230);
            make.bottom.equalTo(self.mas_bottom).offset(-100);
        }];
        
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(closeBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeBtn];
        [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(10);
            make.right.equalTo(self.mas_right).offset(-20);
            make.width.and.height.equalTo(@50);
        }];
        
        UIButton *startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        startBtn.tag = 200;
        [startBtn addTarget:self action:@selector(startBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:startBtn];
        
        if (model.subArray.count > 0) {
            promptLabel.text = [model.subArray[0] text];
            
            [startBtn setTitle:[model.subArray[0] name] forState:UIControlStateNormal];
            [startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(promptLabel.mas_centerX).offset(-90);
                make.bottom.equalTo(self.mas_bottom).offset(-50);
            }];
            
            
            for (NSInteger i = 1; i < model.subArray.count; i++) {
                LFSimulationCategoryModel *subModel = model.subArray[i];
                UIButton *otherBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                otherBtn.tag = 200 + i;
                [otherBtn setTitle:subModel.name forState:UIControlStateNormal];
                [otherBtn addTarget:self action:@selector(startBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:otherBtn];

                [otherBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(promptLabel.mas_centerX).offset(90);
                    make.bottom.equalTo(self.mas_bottom).offset(-50);
                }];
            }
        }else {
            promptLabel.text = model.text;
            [startBtn setTitle:@"开始测试" forState:UIControlStateNormal];
            [startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(promptLabel);
                make.bottom.equalTo(self.mas_bottom).offset(-50);
            }];
        }
        
//        NSMutableParagraphStyle *contentParagraphStyle = [[NSMutableParagraphStyle alloc] init];
//        contentParagraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
//        contentParagraphStyle.lineSpacing = 6;
//        contentParagraphStyle.alignment = NSTextAlignmentJustified;
//        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:promptLabel.text];
//        [attributedString addAttribute:NSParagraphStyleAttributeName value:contentParagraphStyle range:NSMakeRange(0, promptLabel.text.length)];
//        [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, promptLabel.text.length)];
//        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, promptLabel.text.length)];
//        [attributedString addAttribute:NSKernAttributeName value:@0.5 range:NSMakeRange(0, promptLabel.text.length)];
//        promptLabel.attributedText = attributedString;
    }
    return self;
}

- (void)startBtnTouched:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if (self.delegate && [self.delegate respondsToSelector:@selector(startTest:)]) {
        [self.delegate startTest:btn.tag - 200];
    }
}

- (void)closeBtnTouched:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(quitTest)]) {
        [self.delegate quitTest];
    }
}

@end
