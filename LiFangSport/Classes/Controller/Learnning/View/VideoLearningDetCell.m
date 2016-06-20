//
//  VideoLearningDetCell.m
//  LiFangSport
//
//  Created by 张毅 on 16/6/16.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import "VideoLearningDetCell.h"

@interface VideoLearningDetCell ()
@property(nonatomic,strong)UILabel *nameLab;
@property(nonatomic,strong)UIImageView *picView;

@end

@implementation VideoLearningDetCell

-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor greenColor];

        //添加控件
        [self createUI];
    }
    return self;
}

-(void)createUI{
    _picView = [[UIImageView alloc]initWithFrame:self.bounds];
    _picView.height = _picView.height - 20;
    _nameLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.width, 20)];
    _nameLab.bottom = 80;
    _nameLab.textAlignment = NSTextAlignmentCenter;
    _nameLab.textColor = [UIColor blackColor];
    _nameLab.font = [UIFont systemFontOfSize:12];
    
    _picView.image = [UIImage imageNamed:@"haolindemopic"];
    _nameLab.text = @"教学视频";
    [self addSubview:_picView];
    [_picView addSubview:_nameLab];
}
-(void)layoutSubviews{
//    [self addSubview:_picView];
//    [_picView addSubview:_nameLab];
    
}

@end
