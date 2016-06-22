//
//  AJMediaTipsView.m
//  Pods
//
//  Created by Zhangqibin on 15/9/15.
//
//

#import "AJMediaTipsView.h"

@interface AJMediaTipsView()
@property (nonatomic, assign) AJMediaPlayerAppearenceStyle appearenceStyle;
@end

@implementation AJMediaTipsView

- (instancetype)initWithAppearenceStyle:(AJMediaPlayerAppearenceStyle )appearenceStyle text:(NSString *)text {
    self = [super init];
    if (self) {
        self.layer.cornerRadius = 5;
        self.appearenceStyle = appearenceStyle;
        self.tipsLabel = [[UILabel alloc] init];
        _tipsLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _tipsLabel.text = text;
        [_tipsLabel setBackgroundColor:[UIColor clearColor]];
        [_tipsLabel setTextColor:[UIColor whiteColor]];
        
        float tipsLabelSize = _appearenceStyle==AJMediaPlayerStyleForiPhone?12:15;
        [_tipsLabel setFont:[UIFont systemFontOfSize:tipsLabelSize]];
        _tipsLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_tipsLabel];
    }
    return self;
}

- (void)updateConstraints {
    
    float tipsLabelWidth = _appearenceStyle==AJMediaPlayerStyleForiPhone?150:180;
    float tipsLabelHeight = _appearenceStyle==AJMediaPlayerStyleForiPhone?13:20;
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_tipsLabel
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:1.0f
                                                      constant:tipsLabelWidth]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_tipsLabel
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:1.0f
                                                      constant:tipsLabelHeight]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_tipsLabel
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1
                                                      constant:0.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_tipsLabel
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterY
                                                    multiplier:1
                                                      constant:0.0f]];
    [super updateConstraints];
}

@end
