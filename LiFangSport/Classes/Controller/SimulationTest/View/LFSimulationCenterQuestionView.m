//
//  LFSimulationCenterQuestionView.m
//  LiFangSport
//
//  Created by Zhangqibin on 16/6/22.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import "LFSimulationCenterQuestionView.h"
#import "LFSimulationQuestionCell.h"

@interface LFSimulationCenterQuestionView ()
    <UITableViewDelegate, UITableViewDataSource>
{
    UIButton *_nextBtn;
    NSInteger _leftSelectedIndex;
    NSInteger _rightSelectedIndex;
    NSInteger _falseCnt;
    NSInteger _trueCnt;
    LFQuestionMode _questionMode;
    BOOL _isLastQuestion;
}

@property (nonatomic, strong) UITableView *leftTableView;
@property (nonatomic, strong) UITableView *rightTableView;
@property (nonatomic, strong) UIView *scoreView;
@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UILabel *rightLabel;
@property (nonatomic, strong) LFSimulationQuestionModel *questionModel;

@end

@implementation LFSimulationCenterQuestionView
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor blueColor];
        
        _leftSelectedIndex = _rightSelectedIndex = -1;
        _falseCnt = _trueCnt = 0;
        
        __weak typeof(self) weakSelf = self;
        
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(closeBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeBtn];
        [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(10);
            make.right.equalTo(self.mas_right).offset(-20);
            make.width.and.height.equalTo(@50);
        }];
        
        [self addSubview:self.scoreView];
        [self.scoreView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.and.centerY.equalTo(weakSelf);
            make.width.equalTo(@180);
            make.height.equalTo(@140);
        }];
        
        [self addSubview:self.leftTableView];
        [self.leftTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakSelf);
            make.left.equalTo(weakSelf.mas_left).offset(10);
            make.right.equalTo(weakSelf.scoreView.mas_left).offset(-20);
            make.height.equalTo(@240);
        }];
        
        [self addSubview:self.rightTableView];
        [self.rightTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakSelf);
            make.left.equalTo(weakSelf.scoreView.mas_right).offset(20);
            make.right.equalTo(weakSelf.mas_right).offset(-10);
            make.height.equalTo(@180);
        }];
        
        _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _nextBtn.enabled = NO;
        _nextBtn.layer.cornerRadius = 5;
        _nextBtn.layer.masksToBounds = YES;
        _nextBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        _nextBtn.layer.borderWidth = 1;
        [_nextBtn setTitle:@"下一题" forState:UIControlStateNormal];
        [_nextBtn addTarget:self action:@selector(nextBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_nextBtn];
        [_nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf);
            make.width.equalTo(@100);
            make.height.equalTo(@50);
            make.bottom.equalTo(weakSelf.mas_bottom).offset(-30);
        }];
    }
    return self;
}

#pragma mark - Public Methods
- (void)refreshWithModel:(LFSimulationQuestionModel *)questionModel questionMode:(LFQuestionMode)questionMode
{
    _nextBtn.enabled = NO;
    _leftSelectedIndex = _rightSelectedIndex = -1;
    if (_questionMode != questionMode || _isLastQuestion) {
        _falseCnt = _trueCnt = 0;
        _leftLabel.text = _rightLabel.text = @"00";
    }
    _questionMode = questionMode;
    if (_questionMode != LFQuestionModeDefaultFoul) {
        __weak typeof(self) weakSelf = self;
        [self.scoreView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf);
            make.width.equalTo(@180);
            make.height.equalTo(@140);
            make.top.equalTo(weakSelf).offset(30);
        }];
        
        if (_questionMode == LFQuestionModeDefaultOffsideEasy) {
            self.leftTableView.hidden = YES;
            [self.rightTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(weakSelf.scoreView.mas_bottom);
                make.centerX.equalTo(weakSelf);
                make.left.equalTo(weakSelf.scoreView.mas_left).offset(-10);
                make.right.equalTo(weakSelf.mas_right).offset(-10);
                make.height.equalTo(@120);
            }];
        }else {
            self.leftTableView.hidden = self.rightTableView.hidden = YES;
        }
    }
    
    self.leftTableView.userInteractionEnabled = self.rightTableView.userInteractionEnabled = YES;
    self.questionModel = questionModel;
    [self.leftTableView reloadData];
    [self.rightTableView reloadData];
}

- (void)refreshTestingResult
{
    _isLastQuestion = YES;
    [_nextBtn setTitle:@"继续挑战" forState:UIControlStateNormal];
}

