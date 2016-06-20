//
//  UIButton+SimAdditions.h
//
//  Created by Liu Xubin on 13-9-7.
//  Copyright (c) 2013年 Liu Xubin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIButton (SimAdditions)

+ (instancetype)btnWithImageNames:(NSArray *)imageNames;
+ (instancetype)btnWithImageNames:(NSArray *)imageNames btnSize:(CGSize)btnSize;
+ (instancetype)btnWithImageNames:(NSArray *)imageNames isBackgroud:(BOOL)isBackgroud;
+ (instancetype)buttonWithText:(NSString *)string target:(id)target action:(SEL)sel bgImageName:(NSArray *)backImageNames;

- (void)setBackgroundImageByColor:(UIColor *)backgroundColor forState:(UIControlState)state;
- (void)setBackgroundImageByColor:(UIColor *)backgroundColor withcornerRadius:(CGFloat)radius forState:(UIControlState)state;


@end
