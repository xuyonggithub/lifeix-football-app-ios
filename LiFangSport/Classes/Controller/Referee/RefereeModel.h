//
//  RefereeModel.h
//  LiFangSport
//
//  Created by Lifeix on 16/6/17.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface RefereeModel : JSONModel

@property(nonatomic, retain)NSString<Optional> *position;
@property(nonatomic, retain)NSString<Optional> *awatar;
@property(nonatomic, retain)NSString<Optional> *name;

@end
