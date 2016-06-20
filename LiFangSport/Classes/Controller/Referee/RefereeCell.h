//
//  RefereeCell.h
//  LiFangSport
//
//  Created by Lifeix on 16/6/17.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RefereeModel;

@interface RefereeCell : UICollectionViewCell

@property(nonatomic, retain)UIImageView *bgImgView;
@property(nonatomic, retain)UILabel *titleLabel;

-(void)displayCell:(RefereeModel *)refereeModel;

@end
