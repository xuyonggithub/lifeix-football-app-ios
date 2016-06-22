//
//  LFSimulationCenterCell.h
//  LiFangSport
//
//  Created by Zhangqibin on 16/6/20.
//  Copyright © 2016年 zhangyi. All rights reserved.
//
//  模拟测试列表Cell

#import <UIKit/UIKit.h>
#import "LFSimulationCategoryModel.h"

@interface LFSimulationCenterCell : UITableViewCell

- (void)refreshContent:(LFSimulationCategoryModel *)model;

@end
