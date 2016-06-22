//
//  AJMediaIndicatorView.h
//  Pods
//
//  Created by Zhangqibin on 15/8/17.
//
//

#import <UIKit/UIKit.h>

@interface AJMediaIndicatorView : UIView

@property (nonatomic) CGFloat lineWidth;
@property (nonatomic) BOOL hidesWhenStopped;
@property (nonatomic, strong) CAMediaTimingFunction *timingFunction;
@property (nonatomic, readonly) BOOL isAnimating;

- (void)setAnimating:(BOOL)animate;

/**
 *  Starts animation of the spinner.
 */
- (void)startAnimating;

/**
 *  Stops animation of the spinnner.
 */
- (void)stopAnimating;

@end
