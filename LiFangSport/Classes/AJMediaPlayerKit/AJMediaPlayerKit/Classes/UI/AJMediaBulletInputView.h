//
//  AJMediaBulletInputView.h
//  Pods
//
//  Created by tianzhuo on 2/24/16.
//
//  弹幕输入栏

#import <UIKit/UIKit.h>

@class AJMediaBulletInputView;
@protocol AJMediaBulletInputViewDelegate <NSObject>

@optional
/**
 *  用户点击键盘发送按钮时触发
 *
 *  @param inputView self
 *  @param message   弹幕内容
 */
- (void)bulletInputView:(AJMediaBulletInputView *)inputView didReturnMessage:(NSString *)message;

@end

@interface AJMediaBulletInputView : UIView

/**
 *  取消按钮
 */
@property (nonatomic, strong) IBInspectable UIButton *cancelButton;
/**
 *  聊天输入框
 */
@property (nonatomic, strong) IBInspectable UITextField *textField;
/**
 *  消息发送按钮
 */
@property (nonatomic, strong) IBInspectable UIButton *sendButton;
/**
 *  代理
 */
@property (nonatomic, weak) id<AJMediaBulletInputViewDelegate> delegate;


@end
