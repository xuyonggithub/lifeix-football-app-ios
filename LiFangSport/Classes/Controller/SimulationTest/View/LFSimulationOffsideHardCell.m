//
//  LFSimulationOffsideHardCell.m
//  LiFangSport
//
//  Created by Zhangqibin on 16/6/23.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import "LFSimulationOffsideHardCell.h"

@implementation LFSimulationOffsideHardCell

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        __weak typeof(self) weakSelf = self;
        
        self.userLogoImageView = [UIImageView new];
        [self.contentView addSubview:self.userLogoImageView];
        
        [self.userLogoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weakSelf.contentView);
        }];
    }
    return self;
}


@end
