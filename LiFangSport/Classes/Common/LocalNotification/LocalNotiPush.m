//
//  LocalNotiPush.m
//  LiFangSport
//
//  Created by 张毅 on 16/6/30.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import "LocalNotiPush.h"

@implementation LocalNotiPush

+ (void)registerLocalNotification:(NSDate*)fireDate WithalertBody:(NSString *)alertBodyStr WithNotiID:(NSString*)key{
 
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    // 设置触发通知的时间
    notification.fireDate = fireDate;
    // 时区
    notification.timeZone = [NSTimeZone systemTimeZone];
    notification.repeatInterval = 0;
    notification.alertBody =  alertBodyStr;
    notification.alertAction =  @"滑动来查看";
    notification.applicationIconBadgeNumber = 0;
    notification.soundName = UILocalNotificationDefaultSoundName;
    NSDictionary *userDict = [NSDictionary dictionaryWithObject:alertBodyStr forKey:key];
    notification.userInfo = userDict;
    
    // ios8后
    if (ABOVE_IOS8) {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
}

+ (void)cancelLocalNotificationWithNotiID:(NSString *)key{
    NSArray *localNotifications = [UIApplication sharedApplication].scheduledLocalNotifications;
    
    for (UILocalNotification *notification in localNotifications) {
        NSDictionary *userInfo = notification.userInfo;
        if (userInfo) {
            NSString *info = userInfo[key];
            if (info != nil) {
                [[UIApplication sharedApplication] cancelLocalNotification:notification];
                break;
            }
        }
    }
}


@end
