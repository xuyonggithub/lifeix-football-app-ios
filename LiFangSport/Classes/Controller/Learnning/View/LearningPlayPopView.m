//
//  LearningPlayPopView.m
//  LiFangSport
//
//  Created by 张毅 on 16/6/23.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import "LearningPlayPopView.h"

@interface LearningPlayPopView ()
@property(nonatomic,strong)UIButton *closeBtn;
@end

@implementation LearningPlayPopView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}

-(void)initSubViews{
    _closeBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    _closeBtn.right = self.width;
    _closeBtn.backgroundColor = [UIColor redColor];
    [_closeBtn setImage:UIImageNamed(@"popclose") forState:UIControlStateNormal];
    
    [self addSubview:_closeBtn];
    [_closeBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    
    
    
}

-(void)close{
    if (self.closeBc) {
        self.closeBc();
    }
}

@end
