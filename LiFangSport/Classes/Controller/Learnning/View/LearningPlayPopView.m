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
    
    UIImageView *leftOnePic = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    leftOnePic.backgroundColor = kclearColor;
    leftOnePic.centerY = leftOneLab.centerY;
    leftOnePic.left = leftOneLab.right +20;
    leftOnePic.image = UIImageNamed(@"lppopunselect");//lppopselect
    [_baseDecisionView addSubview:leftOnePic];
    
    UIImageView *leftTwoPic = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    leftTwoPic.backgroundColor = kclearColor;
    leftTwoPic.centerY = leftTwoLab.centerY;
    leftTwoPic.left = leftTwoLab.right +20;
    leftTwoPic.image = UIImageNamed(@"lppopunselect");
    [_baseDecisionView addSubview:leftTwoPic];
    
    UIImageView *leftThreePic = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    leftThreePic.backgroundColor = kclearColor;
    leftThreePic.centerY = leftThreeLab.centerY;
    leftThreePic.left = leftThreeLab.right +20;
    leftThreePic.image = UIImageNamed(@"lppopunselect");
    [_baseDecisionView addSubview:leftThreePic];
    
    UIImageView *leftFourPic = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    leftFourPic.backgroundColor = kclearColor;
    leftFourPic.centerY = leftFourLab.centerY;
    leftFourPic.left = leftFourLab.right +20;
    leftFourPic.image = UIImageNamed(@"lppopunselect");
    [_baseDecisionView addSubview:leftFourPic];
    //右
    UIImageView *rightOnePic = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    rightOnePic.backgroundColor = kclearColor;
    rightOnePic.left = leftOnePic.right +30;
    rightOnePic.top = (kScreenHeight -(3*30+2*20))/2;
    rightOnePic.image = UIImageNamed(@"lppopselect");//lppopselect
    [_baseDecisionView addSubview:rightOnePic];
    
    UIImageView *rightTwoPic = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    rightTwoPic.backgroundColor = kclearColor;
    rightTwoPic.top = rightOnePic.bottom+20;
    rightTwoPic.left = leftOnePic.right +30;
    rightTwoPic.image = UIImageNamed(@"lppopselect");
    [_baseDecisionView addSubview:rightTwoPic];
    
    UIImageView *rightThreePic = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    rightThreePic.backgroundColor = kclearColor;
    rightThreePic.top = rightTwoPic.bottom+20;
    rightThreePic.left = leftOnePic.right +30;
    rightThreePic.image = UIImageNamed(@"lppopselect");
    [_baseDecisionView addSubview:rightThreePic];
    
    UILabel *rightOneLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 20)];
    rightOneLab.backgroundColor = kclearColor;
    rightOneLab.centerY = rightOnePic.centerY;
    rightOneLab.left = rightOnePic.right +20;
    rightOneLab.font = kpoplabfont;
    rightOneLab.textAlignment = NSTextAlignmentLeft;
    rightOneLab.textColor = kwhiteColor;
    rightOneLab.text= @"不给牌";
    [_baseDecisionView addSubview:rightOneLab];

    UILabel *rightTwoLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 20)];
    rightTwoLab.backgroundColor = kclearColor;
    rightTwoLab.centerY = rightTwoPic.centerY;
    rightTwoLab.left = rightOnePic.right +20;
    rightTwoLab.font = kpoplabfont;
    rightTwoLab.textAlignment = NSTextAlignmentLeft;
    rightTwoLab.textColor = kwhiteColor;
    rightTwoLab.text= @"黄牌";
    [_baseDecisionView addSubview:rightTwoLab];
    
    UILabel *rightThreeLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 20)];
    rightThreeLab.backgroundColor = kclearColor;
    rightThreeLab.centerY = rightThreePic.centerY;
    rightThreeLab.left = rightOnePic.right +20;
    rightThreeLab.font = kpoplabfont;
    rightThreeLab.textAlignment = NSTextAlignmentLeft;
    rightThreeLab.textColor = kwhiteColor;
    rightThreeLab.text= @"红牌";
    [_baseDecisionView addSubview:rightThreeLab];
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
