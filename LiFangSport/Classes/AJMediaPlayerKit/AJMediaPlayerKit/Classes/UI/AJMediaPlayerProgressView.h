//
//  AJMediaPlayerProgressView.h
//  Pods
//
//  Created by lixiang on 15/7/23.
//
//

@import UIKit;
#import "AJMediaPlayerGesture.h"
#import "AJMediaPlayerStyleDefines.h"

@interface AJMediaPlayerProgressView : UIView
- (instancetype)initWithAJMediaPlayerAppearenceStyle:(AJMediaPlayerAppearenceStyle )appearenceStyle;
- (void)updatePendTimeLabel:(NSTimeInterval )pendtime withDurationLabel:(NSTimeInterval )durationTime;
- (void)updateDirectionImageViewWithType:(ProgessType)type;

@end
