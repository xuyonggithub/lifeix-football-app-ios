//
//  AJMediaPlayerPlaybackControlPanel.m
//  AJMediaPlayerShowcase
//
//  Created by Gang Li on 5/23/15.
//  Copyright (c) 2015 LeTV Sports Culture Develop (Beijing) Co., Ltd. All rights reserved.
//

#import "AJMediaPlayerPlaybackControlPanel.h"
#import "AJMediaPlayerUtilities.h"
#import <MediaPlayer/MediaPlayer.h>
#import "AJMediaPlayerSlider.h"
#define AJPlaybackButtonWidth 40.f
#define AJPlaybackButtonHeight 40.f
#define PlayBackControlPanelLargeFont [UIFont fontWithName:@"Helvetica" size:12]
#define PlayBackControlPanelMediumFont [UIFont fontWithName:@"Helvetica" size:9]
#define PlayBackControlPanelSmallFont [UIFont fontWithName:@"Helvetica" size:7]

@interface AJMediaPlayerPlaybackControlPanel()
{
    
    NSTimeInterval _duration;
    NSTimeInterval _playTime;
    NSTimeInterval _availableTime;
    BOOL _sliderValueChanged;
}
@property (nonatomic, assign) AJMediaPlayerAppearenceStyle appearenceStyle;

@property (nonatomic, strong) NSDictionary *subViewsDictionary;

@property (nonatomic, strong) NSMutableArray *constraintList;

@property (nonatomic, assign) BOOL isPlay;

@end

@implementation AJMediaPlayerPlaybackControlPanel

#pragma mark - Init Method

- (instancetype)initWithAppearenceStyle:(AJMediaPlayerAppearenceStyle )appearenceStyle {
    if (self = [super init]) {
        _appearenceStyle = appearenceStyle;
        
        self.isPlay = NO;
        _isLiveModel = YES;
        _isSupportTimeShift = NO;
        _isSupportChatroom = NO;
        _sliderValueChanged = NO;
        _seekTime = 0;
        _timeshiftPosition = 0;
        self.translatesAutoresizingMaskIntoConstraints = NO;
        
        self.constraintList = [NSMutableArray array];
        [self addBackGroundView];
        [self addPlayOrPauseButton];
        [self addAvailableProgressScubber];
        [self addProgressScubber];
        [self addPresentationSelectionButton];
        [self addStartTimeLable];
        [self addDurationLabel];
        [self addVolumeControlButton];
        [self addTimeShiftProgressScubber];
        [self addTimeShiftStartTimeLabel];
        [self addTimeShiftTotalTimeLabel];
        [self addChatroomSwitch];
        
        if (_appearenceStyle == AJMediaPlayerStyleForiPhone) {
            self.subViewsDictionary = NSDictionaryOfVariableBindings(_backGroundImageView,_playOrPauseButton,_progressScubber,_availableProgressScubber,_presentationSelectionButton,_startTimeLabel,_totalDurationLabel,_volumenControlButton,_timeShiftProgressScubber,_timeShiftStartTimeLabel,_timeShiftTotalTimeLabel,_chatroomSwitch);
        } else if (_appearenceStyle == AJMediaPlayerStyleForiPad) {
            [self addExcerptsHDButton];
            [self addStreamListHDButton];
            self.subViewsDictionary = NSDictionaryOfVariableBindings(_backGroundImageView,_playOrPauseButton,_progressScubber,_availableProgressScubber,_presentationSelectionButton,_startTimeLabel,_totalDurationLabel,_volumenControlButton,_timeShiftProgressScubber,_timeShiftStartTimeLabel,_timeShiftTotalTimeLabel,_streamListHDButton,_excerptsHDButton,_chatroomSwitch);
        }
    }
    return self;
}

- (void)addBackGroundView {
    self.backGroundImageView = [[UIImageView alloc] init];
    _backGroundImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_backGroundImageView];
}

- (void)addPlayOrPauseButton {
    self.playOrPauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _playOrPauseButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_playOrPauseButton setContentMode:UIViewContentModeCenter];
    
    NSString *playerPlayName = _appearenceStyle==AJMediaPlayerStyleForiPhone?@"player_bt_play":@"player_bt_play_ipad";
    NSString *playerPlayPressName = _appearenceStyle==AJMediaPlayerStyleForiPhone?@"player_bt_play_press":@"player_bt_play_press_ipad";
    _playOrPauseButton.enabled = NO;
    [_playOrPauseButton setImage:[UIImage imageNamed:playerPlayName] forState:UIControlStateNormal];
    [_playOrPauseButton setImage:[UIImage imageNamed:playerPlayPressName] forState:UIControlStateHighlighted];
    [_playOrPauseButton addTarget:self action:@selector(didTapOnPlayOrPause:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_playOrPauseButton];
}

