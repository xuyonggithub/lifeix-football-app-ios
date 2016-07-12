//
//  CurrentlyScoreCell.m
//  LiFangSport
//
//  Created by 张毅 on 16/7/6.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import "CurrentlyScoreCell.h"
#import "UIImageView+WebCache.h"
#define kCurrentlyScoreCellPicHeaderPath  @"http://roi.skst.cn/logo/"
@interface CurrentlyScoreCell ()
@property(nonatomic,strong)UIImageView *picView;
@property(nonatomic,strong)UILabel *titleLab;
@property(nonatomic,strong)UILabel *subTitleLab;
@property(nonatomic,strong)UIImageView *hostTeamFlagView;
@property(nonatomic,strong)UIImageView *awayTeamFlagView;
@property(nonatomic,strong)UILabel *hostTeamNameLab;
@property(nonatomic,strong)UILabel *awayTeamNameLab;
@property(nonatomic,strong)NSDictionary *weekDic;
@property(nonatomic,strong)NSDictionary *monthDic;
@property(nonatomic,strong)UILabel *normalScoreLab;
@property(nonatomic,strong)UIButton *gameStatusBtn;

@end
@implementation CurrentlyScoreCell

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
    _titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, kScreenWidth, 30)];
    [self addSubview:_titleLab];
    _subTitleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
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
    
    _awayTeamFlagView = [[UIImageView alloc]initWithFrame:CGRectMake(40, 0, 50, 35)];
    [self addSubview:_awayTeamFlagView];
    
    _titleLab.textAlignment = NSTextAlignmentCenter;
    _subTitleLab.textAlignment = NSTextAlignmentCenter;
    _hostTeamFlagView.top = _picView.bottom;
    _awayTeamFlagView.top = _hostTeamFlagView.top;
    _awayTeamFlagView.right = kScreenWidth-40;
    
    _likeView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 35, 25)];
    _likeView.centerY = _hostTeamFlagView.centerY;
    _likeView.centerX = kScreenWidth/2;
    [self addSubview:_likeView];
    _likeView.image = UIImageNamed(@"VSicon");
    
    _normalScoreLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 20)];
    _normalScoreLab.center = _likeView.center;
    _normalScoreLab.textAlignment = NSTextAlignmentCenter;
    _normalScoreLab.textColor = kTitleColor;
    _normalScoreLab.font = [UIFont systemFontOfSize:20];
    [self addSubview:_normalScoreLab];
    _normalScoreLab.hidden = YES;
    
    _gameStatusBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 20)];
    _gameStatusBtn.centerX = _normalScoreLab.centerX;
    _gameStatusBtn.top = _normalScoreLab.bottom+5;
    _gameStatusBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_gameStatusBtn setTitleColor:HEXRGBCOLOR(0xd0d0d0) forState:UIControlStateNormal];
    _gameStatusBtn.titleLabel.font =[UIFont systemFontOfSize:10];
    [self addSubview:_gameStatusBtn];
    _gameStatusBtn.hidden = YES;
    
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

