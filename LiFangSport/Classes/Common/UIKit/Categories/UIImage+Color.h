//
//  UIImage+Color.h
//
//  Created by jiangxiaolong on 13-11-16.
//  Copyright (c) 2013年 jiangxiaolong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Color)

+ (UIImage *)createImageWithColor:(UIColor *)color;
+ (UIImage *)createImageWithColor:(UIColor *)color withSize:(CGSize)size;
@end