- (void)addProgressScubber {
    if (_appearenceStyle == AJMediaPlayerStyleForiPad) {
        self.progressScubber = [[AJMediaPlayerSlider alloc] init];
    } else {
        self.progressScubber = [[UISlider alloc] init];
    }
    _progressScubber.translatesAutoresizingMaskIntoConstraints = NO;
    _progressScubber.maximumValue = 1;
    _progressScubber.minimumValue = 0;
    _progressScubber.value = 0;
    _progressScubber.continuous = YES;
    _progressScubber.enabled = NO;
    _progressScubber.maximumTrackTintColor = [UIColor clearColor];
    _progressScubber.minimumTrackTintColor = [UIColor colorWithHTMLColorMark:@"#29c4c6"];
    [_progressScubber addTarget:self action:@selector(sliderTouchUp:) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside|UIControlEventTouchCancel];
    [_progressScubber addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    [_progressScubber setThumbImage:[UIImage imageWithColor:[UIColor clearColor]] forState:UIControlStateDisabled];
    [_progressScubber setThumbImage:[UIImage imageNamed:@"player_ic_point"] forState:UIControlStateNormal];
    [self addSubview:_progressScubber];
}

- (void)addAvailableProgressScubber {
    if (_appearenceStyle == AJMediaPlayerStyleForiPad) {
        self.availableProgressScubber = [[AJMediaPlayerSlider alloc] init];
    } else {
        self.availableProgressScubber = [[UISlider alloc] init];
    }
    _availableProgressScubber.translatesAutoresizingMaskIntoConstraints = NO;
    _availableProgressScubber.maximumValue = 1;
    _availableProgressScubber.minimumValue = 0;
    _availableProgressScubber.value = 0;
    _availableProgressScubber.continuous = YES;
    _availableProgressScubber.enabled  = NO;
    _availableProgressScubber.maximumTrackTintColor = [UIColor colorWithHTMLColorMark:@"#b5b5b5" alpha:0.6];
    _availableProgressScubber.minimumTrackTintColor = [UIColor colorWithHTMLColorMark:@"#efeff4"];
    [_availableProgressScubber setThumbImage:[UIImage imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
    [self addSubview:_availableProgressScubber];
}

- (void)addPresentationSelectionButton {
    self.presentationSelectionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _presentationSelectionButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_presentationSelectionButton setImage:[UIImage imageNamed:@"find_ic_full-screen_nor"] forState:UIControlStateNormal];
    [_presentationSelectionButton setImage:[UIImage imageNamed:@"find_ic_full-screen_press"] forState:UIControlStateHighlighted];
    [_presentationSelectionButton addTarget:self action:@selector(changeFullScreenAction:)
                           forControlEvents:UIControlEventTouchUpInside];
    [_presentationSelectionButton setContentMode:UIViewContentModeCenter];
    [self addSubview:_presentationSelectionButton];
}

- (void)addStartTimeLable {
    self.startTimeLabel = [[UILabel alloc] init];
    _startTimeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _startTimeLabel.font= PlayBackControlPanelLargeFont;
    _startTimeLabel.textColor = [UIColor colorWithHTMLColorMark:@"ffffff"];
    _startTimeLabel.textAlignment = NSTextAlignmentLeft;
    _startTimeLabel.text = @"00:00";
    [self addSubview:_startTimeLabel];
}

- (void)addDurationLabel {
    self.totalDurationLabel = [[UILabel alloc] init];
    _totalDurationLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _totalDurationLabel.font= PlayBackControlPanelLargeFont;
    _totalDurationLabel.textColor = [UIColor colorWithHTMLColorMark:@"ffffff"];
    _totalDurationLabel.textAlignment = NSTextAlignmentRight;
    _totalDurationLabel.text = @"00:00";
    [self addSubview:_totalDurationLabel];
}

- (void)addTimeShiftProgressScubber {
    if (_appearenceStyle == AJMediaPlayerStyleForiPad) {
        self.timeShiftProgressScubber = [[AJMediaPlayerSlider alloc] init];
    } else {
        self.timeShiftProgressScubber = [[UISlider alloc] init];
    }
    _timeShiftProgressScubber.translatesAutoresizingMaskIntoConstraints = NO;
    _timeShiftProgressScubber.maximumValue = 1;
    _timeShiftProgressScubber.minimumValue = 0;
    _timeShiftProgressScubber.value = 0;
    _timeShiftProgressScubber.continuous = YES;
    _timeShiftProgressScubber.enabled  = NO;
    _timeShiftProgressScubber.hidden = YES;
    _timeShiftProgressScubber.maximumTrackTintColor = [UIColor colorWithHTMLColorMark:@"#b5b5b5" alpha:0.6];
    _timeShiftProgressScubber.minimumTrackTintColor = [UIColor colorWithHTMLColorMark:@"#29c4c6"];
    [_timeShiftProgressScubber addTarget:self action:@selector(sliderTouchUp:) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside|UIControlEventTouchCancel];
    [_timeShiftProgressScubber addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [_timeShiftProgressScubber setThumbImage:[UIImage imageWithColor:[UIColor clearColor]] forState:UIControlStateDisabled];
    [_timeShiftProgressScubber setThumbImage:[UIImage imageNamed:@"player_ic_point"] forState:UIControlStateNormal];
    [self addSubview:_timeShiftProgressScubber];
}

- (void)addTimeShiftStartTimeLabel {
    self.timeShiftStartTimeLabel = [[UILabel alloc] init];
    _timeShiftStartTimeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _timeShiftStartTimeLabel.font= PlayBackControlPanelLargeFont;
    _timeShiftStartTimeLabel.textColor = [UIColor colorWithHTMLColorMark:@"ffffff"];
    _timeShiftStartTimeLabel.textAlignment = NSTextAlignmentLeft;
    _timeShiftStartTimeLabel.text = @"00:00";
    _timeShiftStartTimeLabel.hidden = YES;
    [self addSubview:_timeShiftStartTimeLabel];
}

- (void)addTimeShiftTotalTimeLabel {
    self.timeShiftTotalTimeLabel = [[UILabel alloc] init];
    _timeShiftTotalTimeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _timeShiftTotalTimeLabel.font= PlayBackControlPanelLargeFont;
    _timeShiftTotalTimeLabel.textColor = [UIColor colorWithHTMLColorMark:@"ffffff"];
    _timeShiftTotalTimeLabel.textAlignment = NSTextAlignmentLeft;
    _timeShiftTotalTimeLabel.text = @"00:00";
    _timeShiftTotalTimeLabel.hidden = YES;
    [self addSubview:_timeShiftTotalTimeLabel];
}

- (void)addChatroomSwitch {
    self.chatroomSwitch = [[UIButton alloc] init];
    _chatroomSwitch.translatesAutoresizingMaskIntoConstraints = NO;
    _chatroomSwitch.selected = YES;
    NSString *chatroomSwitchName = _appearenceStyle == AJMediaPlayerStyleForiPhone ? @"bullet_close_ic":@"chatroomSwitchForPad_normal";
    NSString *chatroomSwitchNamePress = _appearenceStyle == AJMediaPlayerStyleForiPhone ? @"bullet_open_ic":@"chatroomSwitchForPad_press";

    [_chatroomSwitch setBackgroundImage:[UIImage imageNamed:chatroomSwitchName] forState:UIControlStateNormal];
    [_chatroomSwitch setBackgroundImage:[UIImage imageNamed:chatroomSwitchNamePress] forState:UIControlStateSelected];
    [_chatroomSwitch setBackgroundImage:[UIImage imageNamed:chatroomSwitchNamePress] forState:UIControlStateHighlighted];
    _chatroomSwitch.hidden = YES;
    [_chatroomSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_chatroomSwitch];
}

- (void)switchAction:(id)sender {
    UIButton *switchButton = (UIButton *)sender;
    [switchButton setSelected:!switchButton.isSelected];
    if (_delegate && [_delegate respondsToSelector:@selector(playbackControl:didChangeSwitchValue:)]) {
        [_delegate playbackControl:self didChangeSwitchValue:switchButton.selected];
    }
}

- (void)addVolumeControlButton {
    self.volumenControlButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_volumenControlButton setContentMode:UIViewContentModeCenter];
    _volumenControlButton.translatesAutoresizingMaskIntoConstraints = NO;
    _volumenControlButton.hidden = YES;
    [_volumenControlButton addTarget:self action:@selector(soundClick) forControlEvents:UIControlEventTouchUpInside];
    [_volumenControlButton setImage:[UIImage imageNamed:@"player_bt_sound"] forState:UIControlStateNormal];
    [self addSubview:_volumenControlButton];
    
    float systemVolume = [self fetchSystemVolume];
    [self updateVolume:systemVolume isHidden:YES];
}

- (void)addExcerptsHDButton {
    self.excerptsHDButton = [AJMediaPlayerButton buttonWithType:UIButtonTypeCustom];
    _excerptsHDButton.layer.cornerRadius = 2;
    _excerptsHDButton.layer.borderWidth = 1;
    _excerptsHDButton.layer.borderColor = [UIColor colorWithHTMLColorMark:@"#ffffff"].CGColor;
    [_excerptsHDButton setTitle:@"相关" forState:UIControlStateNormal];
    _excerptsHDButton.titleLabel.font = PlayBackControlPanelLargeFont;
    _excerptsHDButton.translatesAutoresizingMaskIntoConstraints = NO;
    _excerptsHDButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [_excerptsHDButton setTitleColor:[UIColor colorWithHTMLColorMark:@"#29c4c6"] forState:UIControlStateHighlighted];
    [_excerptsHDButton addTarget:self action:@selector(excerptsHDButtonAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)addStreamListHDButton {
    self.streamListHDButton = [AJMediaPlayerButton buttonWithType:UIButtonTypeCustom];
    _streamListHDButton.layer.cornerRadius = 2;
    _streamListHDButton.layer.borderWidth = 1;
    _streamListHDButton.layer.borderColor = [UIColor colorWithHTMLColorMark:@"#ffffff"].CGColor;
    [_streamListHDButton setTitle:@"标清" forState:UIControlStateNormal];
    _streamListHDButton.titleLabel.font = PlayBackControlPanelLargeFont;
    _streamListHDButton.translatesAutoresizingMaskIntoConstraints = NO;
    _streamListHDButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [_streamListHDButton setTitleColor:[UIColor colorWithHTMLColorMark:@"#29c4c6"] forState:UIControlStateHighlighted];
    [_streamListHDButton addTarget:self action:@selector(streamListHDButtonAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)excerptsHDButtonAction:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(playbackControlPanel:didTapOnExcerptsHDButton:)]) {
        [_delegate playbackControlPanel:self didTapOnExcerptsHDButton:sender];
    }
}

- (void)streamListHDButtonAction:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(playbackControlPanel:didTapOnStreamListHDButton:)]) {
        [_delegate playbackControlPanel:self didTapOnStreamListHDButton:sender];
    }
}

