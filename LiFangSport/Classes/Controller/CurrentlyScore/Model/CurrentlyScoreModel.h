//
//  CurrentlyScoreModel.h
//  LiFangSport
//
//  Created by 张毅 on 16/7/6.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface CurrentlyScoreModel : JSONModel
@property (nonatomic, copy) NSNumber <Optional>*contest_id;
@property (nonatomic, copy) NSNumber <Optional>*target_id;
@property (nonatomic, copy) NSNumber <Optional>*cup_id;
@property (nonatomic, copy) NSString <Optional>*cup_name;
@property (nonatomic, copy) NSString <Optional>*color;
@property (nonatomic, copy) NSNumber <Optional>*contest_type;
@property (nonatomic, copy) NSNumber <Optional>*home_team;
@property (nonatomic, copy) NSNumber <Optional>*home_scores;
@property (nonatomic, copy) NSNumber <Optional>*away_team;
@property (nonatomic, copy) NSNumber <Optional>*away_scores;
@property (nonatomic, copy) NSString <Optional>*start_time;
@property (nonatomic, copy) NSNumber <Optional>*status;
@property (nonatomic, copy) NSNumber <Optional>*settle;
@property (nonatomic, copy) NSNumber <Optional>*odds_type;
@property (nonatomic, copy) NSNumber <Optional>*level;
@property (nonatomic, copy) NSNumber <Optional>*bet_count;
@property (nonatomic, assign) BOOL belong_five;
@property (nonatomic, assign) BOOL longbi;
@property (nonatomic, strong) NSDictionary <Optional>*h_t;
@property (nonatomic, strong) NSDictionary <Optional>*a_t;
@property (nonatomic, strong) NSDictionary <Optional>*final_result;
@property (nonatomic, copy) NSNumber <Optional>*ext_flag;


@end
