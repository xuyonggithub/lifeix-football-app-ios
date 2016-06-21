//
//  AJMediaPlayerCaptionControlPanel.h
//  Pods
//
//  Created by le_cui on 15/7/16.
//
//

@import UIKit;
#import "AJMediaPlayerStyleDefines.h"
@class AJMediaPlayerAirPlayView;
@class AJMediaPlayerCaptionControlPanel;
@class AJMediaPlayerButton;
@protocol AJMediaPlayerCaptionControlPanelDelegate <NSObject>
/**
 *  点击切换码流按钮回调
 *
 *  @param playerCaptionControlPanel
 *  @param streamListButton
 */
- (void)playerCaptionControlPanel:(AJMediaPlayerCaptionControlPanel *)playerCaptionControlPanel didTapOnStreamListButton:(UIButton *)streamListButton;
/**
 *  点击分享按钮回调
 *
 *  @param playerCaptionControlPanel
 *  @param shareButton
 */
- (void)playerCaptionControlPanel:(AJMediaPlayerCaptionControlPanel *)playerCaptionControlPanel didTapOnShareButton:(UIButton *)shareButton;
/**
 *  点击选段按钮回调
 *
 *  @param playerCaptionControlPanel
 *  @param excerptsButton
 */
- (void)playerCaptionControlPanel:(AJMediaPlayerCaptionControlPanel *)playerCaptionControlPanel didTapOnExcerptsButton:(UIButton *)excerptsButton;
/**
 *  点击卡顿按钮回调
 *
 *  @param playerCaptionControlPanel
 *  @param bufferButton
 */
- (void)playerCaptionControlPanel:(AJMediaPlayerCaptionControlPanel *)playerCaptionControlPanel didTapOnBufferButton:(UIButton *)bufferButton;
/**
 *  网络中是否监测到AirPlay
 *
 *  @param playerCaptionControlPanel
 *  @param isDetect                  网络中是否监测到airPlay
 */
- (void)playerCaptionControlPanel:(AJMediaPlayerCaptionControlPanel *)playerCaptionControlPanel airPlayIsDetected:(BOOL)isDetected;
/**
 *  iPad播放器点击回到直播按钮回调
 *
 *  @param playerCaptionControlPanel
 *  @param streamListButton
 */
- (void)playerCaptionControlPanel:(AJMediaPlayerCaptionControlPanel *)playerCaptionControlPanel didTapOnBackToLiveButton:(UIButton *)backToLiveButton;
@end

IB_DESIGNABLE
@interface AJMediaPlayerCaptionControlPanel : UIControl
/**
 *  AJMediaPlayerCaptionControlPanel回调delegate
 */
@property (nonatomic, weak) id<AJMediaPlayerCaptionControlPanelDelegate> delegate;
/**
 *  airPlayView展示图
 */
@property (nonatomic, strong) IBInspectable AJMediaPlayerAirPlayView *airPlayView;
/**
 *  码流切换按钮
 */
@property (nonatomic, strong) IBInspectable AJMediaPlayerButton *streamListButton;
/**
 *  分享按钮
 */
@property (nonatomic, strong) IBInspectable UIButton *shareButton;
/**
 *  选段按钮
 */
@property (nonatomic, strong) IBInspectable AJMediaPlayerButton *excerptsButton;
/**
 *  标题Label
 */
@property (nonatomic, strong) IBInspectable UILabel *titleLabel;
/**
 *  卡顿按钮
 */
@property (nonatomic, strong) IBInspectable UIButton *bufferButton;
/**
 *  背景图
 */
@property (nonatomic ,strong) IBInspectable UIImageView *backGroundImageView;
/**
 *  是否全屏
 */
@property (nonatomic, assign) BOOL isFullScreen;
/**
 *  iPad中回到直播按钮
 */
@property (nonatomic, strong) IBInspectable UIButton *backToLiveButton;
/**
 *  是否显示在iPad播放器小屏幕中
 */
@property (nonatomic, assign) BOOL isShowInProtraitStyle;
/**
 *  播放器顶部操作栏初始化方法
 */
- (instancetype)initWithAppearenceStyle:(AJMediaPlayerAppearenceStyle )appearenceStyle;

@end
