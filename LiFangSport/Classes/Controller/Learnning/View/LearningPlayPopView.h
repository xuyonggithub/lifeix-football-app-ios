//
//  LearningPlayPopView.h
//  LiFangSport
//
//  Created by 张毅 on 16/6/23.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoSingleInfoModel.h"
typedef NS_ENUM(NSInteger, LearningPlayPopViewType){
    LPPOP_FACTORS,
    LPPOP_DECISION,
    LPPOP_DETAIL,
    LPPOP_RULE,
};
typedef void(^LearningPlayPopViewBlock)(void);

@interface LearningPlayPopView : UIView
@property (nonatomic, copy) LearningPlayPopViewBlock closeBc;
@property(nonatomic,strong)VideoSingleInfoModel *model;

-(void)setModel:(VideoSingleInfoModel *)model WithType:(LearningPlayPopViewType)type;

@end
