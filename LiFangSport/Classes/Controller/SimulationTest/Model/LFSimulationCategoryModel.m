//
//  LFSimulationCategoryModel.m
//  LiFangSport
//
//  Created by Zhangqibin on 16/6/22.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import "LFSimulationCategoryModel.h"

@implementation LFSimulationCategoryModel

+ (LFSimulationCategoryModel *)simulationTestModelWithDict:(NSDictionary *)dict
{
    LFSimulationCategoryModel *model = [[LFSimulationCategoryModel alloc] init];
    model.categoryId = dict[@"id"];
    model.image = dict[@"image"];
    model.name = dict[@"name"];
    model.text = dict[@"text"];
    model.type = dict[@"type"];
    NSArray *catArray = dict[@"cats"];
    if (catArray) {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
        for (NSDictionary *cat in catArray) {
            LFSimulationCategoryModel *model = [[LFSimulationCategoryModel alloc] init];
            model.categoryId = cat[@"id"];
            model.image = cat[@"image"];
            model.name = cat[@"name"];
            model.text = cat[@"text"];
            model.type = cat[@"type"];
            [array addObject:model];
        }
        model.subArray = [NSArray arrayWithArray:array];
    }
    return model;
}

+ (NSArray *)simulationTestModelArrayWithArray:(NSArray *)array
{
    NSMutableArray *modelArray = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary *dict in array) {
        LFSimulationCategoryModel *model = [LFSimulationCategoryModel simulationTestModelWithDict:dict];
        [modelArray addObject:model];
    }
    return [NSArray arrayWithArray:modelArray];
}

@end
