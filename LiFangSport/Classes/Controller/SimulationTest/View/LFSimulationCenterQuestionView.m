//
//  LFSimulationCenterQuestionView.m
//  LiFangSport
//
//  Created by Zhangqibin on 16/6/22.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import "LFSimulationCenterQuestionView.h"
#import "LFSimulationQuestionCell.h"
#import "LFSimulationOffsideHardCell.h"

#define CELL_ID @"LFSimulationOffsideHardCell"
#define CELL_ITEM_SIZE_WIDTH (SCREEN_WIDTH - 30 - 60) / 4.0
#define CELL_ITEM_SIZE_HEIGHT CELL_ITEM_SIZE_WIDTH * (230.0 / 300.0) + 20
#define CELL_HEIGHT ALDFullScreenVertical(45)

@interface LFSimulationCenterQuestionView ()
    <UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource>
{
    LFQuestionMode _questionMode;
    NSInteger _questionCnt;
    NSInteger _rightCount;
    NSInteger _leftSelectedIndex;
    NSInteger _rightSelectedIndex;
    NSInteger _falseCnt;
    NSInteger _trueCnt;
    UIButton *_nextBtn;
    UIView *_leftBorderView;
    UIView *_rightBorderView;
}

@property (nonatomic, strong) UITableView *leftTableView;
@property (nonatomic, strong) UITableView *rightTableView;
@property (nonatomic, strong) UIView *scoreView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UILabel *rightLabel;
@property (nonatomic, strong) LFSimulationQuestionModel *questionModel;

@end

@implementation LFSimulationCenterQuestionView
#pragma mark - init
- (instancetype)initWithQuestionMode:(LFQuestionMode)questionMode questionCnt:(NSInteger)questionCnt rightCount:(NSInteger)rightCount
{
    self = [super init];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        _questionMode = questionMode;
        _questionCnt = questionCnt;
        _rightCount = rightCount;
        _leftSelectedIndex = _rightSelectedIndex = -1;
        _falseCnt = _trueCnt = 0;
        
        __weak typeof(self) weakSelf = self;
        
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeBtn setImage:[UIImage imageNamed:@"popclose"] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(closeBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeBtn];
        [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(ALDFullScreenVertical(20));
            make.right.equalTo(self.mas_right).offset(ALDFullScreenHorizontal(-30));
        }];
        
        [self addSubview:self.scoreView];
        [self.scoreView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(ALDFullScreenHorizontal(175)));
            make.height.equalTo(@(ALDFullScreenHorizontal(80) + 20));
        }];
        
        if (_questionMode == LFQuestionModeDefaultFoul) {
            [self.scoreView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.and.centerY.equalTo(weakSelf);
            }];
            
            _leftBorderView = [UIView new];
            _leftBorderView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2];
            _leftBorderView.layer.masksToBounds = YES;
            _leftBorderView.layer.borderColor = [UIColor whiteColor].CGColor;
            _leftBorderView.layer.borderWidth = 1;
            _leftBorderView.layer.cornerRadius = 20;
            [self addSubview:_leftBorderView];
            [_leftBorderView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(weakSelf);
                make.left.equalTo(weakSelf.mas_left).offset(-20);
                make.right.equalTo(weakSelf.scoreView.mas_left).offset(ALDFullScreenHorizontal(-10));
                make.height.equalTo(@(CELL_HEIGHT * 4 + 10));
            }];
            
            [self addSubview:self.leftTableView];
            [self.leftTableView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(weakSelf);
                make.left.equalTo(weakSelf.mas_left);
                make.right.equalTo(weakSelf.scoreView.mas_left).offset(ALDFullScreenHorizontal(-20));
                make.height.equalTo(@(CELL_HEIGHT * 4));
            }];
            
            _rightBorderView = [UIView new];
            _rightBorderView.backgroundColor = _leftBorderView.backgroundColor;
            _rightBorderView.layer.masksToBounds = YES;
            _rightBorderView.layer.borderColor = [UIColor whiteColor].CGColor;
            _rightBorderView.layer.borderWidth = 1;
            _rightBorderView.layer.cornerRadius = 20;
            [self addSubview:_rightBorderView];
            [_rightBorderView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(weakSelf);
                make.left.equalTo(weakSelf.scoreView.mas_right).offset(ALDFullScreenHorizontal(10));
                make.right.equalTo(weakSelf.mas_right).offset(20);
                make.height.equalTo(_leftBorderView);
            }];
            
            [self addSubview:self.rightTableView];
            [self.rightTableView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(weakSelf);
                make.left.equalTo(weakSelf.scoreView.mas_right).offset(ALDFullScreenHorizontal(20));
                make.right.equalTo(weakSelf.mas_right);
                make.height.equalTo(@(CELL_HEIGHT * 3));
            }];
        }else {
            [self.scoreView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(weakSelf);
                make.top.equalTo(weakSelf).offset(ALDFullScreenHorizontal(50));
            }];
            
            if (_questionMode == LFQuestionModeDefaultOffsideEasy) {
                [self addSubview:self.rightTableView];
                [self.rightTableView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(weakSelf.scoreView.mas_bottom).offset(ALDFullScreenHorizontal(15));
                    make.left.equalTo(weakSelf.scoreView.mas_left);
                    make.right.equalTo(weakSelf.mas_right).offset(-10);
                    make.height.equalTo(@(CELL_HEIGHT * 2 + 5));
                }];
            }else if (_questionMode == LFQuestionModeDefaultOffsideHard) {
                [self addSubview:self.collectionView];
                [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(weakSelf.scoreView.mas_bottom).offset(ALDFullScreenVertical(5));
                    make.left.equalTo(weakSelf.mas_left).offset(15);
                    make.right.equalTo(weakSelf.mas_right).offset(-15);
                    make.height.equalTo(@(CELL_ITEM_SIZE_HEIGHT));
                }];
            }
        }
    
        _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _nextBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _nextBtn.layer.cornerRadius = 5;
        _nextBtn.layer.masksToBounds = YES;
        _nextBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        _nextBtn.layer.borderWidth = 1;
        [_nextBtn setTitle:@"跳过" forState:UIControlStateNormal];
        [_nextBtn addTarget:self action:@selector(nextBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_nextBtn];
        [_nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf);
            make.width.equalTo(@150);
            make.height.equalTo(@45);
            make.bottom.equalTo(weakSelf.mas_bottom).offset(ALDFullScreenVertical(-30));
        }];
    }
    return self;
}

