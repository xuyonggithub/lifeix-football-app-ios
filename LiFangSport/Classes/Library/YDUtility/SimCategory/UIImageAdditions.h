//
//  UIImageAdditions.h
//  SecretCamera
//
//  Created by Xubin Liu on 14-4-29.
//  Copyright (c) 2014年 Xubin Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImage (SimCategory)

+ (UIImage *)imageWithColor:(UIColor *)color;

- (UIImage *)stretchableImageWithCenter;
- (UIImage *)stretchableImageWithPoint:(CGPoint)point;
- (UIImage *)stretchableImageWithEdgeInsets:(UIEdgeInsets)insets;

- (UIImage *)maskImageWithMask:(UIImage*)mask;

- (UIImage*)scaledToSize:(CGSize)newSize;

@end
