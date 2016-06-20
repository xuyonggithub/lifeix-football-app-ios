//
//  UIBarButtonItem+KBAdditions.m
//  Knowbox
//
//  Created by LiuXubin on 15/1/9.
//  Copyright (c) 2015年 knowin. All rights reserved.
//

#import "UIBarButtonItem+SimAdditions.h"
#import "UIButton+SimAdditions.h"
#import "SimButton.h"

#define kNormalTextColor        HEXRGBCOLOR(0xffffff)
#define kHighlightedTextColor   HEXRGBCOLOR(0xaee1db)
#define kDisableTextColor       HEXRGBCOLOR(0x9ddeff)
#define kTextFont               [UIFont systemFontOfSize:15]

@implementation UIBarButtonItem (SimAdditions)

+ (id)itemWithText:(NSString *)text target:(id)target action:(SEL)action
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kTabBarSize, kTabBarSize)];
    [btn setTitle:text forState:UIControlStateNormal];
    
    [btn setTitleColor:kNormalTextColor forState:UIControlStateNormal];
    [btn setTitleColor:kHighlightedTextColor forState:UIControlStateHighlighted];
    [btn setTitleColor:kDisableTextColor forState:UIControlStateDisabled];
    btn.titleLabel.font = kTextFont;
    [btn sizeToFit];
    btn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -8);
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}

+ (id)itemWithIcons:(NSArray *)iconNames target:(id)target action:(SEL)action
{
    /*UIButton *btn = [UIButton btnWithImageNames:iconNames];
    btn.backgroundColor = [UIColor redColor];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];*/
    UIBarButtonItem *item = nil;
    if (ABOVE_IOS7) {
        item = [[UIBarButtonItem alloc] initWithImage:UIImageNamed([iconNames firstObject]) style:UIBarButtonItemStylePlain target:target action:action];
        item.tintColor = [UIColor whiteColor];
    }
    else{
        UIButton *btn = [UIButton btnWithImageNames:iconNames];
        btn.width = MAX(25, btn.width);
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        item = [[UIBarButtonItem alloc] initWithCustomView:btn];
        
    }
    return item;
}

+ (UIBarButtonItem *)backBarBtnItem:(id)target
{
    return [self backBarBtnItem:target backStr:nil];
}

+ (UIBarButtonItem *)backBarBtnItem:(id)target backStr:(NSString *)backStr
{
    if (backStr.length > 0) {
        SimButton *btn = [[SimButton alloc] initWithFrame:CGRectZero];
        [btn setTitle:backStr forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitleColor:HEXRGBCOLOR(0x6ac4a0) forState:UIControlStateHighlighted];
        btn.titleLabel.font = kTextFont;
        btn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [btn setImage:UIImageNamed(@"icon_previous") forState:UIControlStateNormal];
        [btn addTarget:target action:@selector(doPopBack) forControlEvents:UIControlEventTouchUpInside];
        [btn sizeToFit];
        btn.width += 10;
        btn.width = MIN(80, btn.width);
        btn.height = 60;
        btn.offset = 5;
        btn.iconPostion = BIP_Left;
        return [[UIBarButtonItem alloc] initWithCustomView:btn];
    }
    else{
        return [self itemWithIcons:@[@"icon_previous"] target:target action:@selector(doPopBack)];
    }
}



+ (UIBarButtonItem *)closeBarBtnItem:(id)tartget
{
    return [self itemWithIcons:@[@"closeIcon"] target:tartget action:@selector(doDismissModel)];
}

+ (UIBarButtonItem *)cancelBarBtnItem:(id)tartget
{
    return [self itemWithText:@"取消" target:tartget action:@selector(doDismissModel)];
}

- (void)setBtnEnabled:(BOOL)enabled
{
    if ([self.customView isKindOfClass:[UIControl class]]) {
        UIControl *control = (UIControl *)self.customView;
        control.enabled = enabled;
    }
}




@end
