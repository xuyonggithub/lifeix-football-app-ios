//
//  StaffsInfoModel.m
//  LiFangSport
//
//  Created by 张毅 on 16/7/8.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import "StaffsInfoModel.h"

@implementation StaffsInfoModel
+(JSONKeyMapper*)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id": @"kid",
                                                       }];
}
@end
