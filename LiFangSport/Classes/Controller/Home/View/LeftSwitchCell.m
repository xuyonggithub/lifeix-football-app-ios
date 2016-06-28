//
//  LeftSwitchCell.m
//  LiFangSport
//
//  Created by 张毅 on 16/6/15.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import "LeftSwitchCell.h"
#import "UIImageView+WebCache.h"

@interface LeftSwitchCell ()
@property(nonatomic,strong)UIImageView *picView;
@property(nonatomic,strong)UILabel *titleLab;
@property(nonatomic,strong)UILabel *subTitleLab;
@property(nonatomic,strong)UIImageView *hostTeamFlagView;
@property(nonatomic,strong)UIImageView *awayTeamFlagView;
@property(nonatomic,strong)UILabel *hostTeamNameLab;
@property(nonatomic,strong)UILabel *awayTeamNameLab;
@property(nonatomic,strong)UIImageView *vsView;

@end

@implementation LeftSwitchCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self initSubviews];
    }
    return self;
}
-(void)initSubviews{
    _picView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 65)];
    [self addSubview:_picView];
    _picView.image = [UIImage imageNamed:@"leftswitchcellpic"];
    _titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    [self addSubview:_titleLab];
    _subTitleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 25)];
    _subTitleLab.top = _titleLab.bottom;
    [self addSubview:_subTitleLab];
    _titleLab.textColor = kBlackColor;
    _subTitleLab.textColor = kBlackColor;
    _titleLab.textAlignment = NSTextAlignmentCenter;
    _subTitleLab.textAlignment = NSTextAlignmentCenter;
    _titleLab.font = [UIFont systemFontOfSize:16];
    _subTitleLab.font = [UIFont systemFontOfSize:12];
    _hostTeamFlagView = [[UIImageView alloc]initWithFrame:CGRectMake(40, 0, 50, 35)];
    [self addSubview:_hostTeamFlagView];
    _hostTeamFlagView.image = [UIImage imageNamed:@"chinaflag"];

    _awayTeamFlagView = [[UIImageView alloc]initWithFrame:CGRectMake(40, 0, 50, 35)];
    [self addSubview:_awayTeamFlagView];
    _awayTeamFlagView.image = [UIImage imageNamed:@"americaflag"];

    _titleLab.textAlignment = NSTextAlignmentCenter;
    _subTitleLab.textAlignment = NSTextAlignmentCenter;
    _hostTeamFlagView.top = _picView.bottom;
    _awayTeamFlagView.top = _hostTeamFlagView.top;
    _awayTeamFlagView.right = kScreenWidth-40;
    
    _vsView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 28, 20)];
    _vsView.centerY = _hostTeamFlagView.centerY;
    _vsView.centerX = kScreenWidth/2;
    [self addSubview:_vsView];
    _vsView.image = UIImageNamed(@"VSicon");
    
    _hostTeamNameLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 15, 15)];
    _hostTeamNameLab.top = _hostTeamFlagView.bottom;
    _hostTeamNameLab.centerX = _hostTeamFlagView.centerX;
    _hostTeamNameLab.font = [UIFont systemFontOfSize:12];
    _hostTeamNameLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_hostTeamNameLab];
    _awayTeamNameLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 15, 15)];
    _awayTeamNameLab.top = _hostTeamFlagView.bottom;
    _awayTeamNameLab.centerX = _awayTeamFlagView.centerX;
    _awayTeamNameLab.font = [UIFont systemFontOfSize:12];
    _awayTeamNameLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_awayTeamNameLab];
}

-(void)setModel:(LeftSwitchModel *)model{
//    NSString *ss = model.competitionInfo[@"name"];
    NSString *ss = _leftSubtitlePrifxStr?_leftSubtitlePrifxStr:@"世预赛";
    NSTimeInterval dateIN=(NSTimeInterval)[model.startDate integerValue]/1000;
    NSDate * dateData=[NSDate dateWithTimeIntervalSince1970:dateIN];
    
    NSTimeInterval timeIN=(NSTimeInterval)[model.startTime integerValue];
    NSDate * timeData=[NSDate dateWithTimeIntervalSince1970:timeIN];
    
    NSString *dataStr = [NSString stringWithFormat:@"%@",[self extractDate:dateData]];
    NSString *timeStr = [NSString stringWithFormat:@"%@ %@",[self extractDateToTime:timeData],ss];
    _titleLab.text = dataStr;
    _subTitleLab.text = timeStr;
    [_hostTeamFlagView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kQiNiuHeaderPathPrifx,model.hostTeam[@"teamInfo"][@"flag"]]]];

    [_awayTeamFlagView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kQiNiuHeaderPathPrifx,model.awayTeam[@"teamInfo"][@"flag"]]]];

    _hostTeamNameLab.text = model.hostTeam[@"teamInfo"][@"name"];
    [_hostTeamNameLab sizeToFit];
    _hostTeamNameLab.centerX = _hostTeamFlagView.centerX;

    _awayTeamNameLab.text = model.awayTeam[@"teamInfo"][@"name"];
    [_awayTeamNameLab sizeToFit];
    _awayTeamNameLab.centerX = _awayTeamFlagView.centerX;

}

- (NSString *)extractDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MM月dd日"];
    NSString *currentDateString = [NSString stringWithFormat:@"%@",
                                   [formatter stringFromDate:date]];
    return currentDateString;
}
- (NSString *)extractDateToTime:(NSDate *)date {

    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    [formatter setDateFormat:@"hh:mm"];
    NSString *currenttimeString = [NSString stringWithFormat:@"%@",
                                   [formatter stringFromDate:date]];
    return currenttimeString;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
