//
//  RefereeModel.h
//  LiFangSport
//
//  Created by Lifeix on 16/6/17.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface RefereeModel : JSONModel

@property(nonatomic, copy)NSString<Optional> *position;
@property(nonatomic, copy)NSString<Optional> *awatar;
@property(nonatomic, copy)NSString<Optional> *name;
@property(nonatomic, copy)NSString<Optional> *birthday;
@property(nonatomic, copy)NSString<Optional> *association;
@property(nonatomic, copy)NSString<Optional> *fifaTopANum;
@property(nonatomic, copy)NSString<Optional> *sinceInternational;
@property(nonatomic, copy)NSString<Optional> *topLeagueNum;

@end
