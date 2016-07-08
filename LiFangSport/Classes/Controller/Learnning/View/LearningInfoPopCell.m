//
//  LearningInfoPopCell.m
//  LiFangSport
//
//  Created by 张毅 on 16/6/28.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import "LearningInfoPopCell.h"

@interface LearningInfoPopCell ()

@end

@implementation LearningInfoPopCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.bounds];
        self.selectedBackgroundView.backgroundColor = HEXRGBCOLOR(0x951c22);
        [self createSubviews];
    }
    return self;
}

-(void)createSubviews{
    _titleLab = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, 200, 44)];
    _titleLab.textColor = HEXRGBCOLOR(0x929292);
    _titleLab.font = [UIFont systemFontOfSize:11];
    _titleLab.textAlignment = NSTextAlignmentLeft;
    _titleLab.centerY = self.centerY;
    [self addSubview:_titleLab];
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
