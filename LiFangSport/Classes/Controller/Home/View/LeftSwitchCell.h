//
//  LeftSwitchCell.h
//  LiFangSport
//
//  Created by 张毅 on 16/6/15.
//  Copyright © 2016年 zhangyi. All rights reserved.
//
#import "LeftSwitchModel.h"
#import <UIKit/UIKit.h>
typedef void(^LeftSwitchCellBC)(void);

@interface LeftSwitchCell : UITableViewCell
@property(nonatomic,strong)LeftSwitchModel *model;
@property(nonatomic,strong)NSString *leftSubtitlePrifxStr;
@property(nonatomic,copy)LeftSwitchCellBC likeBC;
@property(nonatomic,strong)UIImageView *likeView;

@end
