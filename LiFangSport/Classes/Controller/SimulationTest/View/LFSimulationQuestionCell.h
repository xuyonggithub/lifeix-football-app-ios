//
//  LFSimulationQuestionCell.h
//  LiFangSport
//
//  Created by Zhangqibin on 16/6/23.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^LFGeneralBlock)(id object);

@interface LFSimulationQuestionCell : UITableViewCell

@property (nonatomic, copy) LFGeneralBlock selectedBlock;

- (void)refreshContent:(NSString *)question isSelected:(BOOL)isSelected;

@end
