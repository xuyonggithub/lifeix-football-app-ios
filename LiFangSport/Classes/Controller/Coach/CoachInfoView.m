//
//  CoachInfoView.m
//  LiFangSport
//
//  Created by 卢亚林 on 16/6/24.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import "CoachInfoView.h"
#import "UIImageView+WebCache.h"

@interface CoachInfoView()

@property(nonatomic, retain)UIImageView *bgImgView;
@property(nonatomic, retain)UILabel *nameLabel;

@end

@implementation CoachInfoView

-(instancetype)initWithFrame:(CGRect)frame andAvatar:(NSString *)avatar andName:(NSString *)name andBirday:(NSString *)birday andBirthplace:(NSString *)birthplace andPart:(NSString *)part andClub:(NSString *)club{
    if(self = [super initWithFrame:frame]){
        self.bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 105, 140)];
        if(!avatar){
            self.bgImgView.image = [UIImage imageNamed:@"placeHold_player.jpg"];
        }else{
            NSString *bgImageUrl = [NSString stringWithFormat:@"%@%@?imageView/1/w/105/h/140", kQiNiuHeaderPathPrifx, avatar];
            [self.bgImgView sd_setImageWithURL:[NSURL URLWithString:bgImageUrl] placeholderImage:[UIImage imageNamed:@"placeHold_player.jpg"]];
        }
        [self addSubview:_bgImgView];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(140, 20, SCREEN_WIDTH - 140 - 120, 20)];
        self.nameLabel.font = [UIFont systemFontOfSize:15];
        self.nameLabel.textColor = HEXRGBCOLOR(0x000000);
        self.nameLabel.text = name;
        [self addSubview:self.nameLabel];
        
        // 点赞
        self.likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _likeBtn.frame = CGRectMake(SCREEN_WIDTH - 50 - _nameLabel.height, _nameLabel.top, _nameLabel.height + 50, _nameLabel.height);
        [_likeBtn setImage:[UIImage imageNamed:@"fire.png"] forState:UIControlStateNormal];
        [_likeBtn setTitleColor:HEXRGBCOLOR(0x5f5f5f) forState:UIControlStateNormal];
        [_likeBtn addTarget:self action:@selector(likeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        _likeBtn.titleLabel.font = [UIFont systemFontOfSize:12];;
        [self addSubview:_likeBtn];
        
        NSArray *infoArr = [NSArray arrayWithObjects:@"生日", @"出生地", @"角色", @"俱乐部", nil];
        NSArray *valueArr = [NSArray arrayWithObjects:birday, birthplace, part, club, nil];
        for(int i = 0; i < 4; i++){
            UILabel *birLbl = [[UILabel alloc] initWithFrame:CGRectMake(_nameLabel.left, _nameLabel.bottom + 10 + (39/2+1) * i, 55, 39/2)];
            birLbl.backgroundColor = HEXRGBCOLOR(0xbababa);
            birLbl.text = infoArr[i];
            birLbl.textColor = HEXRGBCOLOR(0xffffff);
            birLbl.font = [UIFont systemFontOfSize:8];
            birLbl.textAlignment = NSTextAlignmentCenter;
            [self addSubview: birLbl];
            
            UILabel *infoLbl = [[UILabel alloc] initWithFrame:CGRectMake(birLbl.right, _nameLabel.bottom + 10 + (39/2+1) * i, SCREEN_WIDTH - 205, 39/2)];
            infoLbl.backgroundColor = HEXRGBCOLOR(0xf9f9f9);
            infoLbl.text = valueArr[i];
            infoLbl.textColor = HEXRGBCOLOR(0x333333);
            infoLbl.font = [UIFont systemFontOfSize:8];
            infoLbl.textAlignment = NSTextAlignmentCenter;
            [self addSubview:infoLbl];
            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(_nameLabel.left, birLbl.bottom, SCREEN_WIDTH - 150, 1)];
            lineView.backgroundColor = HEXRGBCOLOR(0xd9d9d9);
            [self addSubview:lineView];
        }
    }
    return self;
}

-(void)likeBtnClicked:(UIButton *)btn{
    [_delegate likeBtnClicked:btn];
}

@end
