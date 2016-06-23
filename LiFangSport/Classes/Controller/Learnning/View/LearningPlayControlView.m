//
//  LearningPlayControlView.m
//  LiFangSport
//
//  Created by 张毅 on 16/6/23.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import "LearningPlayControlView.h"

@interface LearningPlayControlView ()
@property(nonatomic,strong)UILabel *rePlayLab;
@property(nonatomic,strong)UILabel *factorsLab;
@property(nonatomic,strong)UILabel *decisionLab;
@property(nonatomic,strong)UILabel *detailLab;
@property(nonatomic,strong)UILabel *ruleLab;

@end

@implementation LearningPlayControlView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kclearColor;
        [self initSubViews];
    }
    return self;
}

-(void)initSubViews{
    NSInteger labHeight = (self.height - 20)/5;
    UIFont *textFont = [UIFont systemFontOfSize:22];
    UIColor *labBackColor = HEXRGBACOLOR(0xffffff,0.2);
    _rePlayLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.width, labHeight)];
    _rePlayLab.backgroundColor = labBackColor;
    _rePlayLab.text = @"重放";
    _rePlayLab.font = textFont;
    _rePlayLab.textColor = kwhiteColor;
    _rePlayLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_rePlayLab];
    _rePlayLab.userInteractionEnabled = YES;
    UITapGestureRecognizer *rePlayLabtap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rePlayLabtap)];
    [_rePlayLab addGestureRecognizer:rePlayLabtap];
    
    _factorsLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.width, labHeight)];
    _factorsLab.top = _rePlayLab.bottom + 5;
    _factorsLab.backgroundColor = labBackColor;
    _factorsLab.text = @"考虑因素";
    _factorsLab.font = textFont;
    _factorsLab.textColor = kwhiteColor;
    _factorsLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_factorsLab];
    _factorsLab.userInteractionEnabled = YES;
    UITapGestureRecognizer *factorsLabtap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(factorsLabtap)];
    [_factorsLab addGestureRecognizer:factorsLabtap];
    
    _decisionLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.width, labHeight)];
    _decisionLab.top = _factorsLab.bottom + 5;
    _decisionLab.backgroundColor = labBackColor;
    _decisionLab.text = @"判罚";
    _decisionLab.font = textFont;
    _decisionLab.textColor = kwhiteColor;
    _decisionLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_decisionLab];
    _decisionLab.userInteractionEnabled = YES;
    UITapGestureRecognizer *decisionLabtap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(decisionLabtap)];
    [_decisionLab addGestureRecognizer:decisionLabtap];
    
    _detailLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.width, labHeight)];
    _detailLab.top = _decisionLab.bottom + 5;
    _detailLab.backgroundColor = labBackColor;
    _detailLab.text = @"说明";
    _detailLab.font = textFont;
    _detailLab.textColor = kwhiteColor;
    _detailLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_detailLab];
    _detailLab.userInteractionEnabled = YES;
    UITapGestureRecognizer *detailLabtap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(detailLabtap)];
    [_detailLab addGestureRecognizer:detailLabtap];
    
    _ruleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.width, labHeight)];
    _ruleLab.top = _detailLab.bottom + 5;
    _ruleLab.backgroundColor = labBackColor;
    _ruleLab.text = @"规则";
    _ruleLab.font = textFont;
    _ruleLab.textColor = kwhiteColor;
    _ruleLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_ruleLab];
    _ruleLab.userInteractionEnabled = YES;
    UITapGestureRecognizer *ruleLabtap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ruleLabtap)];
    [_ruleLab addGestureRecognizer:ruleLabtap];
}

//手势
-(void)rePlayLabtap{
    if (self.replayBlock) {
        self.replayBlock();
    }
}

-(void)factorsLabtap{
    if (self.factorsBlock) {
        self.factorsBlock();
    }
}
-(void)decisionLabtap{
    if (self.decisionBlock) {
        self.decisionBlock();
    }
}
-(void)detailLabtap{
    if (self.detailBlock) {
        self.detailBlock();
    }
}
-(void)ruleLabtap{
    if (self.ruleBlock) {
        self.ruleBlock();
    }
}
@end
