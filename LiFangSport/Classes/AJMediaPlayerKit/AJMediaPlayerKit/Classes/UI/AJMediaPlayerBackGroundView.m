//
//  AJMediaPlayerBackGroundView.m
//  Pods
//
//  Created by Zhangqibin on 15/8/21.
//
//

#import "AJMediaPlayerBackGroundView.h"
#import "AJMediaIndicatorView.h"
@interface AJMediaPlayerBackGroundView()
@property (nonatomic, strong) AJMediaIndicatorView *activityIndicatorView;
@property (nonatomic, assign) AJMediaPlayerAppearenceStyle appearenceStyle;
@end

@implementation AJMediaPlayerBackGroundView

- (instancetype)initWithAppearenceStyle:(AJMediaPlayerAppearenceStyle )appearenceStyle {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.clipsToBounds = YES;
        self.appearenceStyle = appearenceStyle;
        
        self.tipsLabel = [[UILabel alloc] init];
        _tipsLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _tipsLabel.text = @"正在建立连接";
        [_tipsLabel setBackgroundColor:[UIColor clearColor]];
        [_tipsLabel setTextColor:[UIColor colorWithRed:135.0f green:135.0f blue:135.0f alpha:0.6]];
        
        float tipsLabelSize = _appearenceStyle==AJMediaPlayerStyleForiPhone?12:15;
        [_tipsLabel setFont:[UIFont systemFontOfSize:tipsLabelSize]];
        _tipsLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_tipsLabel];
        
        self.activityIndicatorView = [[AJMediaIndicatorView alloc] init];
        _activityIndicatorView.hidesWhenStopped = NO;
        _activityIndicatorView.translatesAutoresizingMaskIntoConstraints = NO;
        //_activityIndicatorView.tintColor = [UIColor colorWithRed:41.f/255 green:196.f/255 blue:198.f/255 alpha:1];
        _activityIndicatorView.tintColor = knavibarColor;
        _activityIndicatorView.backgroundColor = [UIColor clearColor];
        [_activityIndicatorView startAnimating];
        [self addSubview:_activityIndicatorView];
    }
    return self;
}

- (void)updateConstraints {
    float tipsLabelWidth = _appearenceStyle==AJMediaPlayerStyleForiPhone?100.0f:120.0f;
    float tipsLabelHeight = _appearenceStyle==AJMediaPlayerStyleForiPhone?12.0f:15.0f;
    float tipsLabelX = _appearenceStyle==AJMediaPlayerStyleForiPhone?15.0f:20.0f;
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_tipsLabel
                                                     attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f
                                                      constant:tipsLabelWidth]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_tipsLabel
                                                     attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f
                                                      constant:tipsLabelHeight]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_tipsLabel
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1
                                                      constant:tipsLabelX]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_tipsLabel
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterY
                                                    multiplier:1
                                                      constant:0.0f]];
    
    float activitySize = _appearenceStyle==AJMediaPlayerStyleForiPhone?15.0f:20.0f;
    float activityX = _appearenceStyle==AJMediaPlayerStyleForiPhone?-50.0f:-60.0f;
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_activityIndicatorView
                                                     attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f
                                                      constant:activitySize]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_activityIndicatorView
                                                     attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f
                                                      constant:activitySize]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_activityIndicatorView
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1
                                                      constant:activityX]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_activityIndicatorView
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterY
                                                    multiplier:1
                                                      constant:0.0f]];
    [super updateConstraints];
}

- (void)updateTipsLabelTitle:(NSString *)titleText {
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (weakSelf.tipsLabel) {
          weakSelf.tipsLabel.text = titleText;
        }
    });
}

@end
