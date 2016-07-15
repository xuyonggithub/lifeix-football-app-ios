//
//  MediaCell.h
//  LiFangSport
//
//  Created by Lifeix on 16/6/12.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MediaModel;

@interface MediaCell : UITableViewCell

@property(nonatomic, retain)UILabel *categorylabel;
@property(nonatomic, retain)UIImageView *bgImgView;
@property(nonatomic, retain)UILabel *titleLabel;
@property(nonatomic, retain)UILabel *timeLabel;

-(void)displayCell:(MediaModel *)media;
@end
