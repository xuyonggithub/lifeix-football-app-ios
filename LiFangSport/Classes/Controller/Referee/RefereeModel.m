//
//  RefereeModel.m
//  LiFangSport
//
//  Created by Lifeix on 16/6/17.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import "RefereeModel.h"

@implementation RefereeModel

+(JSONKeyMapper*)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"function": @"function",
                                                       @"avatar": @"avatar",
                                                       @"name": @"name",
                                                       @"birthday": @"birthday",
                                                       @"association": @"association",
                                                       @"fifaTopANum": @"fifaTopANum",
                                                       @"sinceInternational": @"sinceInternational",
                                                       @"topLeagueNum": @"topLeagueNum",
                                                       @"id": @"refefeeId"
                                                       }];
}

@end