- (float)fetchSystemVolume{
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Wdeprecated-declarations"
        return [MPMusicPlayerController iPodMusicPlayer].volume;
    #pragma clang diagnostic pop
}

- (void)setIsLiveModel:(BOOL)isLiveModel {
    _isLiveModel = isLiveModel;
}

- (void)setIsSupportTimeShift:(BOOL)isSupportTimeShift {
    _isSupportTimeShift = isSupportTimeShift;
}

#pragma mark - AJMediaGesture Action

- (void)updateDuration:(double)duration pendingTime:(double)pendingTime {
    _sliderValueChanged = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        _progressScubber.value = pendingTime/duration;
        if (duration >= 3600) {
            _startTimeLabel.text = [AJMediaPlayerUtilities translateToHHMMSSText:pendingTime];
        } else {
            _startTimeLabel.text = [AJMediaPlayerUtilities translateToMMSSText:pendingTime];
        }
    });
}

- (void)updateTotal:(double)totalTime timeshiftPosition:(double)timeshiftPosition {
    _sliderValueChanged = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        _timeShiftProgressScubber.value = timeshiftPosition/totalTime;
        if (totalTime >= 3600) {
            _timeShiftStartTimeLabel.text = [AJMediaPlayerUtilities translateToHHMMSSText:timeshiftPosition];
        } else {
            _timeShiftStartTimeLabel.text = [AJMediaPlayerUtilities translateToMMSSText:timeshiftPosition];
        }
    });
}

- (void)endPendingTime:(double)pendingTime {
    _sliderValueChanged = NO;
    if (_isPlay == NO) {
        self.isPlay = YES;
    }
    if (_delegate && [_delegate respondsToSelector:@selector(playbackControl:didScrubToPosition:)]) {
        _seekTime = pendingTime;
        [_delegate playbackControl:self didScrubToPosition:(pendingTime/_duration)];
    }
}

- (void)endTimeshift:(double)timeshift {
    _sliderValueChanged = NO;
    if (_isPlay == NO) {
        self.isPlay = YES;
    }
    if (_delegate && [_delegate respondsToSelector:@selector(playbackControl:didTimeShiftToPosition:)]){
        _timeshiftPosition = timeshift;
        [_delegate playbackControl:self didTimeShiftToPosition:timeshift];
    }
}

#pragma mark - Action Method

