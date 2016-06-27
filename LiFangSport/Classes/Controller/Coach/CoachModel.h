//
//  CoachModel.h
//  LiFangSport
//
//  Created by Lifeix on 16/6/17.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface CoachModel : JSONModel

@property(nonatomic, retain)NSString<Optional> *position;
@property(nonatomic, retain)NSString<Optional> *avatar;
@property(nonatomic, retain)NSString<Optional> *name;
@property(nonatomic, retain)NSString<Optional> *coachaId;
@property(nonatomic, retain)NSString<Optional> *country;
@property(nonatomic, retain)NSString<Optional> *birthday;
@property(nonatomic, retain)NSString<Optional> *level;
@property(nonatomic, retain)NSString<Optional> *birthplace;


@end
