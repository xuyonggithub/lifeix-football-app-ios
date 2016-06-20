//
//  PlayerCell.h
//  LiFangSport
//
//  Created by Lifeix on 16/6/13.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PlayerModel;

@interface PlayerCell : UICollectionViewCell

@property(nonatomic, retain)UIImageView *bgImgView;
@property(nonatomic, retain)UILabel *titleLabel;
@property(nonatomic, strong)PlayerModel *playerModel;

@end
