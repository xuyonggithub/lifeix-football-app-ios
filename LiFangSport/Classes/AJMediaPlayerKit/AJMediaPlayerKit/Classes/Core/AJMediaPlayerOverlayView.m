//
//  AJMediaPlayerOverlayView.m
//  Pods
//
//  Created by Zhangqibin on 5/22/15.
//
//

@import AVFoundation;
#import "AJMediaPlayerOverlayView.h"
#import "AJMediaPlayer.h"

@implementation AJMediaPlayerOverlayView

+ (Class)layerClass {
    return [AVPlayerLayer class];
}

- (void)setPlayer:(AVPlayer *)player {
    NSAssert(player != nil, @"AVPlayer could not be nil!");
    [(AVPlayerLayer *)self.layer setPlayer:player];
}

@end
