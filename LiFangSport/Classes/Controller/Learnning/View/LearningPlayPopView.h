//
//  LearningPlayPopView.h
//  LiFangSport
//
//  Created by 张毅 on 16/6/23.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^LearningPlayPopViewBlock)(void);

@interface LearningPlayPopView : UIView
@property (nonatomic, copy) LearningPlayPopViewBlock replayBlock;


@end
