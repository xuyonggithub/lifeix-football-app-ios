//
//  CoachDetailVC.m
//  LiFangSport
//
//  Created by 卢亚林 on 16/6/22.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import "CoachDetailVC.h"
#import "CoachInfoView.h"
#import "CommonRequest.h"
#import "CommonLoading.h"

@interface CoachDetailVC ()<CoachInfoViewDelegate>

@property(nonatomic, assign)int likeNum;
@property(nonatomic, assign)BOOL isClick;
@property(nonatomic, assign)BOOL isLike;

@end

@implementation CoachDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"教练介绍";
    [self requestData];
}

-(void)requestData{
    NSString *urlStr = [NSString stringWithFormat:@"games/coaches/%@", self.coachId];
    [CommonRequest requstPath:urlStr loadingDic:nil queryParam:nil success:^(CommonRequest *request, id jsonDict) {
        [self dealWithDic: jsonDict];
    } failure:^(CommonRequest *request, NSError *error) {
        NSLog(@"error = %@", error);
    }];
}

-(void)requestLikes:(UIView *)view{
    CoachInfoView *baseView = (CoachInfoView *)view;
    UIButton *likeButton = baseView.likeBtn;
    NSString *urlStr = [NSString stringWithFormat:@"like/likes/%@?type=nationalteam", self.coachId];
    [CommonRequest requstPath:urlStr loadingDic:nil queryParam:nil success:^(CommonRequest *request, id jsonDict) {
        NSLog(@"data = %@", jsonDict);
        NSDictionary *dic = jsonDict;
        if(![[dic objectForKey:@"like"] isEqual:[NSNull null]]){
            if([[dic objectForKey:@"like"] boolValue] == YES){
                self.isLike = YES;
            }
        }
        int like = [[dic objectForKey:@"likeNum"] intValue];
        _likeNum = like;
        [likeButton setTitle:[NSString stringWithFormat:@"%d", like] forState:UIControlStateNormal];
    } failure:^(CommonRequest *request, NSError *error) {
        NSLog(@"error = %@", error);
    }];
}

-(void)dealWithDic:(id)dic{
    NSDictionary *dict = dic;
    NSString *birthday = [self timeStampChangeTimeWithTimeStamp:[dict objectForKey:@"birthday"] timeStyle:@"YYYY-MM-dd"];
    NSArray *keys = [dict allKeys];
    NSString *club;
    if([keys containsObject:@"company"]){
        club = [dict objectForKey:@"company"];
    }else{
        club = @"-";
    }
    
    CoachInfoView *coachView = [[CoachInfoView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 150) andAvatar:[dict objectForKey:@"avatar"] andName:[dict objectForKey:@"name"] andBirday:birthday andBirthplace:[dict objectForKey:@"birthplace"] andPart:[[dict objectForKey:@"team"] objectForKey:@"position"] andClub:club];
    coachView.delegate = self;
    [self.view addSubview:coachView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, coachView.bottom, 200, 100/3)];
    label.text = @"执教生涯";
    label.font = [UIFont systemFontOfSize:10];
    label.textColor = HEXRGBCOLOR(0x5f5f5f);
    [self.view addSubview:label];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, label.bottom, SCREEN_WIDTH, 1)];
    lineView.backgroundColor = HEXRGBCOLOR(0x9a9a9a);
    [self.view addSubview:lineView];
    
    [self requestLikes:coachView];
}

#pragma mark - BaseInfoViewDelegate
-(void)likeBtnClicked:(UIButton *)btn{
    NSLog(@"like");
    if(_isClick == YES){
        [CommonLoading showTips:@"重复操作"];
        return;
    }else if (_isLike == YES){
        [CommonLoading showTips:@"不能重复点赞"];
        return;
    };
    NSDictionary *dic = @{@"type":@"nationalteam", @"target":self.coachId, @"like":@1};
    [CommonRequest requstPath:@"like/likes" loadingDic:nil postParam:dic success:^(CommonRequest *request, id jsonDict) {
        NSLog(@"succeed!%@", jsonDict);
        [btn setTitle:[NSString stringWithFormat:@"%d", _likeNum + 1] forState:UIControlStateNormal];
    } failure:^(CommonRequest *request, NSError *error) {
        NSLog(@"error: %@", error);
    }];
    _isClick = YES;
    
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
    NSString *strDate = [formatter stringFromDate:date];
    NSString *formatterStr = [strDate stringByReplacingOccurrencesOfString:@"+08:00" withString:@"Z"];
    return formatterStr;
}
@end
