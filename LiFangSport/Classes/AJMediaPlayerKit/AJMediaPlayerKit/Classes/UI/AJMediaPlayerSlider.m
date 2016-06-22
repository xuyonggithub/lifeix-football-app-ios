//
//  AJMediaPlayerSlider.m
//  Pods
//
//  Created by Zhangqibin on 16/1/19.
//
//

#import "AJMediaPlayerSlider.h"

@implementation AJMediaPlayerSlider

- (CGRect)trackRectForBounds:(CGRect)bounds
{
    bounds = [super trackRectForBounds:bounds];
    return CGRectMake(bounds.origin.x, bounds.origin.y, bounds.size.width, 3);
}


@end