#pragma mark - Responder Methods
- (void)nextBtnTouched:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(questionViewNextQuestion)]) {
        [self.delegate questionViewNextQuestion];
    }
    if (_isLastQuestion) {
        _isLastQuestion = NO;
        [_nextBtn setTitle:@"下一题" forState:UIControlStateNormal];
    }
}

- (void)closeBtnTouched:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(questionViewQuitQuesiotn)]) {
        [self.delegate questionViewQuitQuesiotn];
    }
}

#pragma mark - judgementAnswer
- (void)judgementAnswer
{
    self.leftTableView.userInteractionEnabled = self.rightTableView.userInteractionEnabled = NO;
    _nextBtn.enabled = YES;
    if (_leftSelectedIndex == self.questionModel.leftAnswerIndex && _rightSelectedIndex == self.questionModel.rightAnswerIndex) {
        _trueCnt++;
        if (_trueCnt > 9) {
            _leftLabel.text = [NSString stringWithFormat:@"%@", @(_trueCnt)];
        }else {
            _leftLabel.text = [NSString stringWithFormat:@"0%@", @(_trueCnt)];
        }
    }else {
        _falseCnt++;
        if (_falseCnt > 9) {
            _rightLabel.text = [NSString stringWithFormat:@"%@", @(_falseCnt)];
        }else {
            _rightLabel.text = [NSString stringWithFormat:@"0%@", @(_falseCnt)];
        }
    }
    if (self.questionCnt == _falseCnt + _trueCnt) {
        [self refreshTestingResult];
    }
}

- (void)judgementOffsideAnswer
{
    self.leftTableView.userInteractionEnabled = self.rightTableView.userInteractionEnabled = NO;
    _nextBtn.enabled = YES;
    if (_rightSelectedIndex == self.questionModel.leftAnswerIndex) {
        _trueCnt++;
        if (_trueCnt > 9) {
            _leftLabel.text = [NSString stringWithFormat:@"%@", @(_trueCnt)];
        }else {
            _leftLabel.text = [NSString stringWithFormat:@"0%@", @(_trueCnt)];
        }
    }else {
        _falseCnt++;
        if (_falseCnt > 9) {
            _rightLabel.text = [NSString stringWithFormat:@"%@", @(_falseCnt)];
        }else {
            _rightLabel.text = [NSString stringWithFormat:@"0%@", @(_falseCnt)];
        }
    }
    if (self.questionCnt == _falseCnt + _trueCnt) {
        [self refreshTestingResult];
    }
}

