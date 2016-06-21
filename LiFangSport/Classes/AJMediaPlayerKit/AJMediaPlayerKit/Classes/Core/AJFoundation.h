//
//  AJFoundation.h
//  Pods
//
//  Created by Gang Li on 8/14/15.
//
//

@import Foundation;

typedef NS_ENUM(NSUInteger, AJLoggingLevel) {
    AJLoggingInfo,
    AJLoggingDebug,
    AJLoggingWarn,
    AJLoggingError,
    AJLoggingFatal
};

#define AJLocalizedString(key) \
[[NSBundle bundleForClass:[self class]] localizedStringForKey:key value:@"" table:nil]

#define aj_logMessage(logLevel, ...) aj_logMessage_f(logLevel,__FILE__,__LINE__,__FUNCTION__,__VA_ARGS__)
#define aj_loggingDateFormattedString(d) aj_loggingDateFormattedString_f(d)

#ifdef __cplusplus
extern "C"{
#endif
    extern NSString * aj_loggingDateFormattedString_f(NSDate *date);
    extern void aj_logMessage_f(AJLoggingLevel logLevel,const char *filename,int lineNumber, const char * functionName, NSString *format, ...);
#ifdef __cplusplus
}
#endif