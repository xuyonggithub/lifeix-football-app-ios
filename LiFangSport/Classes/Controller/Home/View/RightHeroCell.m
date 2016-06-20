//
//  RightHeroCell.m
//  LiFangSport
//
//  Created by 张毅 on 16/6/15.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import "RightHeroCell.h"
#import "UIImageView+WebCache.h"

@interface RightHeroCell ()
@property(nonatomic,strong)UILabel *nameLab;
@property(nonatomic,strong)UIImageView *picView;
@end

@implementation RightHeroCell
-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        //添加控件
    [self createUI];
    }
    return self;
}

-(void)createUI{
    if (!self.picView) {
        _picView = [[UIImageView alloc]initWithFrame:self.bounds];
        [self addSubview:_picView];
    }
    if (!self.nameLab) {
        _nameLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 85, self.bounds.size.width, 15)];
        _nameLab.backgroundColor = [UIColor blackColor];
        _nameLab.textAlignment = NSTextAlignmentCenter;
        _nameLab.textColor = [UIColor whiteColor];
        _nameLab.font = [UIFont systemFontOfSize:12];
        [self addSubview:_nameLab];
    }
}

-(void)setModel:(RightSwitchModel *)model{
//    [_picView sd_setImageWithURL:[NSURL URLWithString:model.avatar]];
    _picView.image = UIImageNamed(@"haolindemopic");//[UIImage imageNamed:@"haolindemopic"];
    _nameLab.text = model.name;
}

@end
