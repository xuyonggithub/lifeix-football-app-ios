//
//  AVPlayer+AJMediaPlayerKit.h
//  Pods
//
//  Created by Gang Li on 5/22/15.
//
//

@import AVFoundation;

@interface AVPlayer (AJMediaPlayerKit)
- (void)seekToTimeInSeconds:(NSTimeInterval)time completionHandler:(void (^)(BOOL finished))completionHandler;
@property (NS_NONATOMIC_IOSONLY, readonly) NSTimeInterval currentItemDuration;
@end
