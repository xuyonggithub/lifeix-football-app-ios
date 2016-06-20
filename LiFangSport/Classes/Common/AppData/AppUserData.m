//
//  AppUserData.m
//  LiFangSport
//
//  Created by 张毅 on 16/6/15.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import "AppUserData.h"

@interface AppUserData ()
//@property (nonatomic, strong) UserDataModel *userDataModel;

@end

@implementation AppUserData

- (NSDictionary *)setupDefaults {
    return @{
             @"hasPlaySound": @YES,
             @"launchDoHomework":@NO,
             @"pkTipCount":@(kPkTipCount),
             @"showMenu":@NO,
             };
}

//+ (UserDataModel *)userData
//{
//    return [[AppUserData standardUserDefaults] userDataModel];
//}
//
//
//- (UserDataModel *)userDataModel
//{
//    if (!_userDataModel) {
//        _userDataModel = [[UserDataModel alloc] initWithString:self.userDataStr error:nil];
//        if (!_userDataModel) {
//            _userDataModel = [[UserDataModel alloc] init];
//        }
//    }
//    
//    return _userDataModel;
//}


- (void)updateWithJsonDict:(NSDictionary *)dict
{
//    [self.userDataModel updateUserStorage:dict];
//    [[NSNotificationCenter defaultCenter] postNotificationName:kUserInfoUpdateNoti object:nil];
}

- (void)clearUserDataInfoForLogout
{
    
//    self.userDataModel = nil;
//    self.userDataStr = nil;
//    
//    self.bPushChannelID = @"";
//    self.bPushUserID = @"";
    
    [AppUserData save];
}

+ (void)save
{
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
