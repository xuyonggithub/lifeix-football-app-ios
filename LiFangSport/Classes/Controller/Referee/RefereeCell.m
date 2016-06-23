//
//  RefereeCell.m
//  LiFangSport
//
//  Created by Lifeix on 16/6/17.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import "RefereeCell.h"
#import "RefereeModel.h"
#import "UIImageView+WebCache.h"
/*
@property(nonatomic, retain)UIImageView *bgImgView;
@property(nonatomic, retain)UILabel *titleLabel;
@property(nonatomic, retain)UILabel *nameLabel;
@property(nonatomic, retain)UILabel *birthdayLabel;
@property(nonatomic, retain)UILabel *associationLabel;
@property(nonatomic, retain)UILabel *topALabel;
@property(nonatomic, retain)UILabel *FIFAYearLabel;
@property(nonatomic, retain)UILabel *yopLeagueLabel;
*/
@implementation RefereeCell

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
//        self.bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 100, 150)];
//        self.bgImgView.userInteractionEnabled = YES;
//        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.height - 20, self.width, 20)];
//        self.titleLabel.textAlignment = NSTextAlignmentCenter;
//        self.titleLabel.textColor = [UIColor whiteColor];
//        self.titleLabel.font = [UIFont systemFontOfSize:12];
//        self.titleLabel.backgroundColor = [UIColor blackColor];
//        self.titleLabel.alpha = 0.8;
//        [self addSubview:self.bgImgView];
//        [self addSubview:self.titleLabel];
    }
    return self;
}

-(void)displayCell:(RefereeModel *)refereeModel{
    if(refereeModel.awatar != nil){
        [self.bgImgView sd_setImageWithURL:refereeModel.awatar placeholderImage:[UIImage imageNamed:@"placeHold_player.jpg"]];
    }else{
        self.bgImgView.image = [UIImage imageNamed:@"placeHold_player.jpg"];
    }
    
    
    self.titleLabel.text = [NSString stringWithFormat:@"【%@】%@", refereeModel.position, refereeModel.name];
}

@end
