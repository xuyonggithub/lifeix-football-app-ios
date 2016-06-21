//
//  AJMediaTipsView.h
//  Pods
//
//  Created by lixiang on 15/9/15.
//
//

#import <UIKit/UIKit.h>
#import "AJMediaPlayerStyleDefines.h"

@interface AJMediaTipsView : UIView

@property (nonatomic, strong) UILabel *tipsLabel;

- (instancetype)initWithAppearenceStyle:(AJMediaPlayerAppearenceStyle )appearenceStyle text:(NSString *)text;

@end
