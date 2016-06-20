//
//  UIImageAdditions.m
//  SecretCamera
//
//  Created by Xubin Liu on 14-4-29.
//  Copyright (c) 2014年 Xubin Liu. All rights reserved.
//

#import "UIImageAdditions.h"

@implementation UIImage (SimCategory)


+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *)stretchableImageWithCenter {
    return [self stretchableImageWithPoint:CGPointMake(self.size.width/2, self.size.height/2)];
}

- (UIImage *)stretchableImageWithPoint:(CGPoint)point
{
    UIEdgeInsets inset = UIEdgeInsetsMake(point.y-1, point.x-1, self.size.height-point.y, self.size.width-point.x);
    return [self stretchableImageWithEdgeInsets:inset];

}

- (UIImage *)stretchableImageWithEdgeInsets:(UIEdgeInsets)insets {
    @autoreleasepool {
        UIImage *stretchImg = nil;
        if ([self respondsToSelector:@selector(resizableImageWithCapInsets:resizingMode:)]) {
            stretchImg = [self resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
        } else if ([self respondsToSelector:@selector(stretchableImageWithLeftCapWidth:topCapHeight:)]) {
            stretchImg = [self stretchableImageWithLeftCapWidth:insets.left topCapHeight:insets.top];
        }
        return stretchImg;
    }
}

// mask the original image and return a new UIImage object
- (UIImage *)maskImageWithMask:(UIImage*)mask {
    CGImageRef imgRef = [self CGImage];
    CGImageRef maskRef = [mask CGImage];
    CGImageRef actualMask = CGImageMaskCreate(CGImageGetWidth(maskRef),
                                              CGImageGetHeight(maskRef),
                                              CGImageGetBitsPerComponent(maskRef),
                                              CGImageGetBitsPerPixel(maskRef),
                                              CGImageGetBytesPerRow(maskRef),
                                              CGImageGetDataProvider(maskRef), NULL, false);
    CGImageRef masked = CGImageCreateWithMask(imgRef, actualMask);
    UIImage *image = [UIImage imageWithCGImage:masked];
    CGImageRelease(masked);
    CGImageRelease(actualMask);
    return image;
}

- (UIImage*)scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContextWithOptions(newSize, NO, self.scale);
    [self drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
