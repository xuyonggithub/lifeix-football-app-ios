//
//  VideoLearningUnitModel.m
//  LiFangSport
//
//  Created by 张毅 on 16/6/21.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import "VideoLearningUnitModel.h"

@implementation VideoLearningUnitModel
- (id)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err{
    self = [super initWithDictionary:dict error:err];
    if(self){
        
        self.KID = dict[@"id"];
    }
    return self;
}

+(NSArray *)modelDealDataFromWithDic:(NSDictionary *)dic{
    
    VideoLearningUnitModel *model = [[VideoLearningUnitModel alloc]init];
    model.KID = dic[@"id"];
    model.title = dic[@"title"];
//    model.type = [dic[@"type"] integerValue];
    model.video = dic[@"video"];

    NSArray *arr = [NSArray arrayWithObject:model];
    return arr;
}
@end
