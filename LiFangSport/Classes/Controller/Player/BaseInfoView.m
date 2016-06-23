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
        self.bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 120, 170)];
        [self.bgImgView sd_setImageWithURL:avatar placeholderImage:@"placeHold_player.jpg"];
        [self addSubview:_bgImgView];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(145, 15, SCREEN_WIDTH - 145 - 120, 20)];
        self.nameLabel.font = [UIFont systemFontOfSize:15];
        self.nameLabel.textColor = HEXRGBCOLOR(0xdddddd);
        self.nameLabel.text = name;
        [self addSubview:self.nameLabel];
        
        // 点赞
        
        NSArray *infoArr = [NSArray arrayWithObjects:@"生日", @"身高／体重", @"场上位置", @"出生地", @"俱乐部", nil];
        NSString *bodyInfo = [NSString stringWithFormat:@"%@/%@", height, weight];
        NSArray *valueArr = [NSArray arrayWithObjects:birday, bodyInfo, position, birthplace, club, nil];
        for(int i = 0; i < 5; i++){
            UILabel *birLbl = [[UILabel alloc] initWithFrame:CGRectMake(_nameLabel.left, _nameLabel.bottom + 8 + 20 * i, 50, 19)];
            birLbl.backgroundColor = HEXRGBCOLOR(0xb9b9b9);
            birLbl.text = infoArr[i];
            birLbl.textColor = HEXRGBCOLOR(0xffffff);
            birLbl.font = [UIFont systemFontOfSize:12];
            birLbl.textAlignment = NSTextAlignmentRight;
            [self addSubview: birLbl];
            
            UILabel *infoLbl = [[UILabel alloc] initWithFrame:CGRectMake(birLbl.right, birLbl.top + 20 * i, SCREEN_WIDTH - 205, 19)];
            infoLbl.backgroundColor = HEXRGBCOLOR(0xf9f9f9);
            infoLbl.text = valueArr[i];
            infoLbl.textColor = HEXRGBCOLOR(0x000000);
            infoLbl.font = [UIFont systemFontOfSize:12];
            infoLbl.textAlignment = NSTextAlignmentLeft;
            [self addSubview:infoLbl];
            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(_nameLabel.left, birLbl.bottom, SCREEN_WIDTH - 155, 1)];
            lineView.backgroundColor = HEXRGBCOLOR(0xd8d8d8);
            if(i != 4){
                [self addSubview:lineView];
            }
        }
    }
    return self;
}

@end
