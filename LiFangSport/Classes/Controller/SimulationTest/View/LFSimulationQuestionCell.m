//
//  LFSimulationQuestionCell.m
//  LiFangSport
//
//  Created by Zhangqibin on 16/6/23.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import "LFSimulationQuestionCell.h"
@interface LFSimulationQuestionCell ()
{
    UIButton *_checkBtn;
    UILabel *_nameLabel;
}
@end

@implementation LFSimulationQuestionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        __weak typeof(self) weakSelf = self;
        
        _checkBtn = [UIButton new];
        [_checkBtn setImage:[UIImage imageNamed:@"lppopunselect"] forState:UIControlStateNormal];
        [_checkBtn setImage:[UIImage imageNamed:@"lppopselect"] forState:UIControlStateSelected];
        [_checkBtn addTarget:self action:@selector(checkBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_checkBtn];
        
        _nameLabel = [UILabel new];
        //_nameLabel.backgroundColor = [UIColor blueColor];
        _nameLabel.font = [UIFont systemFontOfSize:17];
        _nameLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_nameLabel];
        
        if ([reuseIdentifier isEqualToString:@"LFSimulationQuestionCellIDLeft"]) {
            _nameLabel.textAlignment = NSTextAlignmentRight;
            [_checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.and.right.equalTo(weakSelf.contentView);
                make.width.and.height.equalTo(@30);
            }];
            
            [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(_checkBtn.mas_left).offset(ALDFullScreenHorizontal(-10));
                make.centerY.equalTo(weakSelf.contentView);
            }];
            
        }else if ([reuseIdentifier isEqualToString:@"LFSimulationQuestionCellIDRight"]) {
            _nameLabel.textAlignment = NSTextAlignmentLeft;
            [_checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.and.left.equalTo(weakSelf.contentView);
                make.width.and.height.equalTo(@30);
            }];
            
            [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_checkBtn.mas_right).offset(ALDFullScreenHorizontal(10));
                make.centerY.equalTo(weakSelf.contentView);
            }];
        }
    }
    return self;
}

#pragma mark - Public Methods
- (void)refreshContent:(NSString *)question isSelected:(BOOL)isSelected
{
    _nameLabel.text = question;
    _checkBtn.selected = isSelected;
}

#pragma mark - Responder Methods
- (void)checkBtnTouched:(id)sender
{
    _checkBtn.selected = !_checkBtn.selected;
    if (self.selectedBlock) {
        self.selectedBlock(@(_checkBtn.selected));
    }
}

@end
