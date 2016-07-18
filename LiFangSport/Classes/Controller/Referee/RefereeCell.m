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
#import "CommonRequest.h"

@implementation RefereeCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 20, 110, 130)];
        self.bgImgView.userInteractionEnabled = YES;
//        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 130, 110, 20)];
//        self.titleLabel.textAlignment = NSTextAlignmentCenter;
//        self.titleLabel.textColor = HEXRGBCOLOR(0xffffff);
//        self.titleLabel.font = [UIFont systemFontOfSize:8];
//        self.titleLabel.backgroundColor = [UIColor blackColor];
//        self.titleLabel.alpha = 0.8;
        [self addSubview:self.bgImgView];
//        [self addSubview:self.titleLabel];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(135, 45, SCREEN_WIDTH - 135, 17.5/2)];
        self.nameLabel.font = [UIFont systemFontOfSize:10];
        self.nameLabel.textColor = HEXRGBCOLOR(0x343433);
        [self addSubview:self.nameLabel];
        
        // 点赞
        self.likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _likeBtn.frame = CGRectMake(SCREEN_WIDTH - 80, _bgImgView.top, 50, 50);
        [_likeBtn setImage:[UIImage imageNamed:@"fire.png"] forState:UIControlStateNormal];
        [_likeBtn setTitleColor:HEXRGBCOLOR(0x5f5f5f) forState:UIControlStateNormal];
        [_likeBtn addTarget:self action:@selector(likeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        _likeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:_likeBtn];
        
        self.birthdayLabel = [[UILabel alloc] initWithFrame:CGRectMake(135, _nameLabel.bottom + 15, _nameLabel.width, 17.5/2)];
        self.birthdayLabel.font = [UIFont systemFontOfSize:10];
        self.birthdayLabel.textColor = HEXRGBCOLOR(0x343433);
        [self addSubview:self.birthdayLabel];
        
        self.associationLabel = [[UILabel alloc] initWithFrame:CGRectMake(135, _birthdayLabel.bottom + 15, (SCREEN_WIDTH - 135)/2 + 10, 17.5/2)];
        self.associationLabel.font = [UIFont systemFontOfSize:10];
        self.associationLabel.textColor = HEXRGBCOLOR(0x343433);
        [self addSubview:self.associationLabel];
        
        self.topALabel = [[UILabel alloc] initWithFrame:CGRectMake(self.associationLabel.right, _birthdayLabel.bottom + 15, _associationLabel.width, 17.5/2)];
        self.topALabel.font = [UIFont systemFontOfSize:10];
        self.topALabel.textColor = HEXRGBCOLOR(0x343433);
        [self addSubview:self.topALabel];
        
        self.FIFAYearLabel = [[UILabel alloc] initWithFrame:CGRectMake(135, _topALabel.bottom + 15, _associationLabel.width, 17.5/2)];
        self.FIFAYearLabel.font = [UIFont systemFontOfSize:10];
        self.FIFAYearLabel.textColor = HEXRGBCOLOR(0x343433);
        [self addSubview:self.FIFAYearLabel];
        
        self.topLeagueLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.FIFAYearLabel.right, _topALabel.bottom + 15, _topALabel.width, 17.5/2)];
        self.topLeagueLabel.font = [UIFont systemFontOfSize:10];
        self.topLeagueLabel.textColor = HEXRGBCOLOR(0x343433);
        [self addSubview:self.topLeagueLabel];
        
        /*
         //右侧数据栏
         self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(135, 45, SCREEN_WIDTH - 135, 17.5)];
         self.nameLabel.font = [UIFont systemFontOfSize:10];
         self.nameLabel.textColor = HEXRGBCOLOR(0x343433);
         [self addSubview:self.nameLabel];
         
         self.birthdayLabel = [[UILabel alloc] initWithFrame:CGRectMake(135, _nameLabel.bottom + 15, _nameLabel.width, 10)];
         self.birthdayLabel.font = [UIFont systemFontOfSize:13];
         self.birthdayLabel.textColor = HEXRGBCOLOR(0x343433);
         [self addSubview:self.birthdayLabel];
         
         self.associationLabel = [[UILabel alloc] initWithFrame:CGRectMake(135, _birthdayLabel.bottom + 8, SCREEN_WIDTH - 155, 20)];
         self.associationLabel.font = [UIFont systemFontOfSize:13];
         self.associationLabel.textColor = HEXRGBCOLOR(0x343433);
         [self addSubview:self.associationLabel];
         
         self.topALabel = [[UILabel alloc] initWithFrame:CGRectMake(145, _associationLabel.bottom + 8, _associationLabel.width, 20)];
         self.topALabel.font = [UIFont systemFontOfSize:13];
         self.topALabel.textColor = HEXRGBCOLOR(0x343433);
         [self addSubview:self.topALabel];
         
         self.FIFAYearLabel = [[UILabel alloc] initWithFrame:CGRectMake(135, _topALabel.bottom + 8, _topALabel.width, 20)];
         self.FIFAYearLabel.font = [UIFont systemFontOfSize:13];
         self.FIFAYearLabel.textColor = HEXRGBCOLOR(0x343433);
         [self addSubview:self.FIFAYearLabel];
         
         self.topLeagueLabel = [[UILabel alloc] initWithFrame:CGRectMake(135, _FIFAYearLabel.bottom + 8, _topALabel.width, 20)];
         self.topLeagueLabel.font = [UIFont systemFontOfSize:13];
         self.topLeagueLabel.textColor = HEXRGBCOLOR(0x343433);
         [self addSubview:self.topLeagueLabel];
         */
    }
    return self;
}

