//
//  LFSimulationQuestionModel.h
//  LiFangSport
//
//  Created by Zhangqibin on 16/6/22.
//  Copyright © 2016年 zhangyi. All rights reserved.
//
//  模拟测试题目Model

#import <Foundation/Foundation.h>

@interface LFSimulationQuestionModel : NSObject

@property (nonatomic, copy) NSString *questionId;
@property (nonatomic, strong) NSArray *leftQuestionArray;
@property (nonatomic, strong) NSArray *rightQuestionArray;
@property (nonatomic, assign) NSInteger leftAnswerIndex;
@property (nonatomic, assign) NSInteger rightAnswerIndex;
@property (nonatomic, copy) NSString *videoPath;

+ (LFSimulationQuestionModel *)simulationQuestionModelWithDict:(NSDictionary *)dict;
+ (NSArray *)simulationQuestionModelArrayWithArray:(NSArray *)array;

@end
/*
id = 5769f022e385fdde342569cb;
type = 1;
videos =     (
              {
                  duration = 24;
                  id = 5769f022e385fdde3425694d;
                  r1 =             (
                                    {
                                        right = 1;
                                        text = "NO FOUL";
                                    },
                                    {
                                        text = "INDIRECT FREE KICK";
                                    },
                                    {
                                        text = "DIRECT FREE KICK";
                                    },
                                    {
                                        text = "PENALTY KICK";
                                    }
                                    );
                  r2 =             (
                                    {
                                        right = 1;
                                        text = "NO CARD";
                                    },
                                    {
                                        text = "YELLOW CARD";
                                    },
                                    {
                                        text = "RED CARD";
                                    }
                                    );
                  videoPath = "elearning/fmc2014/part1/medias/flv/fwc14-m02-mex-cmr-03";
              }
              );
}
 */
