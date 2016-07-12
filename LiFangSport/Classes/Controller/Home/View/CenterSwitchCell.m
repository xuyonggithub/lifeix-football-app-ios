//
//  CenterSwitchCell.m
//  LiFangSport
//
//  Created by 张毅 on 16/6/15.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import "CenterSwitchCell.h"
#import "UIImageView+WebCache.h"

@interface CenterSwitchCell ()
@property(nonatomic,strong)UILabel *timeLab;
@property(nonatomic,strong)UILabel *hostTeamLab;
@property(nonatomic,strong)UILabel *awayTeamLab;
@property(nonatomic,strong)UIImageView *hostTeamFlagView;
@property(nonatomic,strong)UIImageView *awayTeamFlagView;
@property(nonatomic,strong)UIImageView *vsView;

@end

@implementation CenterSwitchCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self createUI];
    }
    return self;
}
-(void)createUI{
    _timeLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 50, 20)];
    _timeLab.centerY = 30;
    _timeLab.textColor = kTitleColor;
    [self addSubview:_timeLab];
    _hostTeamLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 20, 20)];
    _hostTeamLab.centerY = _timeLab.centerY;
    [self addSubview:_hostTeamLab];

    _hostTeamFlagView = [[UIImageView alloc]initWithFrame:CGRectMake(40, 0, 35*kScreenRatioBase6Iphone, 25*kScreenRatioBase6Iphone)];
    _hostTeamFlagView.centerY = _timeLab.centerY;
    [self addSubview:_hostTeamFlagView];
    
    _vsView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 21*kScreenRatioBase6Iphone, 15*kScreenRatioBase6Iphone)];
    _vsView.centerY = _hostTeamFlagView.centerY;
    [self addSubview:_vsView];
    _vsView.image = UIImageNamed(@"VSicon");
    
    _awayTeamFlagView = [[UIImageView alloc]initWithFrame:CGRectMake(40, 0, 35*kScreenRatioBase6Iphone, 25*kScreenRatioBase6Iphone)];
    _awayTeamFlagView.centerY = _timeLab.centerY;
    [self addSubview:_awayTeamFlagView];
    
    _awayTeamLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 20, 20)];
    _awayTeamLab.centerY = _timeLab.centerY;
    [self addSubview:_awayTeamLab];
    
    _timeLab.font = [UIFont systemFontOfSize:10*kScreenRatioBase6Iphone];
    _hostTeamLab.font = [UIFont systemFontOfSize:10*kScreenRatioBase6Iphone];
    _awayTeamLab.font = [UIFont systemFontOfSize:10*kScreenRatioBase6Iphone];

}

-(void)setModel:(CenterSwitchModel *)model{
    
    NSTimeInterval timeIN=(NSTimeInterval)[model.startTime integerValue]/1000;

    NSDate * timeData=[NSDate dateWithTimeIntervalSince1970:timeIN];
    NSString *dataStr = [NSString stringWithFormat:@"%@",[self extractDateToTime:timeData]];
    _timeLab.text = dataStr;
    if (!model.startTime) {
        NSTimeInterval timeINs=(NSTimeInterval)[model.startDate integerValue]/1000;
        NSDate * timeDatas=[NSDate dateWithTimeIntervalSince1970:timeINs];
        NSString *dataStrs = [NSString stringWithFormat:@"%@",[self extractDateToDate:timeDatas]];
        _timeLab.text = dataStrs;
    }
    [_hostTeamFlagView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kQiNiuHeaderPathPrifx,model.hostTeam[@"teamInfo"][@"flag"]]]];
    
    [_awayTeamFlagView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kQiNiuHeaderPathPrifx,model.awayTeam[@"teamInfo"][@"flag"]]]];
    _hostTeamLab.text = model.hostTeam[@"teamInfo"][@"name"];
    _awayTeamLab.text = model.awayTeam[@"teamInfo"][@"name"];

}

-(void)layoutSubviews{
    [_timeLab sizeToFit];
    [_hostTeamLab sizeToFit];
    [_awayTeamLab sizeToFit];
    _awayTeamLab.left = self.width-55*kScreenRatioBase6Iphone;
    _awayTeamFlagView.right = _awayTeamLab.left-17*kScreenRatioBase6Iphone;
    _vsView.right = _awayTeamFlagView.left - 17*kScreenRatioBase6Iphone;
    _hostTeamFlagView.right = _vsView.left-17*kScreenRatioBase6Iphone;
    _hostTeamLab.right = _hostTeamFlagView.left - 17*kScreenRatioBase6Iphone;
    _timeLab.centerY= _hostTeamFlagView.centerY;
    _hostTeamLab.centerY = _hostTeamFlagView.centerY;
    _awayTeamLab.centerY = _hostTeamFlagView.centerY;
    
    _hostTeamFlagView.layer.shadowOffset = CGSizeMake(0, 5);
    _hostTeamFlagView.layer.shadowOpacity = 0.9;
    _hostTeamFlagView.layer.shadowColor = HEXRGBCOLOR(0xdcdcdc).CGColor;
    
    _awayTeamFlagView.layer.shadowOffset = CGSizeMake(0, 5);
    _awayTeamFlagView.layer.shadowOpacity = 0.9;
    _awayTeamFlagView.layer.shadowColor = HEXRGBCOLOR(0xdcdcdc).CGColor;
}

- (NSString *)extractDateToTime:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.timeZone = [NSTimeZone systemTimeZone];
    //formatter.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    NSString *currenttimeString = [NSString stringWithFormat:@"%@",
                                   [formatter stringFromDate:date]];
    return currenttimeString;
}

- (NSString *)extractDateToDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.timeZone = [NSTimeZone systemTimeZone];
    [formatter setDateFormat:@"YYYY-MM-dd"];
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
