//
//  LocalNotiPush.h
//  LiFangSport
//
//  Created by 张毅 on 16/6/30.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocalNotiPush : UILocalNotification

// 设置本地通知
+ (void)registerLocalNotification:(NSDate*)fireDate WithalertBody:(NSString *)alertBodyStr WithNotiID:(NSString*)key WithNotiValue:(NSString*)value;
+ (void)cancelLocalNotificationWithNotiID:(NSString *)key;
+ (void)queryLocalNotificationWithNotiObject:(NSString *)notiObject WithStartdate:(NSDate *)date  WithalertBody:(NSString *)alertBodyStr WithNotiID:(NSString*)newNotiID;

@end
