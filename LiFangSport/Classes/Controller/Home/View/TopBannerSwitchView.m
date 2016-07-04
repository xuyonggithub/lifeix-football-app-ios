//
//  TopBannerSwitchView.m
//  LiFangSport
//
//  Created by 张毅 on 16/6/14.
//  Copyright © 2016年 zhangyi. All rights reserved.
//
#import "SimButton.h"
#import "LineView.h"
#import "TopBannerSwitchView.h"
typedef NS_ENUM(NSInteger, SelectedBtnIndex){
    SBT_Left = 0,
    SBT_Center,
    SBT_RiIght,
};
#define kbtnFont 15
@interface TopBannerSwitchView ()

@property (nonatomic, strong) SimButton *leftBtn;
@property (nonatomic, strong) SimButton *centerBtn;
@property (nonatomic, strong) SimButton *rightBtn;
@property (nonatomic, strong) LineView *leftLine;
@property (nonatomic, strong) LineView *centerLine;
@property (nonatomic, strong) LineView *rightLine;

@end
@implementation TopBannerSwitchView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self showContent];
    }
    return self;
}

- (void)showContent
{
    UIView *topBanner = [[UIView alloc] initWithFrame:self.bounds];
    topBanner.backgroundColor = [UIColor clearColor];
    [self addSubview:topBanner];
    
    _leftBtn = [[SimButton alloc]initWithFrame:CGRectMake(0, 0, topBanner.width/3, topBanner.height)];
    _leftBtn.titleLabel.font = [UIFont systemFontOfSize:kbtnFont];
    [_leftBtn setTitleColor:kDetailTitleColor forState:UIControlStateNormal];
    [_leftBtn setTitleColor:kDetailTitleColor forState:UIControlStateSelected];
    _leftBtn.selected = YES;
    _leftBtn.tag = SBT_Left;
    _leftBtn.backgroundColor = [UIColor clearColor];
    [_leftBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [topBanner addSubview:_leftBtn];
    
    _leftLine = [[LineView alloc] initWithFrame:CGRectMake(3.5*0, _leftBtn.bottom - 3, _leftBtn.width - 7*0, 2)];
    _leftLine.lineColor = kBasicColor;
    _leftLine.hidden = NO;
    [topBanner addSubview:_leftLine];
    
    LineView *separateLine = [[LineView alloc] initWithHeight:topBanner.height/2];
    separateLine.top = (topBanner.height - separateLine.height)/2;
    separateLine.left = _leftBtn.right;
    [topBanner addSubview:separateLine];
    
    //中
    _centerBtn = [[SimButton alloc]initWithFrame:_leftBtn.bounds];
    _centerBtn.left = separateLine.right;
    _centerBtn.titleLabel.font = [UIFont systemFontOfSize:kbtnFont];
    [_centerBtn setTitleColor:kDetailTitleColor forState:UIControlStateNormal];
    [_centerBtn setTitleColor:kDetailTitleColor forState:UIControlStateSelected];
    [_centerBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    _centerBtn.selected = NO;
    _centerBtn.tag = SBT_Center;
    [topBanner addSubview:_centerBtn];
    
    _centerLine = [[LineView alloc] initWithFrame:CGRectMake(0, _centerBtn.bottom - 3, _centerBtn.width - 7*0, 2)];
    _centerLine.centerX = _centerBtn.centerX;
    _centerLine.lineColor = kBasicColor;
    _centerLine.hidden = YES;
    [topBanner addSubview:_centerLine];
    
    LineView *separateLine2 = [[LineView alloc] initWithHeight:topBanner.height/2];
    separateLine2.top = (topBanner.height - separateLine.height)/2;
    separateLine2.left = _centerBtn.right;
    [topBanner addSubview:separateLine2];
    //右
    _rightBtn = [[SimButton alloc]initWithFrame:_leftBtn.bounds];
    _rightBtn.left = separateLine2.right;
    _rightBtn.titleLabel.font = [UIFont systemFontOfSize:kbtnFont];
    [_rightBtn setTitleColor:kDetailTitleColor forState:UIControlStateNormal];
    [_rightBtn setTitleColor:kDetailTitleColor forState:UIControlStateSelected];
    [_rightBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    _rightBtn.selected = NO;
    _rightBtn.tag = SBT_RiIght;
    [topBanner addSubview:_rightBtn];
    
    _rightLine = [[LineView alloc] initWithFrame:CGRectMake(0, _rightBtn.bottom - 3, _rightBtn.width - 7*0, 2)];
//    _rightLine.right = topBanner.right - 3.5*10;
    _rightLine.centerX = _rightBtn.centerX;
    _rightLine.lineColor = kBasicColor;
    _rightLine.hidden = YES;
    [topBanner addSubview:_rightLine];
    
    LineView *lineView = [[LineView alloc] initWithWidth:topBanner.width];
    lineView.bottom = topBanner.height;
    [topBanner addSubview:lineView];
    
}

-(void)setLeftTitleStr:(NSString *)leftTitleStr
{
    [_leftBtn setTitle:leftTitleStr forState:UIControlStateNormal];
    _leftBtn.selected = YES;//默认左边选中
}

- (void)setLeftIcon:(NSString *)normalImg HighImg:(NSString *)highImg
{
    [_leftBtn setImage:UIImageFileName(normalImg) forState:UIControlStateNormal];
    [_leftBtn setImage:UIImageFileName(highImg) forState:UIControlStateSelected];
}

-(void)setCenterTitleStr:(NSString *)centerTitleStr{
    [_centerBtn setTitle:centerTitleStr forState:UIControlStateNormal];
}
-(void)setCenterIcon:(NSString *)normalImg HighImg:(NSString *)highImg{
    [_centerBtn setImage:UIImageFileName(normalImg) forState:UIControlStateNormal];
    [_centerBtn setImage:UIImageFileName(highImg) forState:UIControlStateSelected];
}
- (void)setRightTitleStr:(NSString *)rightTitleStr
{
    [_rightBtn setTitle:rightTitleStr forState:UIControlStateNormal];
}

- (void)setRighticon:(NSString *)normalImg HighImg:(NSString *)highImg
{
    [_rightBtn setImage:UIImageFileName(normalImg) forState:UIControlStateNormal];
    [_rightBtn setImage:UIImageFileName(highImg) forState:UIControlStateSelected];
}

- (void)setIsShowIcon:(BOOL)isShowIcon
{
    if (_isShowIcon) {
        _leftBtn.iconPostion = _rightBtn.iconPostion = BIP_Left;
        _leftBtn.offset = _rightBtn.offset = 10;
    }else{
        _leftBtn.iconPostion = _rightBtn.iconPostion = BIP_None;
    }
}

- (void)clickBtn:(UIButton *)btn
{
    if (btn.tag == SBT_Left) {
        if (self.clickLeftBtn) {
            self.clickLeftBtn();
        }
    }else if(btn.tag == SBT_RiIght){
        if (self.clickRightBtn) {
            self.clickRightBtn();
        }
    }else{
        if (self.clickCenterBtn) {
            self.clickCenterBtn();
        }
    }
    [self updateSelectStatus:btn.tag];
}

- (void)updateSelectStatus:(NSInteger)selectedIndex
{
    if (selectedIndex == SBT_Left) {
        _leftBtn.selected = _rightLine.hidden =YES;
        _centerLine.hidden = YES;
        _rightBtn.selected = _leftLine.hidden = NO;
        _centerBtn.selected = NO;
    }else if(selectedIndex == SBT_RiIght){
        _leftBtn.selected =  _rightLine.hidden = NO;
        _centerLine.hidden = YES;
        _rightBtn.selected = _leftLine.hidden = YES;
        _centerBtn.selected = NO;
    }else{
        _leftBtn.selected = NO;
        _rightBtn.selected = NO;
        _centerBtn.selected = YES;
        _rightLine.hidden = YES;
        _leftLine.hidden = YES;
        _centerLine.hidden = NO;
}
}
@end
