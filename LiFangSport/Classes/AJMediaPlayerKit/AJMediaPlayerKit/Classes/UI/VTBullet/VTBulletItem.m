//
//  VTBulletItem.m
//  VTBulletDemo
//
//  Created by Zhangqibin on 3/8/16.
//  Copyright © 2016 Zhangqibin. All rights reserved.
//

#import "VTBulletItem.h"
#import "VTBulletModel.h"
#import "VTBulletLabel.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface VTBulletItem()

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UIImageView *bubbleView;
@property (nonatomic, strong) VTBulletLabel *titleLabel;
@property (nonatomic, strong) NSMutableArray *constraintsList;

@end

@implementation VTBulletItem

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _iconView = [[UIImageView alloc] init];
        _iconView.translatesAutoresizingMaskIntoConstraints = NO;
        [_iconView setImage:[UIImage imageNamed:@"bullet_administrator_"]];
        _iconView.layer.cornerRadius = 8.f;
        _iconView.layer.masksToBounds = YES;
        [self addSubview:_iconView];
        
        _bubbleView = [[UIImageView alloc] init];
        _bubbleView.translatesAutoresizingMaskIntoConstraints = NO;
        UIImage *image = [[UIImage imageNamed:@"bullet_mine_bubble_"] stretchableImageWithLeftCapWidth:22.0f topCapHeight:11.0f];
        [_bubbleView setImage:image];
        _bubbleView.hidden = YES;
        [self addSubview:_bubbleView];
        
        _titleLabel = [[VTBulletLabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _titleLabel.layer.shadowColor = [UIColor blackColor].CGColor;
        _titleLabel.layer.shadowOffset = CGSizeMake(0,0.5);
        _titleLabel.layer.shadowOpacity = 0.6;
        _titleLabel.layer.shadowRadius = 2;
        _titleLabel.showStroke = NO;
        [self addSubview:_titleLabel];
        
        _constraintsList = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)updateConstraints
{
    [_constraintsList removeAllObjects];
    [_constraintsList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-3-[_iconView(16)]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_iconView)]];
    [_constraintsList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_iconView(16)]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_iconView)]];
    [_constraintsList addObject:[NSLayoutConstraint constraintWithItem:_iconView
                                                          attribute:NSLayoutAttributeCenterY
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self
                                                          attribute:NSLayoutAttributeCenterY
                                                         multiplier:1
                                                           constant:0]];
    
    [_constraintsList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_bubbleView]-0-|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:NSDictionaryOfVariableBindings(_bubbleView)]];
    [_constraintsList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_bubbleView]-0-|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:NSDictionaryOfVariableBindings(_bubbleView)]];
    
    if (_iconView.hidden) {
        [_constraintsList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[_titleLabel]-5-|"
                                                                                      options:0
                                                                                      metrics:nil
                                                                                        views:NSDictionaryOfVariableBindings(_iconView, _titleLabel)]];
    } else {
        [_constraintsList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_iconView(16)]-2-[_titleLabel]-16-|"
                                                                                      options:0
                                                                                      metrics:nil
                                                                                        views:NSDictionaryOfVariableBindings(_iconView, _titleLabel)]];
    }
    [_constraintsList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_titleLabel]-0-|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:NSDictionaryOfVariableBindings(_titleLabel)]];
    [self addConstraints:_constraintsList];
    [super updateConstraints];
}

- (CGSize)bulletSize:(VTBulletModel *)bullet lineBreakMode:(NSLineBreakMode)mode
{
    NSAssert(bullet.font != nil, @"the font of bullet:%@ couldn't be nil!", bullet);
    CGSize size = CGSizeMake(10000, 20);
    CGSize bulletSize = CGSizeZero;
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineBreakMode = mode;
    CGRect rect = [bullet.message boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: bullet.font, NSParagraphStyleAttributeName:style} context:nil];
    bulletSize = rect.size;
    return bulletSize;
}

- (void)setModel:(LEBubbletModel *)model
{
    _model = model;
    _titleLabel.bullet = model;
    if ([model.role isEqualToString:@"1"]) {// 明星
        [_iconView setImage:[UIImage imageNamed:@"bullet_V_ic_"]];
        _iconView.hidden = NO;
    } else if ([model.role isEqualToString:@"2"]) {// 运营
        [_iconView setImage:[UIImage imageNamed:@"bullet_operator_"]];
        _iconView.hidden = NO;
    } else {
        _bubbleView.hidden = !_model.isMineBullet;
        _iconView.hidden = [model.camp isEqualToString:@"0"];
        NSURL *imageUrl = _model.image ? [NSURL URLWithString:_model.image] : nil;
        [_iconView sd_setImageWithURL:imageUrl placeholderImage:nil];
    }
    CGFloat itemWidth = [self bulletSize:model lineBreakMode:NSLineBreakByWordWrapping].width;
    itemWidth += _iconView.hidden ? 20 : (3 + 16 + 4 + 18);
    self.bounds = (CGRect){CGPointZero, CGSizeMake(itemWidth, 22)};
    [self setNeedsUpdateConstraints];
}

@end
