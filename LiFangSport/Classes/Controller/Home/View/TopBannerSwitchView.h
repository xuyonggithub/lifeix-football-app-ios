//
//  TopBannerSwitchView.h
//  LiFangSport
//
//  Created by 张毅 on 16/6/14.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ClickLeftBtn)(void);
typedef void(^ClickCenterBtn)(void);
typedef void(^ClickRightBtn)(void);

@interface TopBannerSwitchView : UIView
@property (nonatomic, copy) NSString *leftTitleStr;
@property (nonatomic, copy) NSString *centerTitleStr;
@property (nonatomic, copy) NSString *rightTitleStr;
@property (nonatomic, assign) BOOL isShowIcon;
@property (nonatomic, strong) ClickLeftBtn clickLeftBtn;
@property (nonatomic, strong) ClickCenterBtn clickCenterBtn;
@property (nonatomic, strong) ClickRightBtn clickRightBtn;

- (void)setLeftIcon:(NSString *)normalImg HighImg:(NSString *)highImg;
- (void)setCenterIcon:(NSString *)normalImg HighImg:(NSString *)highImg;
- (void)setRighticon:(NSString *)normalImg HighImg:(NSString *)highImg;
- (void)updateSelectStatus:(NSInteger)selectedIndex;


@end
