//
//  UIFont+Level.m
//  RapidCalculation
//
//  Created by rjb on 15/9/23.
//  Copyright © 2015年 knowin. All rights reserved.
//

#import "UIFont+Level.h"
@implementation UIFont (Level)
+ (UIFont *)simSystemFontOfSize:(CGFloat)fontSize
{
    if (kFontLvl == 1) {
        return [self systemFontOfSize:fontSize+1];
    }else if(kFontLvl == 2){
        return [self systemFontOfSize:fontSize+2];
    }else if(kFontLvl ==3){
        return [self systemFontOfSize:fontSize+3];
    }else if(kFontLvl == 4){
        return [self systemFontOfSize:fontSize+4];
    }else{
        return [self systemFontOfSize:fontSize];
    }
}

+ (UIFont *)simBoldSystemFontOfSize:(CGFloat)fontSize
{
    if (kFontLvl == 1) {
        return [self boldSystemFontOfSize:fontSize+1];
    }else if(kFontLvl == 2){
        return [self boldSystemFontOfSize:fontSize+2];
    }else if(kFontLvl ==3){
        return [self boldSystemFontOfSize:fontSize+3];
    }else if(kFontLvl == 4){
        return [self boldSystemFontOfSize:fontSize+4];
    }else{
        return [self boldSystemFontOfSize:fontSize];
    }
    
}

@end
