//
//  LearningPlayPopView.m
//  LiFangSport
//
//  Created by 张毅 on 16/6/23.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import "LearningPlayPopView.h"
#import "NSString+WPAttributedMarkup.h"

@interface LearningPlayPopView ()
@property(nonatomic,strong)UIButton *closeBtn;
@property(nonatomic,strong)UILabel *baseLab;
@property(nonatomic,strong)UIView *baseDecisionView;

@end

@implementation LearningPlayPopView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}

-(void)initSubViews{
    _closeBtn = [[UIButton alloc]initWithFrame:CGRectMake(30, 0, 40, 40)];
    _closeBtn.top = 30;
    _closeBtn.right = self.width-30;
    _closeBtn.backgroundColor = [UIColor clearColor];
    [_closeBtn setImage:UIImageNamed(@"popclose") forState:UIControlStateNormal];
    
    [self addSubview:_closeBtn];
    [_closeBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
}

-(void)close{
    if (self.closeBc) {
        self.closeBc();
    }
}

-(void)addSubviewOfDECISIONType:(VideoSingleInfoModel *)model {
    if (!_baseDecisionView) {
        _baseDecisionView = [[UIView alloc]initWithFrame:CGRectMake(10, 0, kScreenWidth-140, kScreenHeight-60)];
        _baseDecisionView.backgroundColor = kclearColor;
        [self addSubview:_baseDecisionView];
    }
    UIFont *kpoplabfont = [UIFont systemFontOfSize:20];
    UILabel *leftOneLab = [[UILabel alloc]initWithFrame:CGRectMake(100, 60, 100, 20)];
    leftOneLab.top = (kScreenHeight -(3*30+4*20))/2;
    leftOneLab.backgroundColor = kclearColor;
    leftOneLab.font = kpoplabfont;
    leftOneLab.textAlignment = NSTextAlignmentRight;
    leftOneLab.textColor = kwhiteColor;
    leftOneLab.text= @"没有犯规";
    [_baseDecisionView addSubview:leftOneLab];
    
    UILabel *leftTwoLab = [[UILabel alloc]initWithFrame:CGRectMake(100, 60, 100, 20)];
    leftTwoLab.top = leftOneLab.bottom +30;
    leftTwoLab.backgroundColor = kclearColor;
    leftTwoLab.font = kpoplabfont;
    leftTwoLab.textAlignment = NSTextAlignmentRight;
    leftTwoLab.textColor = kwhiteColor;
    leftTwoLab.text= @"间接任意球";
    [_baseDecisionView addSubview:leftTwoLab];
    
    UILabel *leftThreeLab = [[UILabel alloc]initWithFrame:CGRectMake(100, 60, 100, 20)];
    leftThreeLab.top = leftTwoLab.bottom +30;
    leftThreeLab.backgroundColor = kclearColor;
    leftThreeLab.font = kpoplabfont;
    leftThreeLab.textAlignment = NSTextAlignmentRight;
    leftThreeLab.textColor = kwhiteColor;
    leftThreeLab.text= @"直接任意球";
    [_baseDecisionView addSubview:leftThreeLab];
    
    UILabel *leftFourLab = [[UILabel alloc]initWithFrame:CGRectMake(100, 60, 100, 20)];
    leftFourLab.top = leftThreeLab.bottom +30;
    leftFourLab.backgroundColor = kclearColor;
    leftFourLab.font = kpoplabfont;
    leftFourLab.textAlignment = NSTextAlignmentRight;
    leftFourLab.textColor = kwhiteColor;
    leftFourLab.text= @"点球";
    [_baseDecisionView addSubview:leftFourLab];
    
}

-(void)addSubviewOfOtherType{
    if (!_baseLab) {
        _baseLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, kScreenWidth-140, kScreenHeight-60)];
        _baseLab.centerY = self.centerY;
        _baseLab.backgroundColor = kclearColor;
        _baseLab.font = [UIFont systemFontOfSize:20*kScreenRatioBase6Plus];
        _baseLab.textAlignment = NSTextAlignmentLeft;
        _baseLab.textColor = kwhiteColor;
        _baseLab.numberOfLines = 0;
        [self addSubview:_baseLab];
    }
}

-(void)setModel:(VideoSingleInfoModel *)model WithType:(LearningPlayPopViewType)type{
    if (model) {
        if (type==LPPOP_DECISION) {//判罚
            [self addSubviewOfDECISIONType:model];
            _baseDecisionView.hidden = NO;
            _baseLab.hidden = YES;
        }else{//其他
            [self addSubviewOfOtherType];
            _baseLab.hidden = NO;
            _baseDecisionView.hidden = YES;
            NSDictionary *detstyleDic = @{@"bigFont":[UIFont systemFontOfSize:12],@"color":HEXRGBCOLOR(0x787878)};
            if (type == LPPOP_FACTORS){
                [_baseLab setAttributedText:[model.considerations attributedStringWithStyleBook:detstyleDic]];
            }else if (type==LPPOP_DETAIL){
                [_baseLab setAttributedText:[model.explanation attributedStringWithStyleBook:detstyleDic]];
            }else if (type==LPPOP_RULE){
                [_baseLab setAttributedText:[model.rule attributedStringWithStyleBook:detstyleDic]];
            }
            [_baseLab sizeToFit];
        }
    }
}

@end
