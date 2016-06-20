//
//  LaunchInfoManager.m
//  LiFangSport
//
//  Created by 张毅 on 16/6/15.
//  Copyright © 2016年 zhangyi. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "LaunchInfoManager.h"
#import "AppUserData.h"
#import "CommonRequest.h"
#import "LaunchInfoModel.h"

#define kMaxFetchLaunchInfoInterval (5*60)

@interface LaunchInfoManager()

@property (nonatomic, strong) NSMutableArray *noticeList;
@property (nonatomic, strong) NSMutableArray *settingList;

@property (nonatomic, assign)BOOL hadPopFlag;
@end

@implementation LaunchInfoManager
+ (instancetype)sharedInstance{
    static id sharedInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}


- (id)init
{
    self = [super init];
    if (self) {
        _hadPopFlag = NO;
        _noticeList = [NSMutableArray array];
    }
    return self;
}



- (void)fetchLaunchInfoForce:(BOOL)force
{
    if (force) {
        
        [AppUserData standardUserDefaults].lastLaunchInfoCheckTime = 0;
    }
    
    NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval lastTimeStamp = [AppUserData standardUserDefaults].lastLaunchInfoCheckTime;
    if (timeStamp - lastTimeStamp < kMaxFetchLaunchInfoInterval) {
        return;
    }
    
    
    [CommonRequest requstPath:@"" loadingDic:nil queryParam:nil success:^(CommonRequest *request, id jsonDict) {
        LaunchInfoModel* launchInfo = [[LaunchInfoModel alloc]initWithDictionary:jsonDict error:nil];
        
        [self dealLaunchInfo:launchInfo];

    } failure:^(CommonRequest *request, NSError *error) {
        
    }];
}

-(void)dealLaunchInfo:(LaunchInfoModel*)launchInfo{
    
    if(launchInfo.noticeList){
        
    }
    
    
    if(launchInfo.setting){
    _settingList = [NSMutableArray arrayWithArray:launchInfo.setting];
    
    [self dealPayChanel];
    }
}

-(void)dealPayChanel{//kKeyPayTypes
    if (_settingList.count == 0) {
        return;
    }
    
//    for(SettingDataModel* setting in _settingList){
//        if([setting.key isEqualToString:kKeyPayTypes]){
//            [AppUserData standardUserDefaults].homeidStr = setting.value;
//            break;
//        }
//    }
}

@end
