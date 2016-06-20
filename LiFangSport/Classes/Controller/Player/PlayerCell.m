//
//  PlayerCell.m
//  LiFangSport
//
//  Created by Lifeix on 16/6/13.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import "PlayerCell.h"
#import "UIImageView+WebCache.h"
#import "PlayerModel.h"

@implementation PlayerCell

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.bgImgView = [[UIImageView alloc] initWithFrame:frame];
        self.bgImgView.userInteractionEnabled = YES;
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.height - 20, self.width, 20)];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.font = [UIFont systemFontOfSize:12];
        self.titleLabel.backgroundColor = [UIColor blackColor];
        self.titleLabel.alpha = 0.4;
        [self addSubview:self.bgImgView];
        [self.bgImgView addSubview:self.titleLabel];
    }
    return self;
}

-(void)setPlayerModel:(PlayerModel *)playerModel{
//    if(playerModel.awatar != nil){
//        [self.bgImgView sd_setImageWithURL:playerModel.awatar placeholderImage:UIImageNamed(@"112233.png")];
//    }else{
//        self.bgImgView.image = [UIImage imageNamed:@"112233.png"];
//    }
    self.titleLabel.text = [NSString stringWithFormat:@"【%@】%@", playerModel.position, playerModel.name];

}

@end
