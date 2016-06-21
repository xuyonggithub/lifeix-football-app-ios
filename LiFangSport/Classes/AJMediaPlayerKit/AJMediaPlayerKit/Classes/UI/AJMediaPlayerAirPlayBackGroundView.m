//
//  AJMediaPlayerAirPlayBackGroundView.m
//  Pods
//
//  Created by lixiang on 15/9/8.
//
//

#import "AJMediaPlayerAirPlayBackGroundView.h"

@interface AJMediaPlayerAirPlayBackGroundView()
@property (nonatomic, strong) UIImageView *airPlayIcon;
@property (nonatomic, strong) UILabel *airPlayTitleLabel;
@property (nonatomic, strong) UILabel *tipsLabel;
@end

@implementation AJMediaPlayerAirPlayBackGroundView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.clipsToBounds = YES;
        
        self.airPlayIcon = [[UIImageView alloc] init];
        _airPlayIcon.translatesAutoresizingMaskIntoConstraints = NO;
        [_airPlayIcon setImage:[UIImage imageNamed:@"player_bt_airplay_used"]];
        [self addSubview:_airPlayIcon];
        
        self.airPlayTitleLabel = [[UILabel alloc] init];
        _airPlayTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _airPlayTitleLabel.text = @"AirPlay";
        [_airPlayTitleLabel setBackgroundColor:[UIColor clearColor]];
        [_airPlayTitleLabel setTextColor:[UIColor whiteColor]];
        [_airPlayTitleLabel setFont:[UIFont systemFontOfSize:12]];
        _airPlayTitleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_airPlayTitleLabel];
        
        self.tipsLabel = [[UILabel alloc] init];
        _tipsLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _tipsLabel.text = @"此视频正在“Apple TV”上播放。";
        [_tipsLabel setBackgroundColor:[UIColor clearColor]];
        [_tipsLabel setTextColor:[UIColor colorWithRed:135.0f green:135.0f blue:135.0f alpha:0.6]];
        [_tipsLabel setFont:[UIFont systemFontOfSize:10]];
        _tipsLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_tipsLabel];
    }
    return self;
}

- (void)updateConstraints {
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_airPlayIcon
                                                     attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f
                                                      constant:132.0*3/4]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_airPlayIcon
                                                     attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f
                                                      constant:100.0*3/4]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_airPlayIcon
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1
                                                      constant:0.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_airPlayIcon
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterY
                                                    multiplier:1
                                                      constant:-24.0f]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_airPlayTitleLabel
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:1.0f
                                                      constant:100.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_airPlayTitleLabel
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:1.0f
                                                      constant:13.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_airPlayTitleLabel
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1
                                                      constant:0.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_airPlayTitleLabel
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterY
                                                    multiplier:1
                                                      constant:25.0f]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_tipsLabel
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:1.0f
                                                      constant:200.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_tipsLabel
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:1.0f
                                                      constant:11.0f]];
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
                                                      constant:40.0f]];
    
    [super updateConstraints];
}

@end
