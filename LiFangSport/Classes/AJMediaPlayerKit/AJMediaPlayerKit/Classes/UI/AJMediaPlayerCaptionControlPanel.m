//
//  AJMediaPlayerCaptionControlPanel.m
//  Pods
//
//  Created by le_cui on 15/7/16.
//
//

#import "AJMediaPlayerCaptionControlPanel.h"
#import "AJMediaPlayerUtilities.h"
#import "AJMediaPlayerAirPlayView.h"
#import "AJMediaPlayerButton.h"
#import <MediaPlayer/MediaPlayer.h>
@interface AJMediaPlayerCaptionControlPanel()<AJMediaPlayerAirplayViewDelegate>
/**
 *  设置约束数组
 */
@property (nonatomic ,strong) NSMutableArray *constraintsList;
/**
 *  约束条件字典
 */
@property (nonatomic, strong) NSDictionary *metrics;
/**
 *  子视图字典
 */
@property (nonatomic, strong) NSDictionary *subViewsDictionary;
/**
 *  外观类型
 */
@property (nonatomic, assign) AJMediaPlayerAppearenceStyle appearenceStyle;
@end

@implementation AJMediaPlayerCaptionControlPanel

#pragma mark - Init Method

- (instancetype)initWithAppearenceStyle:(AJMediaPlayerAppearenceStyle )appearenceStyle {
    if ((self = [super init])) {
        _appearenceStyle = appearenceStyle;
        
        [self initView];
        self.constraintsList = [NSMutableArray array];
        if (_appearenceStyle == AJMediaPlayerStyleForiPhone) {
            self.subViewsDictionary = NSDictionaryOfVariableBindings(_titleLabel,_excerptsButton,_streamListButton,_airPlayView,_shareButton,_bufferButton);
            self.metrics = @{@"bufferbuttonWidth":@(50),@"buttonWidth":@(45),@"buttonHeight":@(22),@"buttonBottom":@(14),@"buttonRight":@(24),@"titleLabelLeft":@(50),@"titleLabelRight":@(24),@"titleLabelBottom":@(15),@"shareButtonRight":@(10)};
        } else if (_appearenceStyle == AJMediaPlayerStyleForiPad) {
            self.subViewsDictionary = NSDictionaryOfVariableBindings(_titleLabel,_backToLiveButton,_airPlayView,_shareButton,_bufferButton);
            self.metrics = @{@"bufferbuttonWidth":@(50),@"buttonWidth":@(45),@"buttonHeight":@(22),@"buttonBottom":@(14),@"buttonRight":@(24),@"titleLabelLeft":@(50),@"titleLabelRight":@(24),@"titleLabelBottom":@(15),@"shareButtonRight":@(10)};
        }
    }
    return self;
}