- (IBAction)didTapOnPlayOrPause:(UIButton *)sender {
    self.isPlay = !self.isPlay;
    SEL expectedSelector = _isPlay ? @selector(playbackControl:didTapPlay:) : @selector(playbackControl:didTapPause:);
    if (_delegate && [_delegate respondsToSelector:expectedSelector]) {
        if (_isPlay) {
            [self.delegate playbackControl:self didTapPlay:sender];
        } else {
            [self.delegate playbackControl:self didTapPause:sender];
        }
    }
}

- (void)updateTimeShiftTime:(double)totalTime {
    if (_sliderValueChanged) {
        return;
    }
    self.totalTime = totalTime;
    _playOrPauseButton.enabled = YES;
    _timeShiftProgressScubber.enabled = YES;
    if (totalTime <= 0) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        _timeShiftProgressScubber.value = (totalTime-_timeshiftPosition)/totalTime;
        if (totalTime >= 3600) {
            _timeShiftStartTimeLabel.text = [AJMediaPlayerUtilities translateToHHMMSSText:totalTime-_timeshiftPosition];
            _timeShiftTotalTimeLabel.text = [AJMediaPlayerUtilities translateToHHMMSSText:totalTime];
        } else {
            _timeShiftStartTimeLabel.text = [AJMediaPlayerUtilities translateToMMSSText:totalTime-_timeshiftPosition];
            _timeShiftTotalTimeLabel.text = [AJMediaPlayerUtilities translateToMMSSText:totalTime];
        }
    });
}

- (void)updateDuration:(double)duration currentPlayTime:(double)playTime availableTime:(double)availableTime{
    if (_sliderValueChanged) {
        return;
    }
    _duration = duration;
    _playTime = playTime;
    _availableTime = availableTime;
    _playOrPauseButton.enabled = YES;
    _progressScubber.enabled = YES;
    if (_duration <= 0) {
        return;
    }
    if (_seekTime != 0) {
        _playTime = _seekTime;
    }
    _seekTime = 0;
    dispatch_async(dispatch_get_main_queue(), ^{
        _availableProgressScubber.value = _availableTime/_duration;
        _progressScubber.value = _playTime/_duration;
        _position = _playTime/_duration;
        if (_duration >= 3600) {
            _startTimeLabel.text = [AJMediaPlayerUtilities translateToHHMMSSText:_playTime];
            _totalDurationLabel.text = [AJMediaPlayerUtilities translateToHHMMSSText:_duration];
        } else {
            _startTimeLabel.text = [AJMediaPlayerUtilities translateToMMSSText:_playTime];
            _totalDurationLabel.text = [AJMediaPlayerUtilities translateToMMSSText:_duration];
        }
    });
}

- (void)updatePlayState:(BOOL)play {
    self.isPlay = play;
}

- (void)changeFullScreenAction:(UIButton *)btn {
    _isFullScreen = YES;
    if (_delegate && [_delegate respondsToSelector:@selector(playbackControl:didSelectPresentationMode:)]) {
        AJMediaPlayerPresentationMode mode = _isFullScreen ? AJMediaPlayerFullscreenPresentation : AJMediaPlayerEmbeddedPresentation;
        [_delegate playbackControl:self didSelectPresentationMode:mode];
    }
}

- (void)soundClick {
    if (_delegate && [_delegate respondsToSelector:@selector(playbackControl:didTapVolume:)]) {
        [_delegate playbackControl:self didTapVolume:self.volumenControlButton];
    }
}

- (void)updateVolume:(float)value isHidden:(BOOL)isHidden {
    NSString *muteName = _appearenceStyle==AJMediaPlayerStyleForiPhone?@"player_bt_mute":@"player_bt_mute_ipad";
    NSString *sound3Name = _appearenceStyle==AJMediaPlayerStyleForiPhone?@"player_bt_sound3":@"player_bt_sound3_ipad";
    NSString *sound2Name = _appearenceStyle==AJMediaPlayerStyleForiPhone?@"player_bt_sound2":@"player_bt_sound2_ipad";
    NSString *soundName = _appearenceStyle==AJMediaPlayerStyleForiPhone?@"player_bt_sound":@"player_bt_sound_ipad";
    NSString *mutePressName = _appearenceStyle==AJMediaPlayerStyleForiPhone?@"player_bt_mute_press":@"player_bt_mute_press_ipad";
    NSString *sound3PressName = _appearenceStyle==AJMediaPlayerStyleForiPhone?@"player_bt_sound3_press":@"player_bt_sound3_press_ipad";
    NSString *sound2PressName = _appearenceStyle==AJMediaPlayerStyleForiPhone?@"player_bt_sound2_press":@"player_bt_sound2_press_ipad";
    NSString *soundPressName = _appearenceStyle==AJMediaPlayerStyleForiPhone?@"player_bt_sound_press":@"player_bt_sound_press_ipad";
    
    if (isHidden) {
        if (value == 0) {
            [_volumenControlButton setImage:[UIImage imageNamed:muteName] forState:UIControlStateNormal];
        } else if(value < 0.5 && value > 0){
            [_volumenControlButton setImage:[UIImage imageNamed:sound3Name] forState:UIControlStateNormal];
        } else if(value < 1 && value >= 0.5){
            [_volumenControlButton setImage:[UIImage imageNamed:sound2Name] forState:UIControlStateNormal];
        } else if(value  == 1){
            [_volumenControlButton setImage:[UIImage imageNamed:soundName] forState:UIControlStateNormal];
        }
    } else {
        if (value == 0) {
            [_volumenControlButton setImage:[UIImage imageNamed:mutePressName] forState:UIControlStateNormal];
        } else if(value < 0.5 && value > 0){
            [_volumenControlButton setImage:[UIImage imageNamed:sound3PressName] forState:UIControlStateNormal];
        } else if(value < 1 && value >= 0.5){
            [_volumenControlButton setImage:[UIImage imageNamed:sound2PressName] forState:UIControlStateNormal];
        } else if(value == 1){
            [_volumenControlButton setImage:[UIImage imageNamed:soundPressName] forState:UIControlStateNormal];
        }
    }
}

