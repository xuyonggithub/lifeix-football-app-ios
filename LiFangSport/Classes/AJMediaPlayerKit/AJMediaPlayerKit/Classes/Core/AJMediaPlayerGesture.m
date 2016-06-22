//
//  AJMediaPlayerGesture.m
//  Pods
//
//  Created by Zhangqibin on 15/7/14.
//
//

#import "AJMediaPlayerGesture.h"
#import "AJFoundation.h"

enum ProgessType {
    ProgessTypeNone = 0,          //无
    ProgessTypeSchedule = 1,      //进度
    ProgessTypeVolume = 2,        //音量
};

@interface AJMediaPlayerGesture () {
    BOOL _isAvailable;
    NSInteger _moveNumbers;
    BOOL isVolumeType;
    BOOL isScheduleType;
}
/**
 *  类型
 */
@property (nonatomic, assign) ProgessType progessType;
/**
 *  手势父视图屏幕宽度
 */
@property (nonatomic, assign) CGFloat parentViewWidth;
/**
 *  手势父视图屏幕高度
 */
@property (nonatomic, assign) CGFloat parentViewHeight;

@end

@implementation AJMediaPlayerGesture

- (instancetype)init {
    self = [super init];
    if (self) {
        _isAvailable = NO;
        _moveNumbers = 0;
        self.progessType = ProgessTypeNone;
    }
    return self;
}

- (void)setParentView:(UIView *)parentView {
    if (!_parentView) {
        _parentView = parentView;
    }
}

- (void)mediaPlayerViewTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSUInteger numTaps = [[[event allTouches] allObjects] count];
    if (numTaps == 1) {
        UITouch *touch = [[[event allTouches] allObjects] firstObject];
        if (touch.phase == UITouchPhaseStationary) {
            return;
        }
        _isAvailable = YES;
        _moveNumbers = 0;
        self.parentViewWidth = [UIScreen mainScreen].bounds.size.width;
        self.parentViewHeight = [UIScreen mainScreen].bounds.size.height;
    } else {
        _isAvailable = NO;
    }
}

- (void)mediaPlayerViewTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!_isAvailable) {
        return;
    }
    _moveNumbers++;
    NSUInteger numTaps = [[[event allTouches] allObjects] count];
    if (numTaps == 1) {
        UITouch *touch = [[[event allTouches] allObjects] firstObject];
        if (touch.phase == UITouchPhaseStationary) {
            return;
        }
        CGPoint curPoint = [touch locationInView:self.parentView];
        CGPoint prePoint = [touch previousLocationInView:self.parentView];
        ProgessType directionType = Addition;
        if (fabs(curPoint.y - prePoint.y)*2 < (fabs(curPoint.x - prePoint.x)) && !isVolumeType) {
            BOOL isResponseToMoveSchedule = NO;
            float screenPercent;
            if (_moveNumbers > 10) {
                isResponseToMoveSchedule = YES;
                if (fabs(curPoint.x-prePoint.x) <= 0.5) {
                    screenPercent = 0;
                } else {
                    if (self.parentViewWidth > self.parentViewHeight) {
                        screenPercent = (fabs(curPoint.x-prePoint.x)/(self.parentViewWidth))*0.5;
                    } else {
                        screenPercent = (fabs(curPoint.x-prePoint.x)/(self.parentViewWidth))*0.25;
                    }
                }
            } else {
                if (fabs(curPoint.x-prePoint.x) > 20) {
                    if (self.parentViewWidth > self.parentViewHeight) {
                        screenPercent = (fabs(curPoint.x-prePoint.x)/(self.parentViewWidth))*0.5;
                    } else {
                        screenPercent = (fabs(curPoint.x-prePoint.x)/(self.parentViewWidth))*0.25;
                    }
                }
            }
            if (isResponseToMoveSchedule) {
                self.progessType = ProgessTypeSchedule;
                isScheduleType = YES;
                if (curPoint.x < prePoint.x) {
                    directionType = Reduction;
                }
                else {
                    directionType = Addition;
                }
                if ([self.delegate respondsToSelector:@selector(moveScheduleWithType:screenPercent:)]) {
                    [self.delegate moveScheduleWithType:directionType screenPercent:screenPercent];
                }
            }
            
        } else if (fabs(curPoint.y - prePoint.y) > (fabs(curPoint.x - prePoint.x))*2 && !isScheduleType) {
            BOOL isResponseToMoveVolume = NO;
            if (_moveNumbers > 10) {
                isResponseToMoveVolume = YES;
            } else {
                if (fabs(curPoint.y - prePoint.y) > 20) {
                    isResponseToMoveVolume = YES;
                }
            }
            if (isResponseToMoveVolume) {
                self.progessType = ProgessTypeVolume;
                isVolumeType = YES;
                if (curPoint.y < prePoint.y) {
                    directionType = Addition;
                } else {
                    directionType = Reduction;
                }
                if ([self.delegate respondsToSelector:@selector(moveVolumeWithType:)]) {
                    [self.delegate moveVolumeWithType:directionType];
                }
            }
        }
    }
}

- (void)mediaPlayerViewTouchesEnded {
    _isAvailable = NO;
    _moveNumbers = 0;
    isScheduleType = NO;
    isVolumeType = NO;
    self.progessType = ProgessTypeNone;
    if ([self.delegate respondsToSelector:@selector(gestureDidEndMoved)]) {
        [self.delegate gestureDidEndMoved];
    }
}
@end
