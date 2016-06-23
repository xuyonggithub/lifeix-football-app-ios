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
@property (nonatomic, strong) NSArray *leftQuestionImageArray;
@property (nonatomic, strong) NSArray *rightQuestionArray;
@property (nonatomic, assign) NSInteger leftAnswerIndex;
@property (nonatomic, assign) NSInteger rightAnswerIndex;
@property (nonatomic, copy) NSString *videoPath;

+ (LFSimulationQuestionModel *)simulationQuestionModelWithDict:(NSDictionary *)dict;
+ (NSArray *)simulationQuestionModelArrayWithArray:(NSArray *)array;

@end
/*
 越位简单
{
    id = 576a807ee38531ddd3aaa5bd;
    index = 143;
    type = 1;
    videos =     (
                  {
                      duration = 4;
                      id = 576a807ee38531ddd3aaa513;
                      r1 =             (
                                        {
                                            index = 1;
                                            text = OFFSIDE;
                                        },
                                        {
                                            index = 2;
                                            right = 1;
                                            text = "NO OFFSIDE";
                                        }
                                        );
                      videoPath = "elearning/iovt2010/medias/flv/143";
                  }
                  );
}
 */
/*
 越位复杂
{
    id = 576a8083e38531ddd3aaa72c;
    index = 170;
    type = 1;
    videos =     (
                  {
                      duration = 2;
                      id = 576a8083e38531ddd3aaa682;
                      r1 =             (
                                        {
                                            image = "elearning/iovt2010/medias/th/170_a.jpg";
                                            index = 1;
                                            text = A;
                                        },
                                        {
                                            image = "elearning/iovt2010/medias/th/170_b.jpg";
                                            index = 2;
                                            text = B;
                                        },
                                        {
                                            image = "elearning/iovt2010/medias/th/170_cv.jpg";
                                            index = 3;
                                            right = 1;
                                            text = C;
                                        },
                                        {
                                            image = "elearning/iovt2010/medias/th/170_d.jpg";
                                            index = 4;
                                            text = D;
                                        }
                                        );
                      videoPath = "elearning/iovt2010/medias/flv/170";
                  }
                  );
}
 */

/*
 男足、女足
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
