//
//  MediaCell.m
//  LiFangSport
//
//  Created by Lifeix on 16/6/12.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import "MediaCell.h"
#import "UIImageView+WebCache.h"
#import "MediaModel.h"

@implementation MediaCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        // 背景图
        self.bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(25/2, 10, SCREEN_WIDTH - 25, 350/2)];
        self.bgImgView.userInteractionEnabled = YES;
        [self addSubview:self.bgImgView];
        
        // 标题
        UIImageView *titleBgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 350/2 - 35, self.bgImgView.width, 35)];
        titleBgView.image = [UIImage imageNamed:@"titleBg.jpg"];
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, titleBgView.width - 20, 25)];
        self.titleLabel.font = kBasicBigDetailTitleFont;
        self.titleLabel.textColor = HEXRGBCOLOR(0xffffff);
        [titleBgView addSubview:self.titleLabel];
        [self.bgImgView addSubview:titleBgView];
        
        // 分类
        self.categorylabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
        self.categorylabel.font = kBasicSmallTitleFont;
        self.categorylabel.textColor = [UIColor whiteColor];
        [self.bgImgView addSubview:self.categorylabel];
    }
    return self;
}

-(void)displayCell:(MediaModel *)media{
    if(media.image != nil){
        NSString *str = [NSString stringWithFormat:@"%@?imageView/1/w/%d/h/%d", media.image, (int)SCREEN_WIDTH - 25, (int)350/2];
        [self.bgImgView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"placeholder_media.jpg"]];
    }else{
        self.bgImgView.image = [UIImage imageNamed:@"placeholder_media.jpg"];
    }
    if(media.containVideo == YES){
        UIImageView *playView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        playView.image = UIImageNamed(@"videobofang");
        playView.center = _bgImgView.center;
        playView.userInteractionEnabled = YES;
        [_bgImgView addSubview:playView];
    }
    self.titleLabel.text = media.title;
}

@end
