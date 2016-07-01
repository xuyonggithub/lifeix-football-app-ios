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
    // 设置重复的间隔
    notification.repeatInterval = 0;
    
    // 通知内容
    notification.alertBody =  alertBodyStr;
    notification.alertAction =  @"滑动来查看";
//    notification.applicationIconBadgeNumber = 1;
    // 通知被触发时播放的声音
    notification.soundName = UILocalNotificationDefaultSoundName;
    // 通知参数
    NSDictionary *userDict = [NSDictionary dictionaryWithObject:alertBodyStr forKey:key];
    notification.userInfo = userDict;
    
    // ios8后，需要添加这个注册，才能得到授权
    [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

+ (void)cancelLocalNotificationWithNotiID:(NSString *)key{
    // 获取所有本地通知数组
    NSArray *localNotifications = [UIApplication sharedApplication].scheduledLocalNotifications;
    
    for (UILocalNotification *notification in localNotifications) {
        NSDictionary *userInfo = notification.userInfo;
        if (userInfo) {
            // 根据设置通知参数时指定的key来获取通知参数
            NSString *info = userInfo[key];
            // 如果找到需要取消的通知，则取消
            if (info != nil) {
                [[UIApplication sharedApplication] cancelLocalNotification:notification];
                break;
            }
        }
    }
}


@end
