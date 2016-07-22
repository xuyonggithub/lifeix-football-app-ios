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
        _nameLab.backgroundColor = [UIColor whiteColor];
        _nameLab.textAlignment = NSTextAlignmentCenter;
        _nameLab.textColor = [UIColor blackColor];
        _nameLab.font = [UIFont systemFontOfSize:12];
        [self addSubview:_nameLab];
    }
}

-(void)layoutSubviews{
    _nameLab.top = self.height - 15;
}

-(void)setModel:(RightSwitchModel *)model{
    //七牛图片处理
    if (IPHONE_5||IPHONE_4) {//85 100
        [_picView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?imageView/1/w/%@/h/%@",kQiNiuHeaderPathPrifx,model.avatar,@(170),@(200)]] placeholderImage:UIImageNamed(@"placeHold_player")];

    }else{//110,130
        [_picView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?imageView/1/w/%@/h/%@",kQiNiuHeaderPathPrifx,model.avatar,@(220),@(260)]] placeholderImage:UIImageNamed(@"placeHold_player")];

    }
    _nameLab.text = [NSString stringWithFormat:@"%@",model.name];
}

@end
