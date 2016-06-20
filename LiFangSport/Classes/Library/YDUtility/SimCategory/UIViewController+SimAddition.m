//
//  UIViewController+SimAddition.m
//  Wenku
//
//  Created by Xubin Liu on 12-7-17.
//  Copyright (c) 2012年 baidu.com. All rights reserved.
//


#define kBackImageNames @[@"backIcon"]
//#define kCancelImageNames @[@"cancelIcon"]



#import "UIViewController+SimAddition.h"
#import "UIButton+SimAdditions.h"
#import "UIView+SimAdditions.h"
#import "UIBarButtonItem+SimAdditions.h"

@implementation UIViewController (SimAddition)

- (void)cleanItemAt:(ItemPos)pos
{
    [self updateItemAt:pos barButtonItem:nil animated:YES];
}

- (void)addBackItem
{
#ifdef kBackImageNames
    [self addBackItem:kBackImageNames];
#else
    [self addBackItem:@"返回"];
#endif
}

- (void)addBackItem:(id)content
{
    [self updateItemAt:LeftItem content:content target:self action:@selector(doPopBack) animated:YES];
}



- (void)addDismissItem
{
#ifdef kCancelImageNames
    [self addDismissItem:kCancelImageNames];
#else
    [self addDismissItem:@"完成"];
#endif
}

- (void)addDismissItem:(id)content
{
    [self updateItemAt:RightItem content:content target:self action:@selector(doDismissModel) animated:YES];
}


- (void)updateItemAt:(ItemPos)pos content:(id)content target:(id)target action:(SEL)sel animated:(BOOL)animated
{
    UIBarButtonItem *item = nil;
    if ([content isKindOfClass:[NSString class]]) {
        item = [UIBarButtonItem itemWithText:(NSString *)content target:target action:sel];
    }
    else if([content isKindOfClass:[NSArray class]]){
        item = [UIBarButtonItem itemWithIcons:(NSArray *)content target:target action:sel];
    }
    if (!item && pos == LeftItem) {
        self.navigationItem.hidesBackButton = YES;
    }
    [self updateItemAt:pos barButtonItem:item animated:animated];
}

- (void)updateItemAt:(ItemPos)pos barButtonItem:(UIBarButtonItem *)item animated:(BOOL)animated
{
    if (pos == RightItem) {
        [self.navigationItem setRightBarButtonItem:item animated:animated];
    }
    else{
        [self.navigationItem setLeftBarButtonItem:item animated:animated];
    }
}

- (UIViewController *)doPopBack
{
    return [self.navigationController popViewControllerAnimated:YES];
}

- (void)doDismissModel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end


