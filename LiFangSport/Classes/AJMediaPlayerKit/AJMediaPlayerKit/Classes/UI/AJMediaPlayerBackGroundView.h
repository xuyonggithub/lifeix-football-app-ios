//
//  AJMediaPlayerBackGroundView.h
//  Pods
//
//  Created by Zhangqibin on 15/8/21.
//
//

#import <UIKit/UIKit.h>
#import "AJMediaPlayerStyleDefines.h"
@interface AJMediaPlayerBackGroundView : UIView
@property (nonatomic, strong) UILabel *tipsLabel;

- (instancetype)initWithAppearenceStyle:(AJMediaPlayerAppearenceStyle )appearenceStyle;

- (void)updateTipsLabelTitle:(NSString *)titleText;

@end
