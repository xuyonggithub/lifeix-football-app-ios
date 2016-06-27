//
//  PlayerModel.m
//  LiFangSport
//
//  Created by Lifeix on 16/6/13.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import "PlayerModel.h"

@implementation PlayerModel

+(JSONKeyMapper*)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"position": @"position",
                                                       @"avatar": @"avatar",
                                                       @"name": @"name",
                                                       @"id": @"playerId"
                                                       }];
}


@end
