//
//  PlayerVideoModel.h
//  LiFangSport
//
//  Created by 卢亚林 on 16/6/23.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface PlayerVideoModel : JSONModel

@property(nonatomic, copy)NSString *videoId;
@property(nonatomic, copy)NSString *playerId;
@property(nonatomic, copy)NSString *playerName;
@property(nonatomic, copy)NSString *title;
@property(nonatomic, copy)NSString *url;

@end
