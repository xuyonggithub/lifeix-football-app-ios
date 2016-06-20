//
//  HomeLeftCategModel.m
//  LiFangSport
//
//  Created by 张毅 on 16/6/14.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import "HomeLeftCategModel.h"

@implementation HomeLeftCategModel
- (id)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err{
    self = [super initWithDictionary:dict error:err];
    if(self){
        
        self.KID = dict[@"id"];
    }
    return self;
}

@end
