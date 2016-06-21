//
//  AJMediaPlayerView.m
//  Pods
//
//  Created by Gang Li on 5/28/15.
//
//

#import "AJMediaPlayerView.h"
#import "AJMediaPlayer.h"
#import "AJMediaSessionVolume.h"
#import "AJMediaPlayerOverlayView.h"
#import "AJFoundation.h"

@interface AJMediaPlayerView()

@end

@implementation AJMediaPlayerView

#pragma mark - UITouch Event
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[[event allTouches] allObjects] firstObject];
    CGPoint curPoint = [touch locationInView:self];
    if (curPoint.y > 5 && curPoint.y < (self.bounds.size.height-5)) {
        if (self.player.canMoveProgress) {
            [_gesture mediaPlayerViewTouchesBegan:touches withEvent:event];
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.player.canMoveProgress) {
         [_gesture mediaPlayerViewTouchesMoved:touches withEvent:event];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.player.canMoveProgress) {
         [_gesture mediaPlayerViewTouchesEnded];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.player.canMoveProgress) {
         [_gesture mediaPlayerViewTouchesEnded];
    }
}

#pragma mark - Init Method

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.clipsToBounds = YES;
        
        videoLayerView= [[AJMediaPlayerOverlayView alloc] init];
        videoLayerView.translatesAutoresizingMaskIntoConstraints = NO;
        self.gesture = [[AJMediaPlayerGesture alloc] init];
        _gesture.delegate = self;
        _gesture.parentView = self;
        [self addSubview:videoLayerView];

        [[AJMediaSessionVolume sharedVolume] setShouldMute:NO];
    }
    return self;
}

- (void)updateConstraints {
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[videoLayerView]-0-|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:NSDictionaryOfVariableBindings(videoLayerView)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[videoLayerView]-0-|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:NSDictionaryOfVariableBindings(videoLayerView)]];
    [super updateConstraints];
}

#pragma mark - Pubilc Method

- (void)prepareToDisplay {
    if ([_player videoPlayer]) {
        [videoLayerView setPlayer:[_player videoPlayer]];
        switch (self.videoFillMode) {
            case AJMediaPlayerOverlayViewResize:
                [videoLayerView.layer setValue:AVLayerVideoGravityResize forKey:@"videoGravity"];
                break;
            case AJMediaPlayerOverlayViewResizeAspectFill:
                [videoLayerView.layer setValue:AVLayerVideoGravityResizeAspectFill forKey:@"videoGravity"];
                break;
            case AJMediaPlayerOverlayViewResizeAspect:
                [videoLayerView.layer setValue:AVLayerVideoGravityResizeAspect forKey:@"videoGravity"];
                break;
            default:
                [videoLayerView.layer setValue:AVLayerVideoGravityResizeAspect forKey:@"videoGravity"];
                break;
        }
        [videoLayerView setNeedsDisplay];
    }
}

#pragma mark - AJMediaPlayerGesture Delegate

- (void)moveScheduleWithType:(ProgessType)type screenPercent:(float)percent {
    if (_shouldNotResponseGesture) {
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(mediaPlayerView:moveScheduleWithType:screenPercent:)]) {
        [self.delegate mediaPlayerView:self moveScheduleWithType:type screenPercent:percent];
    }
}

- (void)gestureDidEndMoved {
    if (_shouldNotResponseGesture) {
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(mediaPlayerViewGestureDidEndMoved)]) {
        [self.delegate mediaPlayerViewGestureDidEndMoved];
    }
}

- (void)moveVolumeWithType:(ProgessType)type {
    if (_shouldNotResponseGesture) {
        return;
    }
    float volume = [AJMediaSessionVolume sharedVolume].volume;
    if (type == Addition) {
        if (volume + 0.025 >= 1) {
            [[AJMediaSessionVolume sharedVolume] setVolume:1];
        } else {
            [[AJMediaSessionVolume sharedVolume] setVolume:volume + 0.025];
        }
    } else {
        if (volume - 0.025 <= 0) {
            [[AJMediaSessionVolume sharedVolume] setVolume:0];
        }
        else {
            [[AJMediaSessionVolume sharedVolume] setVolume:volume - 0.025];
        }
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(mediaPlayerView:moveVolumeWithType:)]) {
        [self.delegate mediaPlayerView:self moveVolumeWithType:type];
    }
}

@end
