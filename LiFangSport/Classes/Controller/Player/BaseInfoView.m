//
//  BaseInfoView.m
//  LiFangSport
//
//  Created by 卢亚林 on 16/6/23.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import "BaseInfoView.h"
#import "UIImageView+WebCache.h"

@interface BaseInfoView()

@property(nonatomic, retain)UIImageView *bgImgView;
@property(nonatomic, retain)UILabel *nameLabel;

@end

@implementation BaseInfoView

-(instancetype)initWithFrame:(CGRect)frame andAvatar:(NSString *)avatar andName:(NSString *)name andBirday:(NSString *)birday andHeight:(NSString *)height andWeight:(NSString *)weight andPosition:(NSString *)position andBirthplace:(NSString *)birthplace andClub:(NSString *)club{
    if(self = [super initWithFrame:frame]){
        self.bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 105, 140)];
        self.bgImgView.contentMode = UIViewContentModeScaleAspectFill;
        self.bgImgView.clipsToBounds = YES;
        if(!avatar){
            self.bgImgView.image = [UIImage imageNamed:@"placeHold_player.jpg"];
        }else{
            NSString *bgImageUrl = [NSString stringWithFormat:@"%@%@?imageView/1/w/210/h/280", kQiNiuHeaderPathPrifx, avatar];
            [self.bgImgView sd_setImageWithURL:[NSURL URLWithString:bgImageUrl] placeholderImage:[UIImage imageNamed:@"placeHold_player.jpg"]];
            NSLog(@"++++++++++++++++++++++++++++++++Name:%@；imageUrl:%@\n", name, bgImageUrl);
        }
        [self addSubview:_bgImgView];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(140 - 15, 10, SCREEN_WIDTH - 140 - 80 - 15, 20)];
        self.nameLabel.font = [UIFont systemFontOfSize:15];
        self.nameLabel.textColor = HEXRGBCOLOR(0x000000);
        self.nameLabel.text = name;
        [self addSubview:self.nameLabel];
        
        // 点赞
        self.likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.likeBtn.frame = CGRectMake(SCREEN_WIDTH - 80, 0, 60, 40);
        [self.likeBtn setImage:[UIImage imageNamed:@"fire.png"] forState:UIControlStateNormal];
        [self.likeBtn setImage:[UIImage imageNamed:@"fired.png"] forState:UIControlStateSelected];
        [self.likeBtn setTitleColor:HEXRGBCOLOR(0x5f5f5f) forState:UIControlStateNormal];
        [self.likeBtn addTarget:self action:@selector(likeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        self.likeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:self.likeBtn];
        
        NSArray *infoArr = [NSArray arrayWithObjects:@"生日", @"身高／体重", @"场上位置", @"出生地", @"俱乐部", nil];
        NSString *bodyInfo = [NSString stringWithFormat:@"%@/%@", height, weight];
        if (position==nil) {
            position = @"-";
        }
        NSArray *valueArr = [NSArray arrayWithObjects:birday, bodyInfo, position, birthplace, club, nil];
        for(int i = 0; i < 5; i++){
            UILabel *birLbl = [[UILabel alloc] initWithFrame:CGRectMake(_nameLabel.left, _nameLabel.bottom + 10 + (83/4+1) * i, 70, 83/4)];
            birLbl.backgroundColor = HEXRGBCOLOR(0xbababa);
            birLbl.text = infoArr[i];
            birLbl.textColor = HEXRGBCOLOR(0xffffff);
            birLbl.font = [UIFont systemFontOfSize:11];
            birLbl.textAlignment = NSTextAlignmentCenter;
            [self addSubview: birLbl];
            
            UILabel *infoLbl = [[UILabel alloc] initWithFrame:CGRectMake(birLbl.right, _nameLabel.bottom + 10 + (83/4+1) * i, SCREEN_WIDTH - 205, 83/4)];
            infoLbl.backgroundColor = HEXRGBCOLOR(0xf9f9f9);
            infoLbl.text = valueArr[i];
            infoLbl.textColor = HEXRGBCOLOR(0x333333);
            infoLbl.font = [UIFont systemFontOfSize:11];
            infoLbl.textAlignment = NSTextAlignmentCenter;
            [self addSubview:infoLbl];
            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(_nameLabel.left, birLbl.bottom, SCREEN_WIDTH - 150 + 15, 1)];
            lineView.backgroundColor = HEXRGBCOLOR(0xd8d8d8);
            [self addSubview:lineView];
        }
    }
    return self;
}

-(void)likeBtnClicked:(UIButton *)btn{
    [_delegate likeBtnClicked:btn];
}

@end
