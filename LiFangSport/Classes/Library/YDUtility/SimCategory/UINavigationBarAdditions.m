//
//  UINavigationBarAdditions.m
//  Knowbox
//
//  Created by LiuXubin on 15/1/26.
//  Copyright (c) 2015年 knowin. All rights reserved.
//

#import "UINavigationBarAdditions.h"
#import "SimCommonTool.h"

@implementation UINavigationBar (SimAddition)

static UIImage *bgImageView = nil;
- (void)saveNavBgImage
{
    bgImageView = [self backgroundImageForBarMetrics:UIBarMetricsDefault];
    [SimCommonTool saveStatusBarStyle];
}

- (void)restoreNavBgImage
{
    if (bgImageView) {
        [self setBackgroundImage:bgImageView forBarMetrics:UIBarMetricsDefault];
        bgImageView = nil;
    }
    
    [SimCommonTool restoreStatusBarStyle];
    
}


@end
