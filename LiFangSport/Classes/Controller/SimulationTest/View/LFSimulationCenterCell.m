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
    UILabel *_nameLabel;
}
@end

@implementation LFSimulationCenterCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _bgImageView = [UIImageView new];
        [self.contentView addSubview:_bgImageView];
        [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        _nameLabel = [UILabel new];
        [self.contentView addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.and.bottom.equalTo(self.contentView);
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
    _nameLabel.text = model.name;
}

@end
