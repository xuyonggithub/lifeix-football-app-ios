//
//  LeftCategoryCell.m
//  LiFangSport
//
//  Created by 张毅 on 16/6/14.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import "LeftCategoryCell.h"
#import "UIImageView+WebCache.h"

@interface LeftCategoryCell ()
@property(nonatomic,strong)UIImageView *iconView;
@property(nonatomic,strong)UILabel *titleLab;

@end

@implementation LeftCategoryCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self createSubviews];
    }
    return self;
}

-(void)createSubviews{
    _iconView = [[UIImageView alloc]initWithFrame:CGRectMake(40, 0, 30, 30)];
    _titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 70, 30)];
    _titleLab.left = _iconView.right + 15;
    _titleLab.textColor = HEXRGBCOLOR(0x929292);
    _titleLab.font = [UIFont systemFontOfSize:13];
    _titleLab.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_iconView];
    [self addSubview:_titleLab];

}
-(void)layoutSubviews{
//    _iconView.centerY = self.centerY;
//    _titleLab.centerY = self.centerY;
}

-(void)setModel:(HomeLeftCategModel *)model{
    _titleLab.text = model.name;
    [_titleLab sizeToFit];
    [_iconView sd_setImageWithURL:[NSURL URLWithString:model.iconUrl] placeholderImage:nil];
    _iconView.centerY = self.centerY;
    _titleLab.centerY = self.centerY;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
