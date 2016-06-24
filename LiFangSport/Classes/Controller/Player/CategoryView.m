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
@interface CategoryView()

@property(nonatomic, retain)UIScrollView *categaryScrollView;

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
    _categaryScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _categaryScrollView.backgroundColor = kclearColor;
    _categaryScrollView.showsHorizontalScrollIndicator = NO;
    _categaryScrollView.showsVerticalScrollIndicator = NO;
    CGFloat btnHeight = _categaryScrollView.height;
    self.categaryScrollView.contentSize = CGSizeMake(0, 40);
    for(int i = 0; i < numOfCategory; i++){
        NSDictionary *attribute = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize: 20] forKey:NSFontAttributeName];
        CGRect contnentRect = [self.categoryArr[i] boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil];
//        CGFloat btnWidth = contnentRect.size.width;
        
//        SimButton *button = [[SimButton alloc] initWithFrame:CGRectMake(self.categaryScrollView.contentSize.width, 0, btnWidth, btnHeight)];
//        button.titleLabel.font = [UIFont systemFontOfSize:kbtnFont];
//        [button setTitleColor:kBasicColor forState:UIControlStateNormal];
//        [button setTitleColor:kDetailTitleColor forState:UIControlStateSelected];
//        [button setTitle:self.categoryArr[i] forState:UIControlStateNormal];
//        button.selected = (i == 0)?YES:NO;
//        button.tag = kbtnTag + i;
//        button.backgroundColor = kclearColor;
//        [button addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
//        [_categaryScrollView addSubview:button];
//        
//        LineView *lineView = [[LineView alloc] initWithFrame:CGRectMake(self.categaryScrollView.contentSize.width, button.bottom - 3, btnWidth, 2)];
//        lineView.lineColor = kDetailTitleColor;
//        lineView.hidden = (i == 0)?NO:YES;
//        lineView.tag = klineTag + i;
//        [_categaryScrollView addSubview:lineView];
        
        CGSize size = self.categaryScrollView.contentSize;
        size.width += contnentRect.size.width;
        self.categaryScrollView.contentSize = size;
    }
    if(self.categaryScrollView.contentSize.width < SCREEN_WIDTH){
        for(int i = 0; i < numOfCategory; i++){
            SimButton *button = [[SimButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH/numOfCategory) * i, 0, SCREEN_WIDTH/numOfCategory, btnHeight)];
            button.titleLabel.font = [UIFont systemFontOfSize:kbtnFont];
            [button setTitleColor:kBasicColor forState:UIControlStateNormal];
            [button setTitleColor:kDetailTitleColor forState:UIControlStateSelected];
            [button setTitle:self.categoryArr[i] forState:UIControlStateNormal];
            button.selected = (i == 0)?YES:NO;
            button.tag = kbtnTag + i;
            button.backgroundColor = kclearColor;
            [button addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
            [_categaryScrollView addSubview:button];
            
            LineView *lineView = [[LineView alloc] initWithFrame:CGRectMake(button.left, button.bottom - 3, button.width, 2)];
            lineView.lineColor = kDetailTitleColor;
            lineView.hidden = (i == 0)?NO:YES;
            lineView.tag = klineTag + i;
            [_categaryScrollView addSubview:lineView];

        }
    }else{
        self.categaryScrollView.contentSize = CGSizeMake(0, 40);
        for(int i = 0; i < numOfCategory; i++){
            NSDictionary *attribute = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize: 20] forKey:NSFontAttributeName];
            CGRect contnentRect = [self.categoryArr[i] boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil];
            CGFloat btnWidth = contnentRect.size.width;
            
            SimButton *button = [[SimButton alloc] initWithFrame:CGRectMake(self.categaryScrollView.contentSize.width, 0, btnWidth, btnHeight)];
            button.titleLabel.font = [UIFont systemFontOfSize:kbtnFont];
            [button setTitleColor:kBasicColor forState:UIControlStateNormal];
            [button setTitleColor:kDetailTitleColor forState:UIControlStateSelected];
            [button setTitle:self.categoryArr[i] forState:UIControlStateNormal];
            button.selected = (i == 0)?YES:NO;
            button.tag = kbtnTag + i;
            button.backgroundColor = kclearColor;
            [button addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
            [_categaryScrollView addSubview:button];
            
            LineView *lineView = [[LineView alloc] initWithFrame:CGRectMake(self.categaryScrollView.contentSize.width, button.bottom - 3, btnWidth, 2)];
            lineView.lineColor = kDetailTitleColor;
            lineView.hidden = (i == 0)?NO:YES;
            lineView.tag = klineTag + i;
            [_categaryScrollView addSubview:lineView];
            
            CGSize size = self.categaryScrollView.contentSize;
            size.width += contnentRect.size.width;
            self.categaryScrollView.contentSize = size;
        }
    }
    [self addSubview:_categaryScrollView];
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

-(void)setBtnNormalColor:(UIColor *)btnNormalColor{
    
    for(int i = 0; i< _categoryArr.count; i++){
        SimButton *button = (SimButton *)[self viewWithTag:i + kbtnTag];
        [button setTitleColor:btnNormalColor forState:UIControlStateNormal];
    }
}
-(void)setBtnSelectColor:(UIColor *)btnSelectColor{
    for(int i = 0; i< _categoryArr.count; i++){
        SimButton *button = (SimButton *)[self viewWithTag:i + kbtnTag];
        [button setTitleColor:btnSelectColor forState:UIControlStateSelected];
    }
}

-(void)setSelectLineColor:(UIColor *)selectLineColor{
    for(int i = 0; i< _categoryArr.count; i++){
        LineView *lineView = (LineView *)[self viewWithTag:i + klineTag];
        lineView.lineColor = selectLineColor;
    }
}

@end