- (void)initView{
    self.backGroundImageView = [[UIImageView alloc] init];
    _backGroundImageView.translatesAutoresizingMaskIntoConstraints = NO;
    CGRect airPlayViewSize;
    if (_appearenceStyle == AJMediaPlayerStyleForiPhone) {
        airPlayViewSize = CGRectMake(0, 0, 45, 22);
    } else if (_appearenceStyle == AJMediaPlayerStyleForiPad) {
        airPlayViewSize = CGRectMake(0, 0, 45, 45);
    }
    self.airPlayView = [[AJMediaPlayerAirPlayView alloc] initWithFrame:airPlayViewSize
                                               detectedImageName:@"player_bt_airplay" playingImageName:@"player_bt_airplay_press"];
    _airPlayView.translatesAutoresizingMaskIntoConstraints = NO;
    _airPlayView.delegate = self;
    [self addSubview:_airPlayView];
    
    float fontSize = _appearenceStyle==AJMediaPlayerStyleForiPhone?12:14;
    if (_appearenceStyle == AJMediaPlayerStyleForiPhone) {
        self.excerptsButton = [AJMediaPlayerButton buttonWithType:UIButtonTypeCustom];
        _excerptsButton.layer.cornerRadius = 2;
        _excerptsButton.layer.borderWidth = 1;
        _excerptsButton.layer.borderColor = [UIColor colorWithHTMLColorMark:@"#ffffff"].CGColor;
        [_excerptsButton setTitle:@"相关" forState:UIControlStateNormal];
        _excerptsButton.titleLabel.font = [UIFont systemFontOfSize:fontSize];
        _excerptsButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_excerptsButton setTitleColor:[UIColor colorWithHTMLColorMark:@"#29c4c6"] forState:UIControlStateHighlighted];
        [_excerptsButton addTarget:self action:@selector(excerptsButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        self.streamListButton = [AJMediaPlayerButton buttonWithType:UIButtonTypeCustom];
        _streamListButton.layer.cornerRadius = 2;
        _streamListButton.layer.borderWidth = 1;
        _streamListButton.layer.borderColor = [UIColor colorWithHTMLColorMark:@"#ffffff"].CGColor;
        [_streamListButton setTitle:@"标清" forState:UIControlStateNormal];
        _streamListButton.titleLabel.font = [UIFont systemFontOfSize:fontSize];
        _streamListButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_streamListButton setTitleColor:[UIColor colorWithHTMLColorMark:@"#29c4c6"] forState:UIControlStateHighlighted];
        [_streamListButton addTarget:self action:@selector(streamListButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    } else if (_appearenceStyle == AJMediaPlayerStyleForiPad) {
        self.backToLiveButton = [AJMediaPlayerButton buttonWithType:UIButtonTypeCustom];
        _backToLiveButton.layer.cornerRadius = 2;
        _backToLiveButton.layer.borderWidth = 1;
        _backToLiveButton.layer.borderColor = [UIColor colorWithHTMLColorMark:@"#ffffff"].CGColor;
        [_backToLiveButton setTitle:@"回到直播" forState:UIControlStateNormal];
        _backToLiveButton.titleLabel.font = [UIFont systemFontOfSize:fontSize];
        _backToLiveButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_backToLiveButton setTitleColor:[UIColor colorWithHTMLColorMark:@"#29c4c6"] forState:UIControlStateHighlighted];
        [_backToLiveButton addTarget:self action:@selector(backToLiveButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    float bufferfontSize = _appearenceStyle==AJMediaPlayerStyleForiPhone?10:14;
    self.bufferButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _bufferButton.layer.cornerRadius = 2;
    _bufferButton.layer.borderWidth = 1;
    _bufferButton.layer.borderColor = [UIColor colorWithHTMLColorMark:@"#f6d208"].CGColor;
    [_bufferButton setTitleColor:[UIColor colorWithHTMLColorMark:@"#f6d208"] forState:UIControlStateNormal];
    [_bufferButton setTitle:@"投诉卡顿" forState:UIControlStateNormal];
    _bufferButton.titleLabel.font = [UIFont systemFontOfSize:bufferfontSize];
    _bufferButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_bufferButton addTarget:self action:@selector(bufferButtonAction:) forControlEvents:UIControlEventTouchUpInside];

    
    self.shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_shareButton setImage:[UIImage imageNamed:@"bt_share"] forState:UIControlStateNormal];
    [_shareButton setImage:[UIImage imageNamed:@"bt_share_press"] forState:UIControlStateHighlighted];
    _shareButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_shareButton addTarget:self action:@selector(shareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    if (_appearenceStyle == AJMediaPlayerStyleForiPad) {
        _shareButton.hidden = YES;
    } else {
        _shareButton.hidden = NO;
    }
    
    self.titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont systemFontOfSize:15];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
}

- (void)updateConstraints {
    [super updateConstraints];
    [self removeConstraints:_constraintsList];
    [_constraintsList removeAllObjects];
    if (_isFullScreen) {
        [self addLanscapeConstraints];
    } else {
        [self addProtraitConstraints];
    }
}

- (void)addProtraitConstraints {
    if (_appearenceStyle == AJMediaPlayerStyleForiPhone) {
        [self addSubview:_backGroundImageView];
        [_titleLabel removeFromSuperview];
        [_bufferButton removeFromSuperview];
        [_excerptsButton removeFromSuperview];
        [_streamListButton removeFromSuperview];
        [_shareButton removeFromSuperview];
        [self setBackgroundColor:[UIColor clearColor]];
        [_backGroundImageView setBackgroundColor:[UIColor clearColor]];
        
        [_constraintsList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_airPlayView(buttonWidth)]-shareButtonRight-|"
                                                                                      options:0
                                                                                      metrics:_metrics
                                                                                        views:_subViewsDictionary]];
        [_constraintsList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_airPlayView(buttonHeight)]-12-|"
                                                                                      options:0
                                                                                      metrics:_metrics
                                                                                        views:_subViewsDictionary]];
        [_constraintsList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_backGroundImageView]-0-|"
                                                                                      options:0
                                                                                      metrics:nil
                                                                                        views:NSDictionaryOfVariableBindings(_backGroundImageView)]];
        [_constraintsList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_backGroundImageView]-0-|"
                                                                                      options:0
                                                                                      metrics:nil
                                                                                        views:NSDictionaryOfVariableBindings(_backGroundImageView)]];
    } else if (_appearenceStyle == AJMediaPlayerStyleForiPad) {
        [_bufferButton removeFromSuperview];
        _backToLiveButton.titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        if (_isShowInProtraitStyle) {
            [self addSubview:_titleLabel];
            [self addSubview:_backToLiveButton];
            [self addSubview:_shareButton];
            [self setBackgroundColor:[UIColor colorWithHTMLColorMark:@"#000000" alpha:0.7f]];
            
            [_constraintsList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-18-[_titleLabel]"
                                                                                          options:0
                                                                                          metrics:nil
                                                                                            views:_subViewsDictionary]];
            [_constraintsList addObject:[NSLayoutConstraint constraintWithItem:_titleLabel
                                                                     attribute:NSLayoutAttributeCenterY
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self
                                                                     attribute:NSLayoutAttributeCenterY
                                                                    multiplier:1
                                                                      constant:0]];
            
            [_constraintsList addObject:[NSLayoutConstraint constraintWithItem:_shareButton
                                                                     attribute:NSLayoutAttributeCenterY
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self
                                                                     attribute:NSLayoutAttributeCenterY
                                                                    multiplier:1
                                                                      constant:0]];
            [_constraintsList addObject:[NSLayoutConstraint constraintWithItem:_shareButton
                                                                     attribute:NSLayoutAttributeHeight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:nil
                                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                                    multiplier:1.0f
                                                                      constant:44.0f]];
            [_constraintsList addObject:[NSLayoutConstraint constraintWithItem:_shareButton
                                                                     attribute:NSLayoutAttributeWidth
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:nil
                                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                                    multiplier:1.0f
                                                                      constant:44.0f]];
            [_airPlayView setVolumeFrame:CGRectMake(0, 0, 45, 45)];
            [_constraintsList addObject:[NSLayoutConstraint constraintWithItem:_airPlayView
                                                                     attribute:NSLayoutAttributeCenterY
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self
                                                                     attribute:NSLayoutAttributeCenterY
                                                                    multiplier:1
                                                                      constant:0]];
            [_constraintsList addObject:[NSLayoutConstraint constraintWithItem:_airPlayView
                                                                     attribute:NSLayoutAttributeHeight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:nil
                                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                                    multiplier:1.0f
                                                                      constant:44.0f]];
            [_constraintsList addObject:[NSLayoutConstraint constraintWithItem:_airPlayView
                                                                     attribute:NSLayoutAttributeWidth
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:nil
                                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                                    multiplier:1.0f
                                                                      constant:44.0f]];
            
            [_constraintsList addObject:[NSLayoutConstraint constraintWithItem:_backToLiveButton
                                                                     attribute:NSLayoutAttributeCenterY
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self
                                                                     attribute:NSLayoutAttributeCenterY
                                                                    multiplier:1
                                                                      constant:0]];
            [_constraintsList addObject:[NSLayoutConstraint constraintWithItem:_backToLiveButton
                                                                     attribute:NSLayoutAttributeHeight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:nil
                                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                                    multiplier:1.0f
                                                                      constant:22.0f]];
            [_constraintsList addObject:[NSLayoutConstraint constraintWithItem:_backToLiveButton
                                                                     attribute:NSLayoutAttributeWidth
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:nil
                                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                                    multiplier:1.0f
                                                                      constant:63.0f]];
            
            if (_airPlayView.hidden == YES && _backToLiveButton.hidden == YES) {
                [_constraintsList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-18-[_titleLabel]-0-[_shareButton]-0-|"
                                                                                              options:0
                                                                                              metrics:nil
                                                                                                views:_subViewsDictionary]];
            } else if (_airPlayView.hidden == YES && _backToLiveButton.hidden == NO) {
                [_constraintsList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-18-[_titleLabel]-0-[_backToLiveButton]-10-[_shareButton]-0-|"
                                                                                              options:0
                                                                                              metrics:nil
                                                                                                views:_subViewsDictionary]];
            } else if (_airPlayView.hidden == NO && _backToLiveButton.hidden == YES) {
                [_constraintsList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-18-[_titleLabel]-0-[_airPlayView]-0-[_shareButton]-0-|"
                                                                                              options:0
                                                                                              metrics:nil
                                                                                                views:_subViewsDictionary]];
            } else if (_airPlayView.hidden == NO && _backToLiveButton.hidden == NO) {
                [_constraintsList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-18-[_titleLabel]-0-[_backToLiveButton]-10-[_airPlayView]-0-[_shareButton]-0-|"
                                                                                              options:0
                                                                                              metrics:nil
                                                                                                views:_subViewsDictionary]];
            }
        } else {
            [_titleLabel removeFromSuperview];
            [_backToLiveButton removeFromSuperview];
            [_shareButton removeFromSuperview];
            [self setBackgroundColor:[UIColor clearColor]];

            [_airPlayView setVolumeFrame:CGRectMake(0, 10, 45, 45)];
            [_constraintsList addObject:[NSLayoutConstraint constraintWithItem:_airPlayView
                                                                     attribute:NSLayoutAttributeCenterY
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self
                                                                     attribute:NSLayoutAttributeCenterY
                                                                    multiplier:1
                                                                      constant:0]];
            [_constraintsList addObject:[NSLayoutConstraint constraintWithItem:_airPlayView
                                                                     attribute:NSLayoutAttributeHeight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:nil
                                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                                    multiplier:1.0f
                                                                      constant:44.0f]];
            [_constraintsList addObject:[NSLayoutConstraint constraintWithItem:_airPlayView
                                                                     attribute:NSLayoutAttributeWidth
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:nil
                                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                                    multiplier:1.0f
                                                                      constant:44.0f]];
            [_constraintsList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_airPlayView]-shareButtonRight-|"
                                                                                          options:0
                                                                                          metrics:_metrics
                                                                                            views:_subViewsDictionary]];
            [_constraintsList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_airPlayView]-12-|"
                                                                                          options:0
                                                                                          metrics:_metrics
                                                                                            views:_subViewsDictionary]];
        }
        
    }
    [self addConstraints:_constraintsList];
}

