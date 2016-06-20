//
//  UIButton+SimAdditions.m
//  piano
//
//  Created by Liu Xubin on 13-9-7.
//  Copyright (c) 2013年 Liu Xubin. All rights reserved.
//

#import "UIButton+SimAdditions.h"
#import "UIView+SimAdditions.h"
#import "SimDefine.h"

#define kFont [UIFont systemFontOfSize:15]
#define kTextColor HEXRGBCOLOR(0x4a576c)

@implementation UIButton (SimAdditions)


+ (instancetype)btnWithImageNames:(NSArray *)imageNames{
    return [self btnWithImageNames:imageNames btnSize:CGSizeMake(0, 0) isBackgroud:NO];
}

// 指定按钮的size
+ (instancetype)btnWithImageNames:(NSArray *)imageNames btnSize:(CGSize)btnSize{
    return [self btnWithImageNames:imageNames btnSize:btnSize isBackgroud:NO];
}

+ (instancetype)btnWithImageNames:(NSArray *)imageNames isBackgroud:(BOOL)isBackgroud{
    return [self btnWithImageNames:imageNames btnSize:CGSizeMake(0, 0) isBackgroud:isBackgroud];
}

+ (instancetype)btnWithImageNames:(NSArray *)imageNames btnSize:(CGSize)btnSize isBackgroud:(BOOL)isBackgroud{
    
    UIButton *btn = nil;
    if (imageNames.count > 0) {
        UIImage *btnImage = [UIImage imageNamed:[imageNames objectAtIndex:0]];
        if (btnSize.width == 0) {
            btnSize.width = btnImage.size.width;
        }
        if (btnSize.height == 0){
            btnSize.height = btnImage.size.height;
        }
        
        btn = [[self alloc] initWithFrame:CGRectMake(0, 0, btnSize.width, btnSize.height)];
        if (isBackgroud) {
            [btn setBackgroundImage:btnImage forState:UIControlStateNormal];
        }
        else{
            [btn setImage:btnImage forState:UIControlStateNormal];
        }
        for (int i = 1; i < imageNames.count; i++) {
            NSString *imageName = [imageNames objectAtIndex:i];
            if (imageName.length > 0) {
                UIControlState state =  UIControlStateHighlighted << (i-1);
                if (isBackgroud) {
                    [btn setBackgroundImage:[UIImage imageNamed:imageName] forState:state];
                }
                else{
                    [btn setImage:[UIImage imageNamed:imageName] forState:state];
                }
            }
        }
    }
    
    return btn;
}

- (void)setBackgroundImageByColor:(UIColor *)backgroundColor forState:(UIControlState)state{
    
    // tcv - temporary colored view
    UIView *tcv = [[UIView alloc] initWithFrame:self.frame];
    [tcv setBackgroundColor:backgroundColor];
    
    // set up a graphics context of button's size
    CGSize gcSize = tcv.frame.size;
    UIGraphicsBeginImageContext(gcSize);
    // add tcv's layer to context
    [tcv.layer renderInContext:UIGraphicsGetCurrentContext()];
    // create background image now
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    // set image as button's background image for the given state
    [self setBackgroundImage:image forState:state];
    UIGraphicsEndImageContext();
    
    // ensure rounded button
    self.clipsToBounds = YES;
    self.layer.cornerRadius = 5.0;
}
- (void)setBackgroundImageByColor:(UIColor *)backgroundColor withcornerRadius:(CGFloat)radius forState:(UIControlState)state{
    
    // tcv - temporary colored view
    UIView *tcv = [[UIView alloc] initWithFrame:self.frame];
    [tcv setBackgroundColor:backgroundColor];
    
    // set up a graphics context of button's size
    CGSize gcSize = tcv.frame.size;
    UIGraphicsBeginImageContext(gcSize);
    // add tcv's layer to context
    [tcv.layer renderInContext:UIGraphicsGetCurrentContext()];
    // create background image now
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    // set image as button's background image for the given state
    [self setBackgroundImage:image forState:state];
    UIGraphicsEndImageContext();
    
    // ensure rounded button
    self.clipsToBounds = YES;
    self.layer.cornerRadius = radius;
}
+ (UIButton *)buttonWithText:(NSString *)string target:(id)target action:(SEL)sel bgImageName:(NSArray *)backImageNames{
    
    UIImage *_barBtnImage = nil;
    UIButton* _button = [[UIButton alloc] init];
    [_button addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    [_button setTitle:string forState:UIControlStateNormal];
    [_button setTitleColor:kTextColor forState:UIControlStateNormal];
    [_button.titleLabel setFont:kFont];
    if ([string isEqualToString:@"返回"]) {//just wk
        [_button setTitleEdgeInsets:UIEdgeInsetsMake(0, 1, 0, 0)];
    }
    
    if (backImageNames.count > 0) {
        _barBtnImage = [UIImage imageNamed:[backImageNames objectAtIndex:0]];
        _button.frame = CGRectMake(0, 0, _barBtnImage.size.width, _barBtnImage.size.height);
        [_button setBackgroundImage:_barBtnImage forState:UIControlStateNormal];
        for (int i = 1; i < backImageNames.count; i++) {
            NSString *_imageName = [backImageNames objectAtIndex:i];
            if (![backImageNames isEqual:[NSNull null]]) {
                UIControlState _state = UIControlStateHighlighted << (i-1);
                [_button setBackgroundImage:[UIImage imageNamed:_imageName] forState:_state];
            }
        }
    }
    else{
        [_button sizeToFit];
        _button.width += 20;
        _button.height += 12;
        
        /*
         set the origin top & left specially for the bug VSM-5338: 在线button的位置异常
         so the button won't move during the parent view is playing animation
         */
        _button.left = 5;
        _button.top = 7;
        
        _button.backgroundColor = RGBCOLOR(9,182,104);
        [_button setBackgroundImageByColor:RGBCOLOR(0,150,83) forState:UIControlStateHighlighted];
        _button.layer.borderWidth = 1;
        _button.layer.cornerRadius = 1;
        _button.layer.borderColor = [RGBCOLOR(1,130,71) CGColor];
        
        
    }
    
    return _button;
}

@end
