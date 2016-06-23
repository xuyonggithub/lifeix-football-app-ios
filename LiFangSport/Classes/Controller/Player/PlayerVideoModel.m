//
//  PlayerVideoModel.m
//  LiFangSport
//
//  Created by 卢亚林 on 16/6/23.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import "PlayerVideoModel.h"

@implementation PlayerVideoModel

+(JSONKeyMapper*)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id": @"videoId",
                                                       @"playerId": @"playerId",
                                                       @"playerName": @"playerName",
                                                       @"title": @"title",
                                                       @"url": @"url"
                                                       }];
}

@end
