//
//  CommonLoading.h
//  TKnowBox
//
//  Created by LiuXubin on 15/3/21.
//  Copyright (c) 2015年 knowin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TAOverlay.h"

typedef NS_ENUM(NSInteger, LoadindType){
    LT_Success = TAOverlayOptionOverlayTypeSuccess,
    LT_Warning = TAOverlayOptionOverlayTypeWarning,
    LT_Error = TAOverlayOptionOverlayTypeError,
};

@interface CommonLoading : NSObject

+ (void)showTips:(NSString *)content;
+ (void)showTips:(NSString *)content inView:(UIView *)view;

+ (void)showLoading:(NSString *)content inView:(UIView *)view;
+ (void)showLoading:(NSString *)content interaction:(BOOL)interaction inView:(UIView *)view;

+ (void)showOverlayLoadingInView:(UIView *)view;
+ (void)showEmptyLoadingInView:(UIView *)view;

+ (void)showLoadingType:(LoadindType)type content:(NSString *)content;

+ (void)showLoading:(NSString *)content progress:(CGFloat)progress;
+ (void)showLoading:(NSString *)content progress:(CGFloat)progress interaction:(BOOL)interaction inView:(UIView *)view;

+ (void)dismissInView:(UIView *)view;


@end
