//
//  UIImage+Additions.m
//  CheckLists
//
//  Created by Marcel Ruegenberg on 25.10.10.
//  Copyright 2010 Dustlab. All rights reserved.
//

#import "UIImage+Additions.h"
#import <QuartzCore/QuartzCore.h>


@implementation UIImage (Scaling)

+ (UIImage*)imageFromView:(UIView*)view
{
    CGSize viewSize = view.bounds.size;
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, view.window.screen.scale);
    if ([view respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
        [view drawViewHierarchyInRect:CGRectMake(0, 0, viewSize.width, viewSize.height) afterScreenUpdates:YES];
    } else {
        CGContextRef imageContext = UIGraphicsGetCurrentContext();
        [view.layer renderInContext:imageContext];
    }
    UIImage *previewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    return previewImage;
}

+ (UIImage*)imageFromView:(UIView*)view scaledToSize:(CGSize)newSize
{
    UIImage *image = [self imageFromView:view];
    if ([view bounds].size.width != newSize.width ||
		[view bounds].size.height != newSize.height) {
        image = [self imageWithImage:image scaledToSize:newSize];
    }
    return image;
}

+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
	UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
    return newImage;
}

@end

@implementation UIImage (Additions)

- (UIImage *)horizontallyStretchedImage {
    CGFloat s = ((self.size.width - 1) / 2.0);
    return [self resizableImageWithCapInsets:UIEdgeInsetsMake(0, s, 0, s)];
}

@end
