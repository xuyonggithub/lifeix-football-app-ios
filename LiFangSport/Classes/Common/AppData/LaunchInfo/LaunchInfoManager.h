//
//  LaunchInfoManager.h
//  LiFangSport
//
//  Created by 张毅 on 16/6/15.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LaunchInfoManager : NSObject
+ (LaunchInfoManager *)sharedInstance;

- (void)fetchLaunchInfoForce:(BOOL)force;
//-(void)dealNoticeInfo;
//-(void)dealUpdateCity:(NSInteger)cityVersion url:(NSString*)cityUrl;


@end
