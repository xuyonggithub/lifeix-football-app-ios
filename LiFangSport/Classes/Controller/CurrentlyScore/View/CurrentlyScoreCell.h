//
//  CurrentlyScoreCell.h
//  LiFangSport
//
//  Created by 张毅 on 16/7/6.
//  Copyright © 2016年 zhangyi. All rights reserved.
//
#import "CurrentlyScoreModel.h"
#import <UIKit/UIKit.h>

@interface CurrentlyScoreCell : UITableViewCell

@property(nonatomic,strong)CurrentlyScoreModel *model;
@property(nonatomic,strong)NSString *leftSubtitlePrifxStr;
@property(nonatomic,strong)UIImageView *likeView;

@end