#pragma mark - Public Methods
- (void)refreshWithModel:(LFSimulationQuestionModel *)questionModel
{
    _nextBtn.enabled = YES;
    self.questionModel = questionModel;
    _leftSelectedIndex = _rightSelectedIndex = -1;
    dispatch_async(dispatch_get_main_queue(), ^{
        switch (_questionMode) {
            case LFQuestionModeDefaultFoul:
                self.leftTableView.userInteractionEnabled = self.rightTableView.userInteractionEnabled = YES;
                [self.leftTableView reloadData];
                [self.rightTableView reloadData];
                break;
            case LFQuestionModeDefaultOffsideEasy:
                self.rightTableView.userInteractionEnabled = YES;
                [self.rightTableView reloadData];
                break;
            case LFQuestionModeDefaultOffsideHard:
                self.collectionView.userInteractionEnabled = YES;
                [self.collectionView reloadData];
                break;
            default:
                break;
        }
    });
}

- (void)beginPerformNextQuestion
{
    [self performSelector:@selector(performNextQuestion) withObject:nil afterDelay:10];
}

#pragma mark - TestingResult
- (void)refreshTestingResult
{
    dispatch_async(dispatch_get_main_queue(), ^{
        __weak typeof(self) weakSelf = self;
        
        UILabel *resultLabel = [UILabel new];
        resultLabel.numberOfLines = 0;
        resultLabel.lineBreakMode = NSLineBreakByWordWrapping;
        resultLabel.font = [UIFont systemFontOfSize:17];
        resultLabel.textColor = kwhiteColor;
        resultLabel.textAlignment = NSTextAlignmentCenter;
        resultLabel.text = [NSString stringWithFormat:@"%@通过本次测试。\n共%@题，正确%@题，错误%@题", _trueCnt >= _rightCount ? @"恭喜您，成功" : @"很抱歉，您未", @(_questionCnt), @(_trueCnt), @(_falseCnt)];
        [self addSubview:resultLabel];
        [resultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf).offset(ALDFullScreenVertical(75));
            make.left.equalTo(weakSelf).offset(40);
            make.right.equalTo(weakSelf).offset(-40);
        }];
        
        switch (_questionMode) {
            case LFQuestionModeDefaultFoul:
            {
                self.leftTableView.hidden = self.rightTableView.hidden = _leftBorderView.hidden = _rightBorderView.hidden = YES;
                [self.scoreView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(weakSelf).offset(ALDFullScreenVertical(10));
                }];
            }
                break;
            case LFQuestionModeDefaultOffsideEasy:
            {
                self.rightTableView.hidden = YES;
                [self.scoreView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(weakSelf).offset(ALDFullScreenVertical(150));
                }];
            }
                break;
            case LFQuestionModeDefaultOffsideHard:
            {
                self.collectionView.hidden = YES;
                [self.scoreView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(weakSelf).offset(ALDFullScreenVertical(150));
                }];
            }
                break;
            default:
                break;
        }
        _nextBtn.enabled = YES;
        [_nextBtn setTitle:@"继续测试" forState:UIControlStateNormal];
    });
}

