//
//  SimCommonTool.m
//  TKnowBox
//
//  Created by Xubin Liu on 14-9-17.
//  Copyright (c) 2014年 Xubin Liu. All rights reserved.
//

#import "SimCommonTool.h"
#import "SimDefine.h"
#include <sys/xattr.h>
#import <AVFoundation/AVFoundation.h>
#import <mach/mach_time.h>
#import <CommonCrypto/CommonDigest.h>


@implementation SimCommonTool

+ (BOOL)skipICloud:(NSString*)urlString{
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"5.1")) {
        if([[NSFileManager defaultManager] fileExistsAtPath:urlString]){
            NSURL *url = [NSURL fileURLWithPath:urlString];
            if (!url) {
                urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                url = [NSURL fileURLWithPath:urlString];
            }
            
            if(url){
                NSError *error = nil;
                BOOL success = [url setResourceValue: [NSNumber numberWithBool: YES]
                                              forKey: NSURLIsExcludedFromBackupKey error: &error];
                if(!success){
                    NSLog(@"Error excluding %@ from backup %@", [urlString lastPathComponent], error);
                }
                return success;
            }
        }
    }
    else if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"5.0.1")){
        const char* filePath = [urlString fileSystemRepresentation];
        const char* attrName = "com.apple.MobileBackup";
        u_int8_t attrValue = 1;
        
        int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
        return result == 0;
    }
    return NO;
}

+ (void)checkRecordPermission:(GrantedBlock)grantedBlock{
    if ([[AVAudioSession sharedInstance] respondsToSelector:@selector(requestRecordPermission:)]) {
        [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (granted) {
                    grantedBlock(YES);
                }
                else{
                    NSString *msg = [NSString stringWithFormat:@"当前麦克风不可用，请到“设置-隐私-麦克风”中，开启“%@”后重试", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]];
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                                        message:msg delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
                    [alertView show];
                }
                
            });
        }];
    }
    else{
        grantedBlock(YES);
    }
}

static UIStatusBarStyle barStyle = -1;
+ (void)saveStatusBarStyle
{
    barStyle = [[UIApplication sharedApplication] statusBarStyle];
}

+ (void)restoreStatusBarStyle
{
    if(barStyle > 0){
        [[UIApplication sharedApplication] setStatusBarStyle:barStyle];
        barStyle = -1;
    }
}


+ (CGFloat)visibleKeyboardHeight {
    
    UIWindow *keyboardWindow = nil;
    for (UIWindow *testWindow in [[UIApplication sharedApplication] windows]) {
        if(![[testWindow class] isEqual:[UIWindow class]]) {
            keyboardWindow = testWindow;
            break;
        }
    }
    
    for (__strong UIView *possibleKeyboard in [keyboardWindow subviews]) {
        if([possibleKeyboard isKindOfClass:NSClassFromString(@"UIPeripheralHostView")] || [possibleKeyboard isKindOfClass:NSClassFromString(@"UIKeyboard")])
            return possibleKeyboard.bounds.size.height;
    }
    
    return 0;
}

+ (NSDate *)dateFromString:(NSString *)string format:(NSString *)format
{
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:format];
    return [inputFormatter dateFromString:string];
}

+ (NSString *)stringFromDate:(NSDate *)date format:(NSString *)format
{
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:format];
    return [inputFormatter stringFromDate:date];
}
#define OneTimeCall(x) \
{ static BOOL UniqueTokenMacro = NO; \
    if (!UniqueTokenMacro) {x; UniqueTokenMacro = YES; }}

uint64_t NanosecondsFromTimeInterval(uint64_t timeInterval)
{
    static struct mach_timebase_info timebase_info;
    OneTimeCall(mach_timebase_info(&timebase_info));
    timeInterval *= timebase_info.numer;
    timeInterval /= timebase_info.denom;
    return timeInterval;
}


uint64_t tickCountOfCPU(void)
{
    return mach_absolute_time();
}
NSString * mdsString(NSString *string)
{
    const char *cStr = [string UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    return [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],result[8], result[9], result[10], result[11],result[12], result[13], result[14], result[15]];
}


@end
