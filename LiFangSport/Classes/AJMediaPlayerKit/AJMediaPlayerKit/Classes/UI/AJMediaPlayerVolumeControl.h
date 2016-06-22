//
//  AJMediaPlayerVolumeControl.h
//  AJMediaPlayerKit
//
//  Created by Zhangqibin on 15/7/10.
//  Copyright (c) 2015年 zhangyi. All rights reserved.
//

@import UIKit;
#import "AJMediaPlayerStyleDefines.h"

IB_DESIGNABLE
@interface AJMediaPlayerVolumeControl : UIControl
@property(nonatomic, strong) IBInspectable UISlider *slider;

- (instancetype)initWithAppearenceStyle:(AJMediaPlayerAppearenceStyle )appearenceStyle;

@end