- (void)sliderValueChanged:(UISlider *)slide {
    if (_progressScubber == slide) {
        if (_duration >= 3600) {
            _startTimeLabel.text = [AJMediaPlayerUtilities translateToHHMMSSText:slide.value*_duration];
        } else {
            _startTimeLabel.text = [AJMediaPlayerUtilities translateToMMSSText:slide.value*_duration];
        }
        _sliderValueChanged = YES;
    } else if (_timeShiftProgressScubber == slide) {
        if (_totalTime >= 3600) {
            _timeShiftStartTimeLabel.text = [AJMediaPlayerUtilities translateToHHMMSSText:slide.value*_totalTime];
        } else {
            _timeShiftStartTimeLabel.text = [AJMediaPlayerUtilities translateToMMSSText:slide.value*_totalTime];
        }
        _sliderValueChanged = YES;
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(playbackControlScrubbing:)]) {
        [_delegate playbackControlScrubbing:self];
    }
}

- (void)sliderTouchUp:(UISlider *)slide {
    if (_progressScubber == slide) {
        _sliderValueChanged = NO;
        if (_isPlay == NO) {
            self.isPlay = YES;
        }
        if (_delegate && [_delegate respondsToSelector:@selector(playbackControl:didScrubToPosition:)]){
            _seekTime = slide.value*_duration;
            [_delegate playbackControl:self didScrubToPosition:slide.value];
        }
    } else if (_timeShiftProgressScubber == slide) {
        _sliderValueChanged = NO;
        if (_isPlay == NO) {
            self.isPlay = YES;
        }
        if (_delegate && [_delegate respondsToSelector:@selector(playbackControl:didTimeShiftToPosition:)]) {
            _timeshiftPosition = (1-slide.value)*_totalTime;
            [_delegate playbackControl:self didTimeShiftToPosition:_timeshiftPosition];
        }
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(playbackControlEndScrubbing:)]) {
        [_delegate playbackControlEndScrubbing:self];
    }
}

#pragma mark - Add Constraints Method

- (void)updateConstraints {
    [super updateConstraints];
    [self removeConstraints:_constraintList];
    [_constraintList removeAllObjects];
    if (_isFullScreen) {
        _startTimeLabel.font= PlayBackControlPanelLargeFont;
        _totalDurationLabel.font = PlayBackControlPanelLargeFont;
        _timeShiftStartTimeLabel.font= PlayBackControlPanelLargeFont;
        _timeShiftTotalTimeLabel.font = PlayBackControlPanelLargeFont;
        [self addLandscapeContraints];
    } else {
        UIFont *labelFont = PlayBackControlPanelSmallFont;
        if (_appearenceStyle == AJMediaPlayerStyleForiPad) {
            labelFont = PlayBackControlPanelMediumFont;
        }
        _startTimeLabel.font= labelFont;
        _totalDurationLabel.font = labelFont;
        _timeShiftStartTimeLabel.font= labelFont;
        _timeShiftTotalTimeLabel.font = labelFont;
        [self addPortraitContraints];
    }
}

- (void)resetSubViewsHiddenState {
    if (_isLiveModel) {
        _progressScubber.hidden = YES;
        _availableProgressScubber.hidden = YES;
        _startTimeLabel.hidden = YES;
        _totalDurationLabel.hidden = YES;
    } else {
        _timeShiftProgressScubber.hidden = YES;
        _timeShiftStartTimeLabel.hidden = YES;
        _timeShiftTotalTimeLabel.hidden = YES;
        
        _progressScubber.hidden = NO;
        _availableProgressScubber.hidden = NO;
        _startTimeLabel.hidden = NO;
        _totalDurationLabel.hidden = NO;
    }
    if (_isSupportTimeShift) {
        _timeShiftProgressScubber.hidden = NO;
        _timeShiftStartTimeLabel.hidden = NO;
        _timeShiftTotalTimeLabel.hidden = NO;
    }
}

- (void)addPortraitContraints {
    if (_appearenceStyle == AJMediaPlayerStyleForiPad) {
        [_streamListHDButton removeFromSuperview];
        [_excerptsHDButton removeFromSuperview];
    }
    [self setBackgroundColor:[UIColor clearColor]];
    [_backGroundImageView setBackgroundColor:[UIColor colorWithHTMLColorMark:@"#000000" alpha:0.7]];
    [self resetSubViewsHiddenState];
    _presentationSelectionButton.hidden = NO;
    _volumenControlButton.hidden = YES;
    _backGroundImageView.hidden = NO;
    _chatroomSwitch.hidden = YES;
    
    [_constraintList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_backGroundImageView]-0-|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:_subViewsDictionary]];
    [_constraintList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_backGroundImageView]-0-|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:_subViewsDictionary]];
    
    [_constraintList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_playOrPauseButton(49)]-0-[_startTimeLabel]-6-[_progressScubber]-6-[_totalDurationLabel]-0-[_presentationSelectionButton(49)]-0-|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:_subViewsDictionary]];
    [_constraintList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_playOrPauseButton(49)]-0-[_startTimeLabel]-6-[_availableProgressScubber]-6-[_totalDurationLabel]-0-[_presentationSelectionButton(49)]-0-|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:_subViewsDictionary]];
    [_constraintList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_playOrPauseButton(49)]-0-[_timeShiftStartTimeLabel]-6-[_timeShiftProgressScubber]-6-[_timeShiftTotalTimeLabel]-0-[_presentationSelectionButton(49)]-0-|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:_subViewsDictionary]];
    [_constraintList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_playOrPauseButton]-0-|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:_subViewsDictionary]];
    [_constraintList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_startTimeLabel]-0-|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:_subViewsDictionary]];
    [_constraintList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_totalDurationLabel]-0-|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:_subViewsDictionary]];
    [_constraintList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_progressScubber]-0-|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:_subViewsDictionary]];
    [_constraintList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_presentationSelectionButton]-0-|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:_subViewsDictionary]];
    [_constraintList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_availableProgressScubber]-0-|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:_subViewsDictionary]];
    [_constraintList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_timeShiftProgressScubber]-0-|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:_subViewsDictionary]];
    [_constraintList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_timeShiftStartTimeLabel]-0-|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:_subViewsDictionary]];
    [_constraintList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_timeShiftTotalTimeLabel]-0-|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:_subViewsDictionary]];
    
    [self addConstraints:_constraintList];
}

