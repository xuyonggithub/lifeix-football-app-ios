//
//  VideoLearningUnitModel.m
//  LiFangSport
//
//  Created by 张毅 on 16/6/21.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import "VideoLearningUnitModel.h"

@implementation VideoLearningUnitModel

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"KID"}];
}

@end
