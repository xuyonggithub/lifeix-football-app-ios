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
    _timeLab.centerY = 30;//self.centerY;
    _timeLab.font = [UIFont systemFontOfSize:16];
    _timeLab.textColor = kTitleColor;
    [self addSubview:_timeLab];
    _hostTeamLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 20, 20)];
    _hostTeamLab.left = _timeLab.right + 50;
    _hostTeamLab.centerY = _timeLab.centerY;
    [self addSubview:_hostTeamLab];

    _hostTeamFlagView = [[UIImageView alloc]initWithFrame:CGRectMake(40, 0, 50, 35)];
    _hostTeamFlagView.centerY = _timeLab.centerY;
    _hostTeamFlagView.left= _hostTeamLab.right+17;
    [self addSubview:_hostTeamFlagView];
    _hostTeamFlagView.image = [UIImage imageNamed:@"chinaflag"];
    
    _vsView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 21, 15)];
    _vsView.centerY = _hostTeamFlagView.centerY;
    _vsView.left = _hostTeamFlagView.right+17;
    [self addSubview:_vsView];
    _vsView.image = UIImageNamed(@"VSicon");
    
    _awayTeamFlagView = [[UIImageView alloc]initWithFrame:CGRectMake(40, 0, 50, 35)];
    _awayTeamFlagView.centerY = _timeLab.centerY;
    _awayTeamFlagView.left = _vsView.right+17;
    [self addSubview:_awayTeamFlagView];
    _awayTeamFlagView.image = [UIImage imageNamed:@"americaflag"];
    
    _awayTeamLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 20, 20)];
    _awayTeamLab.left = _awayTeamFlagView.right + 17;
    _awayTeamLab.centerY = _timeLab.centerY;
    [self addSubview:_awayTeamLab];
    
    _timeLab.font = [UIFont systemFontOfSize:10];
    _hostTeamLab.font = [UIFont systemFontOfSize:10];
    _awayTeamLab.font = [UIFont systemFontOfSize:10];
}

-(void)setModel:(CenterSwitchModel *)model{
    
    NSTimeInterval timeIN=(NSTimeInterval)[model.startDate integerValue]/1000;

    NSDate * timeData=[NSDate dateWithTimeIntervalSince1970:timeIN];
    NSString *dataStr = [NSString stringWithFormat:@"%@",[self extractDateToTime:timeData]];
    [_hostTeamFlagView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kQiNiuHeaderPathPrifx,model.hostTeam[@"teamInfo"][@"flag"]]]];//kQiNiuHeaderPathPrifx
    
    [_awayTeamFlagView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kQiNiuHeaderPathPrifx,model.awayTeam[@"teamInfo"][@"flag"]]]];
    _timeLab.text = dataStr;
    _hostTeamLab.text = model.hostTeam[@"teamInfo"][@"name"];
    _awayTeamLab.text = model.awayTeam[@"teamInfo"][@"name"];
    [self resetLabFrame];
}
-(void)resetLabFrame{
    [_timeLab sizeToFit];
    [_hostTeamLab sizeToFit];
    _hostTeamLab.right = _hostTeamFlagView.left-17;
    [_awayTeamLab sizeToFit];
    _timeLab.centerY= _hostTeamFlagView.centerY;
    _hostTeamLab.centerY = _hostTeamFlagView.centerY;
    _awayTeamLab.centerY = _hostTeamFlagView.centerY;
}
- (NSString *)extractDateToTime:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.timeZone = [NSTimeZone systemTimeZone];
    //formatter.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
//    [formatter setDateFormat:@"YYYY/MM/dd / hh:mm"];
    [formatter setDateFormat:@"YYYY/MM/dd"];
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
