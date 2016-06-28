//
//  RightSwitchModel.m
//  LiFangSport
//
//  Created by 张毅 on 16/6/15.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import "RightSwitchModel.h"

@implementation RightSwitchModel

- (id)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err{
    self = [super initWithDictionary:dict error:err];
    if(self){
        
        self.KID = dict[@"id"];
    }
    return self;
}

+(NSArray *)modelDealDataFromWithDic:(NSDictionary *)dic{
    
    RightSwitchModel *model = [[RightSwitchModel alloc]init];
    model.avatar = dic[@"avatar"];
    model.birthday = dic[@"birthday"];
    model.birthplace = dic[@"birthplace"];
    model.country = dic[@"country"];
    model.KID = dic[@"id"];
    model.level = dic[@"level"];
    model.name = dic[@"name"];
    model.position = dic[@"position"];
    
    NSArray *arr = [NSArray arrayWithObject:model];
    return arr;
}
@end
