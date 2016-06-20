//
//  CategoryView.m
//  LiFangSport
//
//  Created by Lifeix on 16/6/16.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import "CategoryView.h"
#import "SimButton.h"
#import "LineView.h"

#define kbtnFont 15
#define kbtnTag 1000
#define klineTag 2000
@interface CategoryView(){
    
}
@end

@implementation CategoryView

-(instancetype)initWithFrame:(CGRect)frame category:(NSArray *)categoryArr{
    self = [super initWithFrame:frame];
    if(self){
        self.categoryArr = [NSArray arrayWithArray:categoryArr];
        [self showContent];
    }
    return self;
}

-(void)showContent{
    CGFloat numOfCategory = self.categoryArr.count;
    UIView *categoryView = [[UIView alloc] initWithFrame:self.bounds];
    categoryView.backgroundColor = kclearColor;
    CGFloat btnWidth = categoryView.width / numOfCategory;
    CGFloat btnHeight = categoryView.height;
    for(int i = 0; i < numOfCategory; i++){
        SimButton *button = [[SimButton alloc] initWithFrame:CGRectMake(btnWidth * i, 0, btnWidth, btnHeight)];
        button.titleLabel.font = [UIFont systemFontOfSize:kbtnFont];
        [button setTitleColor:kBasicColor forState:UIControlStateNormal];
        [button setTitleColor:kDetailTitleColor forState:UIControlStateSelected];
        [button setTitle:self.categoryArr[i] forState:UIControlStateNormal];
        button.selected = (i == 0)?YES:NO;
        button.tag = kbtnTag + i;
        button.backgroundColor = kclearColor;
        [button addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [categoryView addSubview:button];
        
        LineView *lineView = [[LineView alloc] initWithFrame:CGRectMake(btnWidth * i, button.bottom - 3, btnWidth, 2)];
        lineView.lineColor = kDetailTitleColor;
        lineView.hidden = (i == 0)?NO:YES;
        lineView.tag = klineTag + i;
        [categoryView addSubview:lineView];
    }
    [self addSubview:categoryView];
}

- (void)clickBtn:(UIButton *)btn{
    CGFloat index = btn.tag - kbtnTag;
    if(self.ClickBtn){
        self.ClickBtn(index);
    }
    [self updateSelectStatus:index];
}

- (void)updateSelectStatus:(NSInteger)selectedIndex{
    CGFloat numOfCategory = self.categoryArr.count;
    for(int i = 0; i< numOfCategory; i++){
        SimButton *button = (SimButton *)[self viewWithTag:i + kbtnTag];
        LineView *lineView = (LineView *)[self viewWithTag:i + klineTag];
        button.selected = (button.tag == selectedIndex + kbtnTag)?YES:NO;
        lineView.hidden = (lineView.tag == selectedIndex + klineTag)?NO:YES;
    }
}
@end
