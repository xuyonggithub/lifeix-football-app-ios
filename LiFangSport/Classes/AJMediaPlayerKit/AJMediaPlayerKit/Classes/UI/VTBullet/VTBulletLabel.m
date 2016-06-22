//
//  VTBulletLabel.m
//  VTBulletDemo
//
//  Created by Zhangqibin on 2/24/16.
//  Copyright © 2016 Zhangqibin. All rights reserved.
//

#import "VTBulletLabel.h"
#import "VTBulletModel.h"

@implementation VTBulletLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _strokeWidth = 0.5f;
        _strokeColor = [UIColor blackColor];
        _showStroke = YES;
    }
    return self;
}

- (void)setBullet:(VTBulletModel *)bullet
{
    self.textColor = bullet.textColor;
    self.text = bullet.message;
    self.font = bullet.font;
}

- (void)drawTextInRect:(CGRect)rect
{
    if (!_showStroke) {
        [super drawTextInRect:rect];
        return;
    }
    
    CGSize shadowOffset = self.shadowOffset;
    UIColor *textColor = self.textColor;
    
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(c, _strokeWidth);
    CGContextSetLineJoin(c, kCGLineJoinRound);
    
    CGContextSetTextDrawingMode(c, kCGTextStroke);
    self.textColor = _strokeColor;
    [super drawTextInRect:rect];
    
    CGContextSetTextDrawingMode(c, kCGTextFill);
    self.textColor = textColor;
    self.shadowOffset = CGSizeMake(0, 0);
    [super drawTextInRect:rect];
    
    self.shadowOffset = shadowOffset;
}

@end
