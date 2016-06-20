//
//  SimDefine.h
//
//  Created by Liu Xubin on 13-8-30.
//  Copyright (c) 2013年 Liu Xubin. All rights reserved.
//

#ifndef SimDefine_h
#define SimDefine_h

//#define APP_DELEGATE (AppDelegate *)[UIApplication sharedApplication].delegate

#define SCREEN_WIDTH [[UIScreen mainScreen]bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen]bounds].size.height

#define kApplicationTop (ABOVE_IOS7 ? 0 : 20)  //App显示，对于屏幕的实际Y坐标。
#define kAppRenderTop (ABOVE_IOS7 ? 20 : 0)    //View的绘制需要的起始Y坐标

//Color
#ifndef RGBCOLOR
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define HEXRGBCOLOR(h) RGBCOLOR(((h>>16)&0xFF), ((h>>8)&0xFF), (h&0xFF))
#define HEXRGBACOLOR(h,a) RGBACOLOR(((h>>16)&0xFF), ((h>>8)&0xFF), (h&0xFF), a)
#endif

//Device
#define DEVICE_IS_IPHONE (UIUserInterfaceIdiomPhone == UI_USER_INTERFACE_IDIOM())
#define DEVICE_IS_IPAD (UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM())

#define IPHONE_4 (fabs(CGRectGetHeight([UIScreen mainScreen].bounds) - 480.f) < FLT_EPSILON)
#define IPHONE_5 (fabsf(CGRectGetHeight([UIScreen mainScreen].bounds) - 568.f) < FLT_EPSILON)
#define IPHONE_6 (fabsf(CGRectGetHeight([UIScreen mainScreen].bounds) - 667.f) < FLT_EPSILON)
#define IPHONE_6_PLUS (fabsf(CGRectGetHeight([UIScreen mainScreen].bounds) - 960.f) < FLT_EPSILON)
#define DEVICE_IS_IPHONE (UIUserInterfaceIdiomPhone == UI_USER_INTERFACE_IDIOM())
#define DEVICE_IS_IPAD (UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM())

//System version
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define IOS_VERSION_FLOAT [[[UIDevice currentDevice] systemVersion] floatValue]

#define kApplicationTop (ABOVE_IOS7 ? 0 : 20)  //App显示，对于屏幕的实际Y坐标。
#define kAppRenderTop (ABOVE_IOS7 ? 20 : 0)    //View的绘制需要的起始Y坐标

#define kAppStatusBarHeight 20
#define kAppNavBarHeight  44

//Image
#define UIImageViewNamed(_fileName_)        [[UIImageView alloc] initWithImage:UIImageNamed(_fileName_)]

//Array
#define ObjectsArray(...) [NSArray arrayWithObjects:__VA_ARGS__, nil]
#define ObjectsMutArray(...) [NSMutableArray arrayWithObjects:__VA_ARGS__, nil]

//Notification
#define DECL_NOTIFICATION(notification) extern NSString* notification;
#define IMPL_NOTIFICATION(notification) NSString* notification = @#notification;

//Key
#define DECLARE_KEY( key ) FOUNDATION_EXPORT NSString *const key;
#define DEFINE_KEY( key ) NSString *const key = @ #key;
#define DEFINE_KEY_WITH_VALUE( key, property ) NSString *const key = @ #property;

//Class
#define CLASS_NAME NSStringFromClass([self class])

//Memory
#define SafeRelease(_obj_) [_obj_ release], _obj_ = nil;
#define InvalidateTime(_timer_) [_timer_ invalidate], _timer_ = nil;

//Warning
#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)


//Exception
#define IgnoreException(Stuff)\
@try { \
Stuff \
} \
@catch (NSException *exception) {}

//
#define SafeSyncOnMainThread(Stuff)\
if([NSThread isMainThread]){\
Stuff\
}\
else{\
dispatch_sync(dispatch_get_main_queue(), ^{\
Stuff\
});\
}\

#define FloatEqual(_first, _second) (fabsf( _first - _second ) < FLT_EPSILON)
#define IsKindOfClass(_object, _class) [_object isKindOfClass:[_class class]]

//Time
#define SECOND_MINUTE   60
#define SECOND_HOUR     (60 * SECOND_MINUTE)
#define SECOND_DAY      (24 * SECOND_HOUR)

//Block
#define Weak(__Obj__) weak_##__Obj__
#define DefineWeak(__Obj__) __weak typeof(__Obj__) Weak(__Obj__) = __Obj__
#define Strong(__Obj__) strong_##__Obj__
#define DefineStrong(__Obj__) __strong typeof(__Obj__) Strong(__Obj__) = __Obj__

#define IndexPathKey(__indexPath__) [NSString stringWithFormat:@"%ld:%ld", (long)__indexPath__.row, (long)__indexPath__.section];

typedef void(^FinishBlock)(void);
typedef void(^CompleteBlock)(BOOL success);
typedef void(^ErrorBlock)(NSError *error);
typedef void(^HeightChangedBlock)(CGFloat height);


//text size
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
#define SIM_TEXTSIZE(text, font) [text length] > 0 ? [text \
sizeWithAttributes:@{NSFontAttributeName:font}] : CGSizeZero;
#else
#define SIM_TEXTSIZE(text, font) [text length] > 0 ? [text sizeWithFont:font] : CGSizeZero;
#endif

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
#define SIM_MULTILINE_TEXTSIZE(text, font, maxSize, mode) [text length] > 0 ? [text \
boundingRectWithSize:maxSize options:(NSStringDrawingUsesLineFragmentOrigin) \
attributes:@{NSFontAttributeName:font} context:nil].size : CGSizeZero;
#else
#define SIM_MULTILINE_TEXTSIZE(text, font, maxSize, mode) ([text length] > 0 ? [text \
sizeWithFont:font constrainedToSize:maxSize lineBreakMode:mode] : CGSizeZero);
#endif
#define SIM_MULTILINE_TEXTSIZE2(text, font, maxSize)  \
SIM_MULTILINE_TEXTSIZE(text, font, maxSize, NSLineBreakByWordWrapping)

#define SIM_TRIM_EMPTY(_string_) [_string_ stringByTrimmingCharactersInSet:[NSMutableCharacterSet whitespaceAndNewlineCharacterSet]]

//CustomSetting
#define SimDefineValue(_name_, _type_)  \
void setValue_##_name_(_type_ value);

#define SimImpValue(_name_, _type_)  \
static _type_ _name_ = nil; \
void setValue_##_name_(_type_ value) \
{ \
_name_ = value; \
}

#define SimValue(_name_, _default_)  _name_ ? : _default_
#define SimSetValue(_name_, _value_)        setValue_##_name_(_value_);

#endif
