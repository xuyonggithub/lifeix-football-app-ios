//
//  VideoSingleInfoModel.m
//  LiFangSport
//
//  Created by 张毅 on 16/6/22.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import "VideoSingleInfoModel.h"

@implementation VideoSingleInfoModel
+(JSONKeyMapper*)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id": @"videoId"
                                                       }];
}

+(NSArray *)modelDealDataFromWithDic:(NSDictionary *)dic{
    
    VideoSingleInfoModel *model = [[VideoSingleInfoModel alloc]init];
    model.considerations = dic[@"considerations"];
    model.duration = [dic[@"duration"] integerValue];
    model.explanation = dic[@"explanation"];
    model.videoId = dic[@"id"];
    model.imagePath = dic[@"imagePath"];
    model.r1 = dic[@"r1"];
    model.r2 = dic[@"r2"];
    model.rule = dic[@"rule"];
    model.videoPath = dic[@"videoPath"];
    
    NSArray *arr = [NSArray arrayWithObject:model];
    return arr;
}


@end
