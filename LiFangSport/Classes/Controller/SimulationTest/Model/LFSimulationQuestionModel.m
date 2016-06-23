//
//  LFSimulationQuestionModel.m
//  LiFangSport
//
//  Created by Zhangqibin on 16/6/22.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import "LFSimulationQuestionModel.h"

@implementation LFSimulationQuestionModel
+ (LFSimulationQuestionModel *)simulationQuestionModelWithDict:(NSDictionary *)dict
{
    LFSimulationQuestionModel *model = [[LFSimulationQuestionModel alloc] init];
//    model.categoryId = dict[@"id"];
//    model.image = dict[@"image"];
//    model.name = dict[@"name"];
//    model.text = dict[@"text"];
//    model.type = dict[@"type"];
    model.questionId = dict[@"id"];
    NSArray *videoArray = dict[@"videos"];
    if ([videoArray isKindOfClass:[NSArray class]] && videoArray.count > 0) {
        NSDictionary *videoDict = videoArray[0];
        
        NSArray *leftArray = videoDict[@"r1"];
        NSMutableArray *leftMutableArray = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray *leftImageMutableArray = [NSMutableArray arrayWithCapacity:0];
        for (NSInteger i = 0; i < leftArray.count; i++) {
            NSDictionary *questionDict = leftArray[i];
            [leftMutableArray addObject:questionDict[@"text"]?:@""];
            [leftImageMutableArray addObject:questionDict[@"image"]?:@""];
            if ([questionDict[@"right"] boolValue]) {
                model.leftAnswerIndex = i;
            }
        }
        model.leftQuestionArray = [NSArray arrayWithArray:leftMutableArray];
        model.leftQuestionImageArray = [NSArray arrayWithArray:leftImageMutableArray];
        
        NSArray *rightArray = videoDict[@"r2"];
        NSMutableArray *rightMutableArray = [NSMutableArray arrayWithCapacity:0];
        for (NSInteger i = 0; i < rightArray.count; i++) {
            NSDictionary *questionDict = rightArray[i];
            [rightMutableArray addObject:questionDict[@"text"]?:@""];
            if ([questionDict[@"right"] boolValue]) {
                model.rightAnswerIndex = i;
            }
        }
        model.rightQuestionArray = [NSArray arrayWithArray:rightMutableArray];
        
        model.videoPath = videoDict[@"videoPath"];
    }
    
    
//    id = 5769f022e385fdde342569cb;
//    type = 1;
//    videos =     (
//                  {
//                      duration = 24;
//                      id = 5769f022e385fdde3425694d;
//                      r1 =             (
//                                        {
//                                            right = 1;
//                                            text = "NO FOUL";
//                                        },
//                                        {
//                                            text = "INDIRECT FREE KICK";
//                                        },
//                                        {
//                                            text = "DIRECT FREE KICK";
//                                        },
//                                        {
//                                            text = "PENALTY KICK";
//                                        }
//                                        );
//                      r2 =             (
//                                        {
//                                            right = 1;
//                                            text = "NO CARD";
//                                        },
//                                        {
//                                            text = "YELLOW CARD";
//                                        },
//                                        {
//                                            text = "RED CARD";
//                                        }
//                                        );
//                      videoPath = "elearning/fmc2014/part1/medias/flv/fwc14-m02-mex-cmr-03";
//                  }
//                  );
//}

    
    
    return model;
}

+ (NSArray *)simulationQuestionModelArrayWithArray:(NSArray *)array
{
    NSMutableArray *modelArray = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary *dict in array) {
        LFSimulationQuestionModel *model = [LFSimulationQuestionModel simulationQuestionModelWithDict:dict];
        [modelArray addObject:model];
    }
    return [NSArray arrayWithArray:modelArray];
}

@end
