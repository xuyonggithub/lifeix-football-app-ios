//
//  LFSimulationCategoryModel.h
//  LiFangSport
//
//  Created by Zhangqibin on 16/6/22.
//  Copyright © 2016年 zhangyi. All rights reserved.
//
//  模拟测试列表Model

#import <Foundation/Foundation.h>

@interface LFSimulationCategoryModel : NSObject

@property (nonatomic, copy) NSString *categoryId;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSNumber *type;
@property (nonatomic, strong) NSArray *subArray;

+ (LFSimulationCategoryModel *)simulationTestModelWithDict:(NSDictionary *)dict;
+ (NSArray *)simulationTestModelArrayWithArray:(NSArray *)array;

@end