- (void)addLandscapeContraints {
    if (_appearenceStyle == AJMediaPlayerStyleForiPhone) {
        [self setBackgroundColor:[UIColor colorWithHTMLColorMark:@"#000000" alpha:0.7f]];
    } else if (_appearenceStyle == AJMediaPlayerStyleForiPad) {
        [self setBackgroundColor:[UIColor colorWithHTMLColorMark:@"#222e36" alpha:0.7f]];
        [self addSubview:_streamListHDButton];
        [self addSubview:_excerptsHDButton];
    }
    [_backGroundImageView setBackgroundColor:[UIColor clearColor]];
    [self resetSubViewsHiddenState];
    
    _presentationSelectionButton.hidden = YES;
    _volumenControlButton.hidden = NO;
    _backGroundImageView.hidden = YES;
    [self setUpLanscapeConstraintListWithStyle:_appearenceStyle];
}

- (void)setUpLanscapeConstraintListWithStyle:(AJMediaPlayerAppearenceStyle )appearenceStyle {
    _chatroomSwitch.hidden = !_isSupportChatroom;
    
    [_constraintList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_backGroundImageView]-0-|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:_subViewsDictionary]];
    [_constraintList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_backGroundImageView]-0-|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:_subViewsDictionary]];
    [_constraintList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_playOrPauseButton]-0-|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:_subViewsDictionary]];
    [_constraintList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_startTimeLabel]-0-|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:_subViewsDictionary]];
    [_constraintList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_totalDurationLabel]-0-|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:_subViewsDictionary]];
    [_constraintList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_progressScubber]-0-|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:_subViewsDictionary]];
    [_constraintList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_volumenControlButton]-0-|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:_subViewsDictionary]];
    [_constraintList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_availableProgressScubber]-0-|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:_subViewsDictionary]];
    [_constraintList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_timeShiftProgressScubber]-0-|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:_subViewsDictionary]];
    [_constraintList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_timeShiftStartTimeLabel]-0-|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:_subViewsDictionary]];
    [_constraintList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_timeShiftTotalTimeLabel]-0-|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:_subViewsDictionary]];
    
    if (appearenceStyle == AJMediaPlayerStyleForiPhone) {
        [_constraintList addObject:[NSLayoutConstraint constraintWithItem:_chatroomSwitch
                                                                attribute:NSLayoutAttributeCenterY
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self
                                                                attribute:NSLayoutAttributeCenterY
                                                               multiplier:1
                                                                 constant:0.0f]];
        [_constraintList addObject:[NSLayoutConstraint constraintWithItem:_chatroomSwitch
                                                                attribute:NSLayoutAttributeHeight
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:nil
                                                                attribute:NSLayoutAttributeNotAnAttribute
                                                               multiplier:1
                                                                 constant:23.0f]];
        if (_isSupportChatroom) {
            [_constraintList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_playOrPauseButton(59)]-0-[_startTimeLabel]-18-[_progressScubber]-18-[_totalDurationLabel]-18-[_chatroomSwitch(51)]-0-[_volumenControlButton(59)]-0-|"
                                                                                         options:0
                                                                                         metrics:nil
                                                                                           views:_subViewsDictionary]];
            [_constraintList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_playOrPauseButton(59)]-0-[_startTimeLabel]-18-[_availableProgressScubber]-18-[_totalDurationLabel]-18-[_chatroomSwitch(51)]-0-[_volumenControlButton(59)]-0-|"
                                                                                         options:0
                                                                                         metrics:nil
                                                                                           views:_subViewsDictionary]];
            [_constraintList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_playOrPauseButton(59)]-0-[_timeShiftStartTimeLabel]-18-[_timeShiftProgressScubber]-18-[_timeShiftTotalTimeLabel]-18-[_chatroomSwitch(51)]-0-[_volumenControlButton(59)]-0-|"
                                                                                         options:0
                                                                                         metrics:nil
                                                                                           views:_subViewsDictionary]];
        } else {
            [_constraintList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_playOrPauseButton(59)]-0-[_startTimeLabel]-18-[_progressScubber]-18-[_totalDurationLabel]-0-[_volumenControlButton(59)]-0-|"
                                                                                         options:0
                                                                                         metrics:nil
                                                                                           views:_subViewsDictionary]];
            [_constraintList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_playOrPauseButton(59)]-0-[_startTimeLabel]-18-[_availableProgressScubber]-18-[_totalDurationLabel]-0-[_volumenControlButton(59)]-0-|"
                                                                                         options:0
                                                                                         metrics:nil
                                                                                           views:_subViewsDictionary]];
            [_constraintList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_playOrPauseButton(59)]-0-[_timeShiftStartTimeLabel]-18-[_timeShiftProgressScubber]-18-[_timeShiftTotalTimeLabel]-0-[_volumenControlButton(59)]-0-|"
                                                                                         options:0
                                                                                         metrics:nil
                                                                                           views:_subViewsDictionary]];
        }
    } else if (appearenceStyle == AJMediaPlayerStyleForiPad) {
        [_constraintList addObject:[NSLayoutConstraint constraintWithItem:_chatroomSwitch
                                                                attribute:NSLayoutAttributeCenterY
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self
                                                                attribute:NSLayoutAttributeCenterY
                                                               multiplier:1
                                                                 constant:0.0f]];
        [_constraintList addObject:[NSLayoutConstraint constraintWithItem:_chatroomSwitch
                                                                attribute:NSLayoutAttributeHeight
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:nil
                                                                attribute:NSLayoutAttributeNotAnAttribute
                                                               multiplier:1
                                                                 constant:27.0f]];
        [_constraintList addObject:[NSLayoutConstraint constraintWithItem:_excerptsHDButton
                                                                attribute:NSLayoutAttributeHeight
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:nil
                                                                attribute:NSLayoutAttributeNotAnAttribute
                                                               multiplier:1.0f
                                                                 constant:27.0f]];
        [_constraintList addObject:[NSLayoutConstraint constraintWithItem:_streamListHDButton
                                                                attribute:NSLayoutAttributeHeight
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:nil
                                                                attribute:NSLayoutAttributeNotAnAttribute
                                                               multiplier:1.0f
                                                                 constant:27.0f]];
        [_constraintList addObject:[NSLayoutConstraint constraintWithItem:_excerptsHDButton
                                                                        attribute:NSLayoutAttributeCenterY
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self
                                                                        attribute:NSLayoutAttributeCenterY
                                                                       multiplier:1
                                                                         constant:0.0f]];
        [_constraintList addObject:[NSLayoutConstraint constraintWithItem:_streamListHDButton
                                                                attribute:NSLayoutAttributeCenterY
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self
                                                                attribute:NSLayoutAttributeCenterY
                                                               multiplier:1
                                                                 constant:0.0f]];
        if (_isSupportChatroom) {
            //iPad支持聊天室约束
            if (_excerptsHDButton.hidden == YES && _streamListHDButton.hidden == YES) {
                [_constraintList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_playOrPauseButton(59)]-0-[_startTimeLabel]-18-[_progressScubber]-18-[_totalDurationLabel]-28-[_chatroomSwitch(60)]-18-[_volumenControlButton(59)]-0-|"
                                                                                             options:0
                                                                                             metrics:nil
                                                                                               views:_subViewsDictionary]];
                
                [_constraintList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_playOrPauseButton(59)]-0-[_startTimeLabel]-18-[_availableProgressScubber]-18-[_totalDurationLabel]-28-[_chatroomSwitch(60)]-18-[_volumenControlButton(59)]-0-|"
                                                                                             options:0
                                                                                             metrics:nil
                                                                                               views:_subViewsDictionary]];
                
                [_constraintList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_playOrPauseButton(59)]-0-[_timeShiftStartTimeLabel]-18-[_timeShiftProgressScubber]-18-[_timeShiftTotalTimeLabel]-28-[_chatroomSwitch(60)]-18-[_volumenControlButton(59)]-0-|"
                                                                                             options:0
                                                                                             metrics:nil
                                                                                               views:_subViewsDictionary]];
                
            } else if (_excerptsHDButton.hidden == YES && _streamListHDButton.hidden == NO) {
                [_constraintList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_playOrPauseButton(59)]-0-[_startTimeLabel]-18-[_progressScubber]-18-[_totalDurationLabel]-28-[_streamListHDButton(58)]-28-[_chatroomSwitch(60)]-18-[_volumenControlButton(59)]-0-|"
                                                                                             options:0
                                                                                             metrics:nil
                                                                                               views:_subViewsDictionary]];
                [_constraintList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_playOrPauseButton(59)]-0-[_startTimeLabel]-18-[_availableProgressScubber]-18-[_totalDurationLabel]-28-[_streamListHDButton(58)]-28-[_chatroomSwitch(60)]-18-[_volumenControlButton(59)]-0-|"
                                                                                             options:0
                                                                                             metrics:nil
                                                                                               views:_subViewsDictionary]];
                [_constraintList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_playOrPauseButton(59)]-0-[_timeShiftStartTimeLabel]-18-[_timeShiftProgressScubber]-18-[_timeShiftTotalTimeLabel]-28-[_streamListHDButton(58)]-28-[_chatroomSwitch(60)]-18-[_volumenControlButton(59)]-0-|"
                                                                                             options:0
                                                                                             metrics:nil
                                                                                               views:_subViewsDictionary]];
            } else if (_excerptsHDButton.hidden == NO && _streamListHDButton.hidden == YES) {
                [_constraintList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_playOrPauseButton(59)]-0-[_startTimeLabel]-18-[_progressScubber]-18-[_totalDurationLabel]-28-[_excerptsHDButton(58)]-28-[_chatroomSwitch(60)]-18-[_volumenControlButton(59)]-0-|"
                                                                                             options:0
                                                                                             metrics:nil
                                                                                               views:_subViewsDictionary]];
                [_constraintList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_playOrPauseButton(59)]-0-[_startTimeLabel]-18-[_availableProgressScubber]-18-[_totalDurationLabel]-28-[_excerptsHDButton(58)]-28-[_chatroomSwitch(60)]-18-[_volumenControlButton(59)]-0-|"
                                                                                             options:0
                                                                                             metrics:nil
                                                                                               views:_subViewsDictionary]];
                [_constraintList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_playOrPauseButton(59)]-0-[_timeShiftStartTimeLabel]-18-[_timeShiftProgressScubber]-18-[_timeShiftTotalTimeLabel]-28-[_excerptsHDButton(58)]-28-[_chatroomSwitch(60)]-18-[_volumenControlButton(59)]-0-|"
                                                                                             options:0
                                                                                             metrics:nil
                                                                                               views:_subViewsDictionary]];
            } else {
                [_constraintList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_playOrPauseButton(59)]-0-[_startTimeLabel]-18-[_progressScubber]-18-[_totalDurationLabel]-28-[_excerptsHDButton(58)]-28-[_streamListHDButton(58)]-28-[_chatroomSwitch(60)]-18-[_volumenControlButton(59)]-0-|"
                                                                                             options:0
                                                                                             metrics:nil
                                                                                               views:_subViewsDictionary]];
                
                [_constraintList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_playOrPauseButton(59)]-0-[_startTimeLabel]-18-[_availableProgressScubber]-18-[_totalDurationLabel]-28-[_excerptsHDButton(58)]-28-[_streamListHDButton(58)]-28-[_chatroomSwitch(60)]-18-[_volumenControlButton(59)]-0-|"
                                                                                             options:0
                                                                                             metrics:nil
                                                                                               views:_subViewsDictionary]];
                [_constraintList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_playOrPauseButton(59)]-0-[_timeShiftStartTimeLabel]-18-[_timeShiftProgressScubber]-18-[_timeShiftTotalTimeLabel]-28-[_excerptsHDButton(58)]-28-[_streamListHDButton(58)]-28-[_chatroomSwitch(60)]-18-[_volumenControlButton(59)]-0-|"
                                                                                             options:0
                                                                                             metrics:nil
                                                                                               views:_subViewsDictionary]];
            }
        } else {
            //iPad不支持聊天室约束
            if (_excerptsHDButton.hidden == YES && _streamListHDButton.hidden == YES) {
                [_constraintList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_playOrPauseButton(59)]-0-[_startTimeLabel]-18-[_progressScubber]-18-[_totalDurationLabel]-0-[_volumenControlButton(59)]-0-|"
                                                                                             options:0
                                                                                             metrics:nil
                                                                                               views:_subViewsDictionary]];
                
                [_constraintList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_playOrPauseButton(59)]-0-[_startTimeLabel]-18-[_availableProgressScubber]-18-[_totalDurationLabel]-28-[_volumenControlButton(59)]-0-|"
                                                                                             options:0
                                                                                             metrics:nil
                                                                                               views:_subViewsDictionary]];
                
                [_constraintList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_playOrPauseButton(59)]-0-[_timeShiftStartTimeLabel]-18-[_timeShiftProgressScubber]-18-[_timeShiftTotalTimeLabel]-0-[_volumenControlButton(59)]-0-|"
                                                                                             options:0
                                                                                             metrics:nil
                                                                                               views:_subViewsDictionary]];
                
            } else if (_excerptsHDButton.hidden == YES && _streamListHDButton.hidden == NO) {
                [_constraintList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_playOrPauseButton(59)]-0-[_startTimeLabel]-18-[_progressScubber]-18-[_totalDurationLabel]-28-[_streamListHDButton(58)]-18-[_volumenControlButton(59)]-0-|"
                                                                                             options:0
                                                                                             metrics:nil
                                                                                               views:_subViewsDictionary]];
                [_constraintList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_playOrPauseButton(59)]-0-[_startTimeLabel]-18-[_availableProgressScubber]-18-[_totalDurationLabel]-28-[_streamListHDButton(58)]-18-[_volumenControlButton(59)]-0-|"
                                                                                             options:0
                                                                                             metrics:nil
                                                                                               views:_subViewsDictionary]];
                [_constraintList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_playOrPauseButton(59)]-0-[_timeShiftStartTimeLabel]-18-[_timeShiftProgressScubber]-18-[_timeShiftTotalTimeLabel]-28-[_streamListHDButton(58)]-18-[_volumenControlButton(59)]-0-|"
                                                                                             options:0
                                                                                             metrics:nil
                                                                                               views:_subViewsDictionary]];
            } else if (_excerptsHDButton.hidden == NO && _streamListHDButton.hidden == YES) {
                [_constraintList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_playOrPauseButton(59)]-0-[_startTimeLabel]-18-[_progressScubber]-18-[_totalDurationLabel]-28-[_excerptsHDButton(58)]-18-[_volumenControlButton(59)]-0-|"
                                                                                             options:0
                                                                                             metrics:nil
                                                                                               views:_subViewsDictionary]];
                [_constraintList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_playOrPauseButton(59)]-0-[_startTimeLabel]-18-[_availableProgressScubber]-18-[_totalDurationLabel]-28-[_excerptsHDButton(58)]-18-[_volumenControlButton(59)]-0-|"
                                                                                             options:0
                                                                                             metrics:nil
                                                                                               views:_subViewsDictionary]];
                [_constraintList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_playOrPauseButton(59)]-0-[_timeShiftStartTimeLabel]-18-[_timeShiftProgressScubber]-18-[_timeShiftTotalTimeLabel]-28-[_excerptsHDButton(58)]-18-[_volumenControlButton(59)]-0-|"
                                                                                             options:0
                                                                                             metrics:nil
                                                                                               views:_subViewsDictionary]];
            } else {
                [_constraintList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_playOrPauseButton(59)]-0-[_startTimeLabel]-18-[_progressScubber]-18-[_totalDurationLabel]-28-[_excerptsHDButton(58)]-28-[_streamListHDButton(58)]-18-[_volumenControlButton(59)]-0-|"
                                                                                             options:0
                                                                                             metrics:nil
                                                                                               views:_subViewsDictionary]];
                
                [_constraintList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_playOrPauseButton(59)]-0-[_startTimeLabel]-18-[_availableProgressScubber]-18-[_totalDurationLabel]-28-[_excerptsHDButton(58)]-28-[_streamListHDButton(58)]-18-[_volumenControlButton(59)]-0-|"
                                                                                             options:0
                                                                                             metrics:nil
                                                                                               views:_subViewsDictionary]];
                [_constraintList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_playOrPauseButton(59)]-0-[_timeShiftStartTimeLabel]-18-[_timeShiftProgressScubber]-18-[_timeShiftTotalTimeLabel]-28-[_excerptsHDButton(58)]-28-[_streamListHDButton(58)]-18-[_volumenControlButton(59)]-0-|"
                                                                                             options:0
                                                                                             metrics:nil
                                                                                               views:_subViewsDictionary]];
            }
        }
    }
    [self addConstraints:_constraintList];
}

