//
//  MediaCell.m
//  LiFangSport
//
//  Created by Lifeix on 16/6/12.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import "MediaCell.h"
#import "UIImageView+WebCache.h"
#import "MediaModel.h"

@implementation MediaCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(25/2, 10, SCREEN_WIDTH - 25, (SCREEN_WIDTH - 25) / 2.0)];
        view.backgroundColor = kclearColor;
        [self.contentView addSubview:view];
        self.backgroundColor = kclearColor;
        self.contentView.alpha = 0.2;
        // 背景图
        self.bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 25, (SCREEN_WIDTH - 25) / 2.0)];
        self.bgImgView.userInteractionEnabled = YES;
        [view addSubview:self.bgImgView];
        
        // bottomView
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(25/2, view.bottom, SCREEN_WIDTH - 25, 35)];
        bottomView.backgroundColor = kwhiteColor;
        bottomView.alpha = 0.9;
        [self.contentView addSubview:bottomView];
        // 时间
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 6, view.width - 25, 6)];
        self.timeLabel.font = [UIFont systemFontOfSize:7];
        [bottomView addSubview:_timeLabel];
        // 标题
//        UIImageView *titleBgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, _bgImgView.bottom, self.bgImgView.width, 35)];
//        titleBgView.image = [UIImage imageNamed:@"titleBg.jpg"];
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 18, _timeLabel.width, 11)];
        self.titleLabel.font = kBasicBigDetailTitleFont;
        self.titleLabel.textColor = kBlackColor;
        [bottomView addSubview:self.titleLabel];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

-(void)displayCell:(MediaModel *)media{
    if(media.image != nil){
        NSString *str = [NSString stringWithFormat:@"%@?imageView/1/w/%d/h/%d", media.image, (int)(SCREEN_WIDTH - 25) * 2 - 2, (int)(SCREEN_WIDTH - 25 - 2)];
        [self.bgImgView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"placeholder_media.jpg"] options:SDWebImageCacheMemoryOnly completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            self.contentView.alpha = 1.0;
        }];
        
    }else{
        self.bgImgView.image = [UIImage imageNamed:@"placeholder_media.jpg"];
    }
    if(media.containVideo == YES){
        UIImageView *playView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        playView.image = UIImageNamed(@"videobofang");
        playView.center = _bgImgView.center;
        playView.userInteractionEnabled = YES;
        [_bgImgView addSubview:playView];
    }
    self.titleLabel.text = media.title;
    self.timeLabel.text = [self timeStampChangeTimeWithTimeStamp:[NSString stringWithFormat:@"%f", media.createTime] timeStyle:@"yyyy-MM-dd HH:mm"];
}

/**
 *  时间戳转时间
 *
 *  @param timeStamp 时间戳 （eg:@"1296035591"）
 *  @param timeStyle 时间格式（eg: @"YYYY-MM-dd HH:mm:ss" ）
 *
 *  @return 返回转化好格式的时间字符串
 */
-(NSString *)timeStampChangeTimeWithTimeStamp:(NSString *)timeStamp timeStyle:(NSString *)timeStyle{
    NSTimeInterval interval = [timeStamp doubleValue]/1000.0;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:timeStyle];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSTimeZone *zoneOne = [NSTimeZone systemTimeZone];
    NSInteger intervalOne = [zoneOne secondsFromGMTForDate:date];
    //得到我国时区的时间
    NSDate *locateDateOne = [date dateByAddingTimeInterval:-intervalOne];
    NSString *strDate = [formatter stringFromDate:locateDateOne];
    NSString *formatterStr = [strDate stringByReplacingOccurrencesOfString:@"+08:00" withString:@"Z"];
    return formatterStr;
}

@end
