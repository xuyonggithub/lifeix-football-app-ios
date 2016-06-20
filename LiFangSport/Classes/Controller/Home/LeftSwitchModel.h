//
//  LeftSwitchModel.h
//  LiFangSport
//
//  Created by 张毅 on 16/6/15.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface LeftSwitchModel : JSONModel
@property(nonatomic,strong)NSDictionary<Optional> *awayTeam;
@property(nonatomic,strong)NSDictionary<Optional> *competitionInfo;
@property(nonatomic,strong)NSDictionary<Optional> *court;
@property (nonatomic, strong) NSString<Optional> *group;
@property(nonatomic,strong)NSDictionary<Optional> *hostTeam;
@property(nonatomic,assign)NSInteger id;
@property (nonatomic, strong) NSString<Optional> *position;
@property (nonatomic, strong) NSString<Optional> *stage;
@property (nonatomic, strong) NSString<Optional> *startDate;
@property (nonatomic, strong) NSString<Optional> *startTime;

@end
