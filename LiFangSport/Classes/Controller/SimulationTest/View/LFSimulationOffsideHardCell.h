//
//  LFSimulationOffsideHardCell.h
//  LiFangSport
//
//  Created by Zhangqibin on 16/6/23.
//  Copyright © 2016年 zhangyi. All rights reserved.
//
//  越位复杂题目Cell

#import <UIKit/UIKit.h>

@interface LFSimulationOffsideHardCell : UICollectionViewCell

- (void)refreshOffsideHardCellContent:(NSString *)imageUrl content:(NSString *)content selectedIndex:(NSInteger)selectedIndex rightIndex:(NSInteger)rightIndex row:(NSInteger)row;

@end
