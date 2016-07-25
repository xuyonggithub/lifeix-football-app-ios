//
//  VideoLearningDetCell.h
//  LiFangSport
//
//  Created by 张毅 on 16/6/16.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VideoLearningUnitModel;
@class VideoExerciseModel;

@interface VideoLearningDetCell : UICollectionViewCell

- (void)refreshContentWithVideoLearningUnitModel:(VideoLearningUnitModel *)model;
- (void)refreshContentWithVideoExerciseModel:(VideoExerciseModel *)model;

@end
