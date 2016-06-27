//
//  PlayerVideoCell.h
//  LiFangSport
//
//  Created by 卢亚林 on 16/6/23.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PlayerVideoModel;

@interface PlayerVideoCell : UITableViewCell

@property(nonatomic, retain)UIImageView *bgImgView;
@property(nonatomic, retain)UILabel *titleLabel;
@property(nonatomic, strong)PlayerVideoModel *playerVideo;

-(void)displayCell:(PlayerVideoModel *)model;
@end
