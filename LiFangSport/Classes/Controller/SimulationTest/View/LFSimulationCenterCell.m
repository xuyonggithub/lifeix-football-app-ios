//
//  LFSimulationCenterCell.m
//  LiFangSport
//
//  Created by Zhangqibin on 16/6/20.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import "LFSimulationCenterCell.h"

@interface LFSimulationCenterCell ()
{
    UIImageView *_bgImageView;
    UILabel *_titleLabel;
}
@end

@implementation LFSimulationCenterCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _bgImageView = [UIImageView new];
        [self.contentView addSubview:_bgImageView];
        [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(10, 10, 0, 10));
        }];
        
        UIImageView *bannerView = [UIImageView new];
        bannerView.image = [UIImage imageNamed:@"videolistBannerLabpic"];
        [self.contentView addSubview:bannerView];
        [bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.and.bottom.equalTo(_bgImageView);
            make.height.equalTo(@30);
        }];
        
        _titleLabel = [UILabel new];
        _titleLabel.textColor = kwhiteColor;
        _titleLabel.font = [UIFont systemFontOfSize:19];
        [self.contentView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(bannerView);
            make.left.equalTo(bannerView.mas_left).offset(10);
            make.right.equalTo(bannerView.mas_right).offset(-10);
        }];
    }
    return self;
}

- (void)refreshContent:(LFSimulationCategoryModel *)model
{
    [_bgImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",kQiNiuHeaderPathPrifx,@"mobile/",model.image]] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:model.image];   // 保存文件的名称
//        BOOL result = [UIImagePNGRepresentation(image)writeToFile:filePath atomically:YES]; // 保存成功会返回YES
//        NSLog(@"%@", @(result));
    }];
    _titleLabel.text = model.name;
}

@end