-(void)setModel:(CurrentlyScoreModel *)model{
    _gameStatusBtn.hidden = YES;
    if ([model.status integerValue] == 0) {//未开始
        _normalScoreLab.hidden = YES;
        _likeView.hidden = NO;
        
    }else{
        _normalScoreLab.hidden = NO;
        _likeView.hidden = YES;
        _normalScoreLab.text = [NSString stringWithFormat:@"%@-%@",model.home_scores,model.away_scores];
        if (model.final_result) {
            _normalScoreLab.text = [NSString stringWithFormat:@"(%@)%@-%@(%@)",model.final_result[@"home_scores"],model.home_scores,model.away_scores,model.final_result[@"away_scores"]];
        }
        [self resetLabFrame:_normalScoreLab];
        if ([model.status integerValue] == -1) {//完场
            _gameStatusBtn.hidden = NO;
            [_gameStatusBtn setTitle:@"已完场" forState:UIControlStateNormal];
            [_gameStatusBtn setImage:nil forState:UIControlStateNormal];
            [_gameStatusBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];

            if (model.final_result) {
              if ([model.final_result[@"score_type"] integerValue]==3) {
                [_gameStatusBtn setTitle:@"已完场" forState:UIControlStateNormal];
                [_gameStatusBtn setImage:UIImageNamed(@"overtime") forState:UIControlStateNormal];

                [_gameStatusBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -_gameStatusBtn.imageView.size.width-3, 0, _gameStatusBtn.imageView.size.width)];
                [_gameStatusBtn setImageEdgeInsets:UIEdgeInsetsMake(0, _gameStatusBtn.titleLabel.bounds.size.width+3, 0, -_gameStatusBtn.titleLabel.bounds.size.width)];
              }else if ([model.final_result[@"score_type"] integerValue]==4) {
                [_gameStatusBtn setTitle:@"已完场" forState:UIControlStateNormal];
                [_gameStatusBtn setImage:UIImageNamed(@"penalty") forState:UIControlStateNormal];
                [_gameStatusBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -_gameStatusBtn.imageView.size.width-3, 0, _gameStatusBtn.imageView.size.width)];
                [_gameStatusBtn setImageEdgeInsets:UIEdgeInsetsMake(0, _gameStatusBtn.titleLabel.bounds.size.width+3, 0, -_gameStatusBtn.titleLabel.bounds.size.width)];
              }
            }
        }else{

        }
    }
    
    NSArray *dateTimeArr = [[NSArray alloc]initWithArray:[self dateTimeArrFromOfStr:model.start_time]];
    NSString *dataStr = [NSString stringWithFormat:@"%@月%@日 %@",[self.monthDic objectForKey:dateTimeArr[1]],dateTimeArr[2],[self.weekDic objectForKey:dateTimeArr[0]]];
    
    _titleLab.text = dataStr;
    NSString *timeStr = [NSString stringWithFormat:@"%@ %@",[dateTimeArr[3] substringToIndex:5],model.cup_name];
    _subTitleLab.text = timeStr;

    [_hostTeamFlagView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kCurrentlyScoreCellPicHeaderPath,model.h_t[@"logo"]]]];
    
    [_awayTeamFlagView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kCurrentlyScoreCellPicHeaderPath,model.a_t[@"logo"]]]];

    _hostTeamNameLab.text = model.h_t[@"name"];
    [_hostTeamNameLab sizeToFit];
    _hostTeamNameLab.centerX = _hostTeamFlagView.centerX;
    
    _awayTeamNameLab.text = model.a_t[@"name"];
    [_awayTeamNameLab sizeToFit];
    _awayTeamNameLab.centerX = _awayTeamFlagView.centerX;
}

-(NSDictionary *)weekDic{
    NSDictionary* dic = @{@"Mon":@"周一",@"Tue":@"周二",@"Wed":@"周三",@"Thu":@"周四",@"Fri":@"周五",@"Sat":@"周六",@"Sun":@"周日"};
    if (!_weekDic) {
        _weekDic = [[NSDictionary alloc]initWithDictionary:dic];
    }
    return _weekDic;
}
-(NSDictionary *)monthDic{
    NSDictionary* monthDic = @{@"Jan":@"01",@"Feb":@"02",@"Mar":@"03",@"Apr":@"04",@"May":@"05",@"Jun":@"06",@"Jul":@"07",@"Aug":@"08",@"Sep":@"09",@"Oct":@"10",@"Nov":@"11",@"Dec":@"12"};
    if (_monthDic==nil) {
        _monthDic = [[NSDictionary alloc]initWithDictionary:monthDic];
    }
    return _monthDic;
}

-(NSArray *)dateTimeArrFromOfStr:(NSString *)str{
    NSArray* ndateTimeArr = [str componentsSeparatedByString:@" "];
    return ndateTimeArr;
}

-(void)resetLabFrame:(UILabel *)lab{
    CGFloat x = lab.centerX;
    [lab sizeToFit];
    lab.centerX = x;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
