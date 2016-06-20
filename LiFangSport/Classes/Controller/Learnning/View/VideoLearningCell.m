//
//  VideoLearningCell.m
//  LiFangSport
//
//  Created by 张毅 on 16/6/15.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import "VideoLearningCell.h"
#import "UIImageView+WebCache.h"

@interface VideoLearningCell ()
@property(nonatomic,strong)UIImageView *picView;
@property(nonatomic,strong)UILabel *titleLab;

@end

@implementation VideoLearningCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubviews];
    }
    return self;
}
-(void)initSubviews{
    _picView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 5, kScreenWidth, 90)];
    _picView.width = kScreenWidth;
    [self addSubview:_picView];
    _picView.image = [UIImage imageNamed:@"ou1233aeer"];
    _titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, self.width, 15)];
    _titleLab.bottom = _picView.bottom;
    [self addSubview:_titleLab];
    _titleLab.textColor = kBlackColor;
    _titleLab.textAlignment = NSTextAlignmentCenter;
    _titleLab.font = [UIFont systemFontOfSize:15];
    _titleLab.text = @"详细文字";
}

-(void)setModel:(VideoListModel *)model{
    _titleLab.text = model.name;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
