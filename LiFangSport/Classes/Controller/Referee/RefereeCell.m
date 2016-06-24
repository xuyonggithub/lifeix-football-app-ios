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

@implementation RefereeCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 120, 170)];
        self.bgImgView.userInteractionEnabled = YES;
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 160, 120, 20)];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.font = [UIFont systemFontOfSize:13];
        self.titleLabel.backgroundColor = [UIColor blackColor];
        self.titleLabel.alpha = 0.8;
        [self addSubview:self.bgImgView];
        [self addSubview:self.titleLabel];
        
        //右侧数据栏
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(145, 15, SCREEN_WIDTH - 145, 20)];
        self.nameLabel.font = [UIFont systemFontOfSize:13];
        self.nameLabel.textColor = HEXRGBCOLOR(0x343433);
        [self addSubview:self.nameLabel];
        
        self.birthdayLabel = [[UILabel alloc] initWithFrame:CGRectMake(145, _nameLabel.bottom + 8, _nameLabel.width, 20)];
        self.birthdayLabel.font = [UIFont systemFontOfSize:13];
        self.birthdayLabel.textColor = HEXRGBCOLOR(0x343433);
        [self addSubview:self.birthdayLabel];
        
        self.associationLabel = [[UILabel alloc] initWithFrame:CGRectMake(145, _birthdayLabel.bottom + 8, SCREEN_WIDTH - 155, 20)];
        self.associationLabel.font = [UIFont systemFontOfSize:13];
        self.associationLabel.textColor = HEXRGBCOLOR(0x343433);
        [self addSubview:self.associationLabel];
        
        self.topALabel = [[UILabel alloc] initWithFrame:CGRectMake(145, _associationLabel.bottom + 8, _associationLabel.width, 20)];
        self.topALabel.font = [UIFont systemFontOfSize:13];
        self.topALabel.textColor = HEXRGBCOLOR(0x343433);
        [self addSubview:self.topALabel];
        
        self.FIFAYearLabel = [[UILabel alloc] initWithFrame:CGRectMake(145, _topALabel.bottom + 8, _topALabel.width, 20)];
        self.FIFAYearLabel.font = [UIFont systemFontOfSize:13];
        self.FIFAYearLabel.textColor = HEXRGBCOLOR(0x343433);
        [self addSubview:self.FIFAYearLabel];
        
        self.topLeagueLabel = [[UILabel alloc] initWithFrame:CGRectMake(145, _FIFAYearLabel.bottom + 8, _topALabel.width, 20)];
        self.topLeagueLabel.font = [UIFont systemFontOfSize:13];
        self.topLeagueLabel.textColor = HEXRGBCOLOR(0x343433);
        [self addSubview:self.topLeagueLabel];
    }
    return self;
}

-(void)displayCell:(RefereeModel *)refereeModel{
    if(refereeModel.awatar != nil){
        [self.bgImgView sd_setImageWithURL:refereeModel.awatar placeholderImage:[UIImage imageNamed:@"placeHold_player.jpg"]];
    }else{
        self.bgImgView.image = [UIImage imageNamed:@"placeHold_player.jpg"];
    }
    
    self.nameLabel.text = refereeModel.name?[NSString stringWithFormat:@"姓名:%@",refereeModel.name]:@"姓名:-";
    self.birthdayLabel.text = refereeModel.birthday?[NSString stringWithFormat:@"生日:%@", [self TimeStamp: refereeModel.birthday]]:@"生日:-";
    self.associationLabel.text = refereeModel.association?[NSString stringWithFormat:@"所属协会:%@", refereeModel.association]:@"所属协会:-";
    self.topALabel.text = refereeModel.fifaTopANum?[NSString stringWithFormat:@"国际A级赛事场次:%@", refereeModel.fifaTopANum]:@"国际A级赛事场次:-";
    self.FIFAYearLabel.text = refereeModel.sinceInternational?[NSString stringWithFormat:@"FIFA起始年份:%@", refereeModel.sinceInternational]:@"FIFA起始年份:-";
    self.topLeagueLabel.text = refereeModel.topLeagueNum?[NSString stringWithFormat:@"国际顶级联赛场次:%@", refereeModel.topLeagueNum]:@"国际顶级联赛场次:-";
    self.titleLabel.text = [NSString stringWithFormat:@"【%@】%@", refereeModel.position?refereeModel.position:@"-", refereeModel.name?refereeModel.name:@"-"];
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

@end
