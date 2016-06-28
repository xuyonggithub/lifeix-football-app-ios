//
//  LearningPlayControlView.m
//  LiFangSport
//
//  Created by 张毅 on 16/6/23.
//  Copyright © 2016年 zhangyi. All rights reserved.
//
#import "LearningPlayControlView.h"

@interface LearningPlayControlView (){
    NSInteger pindex;
}
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
//        self.backgroundColor = kclearColor;
//        [self initSubViews];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame WithModel:(VideoSingleInfoModel *)model{
    self = [super initWithFrame:frame];
    if (self) {
        _model = model;
        pindex = 0;
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
    if (!_model.considerations) {
        _factorsLab.height = 0;
        pindex =1;
    }
    
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
    if (!_model.r1&&!_model.r2) {
        _decisionLab.height=0;
        pindex =2;
    }
    
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
    if (!_model.explanation) {
        _detailLab.height = 0;
        pindex =3;
    }
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
    if (!_model.rule) {
        _ruleLab.height=0;
        pindex =4;
    }
    if (pindex!=0) {
        _rePlayLab.top = (labHeight * pindex)/2;
        _factorsLab.top = _rePlayLab.bottom + 5;
        _decisionLab.top = _factorsLab.bottom + 5;
        _detailLab.top = _decisionLab.bottom + 5;
        _ruleLab.top = _detailLab.bottom + 5;
    }
    
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
