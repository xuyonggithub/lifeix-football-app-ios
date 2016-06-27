//
//  CoachModel.m
//  LiFangSport
//
//  Created by Lifeix on 16/6/17.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import "CoachModel.h"

@implementation CoachModel

+(JSONKeyMapper*)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"position": @"position",
                                                       @"awatar": @"awatar",
                                                       @"name": @"name",
                                                       @"id": @"coachaId",
                                                       @"country": @"country",
                                                       @"birthday": @"birthday",
                                                       @"level": @"level",
                                                       @"birthplace": @"birthplace",
                                                       }];
}

@end
