//
//  LineView.h
//  Knowbox
//
//  Created by huxiulei on 15/1/11.
//  Copyright (c) 2015年 knowin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LineView : UIView

@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic) CGFloat lineWidth;


- (id)initWithWidth:(CGFloat)width;
- (id)initWithHeight:(CGFloat)height;


@end
