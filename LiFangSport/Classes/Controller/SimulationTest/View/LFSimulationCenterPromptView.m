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

        UIImageView *bgImageView = [UIImageView new];
        [bgImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",kQiNiuHeaderPathPrifx,@"mobile/",model.image]]];
        [self addSubview:bgImageView];
        [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        UIView *bgView= [UIImageView new];
        bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        [self addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        UITextView *textView = [UITextView new];
        textView.font = [UIFont systemFontOfSize:17];
        textView.backgroundColor = [UIColor clearColor];
        textView.editable = NO;
        textView.selectable = NO;
        [self addSubview:textView];
        [textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(55);
            make.left.equalTo(self.mas_left).offset(100);
            make.right.equalTo(self.mas_right).offset(-100);
            make.bottom.equalTo(self.mas_bottom).offset(-100);
        }];
        
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeBtn setImage:[UIImage imageNamed:@"popclose"] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(closeBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeBtn];
        [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(20);
            make.right.equalTo(self.mas_right).offset(-30);
            make.width.and.height.equalTo(@50);
        }];
        
        UIButton *startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        startBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        startBtn.layer.cornerRadius = 5;
        startBtn.layer.masksToBounds = YES;
        startBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        startBtn.layer.borderWidth = 1;
        [startBtn addTarget:self action:@selector(startBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:startBtn];
        
        NSString *string = nil;
        
        if (model.subArray.count > 0) {
            startBtn.tag = 201;
            string = [model.subArray[0] text];
            
            [startBtn setTitle:[model.subArray[0] name] forState:UIControlStateNormal];
            [startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(textView.mas_centerX).offset(-90);
                make.bottom.equalTo(self.mas_bottom).offset(-50);
                make.width.equalTo(@130);
                make.height.equalTo(@45);
            }];
            
            for (NSInteger i = 1; i < model.subArray.count; i++) {
                LFSimulationCategoryModel *subModel = model.subArray[i];
                UIButton *otherBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                otherBtn.tag = 201 + i;
                otherBtn.layer.cornerRadius = 5;
                otherBtn.layer.masksToBounds = YES;
                otherBtn.layer.borderColor = [UIColor whiteColor].CGColor;
                otherBtn.layer.borderWidth = 1;
                [otherBtn setTitle:subModel.name forState:UIControlStateNormal];
                [otherBtn addTarget:self action:@selector(startBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:otherBtn];

                [otherBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(textView.mas_centerX).offset(90);
                    make.bottom.equalTo(self.mas_bottom).offset(-50);
                    make.width.equalTo(@130);
                    make.height.equalTo(@45);
                }];
            }
        }else {
            startBtn.tag = 200;
            string = model.text;
            [startBtn setTitle:@"开始测试" forState:UIControlStateNormal];
            [startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(textView);
                make.bottom.equalTo(self.mas_bottom).offset(-50);
                make.width.equalTo(@130);
                make.height.equalTo(@45);
            }];
        }
        
        NSMutableParagraphStyle *contentParagraphStyle = [[NSMutableParagraphStyle alloc] init];
        contentParagraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        contentParagraphStyle.lineSpacing = 6;
        contentParagraphStyle.alignment = NSTextAlignmentJustified;
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string attributes:[NSDictionary dictionaryWithObjectsAndKeys:contentParagraphStyle, NSParagraphStyleAttributeName, [UIFont systemFontOfSize:18], NSFontAttributeName, [UIColor whiteColor], NSForegroundColorAttributeName, @0.5, NSKernAttributeName, nil]];
        textView.attributedText = attributedString;
    }
    return self;
}

- (void)startBtnTouched:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if (self.delegate && [self.delegate respondsToSelector:@selector(promptViewStartTesting:)]) {
        [self.delegate promptViewStartTesting:btn.tag - 200];
    }
}

- (void)closeBtnTouched:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(promptViewQuitTesting)]) {
        [self.delegate promptViewQuitTesting];
    }
}

@end
