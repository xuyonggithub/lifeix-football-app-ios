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
        self.bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, SCREEN_WIDTH - 10, SCREEN_WIDTH/2 - 5)];
        self.bgImgView.userInteractionEnabled = YES;
        [self addSubview:self.bgImgView];
        
        // 标题
        UIImageView *titleBgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREEN_WIDTH/2 - 30, self.bgImgView.frame.size.width, 25)];
        titleBgView.image = [UIImage imageNamed:@"titleBg.jpg"];
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH - 50, 25)];
        self.titleLabel.font = kBasicSmallTitleFont;
        self.titleLabel.textColor = [UIColor whiteColor];
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
        NSString *str = [NSString stringWithFormat:@"%@?imageView/1/w/%d/h/%d", media.image, (int)SCREEN_WIDTH - 10, (int)SCREEN_WIDTH/2 - 5];
        [self.bgImgView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"placeholder_media.jpg"]];
    }else{
        self.bgImgView.image = [UIImage imageNamed:@"placeholder_media.jpg"];
    }
    self.titleLabel.text = media.title;
}

@end
