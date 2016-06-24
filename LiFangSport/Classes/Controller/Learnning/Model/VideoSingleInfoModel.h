//
//  VideoSingleInfoModel.h
//  LiFangSport
//
//  Created by 张毅 on 16/6/22.
//  Copyright © 2016年 zhangyi. All rights reserved.
//
#import "LearningPlayPopDeciModel.h"
#import <JSONModel/JSONModel.h>

@interface VideoSingleInfoModel : JSONModel
@property(nonatomic,strong)NSString<Optional> *considerations;
@property(nonatomic,assign)NSInteger duration;
@property(nonatomic,strong)NSString<Optional> *explanation;
@property(nonatomic,strong)NSString<Optional> *videoId;
@property(nonatomic,strong)NSString<Optional> *imagePath;
@property(nonatomic,strong)NSArray<LearningPlayPopDeciModel *> *r1;
@property(nonatomic,strong)NSArray<LearningPlayPopDeciModel *> *r2;
@property(nonatomic,strong)NSString<Optional> *rule;
@property(nonatomic,strong)NSString<Optional> *videoPath;

+(NSArray *)modelDealDataFromWithDic:(NSDictionary *)dic;

@end
