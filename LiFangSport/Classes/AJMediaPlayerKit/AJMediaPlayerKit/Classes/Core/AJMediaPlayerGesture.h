//
//  AJMediaPlayerGesture.h
//  Pods
//
//  Created by lixiang on 15/7/14.
//
//

@import Foundation;
@import UIKit;

enum ProgessAction {
    Addition = 0,
    Reduction = 1
};
typedef NSUInteger ProgessType;

@protocol AJMediaPlayerGestureDelegate <NSObject>

@optional
/**
 *  调节进度
 *
 *  @param type 类型,增大或者减小
 */
- (void)moveScheduleWithType:(ProgessType)type screenPercent:(float)percent;
/**
 *  调节音量
 *
 *  @param type 类型,增大或者减小
 */
- (void)moveVolumeWithType:(ProgessType)type;
/**
 *  结束滑动
 */
- (void)gestureDidEndMoved;
@end

@interface AJMediaPlayerGesture : NSObject
/**
 *  手势父类
 */
@property (nonatomic,strong) UIView *parentView;
/**
 *  回调delegate
 */
@property (nonatomic, weak) id <AJMediaPlayerGestureDelegate>delegate;
/**
 *  触摸开始事件 (直接传递touch参数)
 *
 *  @param touches 移动事件集合
 *  @param event   事件
 */
- (void)mediaPlayerViewTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
/**
 *  触摸移动事件 (直接传递touch参数)
 *
 *  @param touches  移动事件集合
 *  @param event   事件
 */
- (void)mediaPlayerViewTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
/**
 *  触摸结束事件 (直接传递touch参数)
 *
 *  @param touches 移动事件集合
 */
- (void)mediaPlayerViewTouchesEnded;

@end
