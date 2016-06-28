//
//  CoachCell.m
//  LiFangSport
//
//  Created by Lifeix on 16/6/17.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import "CoachCell.h"
#import "CoachModel.h"
#import "UIImageView+WebCache.h"

@implementation CoachCell

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.bgImgView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.bgImgView.userInteractionEnabled = YES;
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.height - 20, self.width, 20)];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.font = [UIFont systemFontOfSize:12];
        self.titleLabel.backgroundColor = [UIColor blackColor];
        self.titleLabel.alpha = 0.8;
        [self addSubview:self.bgImgView];
        [self addSubview:self.titleLabel];
    }
    return self;
}

-(void)displayCell:(CoachModel *)coachModel{
    if(coachModel.avatar != nil){
        NSString *bgImageUrl = [NSString stringWithFormat:@"%@%@?imageView/1/w/%d/h/%d", kQiNiuHeaderPathPrifx, coachModel.avatar, (int)self.bgImgView.width, (int)self.bgImgView.height];
        [self.bgImgView sd_setImageWithURL:[NSURL URLWithString:bgImageUrl] placeholderImage:[UIImage imageNamed:@"placeHold_player.jpg"]];
    }else{
        self.bgImgView.image = [UIImage imageNamed:@"placeHold_player.jpg"];;
    }
    self.titleLabel.text = [NSString stringWithFormat:@"【%@】%@", coachModel.position, coachModel.name];

}

@end