- (void)addLanscapeConstraints {
    if (_appearenceStyle == AJMediaPlayerStyleForiPhone) {
        [self setBackgroundColor:[UIColor colorWithHTMLColorMark:@"#000000" alpha:0.7f]];
        [_backGroundImageView removeFromSuperview];
        [self addSubview:_titleLabel];
        [self addSubview:_bufferButton];
        [self addSubview:_excerptsButton];
        [self addSubview:_streamListButton];
        [self addSubview:_shareButton];
        
        [self addSubViewsHConstraints];
        [self addSubViewsVConstraints];
    } else if (_appearenceStyle == AJMediaPlayerStyleForiPad) {
        _backToLiveButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.font = [UIFont systemFontOfSize:17];
        [self setBackgroundColor:[UIColor colorWithHTMLColorMark:@"#222e36" alpha:0.7f]];
        [self addSubview:_bufferButton];
        if (!_isShowInProtraitStyle) {
            [self addSubview:_titleLabel];
            [self addSubview:_backToLiveButton];
            [self addSubview:_shareButton];
        }
        [_constraintsList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-50-[_titleLabel]"
                                                                                      options:0
                                                                                      metrics:nil
                                                                                        views:_subViewsDictionary]];
        [_constraintsList addObject:[NSLayoutConstraint constraintWithItem:_titleLabel
                                                                 attribute:NSLayoutAttributeCenterY
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self
                                                                 attribute:NSLayoutAttributeCenterY
                                                                multiplier:1
                                                                  constant:10]];
        [_constraintsList addObject:[NSLayoutConstraint constraintWithItem:_shareButton
                                                                 attribute:NSLayoutAttributeCenterY
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self
                                                                 attribute:NSLayoutAttributeCenterY
                                                                multiplier:1
                                                                  constant:10]];
        [_constraintsList addObject:[NSLayoutConstraint constraintWithItem:_shareButton
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:1.0f
                                                                  constant:60.0f]];
        [_constraintsList addObject:[NSLayoutConstraint constraintWithItem:_shareButton
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:1.0f
                                                                  constant:60.0f]];
        [_airPlayView setVolumeFrame:CGRectMake(0, 0, 60, 60)];
        [_constraintsList addObject:[NSLayoutConstraint constraintWithItem:_airPlayView
                                                                 attribute:NSLayoutAttributeCenterY
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self
                                                                 attribute:NSLayoutAttributeCenterY
                                                                multiplier:1
                                                                  constant:10]];
        [_constraintsList addObject:[NSLayoutConstraint constraintWithItem:_airPlayView
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:1.0f
                                                                  constant:60.0f]];
        [_constraintsList addObject:[NSLayoutConstraint constraintWithItem:_airPlayView
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:1.0f
                                                                  constant:60.0f]];
        
        [_constraintsList addObject:[NSLayoutConstraint constraintWithItem:_backToLiveButton
                                                                 attribute:NSLayoutAttributeCenterY
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self
                                                                 attribute:NSLayoutAttributeCenterY
                                                                multiplier:1
                                                                  constant:10]];
        [_constraintsList addObject:[NSLayoutConstraint constraintWithItem:_backToLiveButton
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:1.0f
                                                                  constant:27.0f]];
        [_constraintsList addObject:[NSLayoutConstraint constraintWithItem:_backToLiveButton
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:1.0f
                                                                  constant:68.0f]];
        
        [_constraintsList addObject:[NSLayoutConstraint constraintWithItem:_bufferButton
                                                                 attribute:NSLayoutAttributeCenterY
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self
                                                                 attribute:NSLayoutAttributeCenterY
                                                                multiplier:1
                                                                  constant:10]];
        [_constraintsList addObject:[NSLayoutConstraint constraintWithItem:_bufferButton
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:1.0f
                                                                  constant:27.0f]];
        [_constraintsList addObject:[NSLayoutConstraint constraintWithItem:_bufferButton
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:1.0f
                                                                  constant:68.0f]];
        
        if (_bufferButton.hidden == YES) {
            if (_airPlayView.hidden == YES && _backToLiveButton.hidden == YES) {
                [_constraintsList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_shareButton]-0-|"
                                                                                              options:0
                                                                                              metrics:nil
                                                                                                views:_subViewsDictionary]];
            } else if (_airPlayView.hidden == YES && _backToLiveButton.hidden == NO) {
                [_constraintsList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_backToLiveButton]-0-[_shareButton]-0-|"
                                                                                              options:0
                                                                                              metrics:nil
                                                                                                views:_subViewsDictionary]];
            } else if (_airPlayView.hidden == NO && _backToLiveButton.hidden == YES) {
                [_constraintsList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_airPlayView]-0-[_shareButton]-0-|"
                                                                                              options:0
                                                                                              metrics:nil
                                                                                                views:_subViewsDictionary]];
            } else if (_airPlayView.hidden == NO && _backToLiveButton.hidden == NO) {
                [_constraintsList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_backToLiveButton]-0-[_airPlayView]-0-[_shareButton]-0-|"
                                                                                              options:0
                                                                                              metrics:nil
                                                                                                views:_subViewsDictionary]];
            }   
        } else {
            if (_airPlayView.hidden == YES && _backToLiveButton.hidden == YES) {
                [_constraintsList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_bufferButton]-0-[_shareButton]-0-|"
                                                                                              options:0
                                                                                              metrics:nil
                                                                                                views:_subViewsDictionary]];
            } else if (_airPlayView.hidden == YES && _backToLiveButton.hidden == NO) {
                [_constraintsList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_bufferButton]-28-[_backToLiveButton]-0-[_shareButton]-0-|"
                                                                                              options:0
                                                                                              metrics:nil
                                                                                                views:_subViewsDictionary]];
            } else if (_airPlayView.hidden == NO && _backToLiveButton.hidden == YES) {
                [_constraintsList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_bufferButton]-0-[_airPlayView]-0-[_shareButton]-0-|"
                                                                                              options:0
                                                                                              metrics:nil
                                                                                                views:_subViewsDictionary]];
            } else if (_airPlayView.hidden == NO && _backToLiveButton.hidden == NO) {
                [_constraintsList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_bufferButton]-28-[_backToLiveButton]-0-[_airPlayView]-0-[_shareButton]-0-|"
                                                                                              options:0
                                                                                              metrics:nil
                                                                                                views:_subViewsDictionary]];
            }
        }
    }
    [self addConstraints:_constraintsList];
}


