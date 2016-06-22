//
//  AJMediaPlayerVolumeControl.m
//  AJMediaPlayerKit
//
//  Created by Zhangqibin on 15/7/10.
//  Copyright (c) 2015年 zhangyi. All rights reserved.
//

#import "AJMediaPlayerVolumeControl.h"
#import "AJMediaPlayerUtilities.h"
#import <MediaPlayer/MediaPlayer.h>
#import "AJMediaSessionVolume.h"
@interface AJMediaPlayerVolumeControl ()

@property (nonatomic, assign) AJMediaPlayerAppearenceStyle appearenceStyle;

@end

@implementation AJMediaPlayerVolumeControl

- (instancetype)initWithAppearenceStyle:(AJMediaPlayerAppearenceStyle )appearenceStyle {
    if (self = [super init]) {
        self.appearenceStyle = appearenceStyle;
        self.backgroundColor = [UIColor clearColor];
        self.translatesAutoresizingMaskIntoConstraints = NO;
        _slider= [[UISlider alloc] init];
        _slider.translatesAutoresizingMaskIntoConstraints = NO;
        _slider.minimumValue = 0;
        _slider.maximumValue = 1;
        _slider.minimumTrackTintColor = [UIColor colorWithHTMLColorMark:@"#29c4c6"];
        _slider.maximumTrackTintColor = [UIColor colorWithHTMLColorMark:@"#b5b5b5" alpha:0.6];
        [_slider setThumbImage:[UIImage imageNamed:@"player_ic_point"] forState:UIControlStateNormal];
        [_slider setTransform:CGAffineTransformMakeRotation(3 * M_PI / 2)];
        _slider.value = [[AJMediaSessionVolume sharedVolume] volume];
        [self addSubview:_slider];
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
            float sliderSpace = _appearenceStyle==AJMediaPlayerStyleForiPhone ? -38 : -50;
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(sliderSpace)-[_slider]-(sliderSpace)-|"
                                                                         options:0
                                                                         metrics:@{@"sliderSpace":@(sliderSpace)}
                                                                           views:NSDictionaryOfVariableBindings(_slider)]];
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_slider]-5-|"
                                                                         options:0
                                                                         metrics:nil
                                                                           views:NSDictionaryOfVariableBindings(_slider)]];
        } else {
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(0)-[_slider]-(2)-|"
                                                                         options:0
                                                                         metrics:nil
                                                                           views:NSDictionaryOfVariableBindings(_slider)]];
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_slider]-10-|"
                                                                         options:0
                                                                         metrics:nil
                                                                           views:NSDictionaryOfVariableBindings(_slider)]];
        }
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    NSString *imageName = _appearenceStyle == AJMediaPlayerStyleForiPhone ? @"player_bg_sound":@"player_bg_sound_iPad";
    UIImage *image = [UIImage imageNamed:imageName];
    [image drawInRect:rect];
}

@end