#pragma mark - UITableViewDelegate and UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger number = 0;
    if ([self.leftTableView isEqual:tableView] || _questionMode == LFQuestionModeDefaultOffsideEasy) {
        number = self.questionModel.leftQuestionArray.count;
    }else {
        number = self.questionModel.rightQuestionArray.count;
    }
    
    return number;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) weakSelf = self;
    
    if ([self.leftTableView isEqual:tableView]) {
        static NSString *customCellID = @"LFSimulationQuestionCellIDLeft";
        LFSimulationQuestionCell * cell = [tableView dequeueReusableCellWithIdentifier:customCellID];
        if (!cell) {
            cell = [[LFSimulationQuestionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:customCellID];
        }
        
        __weak typeof(tableView) weakTableView = tableView;
        
        cell.selectedBlock = ^(id object) {
            NSInteger lastSelectedIndex = _leftSelectedIndex;
            _leftSelectedIndex = [object boolValue] ? indexPath.row : -1;
            if (lastSelectedIndex >= 0) {
                [weakTableView beginUpdates];
                [weakTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:lastSelectedIndex inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                [weakTableView endUpdates];
            }
            if (_rightSelectedIndex != -1) {
                //  两道题都已选择
                [weakSelf judgementAnswer];
            }
        };
        [cell refreshContent:self.questionModel.leftQuestionArray[indexPath.row] isSelected:_leftSelectedIndex == indexPath.row];
        
        return cell;
    }else {
        if (_questionMode == LFQuestionModeDefaultOffsideEasy) {
            static NSString *customCellID = @"LFSimulationQuestionCellIDRight";
            LFSimulationQuestionCell * cell = [tableView dequeueReusableCellWithIdentifier:customCellID];
            if (!cell) {
                cell = [[LFSimulationQuestionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:customCellID];
            }
            
            cell.selectedBlock = ^(id object) {
                _rightSelectedIndex = [object boolValue] ? indexPath.row : -1;
                [weakSelf judgementOffsideAnswer];
            };
            
            [cell refreshContent:self.questionModel.leftQuestionArray[indexPath.row] isSelected:_rightSelectedIndex == indexPath.row];
            
            return cell;
        }else {
            static NSString *customCellID = @"LFSimulationQuestionCellIDRight";
            LFSimulationQuestionCell * cell = [tableView dequeueReusableCellWithIdentifier:customCellID];
            if (!cell) {
                cell = [[LFSimulationQuestionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:customCellID];
            }
            
            __weak typeof(tableView) weakTableView = tableView;
            
            cell.selectedBlock = ^(id object) {
                NSInteger lastSelectedIndex = _leftSelectedIndex;
                _rightSelectedIndex = [object boolValue] ? indexPath.row : -1;
                if (_rightSelectedIndex >= 0) {
                    [weakTableView beginUpdates];
                    [weakTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:lastSelectedIndex inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                    [weakTableView endUpdates];
                }
                if (_leftSelectedIndex != -1) {
                    //  两道题都已选择
                    [weakSelf judgementAnswer];
                }
            };
            
            [cell refreshContent:self.questionModel.rightQuestionArray[indexPath.row] isSelected:_rightSelectedIndex == indexPath.row];
            
            return cell;
        }
    }
}

#pragma mark - Getter and Setter
- (UITableView *)leftTableView
{
    if (!_leftTableView) {
        _leftTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _leftTableView.delegate = self;
        _leftTableView.dataSource = self;
        _leftTableView.rowHeight = 60;
        _leftTableView.backgroundColor = [UIColor clearColor];
        _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _leftTableView.tableFooterView = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _leftTableView;
}

- (UITableView *)rightTableView
{
    if (!_rightTableView) {
        _rightTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _rightTableView.delegate = self;
        _rightTableView.dataSource = self;
        _rightTableView.rowHeight = 60;
        _rightTableView.backgroundColor = [UIColor clearColor];
        _rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _rightTableView.tableFooterView = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _rightTableView;
}

- (UIView *)scoreView
{
    if (!_scoreView) {
        _scoreView = [UIView new];
        [_scoreView addSubview:self.leftLabel];
        [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.top.equalTo(_scoreView);
            make.width.and.height.equalTo(@80);
        }];
        
        UILabel *promptLeftLabel = [UILabel new];
        promptLeftLabel.font = [UIFont systemFontOfSize:25];
        promptLeftLabel.textColor = HEXRGBCOLOR(0x9dee38);
        promptLeftLabel.text = @"正确";
        [_scoreView addSubview:promptLeftLabel];
        [promptLeftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_leftLabel);
            make.top.equalTo(_leftLabel.mas_bottom).offset(10);
        }];
        
        [_scoreView addSubview:self.rightLabel];
        [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.and.top.equalTo(_scoreView);
            make.width.and.height.equalTo(@80);
        }];
        UILabel *promptRightLabel = [UILabel new];
        promptRightLabel.font = [UIFont systemFontOfSize:25];
        promptRightLabel.textColor = HEXRGBCOLOR(0xc2021e);
        promptRightLabel.text = @"错误";
        [_scoreView addSubview:promptRightLabel];
        [promptRightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_rightLabel);
            make.top.equalTo(_rightLabel.mas_bottom).offset(10);
        }];
    }
    return _scoreView;
}

- (UILabel *)leftLabel
{
    if (!_leftLabel) {
        _leftLabel = [UILabel new];
        _leftLabel.layer.cornerRadius = 5;
        _leftLabel.layer.masksToBounds = YES;
        _leftLabel.layer.borderColor = [UIColor whiteColor].CGColor;
        _leftLabel.layer.borderWidth = 1;
        _leftLabel.font = [UIFont systemFontOfSize:50];
        _leftLabel.textColor = HEXRGBCOLOR(0x9dee38);
        _leftLabel.text = @"00";
        _leftLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _leftLabel;
}

- (UILabel *)rightLabel
{
    if (!_rightLabel) {
        _rightLabel = [UILabel new];
        _rightLabel.layer.cornerRadius = 5;
        _rightLabel.layer.masksToBounds = YES;
        _rightLabel.layer.borderColor = [UIColor whiteColor].CGColor;
        _rightLabel.layer.borderWidth = 1;
        _rightLabel.font = [UIFont systemFontOfSize:50];
        _rightLabel.textColor = HEXRGBCOLOR(0xc2021e);
        _rightLabel.text = @"00";
        _rightLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _rightLabel;
}

@end