- (void)setIsPlay:(BOOL)isPlay
{
    if (_isPlay != isPlay) {
        _isPlay = isPlay;
        if (_playOrPauseButton) {
            if (!_isPlay) {
                NSString *playerPlayName = _appearenceStyle==AJMediaPlayerStyleForiPhone?@"player_bt_play":@"player_bt_play_ipad";
                NSString *playerPlayPressName = _appearenceStyle==AJMediaPlayerStyleForiPhone?@"player_bt_play_press":@"player_bt_play_press_ipad";
                [_playOrPauseButton setImage:[UIImage imageNamed:playerPlayName] forState:UIControlStateNormal];
                [_playOrPauseButton setImage:[UIImage imageNamed:playerPlayPressName] forState:UIControlStateHighlighted];
            } else {
                NSString *playerPauseName = _appearenceStyle==AJMediaPlayerStyleForiPhone?@"player_bt_pause":@"player_bt_pause_ipad";
                NSString *playerPausePressName = _appearenceStyle==AJMediaPlayerStyleForiPhone?@"player_bt_pause_press":@"player_bt_pause_press_ipad";
                [_playOrPauseButton setImage:[UIImage imageNamed:playerPauseName] forState:UIControlStateNormal];
                [_playOrPauseButton setImage:[UIImage imageNamed:playerPausePressName] forState:UIControlStateHighlighted];
            }
        }
    }
}

@end
