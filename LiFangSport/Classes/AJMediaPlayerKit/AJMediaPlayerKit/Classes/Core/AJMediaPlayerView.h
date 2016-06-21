//
//  AJMediaPlayerView.h
//  Pods
//
//  Created by Gang Li on 5/28/15.
//
//

@import AVFoundation;
@import UIKit;
#import "AJMediaPlayer.h"
#import "AJMediaPlayerGesture.h"

typedef NS_ENUM(NSInteger, AJMediaPlayerOverlayViewFillMode) {
    AJMediaPlayerOverlayViewResizeAspect,
    AJMediaPlayerOverlayViewResizeAspectFill,
    AJMediaPlayerOverlayViewResize
};

NS_ASSUME_NONNULL_BEGIN

@class AJMediaPlayerOverlayView;

@protocol AJMediaPlayerViewDelegate <NSObject>
@optional
- (void)mediaPlayerView:(AJMediaPlayerView * )mediaPlayerView moveVolumeWithType:(ProgessType)type;

- (void)mediaPlayerView:(AJMediaPlayerView * )mediaPlayerView moveScheduleWithType:(ProgessType)type screenPercent:(float)percent;

- (void)mediaPlayerViewGestureDidEndMoved;

@end

@interface AJMediaPlayerView : UIView<AJMediaPlayerGestureDelegate>
{
    @private
    AJMediaPlayerOverlayView *videoLayerView;
}
@property (nonatomic, assign) AJMediaPlayerOverlayViewFillMode videoFillMode;

@property(nonatomic, weak) AJMediaPlayer *player;

@property (nonatomic, strong)AJMediaPlayerGesture *gesture;

@property (nonatomic ,assign) id<AJMediaPlayerViewDelegate>delegate;
/**
 *  playView不响应手势的代理回调，默认为NO
 */
@property (nonatomic, assign) BOOL shouldNotResponseGesture;
/**
 *  播放器将AVplayer的layer渲染到view上,显示画面
 */
- (void)prepareToDisplay;

@end

NS_ASSUME_NONNULL_END
