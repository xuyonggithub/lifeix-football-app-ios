//
//  AJMediaPlayerProgressView.m
//  Pods
//
//  Created by lixiang on 15/7/23.
//
//

#import "AJMediaPlayerProgressView.h"
#import "AJMediaPlayerUtilities.h"

@interface AJMediaPlayerProgressView()
@property (nonatomic, strong) UILabel *pendingTimeLabel;
@property (nonatomic, strong) UILabel *durationLabel;
@property (nonatomic, strong) UIImageView *directionImageView;
@property (nonatomic, strong) UISlider *progressSlider;
@property (nonatomic, assign) AJMediaPlayerAppearenceStyle appearenceStyle;
@end

@implementation AJMediaPlayerProgressView

- (instancetype)initWithAJMediaPlayerAppearenceStyle:(AJMediaPlayerAppearenceStyle )appearenceStyle {
    self = [super init];
    if (self) {
        [self setBackgroundColor:[UIColor colorWithHTMLColorMark:@"#000000" alpha:0.7]];
        if (_appearenceStyle == AJMediaPlayerStyleForiPad) {
            self.layer.cornerRadius = 4;
        } else {
            self.layer.cornerRadius = 2;
        }
        self.appearenceStyle = appearenceStyle;
        
        self.progressSlider = [[UISlider alloc] init];
        _progressSlider.translatesAutoresizingMaskIntoConstraints = NO;
        _progressSlider.maximumValue = 1;
        _progressSlider.minimumValue = 0;
        _progressSlider.value = 0;
        _progressSlider.continuous = YES;
        _progressSlider.enabled = YES;
        _progressSlider.maximumTrackTintColor = [UIColor colorWithHTMLColorMark:@"#b5b5b5" alpha:0.6];
        _progressSlider.minimumTrackTintColor = [UIColor colorWithHTMLColorMark:@"#29c4c6"];
        [_progressSlider setThumbImage:[UIImage imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
        [self addSubview:_progressSlider];
    
        self.directionImageView = [[UIImageView alloc] init];
        _directionImageView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_directionImageView];
        
        float fontSize = _appearenceStyle==AJMediaPlayerStyleForiPhone?12:14;
        self.pendingTimeLabel = [[UILabel alloc] init];
        _pendingTimeLabel.backgroundColor = [UIColor clearColor];
        _pendingTimeLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _pendingTimeLabel.font = [UIFont fontWithName:@"Helvetica" size:fontSize];
        _pendingTimeLabel.textColor = [UIColor colorWithHTMLColorMark:@"#29c4c6"];
        _pendingTimeLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:_pendingTimeLabel];
        
        self.durationLabel = [[UILabel alloc] init];
        _durationLabel.backgroundColor = [UIColor clearColor];
        _durationLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _durationLabel.font = [UIFont fontWithName:@"Helvetica" size:fontSize];
        _durationLabel.textColor = [UIColor colorWithHTMLColorMark:@"#999999"];
        _durationLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_durationLabel];
    }
    return self;
}

- (void)updateConstraints {
    float directionImageViewY = _appearenceStyle==AJMediaPlayerStyleForiPhone?-25:-30;
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_directionImageView
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1
                                                      constant:0.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_directionImageView
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterY
                                                    multiplier:1
                                                      constant:directionImageViewY]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_directionImageView
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:1
                                                      constant:25.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_directionImageView
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:1
                                                      constant:25.0f]];
    
    float labelWidth = _appearenceStyle==AJMediaPlayerStyleForiPhone?72.5f:100.0f;
    float labelY = _appearenceStyle==AJMediaPlayerStyleForiPhone?10.0f:10.0f;
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_pendingTimeLabel
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1
                                                      constant:-(labelWidth/2)]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_pendingTimeLabel
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterY
                                                    multiplier:1
                                                      constant:labelY]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_pendingTimeLabel
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:1
                                                      constant:labelWidth]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_durationLabel
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1
                                                      constant:(labelWidth/2)]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_durationLabel
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterY
                                                    multiplier:1
                                                      constant:labelY]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_durationLabel
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:1
                                                      constant:labelWidth]];
    
    float progressSliderWidth = _appearenceStyle==AJMediaPlayerStyleForiPhone?100:120;
    float progressSliderY = _appearenceStyle==AJMediaPlayerStyleForiPhone?35:40;
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_progressSlider
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1
                                                      constant:0.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_progressSlider
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterY
                                                    multiplier:1
                                                      constant:progressSliderY]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_progressSlider
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:1
                                                      constant:progressSliderWidth]];
    
    [super updateConstraints];
}


- (void)updatePendTimeLabel:(NSTimeInterval )pendtime withDurationLabel:(NSTimeInterval )durationTime {
    if (durationTime && durationTime >= 3600) {
        _pendingTimeLabel.text = [AJMediaPlayerUtilities translateToHHMMSSText:pendtime];
        _durationLabel.text = [NSString stringWithFormat:@"/%@",[AJMediaPlayerUtilities translateToHHMMSSText:durationTime]];
    } else {
        _pendingTimeLabel.text = [AJMediaPlayerUtilities translateToMMSSText:pendtime];
        _durationLabel.text = [NSString stringWithFormat:@"/%@",[AJMediaPlayerUtilities translateToMMSSText:durationTime]];
    }
    _progressSlider.value = pendtime/durationTime;
}

- (void)updateDirectionImageViewWithType:(ProgessType )type {
    if (type == Addition) {
        [_directionImageView setImage:[UIImage imageNamed:@"player_ic_forward"]];
    } else {
        [_directionImageView setImage:[UIImage imageNamed:@"player_ic_backward"]];
    }
}

@end
