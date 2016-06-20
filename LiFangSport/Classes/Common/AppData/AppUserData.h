//
//  AppUserData.h
//  LiFangSport
//
//  Created by 张毅 on 16/6/15.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import <GVUserDefaults/GVUserDefaults.h>
#define HasLogin          ([[AppUserData userData] token] != nil)

#define  kPkTipCount 3
@interface AppUserData : GVUserDefaults
@property (nonatomic, assign) NSTimeInterval lastVersionCheckTime;
@property (nonatomic, assign) NSTimeInterval lastLaunchInfoCheckTime;

@property (nonatomic, strong) NSString* homeidStr;


//+ (UserDataModel *)userData;
+ (void)save;

- (void)updateWithJsonDict:(NSDictionary *)dict;
- (void)clearUserDataInfoForLogout;

@end
