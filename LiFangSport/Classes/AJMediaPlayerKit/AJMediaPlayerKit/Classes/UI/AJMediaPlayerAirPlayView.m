//
//  AJMediaPlayerAirPlayView.m
//  Pods
//
//  Created by Zhangqibin on 15/7/23.
//
//

#import "AJMediaPlayerAirPlayView.h"
#import <AudioToolbox/AudioToolbox.h>
#import <MediaPlayer/MediaPlayer.h>
#import "AJMediaPlayerUtilities.h"
#import "AJMediaPlayerHeaders.h"
@import Foundation;

@interface AJMediaPlayerAirPlayView () {
    MPVolumeView *volumeView;
    NSString *strDetectedImageName;
    NSString *strPlayingImageName;
}
@end

@implementation AJMediaPlayerAirPlayView


#pragma mark - Init Method

- (instancetype)initWithFrame:(CGRect)frame
            detectedImageName:(NSString*)detectedName
             playingImageName:(NSString*)playingName {
    self = [super initWithFrame:frame];
    if (self) {
        strDetectedImageName = [detectedName copy];
        strPlayingImageName = [playingName copy];
        self.volumeFrame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    }
    return self;
}

#pragma mark - View LifeCycle

- (void)layoutSubviews {
    [super layoutSubviews];
    [self buildAirPlayButton];
    [self buildCustomVolumeView];
}

- (void)dealloc {
    [self.mpButton removeObserver:self forKeyPath:@"alpha" context:nil];
}

#pragma mark - Add SubViews

- (void)buildAirPlayButton {
    if (!_airPlayButton) {
        self.airPlayButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_airPlayButton setFrame:_volumeFrame];
        UIImage *image = [UIImage imageNamed:strDetectedImageName];
        [_airPlayButton setImage:image forState:UIControlStateNormal];
        [_airPlayButton setImage:image forState:UIControlStateHighlighted];
        [_airPlayButton setImage:image forState:UIControlStateSelected];
    } else {
        [_airPlayButton setFrame:_volumeFrame];
    }
    if (![self.airPlayButton.superview isEqual:self]) {
        [self addSubview:_airPlayButton];
    }
}

- (void)buildCustomVolumeView {
    CGRect frame;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        frame = CGRectMake(_volumeFrame.origin.x, _volumeFrame.origin.y, _volumeFrame.size.width, _volumeFrame.size.height);
    } else {
        frame = CGRectMake(_volumeFrame.origin.x-7, _volumeFrame.origin.y-2, _volumeFrame.size.width, _volumeFrame.size.height);
    }
    if (!volumeView) {
        volumeView = [[MPVolumeView alloc] initWithFrame:frame];
        [volumeView setShowsVolumeSlider:NO];
        [volumeView setShowsRouteButton:YES];
    } else {
        [volumeView setFrame:frame];
    }
    for (id temp in volumeView.subviews) {
        if (![temp isKindOfClass:[UIButton class]]) continue;
        if (!self.mpButton) {
            self.mpButton = (UIButton*)temp;
            [self.mpButton setFrame:_volumeFrame];
            [self.mpButton addObserver:self
                            forKeyPath:@"alpha"
                               options:NSKeyValueObservingOptionNew
                               context:nil];
        }
        break;
    }
    if (![volumeView.superview isEqual:self]) {
        [self addSubview:volumeView];
    }
}

#pragma mark - Add Observer

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object && self) {
        if ([[change valueForKey:NSKeyValueChangeNewKey] intValue] == 1) {
            if (self.delegate) {
                UIImage *image = [UIImage imageNamed:strDetectedImageName];
                [_airPlayButton setImage:image forState:UIControlStateNormal];
                [_airPlayButton setImage:image forState:UIControlStateHighlighted];
                [_airPlayButton setImage:image forState:UIControlStateSelected];
                [self.delegate didBrowserAvailableAirplayDevices:YES];
            }
            [self setMPButtonImage:[self isAirPlayActive]];
            [self enableAirplay:YES];
        } else {
            if (self.delegate) {
                UIImage *image = [UIImage imageWithColor:[UIColor clearColor]];
                [_airPlayButton setImage:image forState:UIControlStateNormal];
                [_airPlayButton setImage:image forState:UIControlStateHighlighted];
                [_airPlayButton setImage:image forState:UIControlStateSelected];
                [self.delegate didBrowserAvailableAirplayDevices:NO];
            }
        }
    }
}

#pragma mark - Private Method

- (void)setMPButtonImage:(BOOL)isOutPlaying {
    NSString *imageName = isOutPlaying ? strPlayingImageName:strDetectedImageName;
    UIImage *image = [UIImage imageNamed:imageName];
    [self.mpButton setImage:image forState:UIControlStateNormal];
    [self.mpButton setImage:image forState:UIControlStateHighlighted];
    [self.mpButton setImage:image forState:UIControlStateSelected];
}

- (void)enableAirplay:(BOOL)isEnable {
    volumeView.userInteractionEnabled = isEnable;
    self.mpButton.userInteractionEnabled = isEnable;
}

- (BOOL)isAirPlayActive {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
#if !TARGET_IPHONE_SIMULATOR
    CFDictionaryRef currentRouteDescriptionDictionary = nil;
    UInt32 dataSize = sizeof(currentRouteDescriptionDictionary);
    AudioSessionGetProperty(kAudioSessionProperty_AudioRouteDescription, &dataSize, &currentRouteDescriptionDictionary);
    if (currentRouteDescriptionDictionary) {
        CFArrayRef outputs = CFDictionaryGetValue(currentRouteDescriptionDictionary, kAudioSession_AudioRouteKey_Outputs);
        if(CFArrayGetCount(outputs) > 0) {
            CFDictionaryRef currentOutput = CFArrayGetValueAtIndex(outputs, 0);
            CFStringRef outputType = CFDictionaryGetValue(currentOutput, kAudioSession_AudioRouteKey_Type);
            return (CFStringCompare(outputType, kAudioSessionOutputRoute_AirPlay, 0) == kCFCompareEqualTo);
        }
    }
#endif
    return NO;
#pragma clang diagnostic pop
}

@end
