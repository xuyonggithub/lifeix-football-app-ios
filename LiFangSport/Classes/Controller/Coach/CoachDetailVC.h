//
//  CoachDetailVC.h
//  LiFangSport
//
//  Created by 卢亚林 on 16/6/22.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import "BaseVC.h"
#import "CoachModel.h"

@interface CoachDetailVC : BaseVC

@property(nonatomic, copy)NSString *coachId;
@property(nonatomic, copy)NSString *coachName;
@property(nonatomic, retain)CoachModel *coach;
@end
