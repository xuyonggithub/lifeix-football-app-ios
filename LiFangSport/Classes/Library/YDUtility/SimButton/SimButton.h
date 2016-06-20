//
//  SimButton.h
//  TKnowBox
//
//  Created by LiuXubin on 15/3/13.
//  Copyright (c) 2015年 knowin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ButtonIconPosition){
    BIP_None,
    BIP_Left,
    BIP_Right,
    BIP_Top,
    BIP_Bottom,
    BIP_Center,
};

@interface SimButton : UIButton

@property (nonatomic, assign) CGFloat offset;
@property (nonatomic, assign) ButtonIconPosition iconPostion;

@property (nonatomic, assign, getter = isDragEnable)   BOOL dragEnable;
@property (nonatomic, assign, getter = isAdsorbEnable) BOOL adsorbEnable;
@property (nonatomic, assign) NSTimeInterval minDragTriggerInterval;
@property (nonatomic, assign) CGFloat adsordPadding;

@property (nonatomic, strong) id userInfo;

- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state;

@end
