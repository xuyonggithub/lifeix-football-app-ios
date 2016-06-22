//
//  PlayerModel.h
//  LiFangSport
//
//  Created by Lifeix on 16/6/13.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface PlayerModel : JSONModel

//@property(nonatomic, retain)NSString<Optional> *birtyday;
//@property(nonatomic, retain)NSString<Optional> *teamName;
//@property(nonatomic, retain)NSString<Optional> *country;
@property(nonatomic, retain)NSString<Optional> *position;
//@property(nonatomic, retain)NSString<Optional> *weight;
@property(nonatomic, retain)NSString<Optional> *awatar;
//@property(nonatomic, retain)NSString<Optional> *selectedNum; // 入选国家队次数
//@property(nonatomic, retain)NSString<Optional> *birthplace;
//@property(nonatomic, retain)NSString<Optional> *teamId;
//@property(nonatomic, retain)NSString<Optional> *goals; //进球数
@property(nonatomic, retain)NSString<Optional> *name;
//@property(nonatomic, retain)NSString<Optional> *club;
@property(nonatomic, retain)NSString<Optional> *playerId;
//@property(nonatomic, retain)NSString<Optional> *height;
@end
