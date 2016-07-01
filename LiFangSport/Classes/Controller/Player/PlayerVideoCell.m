//
//  PlayerVideoCell.m
//  LiFangSport
//
//  Created by 卢亚林 on 16/6/23.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import "PlayerVideoCell.h"
#import "PlayerVideoModel.h"

@implementation PlayerVideoCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(25/2, 10, SCREEN_WIDTH - 25, 350/2)];
        self.bgImgView.userInteractionEnabled = YES;
        [self addSubview:self.bgImgView];
        
        UIImageView *titleBgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 350/2 - 35, self.bgImgView.width, 35)];
        titleBgView.image = [UIImage imageNamed:@"titleBg.jpg"];
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, titleBgView.width - 20, 25)];
        self.titleLabel.font = [UIFont systemFontOfSize:12];
        self.titleLabel.textColor = HEXRGBCOLOR(0xffffff);
        [titleBgView addSubview:self.titleLabel];
        [self.bgImgView addSubview:titleBgView];
        
        UIImageView *playView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        playView.image = UIImageNamed(@"videobofang");
        playView.center = _bgImgView.center;
        playView.userInteractionEnabled = YES;
        [self addSubview:playView];
    }
    return self;
}

-(void)displayCell:(PlayerVideoModel *)model{
    
    NSString *bgImageUrl = [NSString stringWithFormat:@"%@%@?vframe/jpg/offset/1/w/%d/h/%d", kQiNiuHeaderPathPrifx, model.url, (int)_bgImgView.width, (int)_bgImgView.height];
    [self.bgImgView sd_setImageWithURL:[NSURL URLWithString:bgImageUrl] placeholderImage:[UIImage imageNamed:@"placeholder_media.jpg"]];

    self.titleLabel.text = model.title;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
