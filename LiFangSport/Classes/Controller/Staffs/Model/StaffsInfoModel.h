//
//  StaffsInfoModel.h
//  LiFangSport
//
//  Created by 张毅 on 16/7/8.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface StaffsInfoModel : JSONModel
@property(nonatomic, copy)NSString<Optional> *avatar;
@property(nonatomic, copy)NSString<Optional> *birthday;
@property(nonatomic, copy)NSString<Optional> *birthplace;
@property(nonatomic, copy)NSString<Optional> *company;
@property(nonatomic, copy)NSString<Optional> *country;
@property(nonatomic, copy)NSString<Optional> *kid;
@property(nonatomic, copy)NSString<Optional> *introduce;
@property(nonatomic, copy)NSString<Optional> *name;
@property(nonatomic, copy)NSString<Optional> *position;
@property(nonatomic, strong)NSDictionary<Optional> *team;
@property(nonatomic, copy)NSString<Optional> *url;
@property(nonatomic, copy)NSString<Ignore> *like;
@property(nonatomic, copy)NSString<Ignore> *likeNum;

@end