- (void)addSubViewsHConstraints {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        if (_streamListButton.hidden == YES) {
            if (_bufferButton.hidden == YES) {
                if (_airPlayView.hidden == YES && _excerptsButton.hidden == NO) {
                    [_constraintsList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-titleLabelLeft-[_titleLabel]-titleLabelRight-[_excerptsButton(buttonWidth)]-10-[_shareButton(buttonWidth)]-shareButtonRight-|"
                                                                                                  options:0
                                                                                                  metrics:_metrics
                                                                                                    views:_subViewsDictionary]];
                } else if (_airPlayView.hidden == NO && _excerptsButton.hidden == NO){
                    [_constraintsList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-titleLabelLeft-[_titleLabel]-titleLabelRight-[_excerptsButton(buttonWidth)]-14-[_airPlayView(buttonWidth)]-0-[_shareButton(buttonWidth)]-shareButtonRight-|"
                                                                                                  options:0
                                                                                                  metrics:_metrics
                                                                                                    views:_subViewsDictionary]];
                } else if (_airPlayView.hidden == YES && _excerptsButton.hidden == YES) {
                    [_constraintsList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-titleLabelLeft-[_titleLabel]-10-[_shareButton(buttonWidth)]-shareButtonRight-|"
                                                                                                  options:0
                                                                                                  metrics:_metrics
                                                                                                    views:_subViewsDictionary]];
                } else if (_airPlayView.hidden == NO && _excerptsButton.hidden == YES) {
                    [_constraintsList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-titleLabelLeft-[_titleLabel]-14-[_airPlayView(buttonWidth)]-0-[_shareButton(buttonWidth)]-shareButtonRight-|"
                                                                                                  options:0
                                                                                                  metrics:_metrics
                                                                                                    views:_subViewsDictionary]];
                }
            } else {
                if (_airPlayView.hidden == YES && _excerptsButton.hidden == NO) {
                    [_constraintsList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-titleLabelLeft-[_titleLabel]-titleLabelRight-[_bufferButton(bufferbuttonWidth)]-buttonRight-[_excerptsButton(buttonWidth)]-10-[_shareButton(buttonWidth)]-shareButtonRight-|"
                                                                                                  options:0
                                                                                                  metrics:_metrics
                                                                                                    views:_subViewsDictionary]];
                } else if (_airPlayView.hidden == NO && _excerptsButton.hidden == NO){
                    [_constraintsList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-titleLabelLeft-[_titleLabel]-titleLabelRight-[_bufferButton(bufferbuttonWidth)]-buttonRight-[_excerptsButton(buttonWidth)]-14-[_airPlayView(buttonWidth)]-0-[_shareButton(buttonWidth)]-shareButtonRight-|"
                                                                                                  options:0
                                                                                                  metrics:_metrics
                                                                                                    views:_subViewsDictionary]];
                } else if (_airPlayView.hidden == YES && _excerptsButton.hidden == YES) {
                    [_constraintsList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-titleLabelLeft-[_titleLabel]-titleLabelRight-[_bufferButton(bufferbuttonWidth)]-10-[_shareButton(buttonWidth)]-shareButtonRight-|"
                                                                                                  options:0
                                                                                                  metrics:_metrics
                                                                                                    views:_subViewsDictionary]];
                } else if (_airPlayView.hidden == NO && _excerptsButton.hidden == YES) {
                    [_constraintsList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-titleLabelLeft-[_titleLabel]-titleLabelRight-[_bufferButton(bufferbuttonWidth)]-14-[_airPlayView(buttonWidth)]-0-[_shareButton(buttonWidth)]-shareButtonRight-|"
                                                                                                  options:0
                                                                                                  metrics:_metrics
                                                                                                    views:_subViewsDictionary]];
                }
            }
        } else {
            if (_bufferButton.hidden == YES) {
                if (_airPlayView.hidden == YES && _excerptsButton.hidden == NO) {
                    [_constraintsList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-titleLabelLeft-[_titleLabel]-titleLabelRight-[_excerptsButton(buttonWidth)]-buttonRight-[_streamListButton(buttonWidth)]-10-[_shareButton(buttonWidth)]-shareButtonRight-|"
                                                                                                  options:0
                                                                                                  metrics:_metrics
                                                                                                    views:_subViewsDictionary]];
                } else if (_airPlayView.hidden == NO && _excerptsButton.hidden == NO){
                    [_constraintsList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-titleLabelLeft-[_titleLabel]-titleLabelRight-[_excerptsButton(buttonWidth)]-buttonRight-[_streamListButton(buttonWidth)]-14-[_airPlayView(buttonWidth)]-0-[_shareButton(buttonWidth)]-shareButtonRight-|"
                                                                                                  options:0
                                                                                                  metrics:_metrics
                                                                                                    views:_subViewsDictionary]];
                } else if (_airPlayView.hidden == YES && _excerptsButton.hidden == YES) {
                    [_constraintsList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-titleLabelLeft-[_titleLabel]-titleLabelRight-[_streamListButton(buttonWidth)]-10-[_shareButton(buttonWidth)]-shareButtonRight-|"
                                                                                                  options:0
                                                                                                  metrics:_metrics
                                                                                                    views:_subViewsDictionary]];
                } else if (_airPlayView.hidden == NO && _excerptsButton.hidden == YES) {
                    [_constraintsList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-titleLabelLeft-[_titleLabel]-titleLabelRight-[_streamListButton(buttonWidth)]-14-[_airPlayView(buttonWidth)]-0-[_shareButton(buttonWidth)]-shareButtonRight-|"
                                                                                                  options:0
                                                                                                  metrics:_metrics
                                                                                                    views:_subViewsDictionary]];
                }
            } else {
                if (_airPlayView.hidden == YES && _excerptsButton.hidden == NO) {
                    [_constraintsList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-titleLabelLeft-[_titleLabel]-titleLabelRight-[_bufferButton(bufferbuttonWidth)]-buttonRight-[_excerptsButton(buttonWidth)]-buttonRight-[_streamListButton(buttonWidth)]-10-[_shareButton(buttonWidth)]-shareButtonRight-|"
                                                                                                  options:0
                                                                                                  metrics:_metrics
                                                                                                    views:_subViewsDictionary]];
                } else if (_airPlayView.hidden == NO && _excerptsButton.hidden == NO){
                    [_constraintsList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-titleLabelLeft-[_titleLabel]-titleLabelRight-[_bufferButton(bufferbuttonWidth)]-buttonRight-[_excerptsButton(buttonWidth)]-buttonRight-[_streamListButton(buttonWidth)]-14-[_airPlayView(buttonWidth)]-0-[_shareButton(buttonWidth)]-shareButtonRight-|"
                                                                                                  options:0
                                                                                                  metrics:_metrics
                                                                                                    views:_subViewsDictionary]];
                } else if (_airPlayView.hidden == YES && _excerptsButton.hidden == YES) {
                    [_constraintsList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-titleLabelLeft-[_titleLabel]-titleLabelRight-[_bufferButton(bufferbuttonWidth)]-buttonRight-[_streamListButton(buttonWidth)]-10-[_shareButton(buttonWidth)]-shareButtonRight-|"
                                                                                                  options:0
                                                                                                  metrics:_metrics
                                                                                                    views:_subViewsDictionary]];
                } else if (_airPlayView.hidden == NO && _excerptsButton.hidden == YES) {
                    [_constraintsList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-titleLabelLeft-[_titleLabel]-titleLabelRight-[_bufferButton(bufferbuttonWidth)]-buttonRight-[_streamListButton(buttonWidth)]-14-[_airPlayView(buttonWidth)]-0-[_shareButton(buttonWidth)]-shareButtonRight-|"
                                                                                                  options:0
                                                                                                  metrics:_metrics
                                                                                                    views:_subViewsDictionary]];
                }
            }
        }
    } else {
        _shareButton.hidden = YES;
        if (_streamListButton.hidden == YES) {
            if (_bufferButton.hidden == YES) {
                if (_airPlayView.hidden == YES && _excerptsButton.hidden == NO) {
                    [_constraintsList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-titleLabelLeft-[_titleLabel]-titleLabelRight-[_excerptsButton(buttonWidth)]-shareButtonRight-|"
                                                                                                  options:0
                                                                                                  metrics:_metrics
                                                                                                    views:_subViewsDictionary]];
                } else if (_airPlayView.hidden == NO && _excerptsButton.hidden == NO){
                    [_constraintsList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-titleLabelLeft-[_titleLabel]-titleLabelRight-[_excerptsButton(buttonWidth)]-14-[_airPlayView(buttonWidth)]-shareButtonRight-|"
                                                                                                  options:0
                                                                                                  metrics:_metrics
                                                                                                    views:_subViewsDictionary]];
                } else if (_airPlayView.hidden == YES && _excerptsButton.hidden == YES) {
                    [_constraintsList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-titleLabelLeft-[_titleLabel]-shareButtonRight-|"
                                                                                                  options:0
                                                                                                  metrics:_metrics
                                                                                                    views:_subViewsDictionary]];
                } else if (_airPlayView.hidden == NO && _excerptsButton.hidden == YES) {
                    [_constraintsList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-titleLabelLeft-[_titleLabel]-14-[_airPlayView(buttonWidth)]-shareButtonRight-|"
                                                                                                  options:0
                                                                                                  metrics:_metrics
                                                                                                    views:_subViewsDictionary]];
                }
            } else {
                if (_airPlayView.hidden == YES && _excerptsButton.hidden == NO) {
                    [_constraintsList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-titleLabelLeft-[_titleLabel]-titleLabelRight-[_bufferButton(bufferbuttonWidth)]-buttonRight-[_excerptsButton(buttonWidth)]-shareButtonRight-|"
                                                                                                  options:0
                                                                                                  metrics:_metrics
                                                                                                    views:_subViewsDictionary]];
                } else if (_airPlayView.hidden == NO && _excerptsButton.hidden == NO){
                    [_constraintsList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-titleLabelLeft-[_titleLabel]-titleLabelRight-[_bufferButton(bufferbuttonWidth)]-buttonRight-[_excerptsButton(buttonWidth)]-14-[_airPlayView(buttonWidth)]-shareButtonRight-|"
                                                                                                  options:0
                                                                                                  metrics:_metrics
                                                                                                    views:_subViewsDictionary]];
                } else if (_airPlayView.hidden == YES && _excerptsButton.hidden == YES) {
                    [_constraintsList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-titleLabelLeft-[_titleLabel]-titleLabelRight-[_bufferButton(bufferbuttonWidth)]-shareButtonRight-|"
                                                                                                  options:0
                                                                                                  metrics:_metrics
                                                                                                    views:_subViewsDictionary]];
                } else if (_airPlayView.hidden == NO && _excerptsButton.hidden == YES) {
                    [_constraintsList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-titleLabelLeft-[_titleLabel]-titleLabelRight-[_bufferButton(bufferbuttonWidth)]-14-[_airPlayView(buttonWidth)]-shareButtonRight-|"
                                                                                                  options:0
                                                                                                  metrics:_metrics
                                                                                                    views:_subViewsDictionary]];
                }
            }
        } else {
            if (_bufferButton.hidden == YES) {
                if (_airPlayView.hidden == YES && _excerptsButton.hidden == NO) {
                    [_constraintsList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-titleLabelLeft-[_titleLabel]-titleLabelRight-[_excerptsButton(buttonWidth)]-buttonRight-[_streamListButton(buttonWidth)]-shareButtonRight-|"
                                                                                                  options:0
                                                                                                  metrics:_metrics
                                                                                                    views:_subViewsDictionary]];
                } else if (_airPlayView.hidden == NO && _excerptsButton.hidden == NO){
                    [_constraintsList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-titleLabelLeft-[_titleLabel]-titleLabelRight-[_excerptsButton(buttonWidth)]-buttonRight-[_streamListButton(buttonWidth)]-14-[_airPlayView(buttonWidth)]-shareButtonRight-|"
                                                                                                  options:0
                                                                                                  metrics:_metrics
                                                                                                    views:_subViewsDictionary]];
                } else if (_airPlayView.hidden == YES && _excerptsButton.hidden == YES) {
                    [_constraintsList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-titleLabelLeft-[_titleLabel]-titleLabelRight-[_streamListButton(buttonWidth)]-shareButtonRight-|"
                                                                                                  options:0
                                                                                                  metrics:_metrics
                                                                                                    views:_subViewsDictionary]];
                } else if (_airPlayView.hidden == NO && _excerptsButton.hidden == YES) {
                    [_constraintsList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-titleLabelLeft-[_titleLabel]-titleLabelRight-[_streamListButton(buttonWidth)]-14-[_airPlayView(buttonWidth)]-shareButtonRight-|"
                                                                                                  options:0
                                                                                                  metrics:_metrics
                                                                                                    views:_subViewsDictionary]];
                }
            } else {
                if (_airPlayView.hidden == YES && _excerptsButton.hidden == NO) {
                    [_constraintsList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-titleLabelLeft-[_titleLabel]-titleLabelRight-[_bufferButton(bufferbuttonWidth)]-buttonRight-[_excerptsButton(buttonWidth)]-buttonRight-[_streamListButton(buttonWidth)]-shareButtonRight-|"
                                                                                                  options:0
                                                                                                  metrics:_metrics
                                                                                                    views:_subViewsDictionary]];
                } else if (_airPlayView.hidden == NO && _excerptsButton.hidden == NO){
                    [_constraintsList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-titleLabelLeft-[_titleLabel]-titleLabelRight-[_bufferButton(bufferbuttonWidth)]-buttonRight-[_excerptsButton(buttonWidth)]-buttonRight-[_streamListButton(buttonWidth)]-14-[_airPlayView(buttonWidth)]-shareButtonRight-|"
                                                                                                  options:0
                                                                                                  metrics:_metrics
                                                                                                    views:_subViewsDictionary]];
                } else if (_airPlayView.hidden == YES && _excerptsButton.hidden == YES) {
                    [_constraintsList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-titleLabelLeft-[_titleLabel]-titleLabelRight-[_bufferButton(bufferbuttonWidth)]-buttonRight-[_streamListButton(buttonWidth)]-shareButtonRight-|"
                                                                                                  options:0
                                                                                                  metrics:_metrics
                                                                                                    views:_subViewsDictionary]];
                } else if (_airPlayView.hidden == NO && _excerptsButton.hidden == YES) {
                    [_constraintsList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-titleLabelLeft-[_titleLabel]-titleLabelRight-[_bufferButton(bufferbuttonWidth)]-buttonRight-[_streamListButton(buttonWidth)]-14-[_airPlayView(buttonWidth)]-shareButtonRight-|"
                                                                                                  options:0
                                                                                                  metrics:_metrics
                                                                                                    views:_subViewsDictionary]];
                }
            }
        }
    }
}

