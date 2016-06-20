//
//  MediaCategoryCell.m
//  LiFangSport
//
//  Created by Lifeix on 16/6/15.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import "MediaCategoryCell.h"

@implementation MediaCategoryCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.bounds];
        self.selectedBackgroundView.backgroundColor = HEXRGBCOLOR(0x951c22);
        [self createSubviews];
    }
    return self;
}

-(void)createSubviews{
    _titleLab = [[UILabel alloc]initWithFrame:CGRectMake(80, 0, 80, 44)];
    _titleLab.textColor = HEXRGBCOLOR(0x929292);
    _titleLab.font = [UIFont systemFontOfSize:19];
    _titleLab.textAlignment = NSTextAlignmentLeft;
    _titleLab.centerY = self.centerY;
    [self addSubview:_titleLab];
    
}
-(void)layoutSubviews{
    [super layoutSubviews];
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
