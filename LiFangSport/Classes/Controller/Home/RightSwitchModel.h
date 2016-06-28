//
//  RightSwitchModel.h
//  LiFangSport
//
//  Created by 张毅 on 16/6/15.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface RightSwitchModel : JSONModel
@property (nonatomic, strong) NSString<Optional> *avatar;
@property (nonatomic, strong) NSString<Optional> *birthday;
@property (nonatomic, strong) NSString<Optional> *birthplace;
@property (nonatomic, strong) NSString<Optional> *country;
@property (nonatomic, strong) NSString<Optional>* KID;
@property (nonatomic, strong) NSString<Optional> *level;
@property (nonatomic, strong) NSString<Optional> *name;
@property (nonatomic, strong) NSString<Optional> *position;
//@property (nonatomic, assign) NSInteger jeserysNum;
//@property (nonatomic, strong) NSDictionary<Optional> *record;
//@property (nonatomic, assign) NSInteger weight;
@property (nonatomic, strong) NSString<Ignore> *menberType;


+(NSArray *)modelDealDataFromWithDic:(NSDictionary *)dic;

@end