- (void)addSubViewsVConstraints {
    [_constraintsList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_titleLabel]-titleLabelBottom-|"
                                                                                 options:0
                                                                                 metrics:_metrics
                                                                                    views:_subViewsDictionary]];
    
    [_constraintsList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_airPlayView(buttonHeight)]-buttonBottom-|"
                                                                                  options:0
                                                                                  metrics:_metrics
                                                                                    views:_subViewsDictionary]];
    
    [_constraintsList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_excerptsButton(buttonHeight)]-buttonBottom-|"
                                                                                  options:0
                                                                                  metrics:_metrics
                                                                                    views:_subViewsDictionary]];
    
    [_constraintsList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_bufferButton(buttonHeight)]-buttonBottom-|"
                                                                                  options:0
                                                                                  metrics:_metrics
                                                                                    views:_subViewsDictionary]];
    
    [_constraintsList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_streamListButton(buttonHeight)]-buttonBottom-|"
                                                                                  options:0
                                                                                  metrics:_metrics
                                                                                    views:_subViewsDictionary]];
    
    [_constraintsList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_shareButton(buttonHeight)]-buttonBottom-|"
                                                                                  options:0
                                                                                  metrics:_metrics
                                                                                    views:_subViewsDictionary]];
}

-(void)streamListButtonAction:(UIButton *)button{
    if (_delegate && [_delegate respondsToSelector:@selector(playerCaptionControlPanel:didTapOnStreamListButton:)]) {
        [_delegate playerCaptionControlPanel:self didTapOnStreamListButton:self.streamListButton];
    }
}

