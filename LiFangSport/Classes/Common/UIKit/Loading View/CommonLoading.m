//
//  CommonLoading.m
//  TKnowBox
//
//  Created by LiuXubin on 15/3/21.
//  Copyright (c) 2015年 knowin. All rights reserved.
//

#import "CommonLoading.h"

@implementation CommonLoading



+ (void)showTips:(NSString *)content
{
    [self showTips:content inView:nil];
}

+ (void)showTips:(NSString *)content inView:(UIView *)view
{
    TAOverlay *overlay = [[TAOverlay alloc] init];
    overlay.overlayBackgroundColor = HEXRGBACOLOR(0x000000, 0.6);
    overlay.overlayFontColor = [UIColor whiteColor];
    overlay.overlayRectSize = CGSizeMake(80, 20);
    overlay.rootView = view;
    overlay.overlayText = content;
    TAOverlayOptions options = TAOverlayOptionOverlayTypeText | TAOverlayOptionAutoHide | TAOverlayOptionOverlaySizeRoundedRect;
    [overlay analyzeOptions:options image:NO imageArray:NO];
}


+ (void)showLoading:(NSString *)content inView:(UIView *)view
{
    [self showLoading:content interaction:NO inView:view];
}

+ (void)showLoading:(NSString *)content interaction:(BOOL)interaction inView:(UIView *)view
{
    TAOverlay *overlay = [[TAOverlay alloc] init];
    overlay.overlayBackgroundColor =HEXRGBACOLOR(0x000000, 0.6);
    overlay.overlayFontColor = [UIColor whiteColor];
    overlay.rootView = view;
    overlay.overlayText = content;
    TAOverlayOptions options = TAOverlayOptionOverlaySizeRoundedRect;
    if (!interaction) {
        options |= TAOverlayOptionAllowUserInteraction;
    }
    [overlay analyzeOptions:options image:NO imageArray:NO];
    
}

#pragma mark - Ani Loading
+ (void)showOverlayLoadingInView:(UIView *)view
{
    TAOverlay *overlay = [[TAOverlay alloc] init];
    overlay.backgroundColor = [UIColor clearColor];
    overlay.overlayBackgroundColor = HEXRGBACOLOR(0xffffff, 0.9f);
    overlay.rootView = view;
    overlay.overlayRectSize = CGSizeMake(94, 94);
    overlay.customAnimationDuration = 0.6;
    overlay.iconSize = CGSizeMake(38, 38);
    overlay.overlayText = nil;
    
    overlay.imageArray = @[UIImageNamed(@"loading_00000"),
                           UIImageNamed(@"loading_00001"),
                           UIImageNamed(@"loading_00002"),
                           UIImageNamed(@"loading_00003"),
                           UIImageNamed(@"loading_00004"),
                           UIImageNamed(@"loading_00005"),
                           UIImageNamed(@"loading_00006"),
                           UIImageNamed(@"loading_00007"),
                           UIImageNamed(@"loading_00008")];
    TAOverlayOptions options = TAOverlayOptionOverlaySizeRoundedRect;
    [overlay analyzeOptions:options image:NO imageArray:YES];
}

+ (void)showEmptyLoadingInView:(UIView *)view
{
    TAOverlay *overlay = [[TAOverlay alloc] init];
    overlay.overlayBackgroundColor = HEXRGBACOLOR(0xffffff, 0.9f);
    overlay.rootView = view;
    overlay.customAnimationDuration = 0.6;
    overlay.iconSize = CGSizeMake(38, 38);
    overlay.overlayRectSize = CGSizeMake(94, 94);
    overlay.overlayText = nil;
    
    overlay.imageArray = @[UIImageNamed(@"loading_00000"),
                           UIImageNamed(@"loading_00001"),
                           UIImageNamed(@"loading_00002"),
                           UIImageNamed(@"loading_00003"),
                           UIImageNamed(@"loading_00004"),
                           UIImageNamed(@"loading_00005"),
                           UIImageNamed(@"loading_00006"),
                           UIImageNamed(@"loading_00007"),
                           UIImageNamed(@"loading_00008")];
    
    TAOverlayOptions options = TAOverlayOptionOverlaySizeRoundedRect | TAOverlayOptionAllowUserInteraction;
    [overlay analyzeOptions:options image:NO imageArray:YES];
}

#pragma mark - Type Loading
+ (void)showLoadingType:(LoadindType)type content:(NSString *)content
{
    
    UIImage *image = nil;
    switch (type) {
        case LT_Success:
            image = UIImageNamed(@"icon_loading_success");
            break;
        case LT_Error:
            image = UIImageNamed(@"icon_loading_error");
            break;
        case LT_Warning:
            image = UIImageNamed(@"icon_loading_warning");
            break;
        default:
            break;
    }

    TAOverlay *overlay = [[TAOverlay alloc] init];
    overlay.overlayBackgroundColor = HEXRGBACOLOR(0x000000, 0.6);
    overlay.overlayFontColor = [UIColor whiteColor];
    overlay.iconSize = CGSizeMake(27, 27);
    overlay.rootView = nil;
    overlay.overlayText = content;
    overlay.iconImage = image;
    TAOverlayOptions options = TAOverlayOptionOverlaySizeRoundedRect | TAOverlayOptionAutoHide;
    [overlay analyzeOptions:options image:YES imageArray:NO];
}

+ (void)showLoading:(NSString *)content progress:(CGFloat)progress
{
    [self showLoading:content progress:progress interaction:NO inView:nil];
}

+ (void)showLoading:(NSString *)content progress:(CGFloat)progress interaction:(BOOL)interaction inView:(UIView *)view;
{
    TAOverlay *overlay = [[TAOverlay alloc] init];
    overlay.overlayBackgroundColor = HEXRGBACOLOR(0x000000, 0.6);
    overlay.overlayFontColor = [UIColor whiteColor];
    overlay.rootView = view;
    overlay.iconSize = CGSizeMake(40, 40);
    overlay.overlayText = content;
    TAOverlayOptions options = TAOverlayOptionOverlaySizeRoundedRect | TAOverlayOptionOverlayTypeProgress;
    if (!interaction) {
        options |= TAOverlayOptionAllowUserInteraction;
    }
    [overlay analyzeOptions:options image:NO imageArray:NO];
    overlay.overlayProgress = 0.5;
}

+ (void)dismissInView:(UIView *)view
{
    [TAOverlay hideOverlayInView:view];
}

@end
