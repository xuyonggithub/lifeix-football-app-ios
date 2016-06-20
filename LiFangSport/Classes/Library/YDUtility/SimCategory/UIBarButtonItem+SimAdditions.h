//
//  UIBarButtonItem+SimAdditions.h
//  Knowbox
//
//  Created by LiuXubin on 15/1/9.
//  Copyright (c) 2015年 knowin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (SimAdditions)

+ (id)itemWithText:(NSString *)text target:(id)target action:(SEL)action;
+ (id)itemWithIcons:(NSArray *)iconNames target:(id)target action:(SEL)action;

+ (UIBarButtonItem *)backBarBtnItem:(id)target;
+ (UIBarButtonItem *)backBarBtnItem:(id)target backStr:(NSString *)backStr;

+ (UIBarButtonItem *)closeBarBtnItem:(id)tartget;
+ (UIBarButtonItem *)cancelBarBtnItem:(id)tartget;

- (void)setBtnEnabled:(BOOL)enabled;

@end
