//
//  LFSimulationQuestionModel.m
//  LiFangSport
//
//  Created by Zhangqibin on 16/6/22.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import "LFSimulationQuestionModel.h"

@implementation LFSimulationQuestionModel
+ (LFSimulationQuestionModel *)simulationQuestionModelWithDict:(NSDictionary *)dict
{
    LFSimulationQuestionModel *model = [[LFSimulationQuestionModel alloc] init];
//    model.categoryId = dict[@"id"];
//    model.image = dict[@"image"];
//    model.name = dict[@"name"];
//    model.text = dict[@"text"];
//    model.type = dict[@"type"];
    return model;
}

+ (NSArray *)simulationQuestionModelArrayWithArray:(NSArray *)array
{
    NSMutableArray *modelArray = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary *dict in array) {
        LFSimulationQuestionModel *model = [LFSimulationQuestionModel simulationQuestionModelWithDict:dict];
        [modelArray addObject:model];
    }
    return [NSArray arrayWithArray:modelArray];
}

@end
