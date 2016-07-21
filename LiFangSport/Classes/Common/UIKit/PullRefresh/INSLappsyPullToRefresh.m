//
//  INSLappsyPullToRefresh.m
//  INSPullToRefresh
//
//  Created by Michał Zaborowski on 22.02.2015.
//  Copyright (c) 2015 inspace.io. All rights reserved.
//

#import "INSLappsyPullToRefresh.h"

@interface INSLappsyPullToRefresh ()
@property (nonatomic, strong) NSMutableArray *images;
@end

@implementation INSLappsyPullToRefresh

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        NSMutableArray *images = [[NSMutableArray alloc] init];

        for (int i = 1; i <= 30; i++) {
            [images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"hud_%d",i]]];
        }
        self.images = images;
        self.image = [images firstObject];

        self.animationImages = [[images objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(21, 9)]] arrayByAddingObjectsFromArray:[images objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 20)]]];
        self.animationDuration = 2.5;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.center = CGPointMake(CGRectGetMidX(self.superview.bounds), CGRectGetMidY(self.superview.bounds));
}

- (void)pullToRefreshBackgroundView:(INSPullToRefreshBackgroundView *)pullToRefreshBackgroundView didChangeState:(INSPullToRefreshBackgroundViewState)state {
    [self handleStateChange:state];
}

- (void)pullToRefreshBackgroundView:(INSPullToRefreshBackgroundView *)pullToRefreshBackgroundView didChangeTriggerStateProgress:(CGFloat)progress {
    [self handleProgress:progress forState:pullToRefreshBackgroundView.state];
}

- (void)handleProgress:(CGFloat)progress forState:(INSPullToRefreshBackgroundViewState)state {
    if (state == INSPullToRefreshBackgroundViewStateTriggered || state == INSPullToRefreshBackgroundViewStateNone) {
        if (progress > 0.2 && progress < 1.0) {
            [self stopAnimating];
            NSInteger frame = (NSInteger)((progress-0.2)/0.8 * 20);
            self.image = self.images[frame];
        }
        if (progress >= 1.0) {
            [self startAnimating];
        }
    }

}
- (void)handleStateChange:(INSPullToRefreshBackgroundViewState)state {
    if (state == INSPullToRefreshBackgroundViewStateNone) {
        [self stopAnimating];
    } else if (state == INSPullToRefreshBackgroundViewStateTriggered) {

    } else {
        [self startAnimating];
    }
}

@end
