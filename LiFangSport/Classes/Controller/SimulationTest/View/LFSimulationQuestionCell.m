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
        [_checkBtn setTitle:@"0" forState:UIControlStateNormal];
        [_checkBtn setTitle:@"1" forState:UIControlStateSelected];
        [_checkBtn addTarget:self action:@selector(checkBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_checkBtn];
        
        _nameLabel = [UILabel new];
        _nameLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_nameLabel];
        
        if ([reuseIdentifier isEqualToString:@"LFSimulationQuestionCellIDLeft"]) {
            [_checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.and.right.equalTo(weakSelf.contentView);
                make.width.and.height.equalTo(@30);
            }];
            
            [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(_checkBtn.mas_left).offset(-10);
                make.centerY.equalTo(weakSelf.contentView);
            }];
            
        }else if ([reuseIdentifier isEqualToString:@"LFSimulationQuestionCellIDRight"]) {
            [_checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.and.left.equalTo(weakSelf.contentView);
                make.width.and.height.equalTo(@30);
            }];
            
            [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_checkBtn.mas_right).offset(10);
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