#pragma mark - Responder Methods
- (void)nextBtnTouched:(id)sender
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(performNextQuestion) object:nil];
    if ([_nextBtn.titleLabel.text isEqualToString:@"继续挑战"]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(questionViewAgainQuesiotn)]) {
            [self.delegate questionViewAgainQuesiotn];
        }
    }else {
        [self performNextQuestion];
    }
}

- (void)closeBtnTouched:(id)sender
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(performNextQuestion) object:nil];
    if (self.delegate && [self.delegate respondsToSelector:@selector(questionViewQuitQuesiotn)]) {
        [self.delegate questionViewQuitQuesiotn];
    }
}

- (void)performNextQuestion
{
    _nextBtn.enabled = NO;
    if (_leftSelectedIndex == -1 || _rightSelectedIndex == -1) {
        //  跳过
        _falseCnt++;
        [self refreshRightLabelContent];
    }
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5*NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^{
        if (_questionCnt == _falseCnt + _trueCnt) {
            [self refreshTestingResult];
        }else {
            if (self.delegate && [self.delegate respondsToSelector:@selector(questionViewNextQuestion)]) {
                [self.delegate questionViewNextQuestion];
            }
        }
    });
}

#pragma mark - Judgement Answer
- (void)judgementAnswer
{
    _nextBtn.enabled = NO;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(performNextQuestion) object:nil];
    self.leftTableView.userInteractionEnabled = self.rightTableView.userInteractionEnabled = NO;
    if (_leftSelectedIndex == self.questionModel.leftAnswerIndex && _rightSelectedIndex == self.questionModel.rightAnswerIndex) {
        _trueCnt++;
        [self refreshLeftLabelContent];
    }else {
        _falseCnt++;
        [self refreshRightLabelContent];
    }
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5*NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^{
        if (_questionCnt == _falseCnt + _trueCnt) {
            [self refreshTestingResult];
        }else {
            if (self.delegate && [self.delegate respondsToSelector:@selector(questionViewNextQuestion)]) {
                [self.delegate questionViewNextQuestion];
            }
        }
    });
}

- (void)judgementOffsideAnswer
{
    _nextBtn.enabled = NO;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(performNextQuestion) object:nil];
    if (_questionMode == LFQuestionModeDefaultOffsideEasy) {
        self.rightTableView.userInteractionEnabled = NO;
    }else {
        self.collectionView.userInteractionEnabled = NO;
    }
    if (_rightSelectedIndex == self.questionModel.leftAnswerIndex) {
        _trueCnt++;
        [self refreshLeftLabelContent];
    }else {
        _falseCnt++;
        [self refreshRightLabelContent];
    }
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5*NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^{
        if (_questionCnt == _falseCnt + _trueCnt) {
            [self refreshTestingResult];
        }else {
            if (self.delegate && [self.delegate respondsToSelector:@selector(questionViewNextQuestion)]) {
                [self.delegate questionViewNextQuestion];
            }
        }
    });
}

#pragma mark - Refresh Label Content
- (void)refreshLeftLabelContent
{
    if (_trueCnt > 9) {
        _leftLabel.text = [NSString stringWithFormat:@"%@", @(_trueCnt)];
    }else {
        _leftLabel.text = [NSString stringWithFormat:@"0%@", @(_trueCnt)];
    }
}

