//
//  CategoryView.h
//  LiFangSport
//
//  Created by Lifeix on 16/6/16.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickBtn)(CGFloat);

@interface CategoryView : UIView

@property(nonatomic, retain)NSArray *categoryArr;
@property (nonatomic, strong) ClickBtn ClickBtn;
@property(nonatomic,strong)UIColor *btnNormalColor;
@property(nonatomic,strong)UIColor *btnSelectColor;
@property(nonatomic,strong)UIColor *selectLineColor;

-(instancetype)initWithFrame:(CGRect)frame category:(NSArray *)categoryArr;
- (void)updateSelectStatus:(NSInteger)selectedIndex;

@end
