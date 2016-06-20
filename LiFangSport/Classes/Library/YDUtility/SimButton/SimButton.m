//
//  SimButton.m
//  TKnowBox
//
//  Created by LiuXubin on 15/3/13.
//  Copyright (c) 2015年 knowin. All rights reserved.
//

#import "SimButton.h"
#import "UIImage+SimAdditions.h"

@interface SimButton()
{
    CGPoint _beginPoint;
    
    BOOL _dragTriggerd;
    NSTimer *_dragTimer;
}

@end

@implementation SimButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _minDragTriggerInterval = 0.2;
    }
    
    return self;
}

- (void)setOffset:(CGFloat)offset
{
    if (_offset != offset) {
        _offset = offset;
        if (_iconPostion == BIP_Left || _iconPostion == BIP_Right){
            [self setContentEdgeInsets:UIEdgeInsetsMake(0, _offset/2, 0, _offset/2)];
        }
        else if (_iconPostion == BIP_Top || _iconPostion == BIP_Bottom){
            [self setContentEdgeInsets:UIEdgeInsetsMake(_offset/2, 0, _offset/2, 0)];
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (_iconPostion != BIP_None) {
        [self.titleLabel sizeToFit];
        if (_iconPostion == BIP_Left || _iconPostion == BIP_Right) {
            self.titleLabel.width = MIN(self.width-_offset-4-self.imageView.width, self.titleLabel.width);
        }
        else{
            self.titleLabel.width = MIN(self.width-4, self.titleLabel.width);
        }
        if (_iconPostion == BIP_Left){
            CGFloat width = self.imageView.width + self.titleLabel.width + _offset;
            self.titleLabel.right = self.width/2 + width/2;
            self.imageView.left = self.width/2 - width/2;
        }
        else if (_iconPostion == BIP_Right) {
            CGFloat width = self.imageView.width + self.titleLabel.width + _offset;
            self.imageView.right = self.width/2 + width/2;
            self.titleLabel.left = self.width/2 - width/2;
        }
        else if (_iconPostion == BIP_Center) {
            self.imageView.centerX = self.width/2;
            self.titleLabel.centerX = self.width/2;
        }
        else if (_iconPostion == BIP_Top){
            CGFloat height = self.imageView.height + self.titleLabel.height + _offset;
            self.imageView.top = self.height/2 - height/2 + 2;
            self.titleLabel.bottom = self.height/2 + height/2 + 2;
            self.imageView.centerX = self.width/2;
            self.titleLabel.centerX = self.width/2;
        }
        else if (_iconPostion == BIP_Bottom) {
            CGFloat height = self.imageView.height + self.titleLabel.height + _offset;
            self.imageView.bottom = self.height/2 + height/2;
            self.titleLabel.top = self.height/2 - height/2;
            self.imageView.centerX = self.width/2;
            self.titleLabel.centerX = self.width/2;
        }
    }
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
}

#pragma mark -
- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state
{
    UIImage *image = [UIImage imageWithColor:backgroundColor];
    [self setBackgroundImage:image forState:state];
}

#pragma mark - drag
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_dragEnable) {
        UITouch *touch = [touches anyObject];
        _beginPoint = [touch locationInView:self];
        [self sendActionsForControlEvents:UIControlEventTouchDown];
        self.highlighted = YES;
        
        _dragTimer = [NSTimer scheduledTimerWithTimeInterval:self.minDragTriggerInterval target:self selector:@selector(triggerDrag) userInfo:nil repeats:NO];
    }
    else{
        [super touchesBegan:touches withEvent:event];
    }
}

- (void)triggerDrag
{
    _dragTriggerd = YES;
    [_dragTimer invalidate], _dragTimer = nil;
    self.alpha = 0.6;
    self.highlighted = NO;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_dragEnable) {
        if (_dragTriggerd) {
            UITouch *touch = [touches anyObject];
            CGPoint nowPoint = [touch locationInView:self];
            float offsetX = nowPoint.x - _beginPoint.x;
            float offsetY = nowPoint.y - _beginPoint.y;
            
            self.center = CGPointMake(self.center.x + offsetX, self.center.y + offsetY);
        }
    }
    else{
        [super touchesMoved:touches withEvent:event];
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    
    
    if (_dragEnable) {
        if (self.highlighted) {
            [self sendActionsForControlEvents:UIControlEventTouchUpInside];
            self.highlighted = NO;
        }
        
        if (_dragTimer) {
            [_dragTimer invalidate], _dragTimer = nil;
        }
        if (_dragTriggerd) {
            self.alpha = 1.0;
            _dragTriggerd = NO;
            
            if (self.superview && _adsorbEnable ) {
                float marginLeft = self.frame.origin.x;
                float marginRight = self.superview.frame.size.width - self.frame.origin.x - self.frame.size.width;
                //        float marginTop = self.frame.origin.y;
                //        float marginBottom = self.superview.frame.size.height - self.frame.origin.y - self.frame.size.height;
                [UIView animateWithDuration:0.125 animations:^(void){
                    /*if (marginTop<60) {
                     self.frame = CGRectMake(marginLeft<marginRight?marginLeft<_adsorPadding?_adsorPadding:self.frame.origin.x:marginRight<_adsorPadding?self.superview.frame.size.width -self.frame.size.width-_adsorPadding:self.frame.origin.x,
                     _adsorPadding,
                     self.frame.size.width,
                     self.frame.size.height);
                     }
                     else if (marginBottom<60) {
                     self.frame = CGRectMake(marginLeft<marginRight?marginLeft<_adsorPadding?_adsorPadding:self.frame.origin.x:marginRight<_adsorPadding?self.superview.frame.size.width -self.frame.size.width-_adsorPadding:self.frame.origin.x,
                     self.superview.frame.size.height - self.frame.size.height-_adsorPadding,
                     self.frame.size.width,
                     self.frame.size.height);
                     
                     }
                     else*/ {
                         CGFloat topY = MIN(MAX(0, self.frame.origin.y),  self.superview.frame.size.height-self.frame.size.height);
                         self.frame = CGRectMake(marginLeft<marginRight?_adsordPadding:self.superview.frame.size.width - self.frame.size.width-_adsordPadding,
                                                 topY,
                                                 self.frame.size.width,
                                                 self.frame.size.height);
                     }
                }];
            }
        }
    }
    else{
        [super touchesEnded:touches withEvent:event];
    }
}

@end
