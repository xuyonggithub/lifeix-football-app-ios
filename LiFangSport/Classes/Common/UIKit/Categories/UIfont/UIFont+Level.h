//
//  UIFont+Level.h
//  RapidCalculation
//
//  Created by rjb on 15/9/23.
//  Copyright © 2015年 knowin. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kFontLvl   2    //在原有项目基础做的字体大小的提高

@interface UIFont (Level)

+ (UIFont *)simSystemFontOfSize:(CGFloat)fontSize;
+ (UIFont *)simBoldSystemFontOfSize:(CGFloat)fontSize;
@end