-(void)displayCell:(RefereeModel *)refereeModel{
    if(refereeModel.avatar != nil){
        NSString *bgImageUrl = [NSString stringWithFormat:@"%@%@?imageView/1/w/%d/h/%d", kQiNiuHeaderPathPrifx, refereeModel.avatar, (int)self.bgImgView.width, (int)self.bgImgView.height];
        [self.bgImgView sd_setImageWithURL:[NSURL URLWithString:bgImageUrl] placeholderImage:[UIImage imageNamed:@"placeHold_player.jpg"]];
    }else{
        self.bgImgView.image = [UIImage imageNamed:@"placeHold_player.jpg"];
    }
    
    self.nameLabel.text = refereeModel.name?[NSString stringWithFormat:@"姓名:%@",refereeModel.name]:@"姓名:-";
    self.birthdayLabel.text = refereeModel.birthday?[NSString stringWithFormat:@"生日:%@", [self TimeStamp: refereeModel.birthday]]:@"生日:-";
    self.associationLabel.text = refereeModel.association?[NSString stringWithFormat:@"所属协会:%@", refereeModel.association]:@"所属协会:-";
    self.topALabel.text = refereeModel.fifaTopANum?[NSString stringWithFormat:@"国际A级赛事场次:%@", refereeModel.fifaTopANum]:@"国际A级赛事场次:-";
    self.FIFAYearLabel.text = refereeModel.sinceInternational?[NSString stringWithFormat:@"FIFA起始年份:%@", refereeModel.sinceInternational]:@"FIFA起始年份:-";
    self.topLeagueLabel.text = refereeModel.topLeagueNum?[NSString stringWithFormat:@"中国顶级联赛场次:%@", refereeModel.topLeagueNum]:@"中国顶级联赛场次:-";
//    self.titleLabel.text = [NSString stringWithFormat:@"%@", refereeModel.name?refereeModel.name:@"-"];
    
    //like
    NSString *urlStr = [NSString stringWithFormat:@"like/likes/%@?type=referee", refereeModel.refefeeId];
    [CommonRequest requstPath:urlStr loadingDic:nil queryParam:nil success:^(CommonRequest *request, id jsonDict) {
        NSLog(@"data = %@", jsonDict);
        NSDictionary *dic = jsonDict;
        int like = [[dic objectForKey:@"likeNum"] intValue];
        [self.likeBtn setTitle:[NSString stringWithFormat:@"%d", like] forState:UIControlStateNormal];
        if(![[dic objectForKey:@"like"] isEqual:[NSNull null]]){
            [self.likeBtn setImage:[UIImage imageNamed:@"fired"] forState:UIControlStateNormal];
        }
    } failure:^(CommonRequest *request, NSError *error) {
        NSLog(@"error = %@", error);
    }];
}

// 时间戳转时间
-(NSString *)TimeStamp:(NSString *)time{
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:[time doubleValue]/1000];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:detaildate];
    NSDate *localeDate = [detaildate dateByAddingTimeInterval: interval];
    
    NSDateFormatter*dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateStyle = NSDateFormatterShortStyle;
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDateStr = [dateFormatter stringFromDate:localeDate];
    return currentDateStr;
}

-(void)likeBtnClicked:(UIButton *)btn{
    [_delegate likeBtnClicked:btn cell:self];
}

@end
