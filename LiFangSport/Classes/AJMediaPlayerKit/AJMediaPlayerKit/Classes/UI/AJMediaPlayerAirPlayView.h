//
//  AJMediaPlayerAirPlayView.h
//  Pods
//
//  Created by Zhangqibin on 15/7/23.
//
//

@import UIKit;


@protocol AJMediaPlayerAirplayViewDelegate <NSObject>
/**
 *  监测网络中的airplay
 *
 *  @param found 监测标示符
 */
- (void)didBrowserAvailableAirplayDevices:(BOOL)found;
@end

@interface AJMediaPlayerAirPlayView : UIView
/**
 *  airplay显示按钮
 */
@property (nonatomic, strong) UIButton *airPlayButton;
/**
 *  delegate
 */
@property (nonatomic, assign) id<AJMediaPlayerAirplayViewDelegate> delegate;
/**
 *  调用系统mpButton，响应弹出选择airplay页面
 */
@property (nonatomic, strong) UIButton *mpButton;
/**
 *  调用系统airPlayButton坐标
 */
@property (nonatomic, assign) CGRect volumeFrame;
/**
 *  生成airplayView方法
 *
 *  @param frame
 *  @param detectedName   检测到airplay时的显示的图片
 *  @param playingName    连接到airplay时的显示的图片
 *
 *  @return airplayView
 */
- (instancetype)initWithFrame:(CGRect)frame
            detectedImageName:(NSString*)detectedName
             playingImageName:(NSString*)playingName;

@end
