//
//  AVPlayer+AJMediaPlayerKit.m
//  Pods
//
//  Created by Zhangqibin on 5/22/15.
//
//

#import "AVPlayer+AJMediaPlayerKit.h"
@import AVFoundation;

@implementation AVPlayer (AJMediaPlayerKit)

- (void)seekToTimeInSeconds:(NSTimeInterval)time completionHandler:(void (^)(BOOL finished))completionHandler {
    if ([self respondsToSelector:@selector(seekToTime:toleranceBefore:toleranceAfter:completionHandler:)]) {
        [self seekToTime:CMTimeMakeWithSeconds(time, NSEC_PER_SEC) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:completionHandler];
    } else {
        [self seekToTime:CMTimeMakeWithSeconds(time, NSEC_PER_SEC) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
        completionHandler(YES);
    }
}

- (NSTimeInterval)currentItemDuration {

    CMTime theDuration = kCMTimeInvalid;
    AVAsset* theAsset = nil;
    if ([AVPlayerItem instancesRespondToSelector:@selector(duration)])
    {
        // On iOS 4.3 we get here...
        theDuration = [self.currentItem duration];
    }
    double duration = CMTimeGetSeconds(theDuration);
    //在网络情况较差的时候有可能会得到duration为1秒,这个时候通过asset能得到一个比较正常的结果
    if (duration == 1.0 && [AVPlayerItem instancesRespondToSelector:@selector(asset)])
    {
        // On iOS 4.2 we get here...
        theAsset = [self.currentItem asset];
        if (theAsset)
        {
            // Unfortunately, we do not get here as theAsset is nil...
            theDuration = [theAsset duration];
        }
    }
    if (CMTIME_IS_VALID(theDuration) && !CMTIME_IS_INDEFINITE(theDuration))
    {
        duration = CMTimeGetSeconds(theDuration);
    }
    
    return duration;
}

@end
