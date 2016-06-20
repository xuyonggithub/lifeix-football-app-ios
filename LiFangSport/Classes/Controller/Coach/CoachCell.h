//
//  CoachCell.h
//  LiFangSport
//
//  Created by Lifeix on 16/6/17.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CoachModel;

@interface CoachCell : UICollectionViewCell

@property(nonatomic, retain)UIImageView *bgImgView;
@property(nonatomic, retain)UILabel *titleLabel;

-(void)displayCell:(CoachModel *)coachModel;

@end