- (void)refreshRightLabelContent
{
    if (_falseCnt > 9) {
        _rightLabel.text = [NSString stringWithFormat:@"%@", @(_falseCnt)];
    }else {
        _rightLabel.text = [NSString stringWithFormat:@"0%@", @(_falseCnt)];
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

#pragma mark - UICollectionViewDelegate and UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.questionModel.leftQuestionImageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LFSimulationOffsideHardCell *cell = (LFSimulationOffsideHardCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CELL_ID forIndexPath: indexPath];
    [cell refreshOffsideHardCellContent:self.questionModel.leftQuestionImageArray[indexPath.row] content:self.questionModel.leftQuestionArray[indexPath.row] selectedIndex:_rightSelectedIndex rightIndex:self.questionModel.leftAnswerIndex row:indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    _rightSelectedIndex = indexPath.row;
    [self judgementOffsideAnswer];
    [collectionView reloadData];
}

#pragma mark - Getter and Setter
- (UITableView *)leftTableView
{
    if (!_leftTableView) {
        _leftTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _leftTableView.delegate = self;
        _leftTableView.dataSource = self;
        _leftTableView.bounces = NO;
        _leftTableView.rowHeight = CELL_HEIGHT;
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
        _rightTableView.bounces = NO;
        _rightTableView.rowHeight = CELL_HEIGHT;
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
        
        UIView *subView = [UIView new];
        subView.backgroundColor = [UIColor blackColor];
        subView.layer.cornerRadius = 10;
        subView.layer.masksToBounds = YES;
        subView.layer.borderColor = [UIColor whiteColor].CGColor;
        subView.layer.borderWidth = 1;
        [_scoreView addSubview:subView];
        [subView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.top.and.right.equalTo(_scoreView);
            make.height.equalTo(@(ALDFullScreenVertical(75)));
        }];
        
        [subView addSubview:self.leftLabel];
        [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.equalTo(subView);
            make.centerY.equalTo(subView.mas_centerY).offset(3);
            make.width.equalTo(@(ALDFullScreenHorizontal(175 / 2.0)));
        }];
        
        [subView addSubview:self.rightLabel];
        [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(subView);
            make.width.and.centerY.equalTo(_leftLabel);
        }];
        
        UIView *lineView = [UIView new];
        lineView.backgroundColor = [UIColor whiteColor];
        [subView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.and.centerX.equalTo(subView);
            make.width.equalTo(@1);
            make.height.equalTo(@(ALDFullScreenVertical(75) - ALDFullScreenVertical(20)));
        }];
        
        UILabel *promptLeftLabel = [UILabel new];
        promptLeftLabel.font = [UIFont systemFontOfSize:20];
        promptLeftLabel.textColor = HEXRGBCOLOR(0x6aed00);
        promptLeftLabel.text = @"正确";
        [_scoreView addSubview:promptLeftLabel];
        [promptLeftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_leftLabel);
            make.top.equalTo(subView.mas_bottom).offset(ALDFullScreenVertical(5));
        }];
        
        UILabel *promptRightLabel = [UILabel new];
        promptRightLabel.font = [UIFont systemFontOfSize:20];
        promptRightLabel.textColor = HEXRGBCOLOR(0xe30019);
        promptRightLabel.text = @"错误";
        [_scoreView addSubview:promptRightLabel];
        [promptRightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_rightLabel);
            make.top.equalTo(promptLeftLabel);
        }];
    }
    return _scoreView;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal | UICollectionViewScrollDirectionVertical];
        flowLayout.minimumLineSpacing = 12;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 12, 0, 12);
        //flowLayout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH * 300 / 750.0 + 10 + 32);
        flowLayout.itemSize = CGSizeMake(CELL_ITEM_SIZE_WIDTH, CELL_ITEM_SIZE_HEIGHT);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(5, 0, SCREEN_WIDTH - 10, self.bounds.size.height) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[LFSimulationOffsideHardCell class] forCellWithReuseIdentifier:CELL_ID];
        _collectionView.showsVerticalScrollIndicator = YES;
    }
    return _collectionView;
}


- (UILabel *)leftLabel
{
    if (!_leftLabel) {
        _leftLabel = [UILabel new];
        _leftLabel.font = [UIFont fontWithName:@"AppleSDGothicNeo-Bold" size:50];
        _leftLabel.textColor = HEXRGBCOLOR(0x6aed00);
        _leftLabel.text = @"00";
        _leftLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _leftLabel;
}

- (UILabel *)rightLabel
{
    if (!_rightLabel) {
        _rightLabel = [UILabel new];
        _rightLabel.font = [UIFont fontWithName:@"AppleSDGothicNeo-Bold" size:50];
        _rightLabel.textColor = HEXRGBCOLOR(0xe30019);
        _rightLabel.text = @"00";
        _rightLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _rightLabel;
}

@end