- (void)backToLiveButtonAction:(UIButton *)button {
    if (_delegate && [_delegate respondsToSelector:@selector(playerCaptionControlPanel:didTapOnBackToLiveButton:)]) {
        [_delegate playerCaptionControlPanel:self didTapOnBackToLiveButton:self.backToLiveButton];
    }
}

-(void)excerptsButtonAction:(UIButton *)button{
    if (_delegate && [_delegate respondsToSelector:@selector(playerCaptionControlPanel:didTapOnExcerptsButton:)]) {
        [_delegate playerCaptionControlPanel:self didTapOnExcerptsButton:self.excerptsButton];
    }
}
-(void)shareButtonAction:(UIButton *)button{
    if (_delegate && [_delegate respondsToSelector:@selector(playerCaptionControlPanel:didTapOnShareButton:)]) {
        [_delegate playerCaptionControlPanel:self didTapOnShareButton:self.shareButton];
    }
}
- (void)bufferButtonAction:(UIButton *)button {
    if (_delegate && [_delegate respondsToSelector:@selector(playerCaptionControlPanel:didTapOnBufferButton:)]) {
        [_delegate playerCaptionControlPanel:self didTapOnBufferButton:self.bufferButton];
    }
}

#pragma mark - AJMediaAirPlayViewDelegate

- (void)didBrowserAvailableAirplayDevices:(BOOL)isDetected {
    if (isDetected) {
        if (_airPlayView.hidden == YES) {
            _airPlayView.hidden = NO;
            [self setNeedsUpdateConstraints];
            [self updateConstraintsIfNeeded];
        }
    } else {
        if (_airPlayView.hidden == NO) {
            _airPlayView.hidden = YES;
            [self setNeedsUpdateConstraints];
            [self updateConstraintsIfNeeded];
        }
    }
    if (_delegate && [_delegate respondsToSelector:@selector(playerCaptionControlPanel:airPlayIsDetected:)]) {
        [_delegate playerCaptionControlPanel:self airPlayIsDetected:isDetected];
    }
}

@end
