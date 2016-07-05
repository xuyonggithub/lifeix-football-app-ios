//
//  VideoLearningCell.m
//  LiFangSport
//
//  Created by 张毅 on 16/6/15.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import "VideoLearningCell.h"
#import "UIImageView+WebCache.h"
#define picWith 634
#define picHeight 304

@interface VideoLearningCell ()
@property(nonatomic,strong)UIImageView *picView;
@property(nonatomic,strong)UILabel *titleLab;
@property(nonatomic,strong)UIImageView *bannerView;

@end

@implementation VideoLearningCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = kclearColor;
        [self initSubviews];
    }
    return self;
}
-(void)initSubviews{
    _picView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.48 * kScreenWidth-5)];
    _picView.width = kScreenWidth;
    [self addSubview:_picView];
    
    _bannerView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 20, self.width, 25)];
    _bannerView.bottom = _picView.bottom-5;
    _bannerView.image = [UIImage imageNamed:@"videolistBannerLabpic"];
    [self addSubview:_bannerView];

    _titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, self.width, 20)];
    _titleLab.centerY = _bannerView.centerY;
    _titleLab.backgroundColor = kclearColor;
    [self addSubview:_titleLab];
    _titleLab.textColor = kwhiteColor;
    _titleLab.textAlignment = NSTextAlignmentLeft;
    _titleLab.font = [UIFont systemFontOfSize:19];
}

-(void)setModel:(VideoListModel *)model{
    _titleLab.text = model.name;
    NSString *picstr = [NSString stringWithFormat:@"%@%@%@",kQiNiuHeaderPathPrifx,@"mobile/",[NSString stringWithFormat:@"%@?imageView/1/w/%d/h/%d",model.image,picWith,picHeight]];
    [_picView sd_setImageWithURL:[NSURL URLWithString:picstr] placeholderImage:UIImageNamed(@"placeholder_media")];
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
