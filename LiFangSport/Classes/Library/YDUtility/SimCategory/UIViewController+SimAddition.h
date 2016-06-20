//
//  UIViewController+SimAddition.h
//
//  Created by Xubin Liu on 12-7-17.
//  Copyright (c) 2012年 baidu.com. All rights reserved.
//

typedef enum {
    LeftItem = 0,
    RightItem,
}ItemPos; 

#import <UIKit/UIKit.h>

/*
提供ViewConroller一些扩展方法，主要用于navItem的设置。
作用：统一navItem的风格，减少navItem的实现代码。
 */

@interface UIViewController (SimAddition)

- (void)cleanItemAt:(ItemPos)pos;
- (void)addBackItem;
- (void)addDismissItem;

- (void)addBackItem:(id)content;
- (void)addDismissItem:(id)content;

- (void)updateItemAt:(ItemPos)pos content:(id)content target:(id)target action:(SEL)sel animated:(BOOL)animated;
- (void)updateItemAt:(ItemPos)pos barButtonItem:(UIBarButtonItem *)item animated:(BOOL)animated;

- (UIViewController *)doPopBack;
- (void)doDismissModel;



@end
