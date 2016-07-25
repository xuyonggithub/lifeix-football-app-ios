//
//  PlayerDetailVC.h
//  LiFangSport
//
//  Created by 卢亚林 on 16/6/22.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import "BaseVC.h"
@class PlayerModel;

@interface PlayerDetailVC : BaseVC

@property(nonatomic, copy)NSString *playerId;
@property(nonatomic, copy)NSString *playerName;
@property(nonatomic, retain)PlayerModel *player;
@property(nonatomic, assign)int nationalLevel;
@end
