//
//  LineView.m
//  Knowbox
//
//  Created by huxiulei on 15/1/11.
//  Copyright (c) 2015年 knowin. All rights reserved.
//

#import "LineView.h"


@implementation LineView

- (id)init
{
    self = [super initWithFrame:CGRectMake(0, 0, 0.5, 0.5)];
    if (self) {
        _lineWidth = 0.5;
        _lineColor = HEXRGBCOLOR(0xe6e6e6);
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (id)initWithWidth:(CGFloat)width
{
    if (self = [self init]) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.width = width;
    }
    
    return self;
}

- (id)initWithHeight:(CGFloat)height
{
    if (self = [self init]) {
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        self.height = height;
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [_lineColor set];
    CGContextFillRect(context, rect);
}


@end
