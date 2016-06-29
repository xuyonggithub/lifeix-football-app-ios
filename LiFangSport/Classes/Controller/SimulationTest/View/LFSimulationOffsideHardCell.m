//
//  LFSimulationOffsideHardCell.m
//  LiFangSport
//
//  Created by Zhangqibin on 16/6/23.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import "LFSimulationOffsideHardCell.h"

@interface LFSimulationOffsideHardCell ()
{
    UIImageView *_imageView;
    UIImageView *_coverImageView;
    UILabel *_label;
}
@end

@implementation LFSimulationOffsideHardCell

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        __weak typeof(self) weakSelf = self;
        
        _imageView = [UIImageView new];
        [self.contentView addSubview:_imageView];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.top.and.width.equalTo(weakSelf.contentView);
            make.height.equalTo(weakSelf.contentView.mas_width).multipliedBy(230.0/300);
        }];
        
        _coverImageView = [UIImageView new];
        [self.contentView addSubview:_coverImageView];
        [_coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_imageView);
        }];
        
        _label = [UILabel new];
        _label.font = [UIFont systemFontOfSize:20];
        _label.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_label];
        [_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_imageView.mas_bottom);
            make.centerX.equalTo(_imageView);
        }];
    }
    return self;
}

#pragma mark - Public Methods
- (void)refreshOffsideHardCellContent:(NSString *)imageUrl content:(NSString *)content selectedIndex:(NSInteger)selectedIndex rightIndex:(NSInteger)rightIndex row:(NSInteger)row
{
    [_imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kQiNiuHeaderPathPrifx, imageUrl]] placeholderImage:nil];
    _label.text = content;
    if (selectedIndex != -1) {
        if (row == selectedIndex) {
            _coverImageView.hidden = NO;
            if (selectedIndex == rightIndex) {
                _coverImageView.image = [UIImage imageNamed:@"offside_true"];
            }else {
                _coverImageView.image = [UIImage imageNamed:@"offside_false"];
            }
        }else if (row == rightIndex) {
            _coverImageView.hidden = NO;
            _coverImageView.image = [UIImage imageNamed:@"offside_true"];
        }else {
            _coverImageView.hidden = YES;
        }
    }else {
        _coverImageView.hidden = YES;
    }
}

@end
