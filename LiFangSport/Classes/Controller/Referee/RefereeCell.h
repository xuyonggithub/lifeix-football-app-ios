//
//  RefereeCell.h
//  LiFangSport
//
//  Created by Lifeix on 16/6/17.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RefereeModel;

@interface RefereeCell : UITableViewCell

@property(nonatomic, retain)UIImageView *bgImgView;
@property(nonatomic, retain)UILabel *titleLabel;
@property(nonatomic, retain)UILabel *nameLabel;
@property(nonatomic, retain)UILabel *birthdayLabel;
@property(nonatomic, retain)UILabel *associationLabel;
@property(nonatomic, retain)UILabel *topALabel;
@property(nonatomic, retain)UILabel *FIFAYearLabel;
@property(nonatomic, retain)UILabel *topLeagueLabel;

-(void)displayCell:(RefereeModel *)refereeModel;

@end
