//
//  StaffsInfoHeaderView.m
//  LiFangSport
//
//  Created by 张毅 on 16/7/8.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import "StaffsInfoHeaderView.h"
#import "UIImageView+WebCache.h"

@interface StaffsInfoHeaderView ()
@property(nonatomic,strong)StaffsInfoModel *model;

@end

@implementation StaffsInfoHeaderView

-(instancetype)initWithFrame:(CGRect)frame andDataModel:(StaffsInfoModel*)model{
    if(self = [super initWithFrame:frame]){
        _model = model;
        [self createSubViews];
        
    }
    return self;
}

-(void)createSubViews{
 
    UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 105, 140)];
    if(!_model.avatar){
        bgImgView.image = [UIImage imageNamed:@"placeHold_player.jpg"];
    }else{
        NSString *bgImageUrl = [NSString stringWithFormat:@"%@%@?imageView/1/w/210/h/280", kQiNiuHeaderPathPrifx, _model.avatar];
        [bgImgView sd_setImageWithURL:[NSURL URLWithString:bgImageUrl] placeholderImage:[UIImage imageNamed:@"placeHold_player.jpg"]];
    }
    [self addSubview:bgImgView];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(140 - 15, 30, SCREEN_WIDTH - 140 - 120 - 15, 20)];
    nameLabel.font = [UIFont systemFontOfSize:15];
    nameLabel.textColor = HEXRGBCOLOR(0x000000);
    nameLabel.text = _model.name;
    [self addSubview:nameLabel];
    
    // 点赞
    _likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _likeBtn.frame = CGRectMake(SCREEN_WIDTH - 50 - nameLabel.height, nameLabel.top, nameLabel.height + 50, nameLabel.height);
    if (_model.like) {
        [_likeBtn setImage:[UIImage imageNamed:@"fired"] forState:UIControlStateNormal];
    }else{
    [_likeBtn setImage:[UIImage imageNamed:@"fire.png"] forState:UIControlStateNormal];
    }
    [_likeBtn setTitle:[NSString stringWithFormat:@"%zd", [_model.likeNum integerValue]] forState:UIControlStateNormal];

    [_likeBtn setTitleColor:HEXRGBCOLOR(0x5f5f5f) forState:UIControlStateNormal];
    [_likeBtn addTarget:self action:@selector(likeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    _likeBtn.titleLabel.font = [UIFont systemFontOfSize:12];;
    [self addSubview:_likeBtn];

    NSArray *infoArr = [NSArray arrayWithObjects:@"生日", @"角色", @"所属单位", nil];
    for(int i = 0; i < 3; i++){
        UILabel *birLbl = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.left, nameLabel.bottom + 17 + (83/4+1) * i, 55, 83/4)];
        birLbl.backgroundColor = HEXRGBCOLOR(0xbababa);
        birLbl.text = infoArr[i];
        birLbl.textColor = HEXRGBCOLOR(0xffffff);
        birLbl.font = [UIFont systemFontOfSize:11];
        birLbl.textAlignment = NSTextAlignmentCenter;
        [self addSubview: birLbl];
        
        UILabel *infoLbl = [[UILabel alloc] initWithFrame:CGRectMake(birLbl.right, nameLabel.bottom + 17 + (83/4+1) * i, SCREEN_WIDTH - 205 + 15, 83/4)];
        infoLbl.backgroundColor = HEXRGBCOLOR(0xf9f9f9);
        NSTimeInterval dateIN=(NSTimeInterval)[_model.birthday integerValue]/1000;
        NSDate * dateData=[NSDate dateWithTimeIntervalSince1970:dateIN];

        switch (i) {
            case 0:
                infoLbl.text = [self extractDate:dateData];
                break;
            case 1:
                infoLbl.text = _model.team[@"position"];
                break;
            case 2:
                infoLbl.text = _model.company;
                break;
            default:
                break;
        }
        infoLbl.textColor = HEXRGBCOLOR(0x333333);
        infoLbl.font = [UIFont systemFontOfSize:11];
        infoLbl.textAlignment = NSTextAlignmentCenter;
        [self addSubview:infoLbl];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(nameLabel.left, birLbl.bottom, SCREEN_WIDTH - 150 + 15, 1)];
        lineView.backgroundColor = HEXRGBCOLOR(0xd8d8d8);
        [self addSubview:lineView];
  }
}

-(void)likeBtnClicked:(UIButton *)btn{
    if (self.clickBC) {
        self.clickBC();
    }
}
- (NSString *)extractDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSString *currentDateString = [NSString stringWithFormat:@"%@",
                                   [formatter stringFromDate:date]];
    return currentDateString;
}
    
@end
