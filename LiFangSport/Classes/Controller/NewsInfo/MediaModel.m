//
//  MediaModel.m
//  LiFangSport
//
//  Created by Lifeix on 16/6/12.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import "MediaModel.h"

@implementation MediaModel

+(JSONKeyMapper*)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"images": @"images",
                                                       @"categoryIds": @"categoryIds",
                                                       @"createTime": @"createTime",
                                                       @"author.name": @"author",
                                                       @"videos": @"videos",
                                                       @"id": @"mediaId",
                                                       @"title": @"title",
                                                       @"content": @"content",
                                                       @"status": @"status",
                                                       @"image": @"image",
                                                       @"url": @"url"
                                                       }];
}

@end
