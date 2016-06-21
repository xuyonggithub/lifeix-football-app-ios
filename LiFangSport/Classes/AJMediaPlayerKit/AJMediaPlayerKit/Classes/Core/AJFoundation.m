//
//  AJFoundation.m
//  Pods
//
//  Created by Gang Li on 8/14/15.
//
//

#import "AJFoundation.h"
#import "AJMediaPlayerInfrastructureContext_Internal.h"


NSString *aj_loggingDateFormattedString_f(NSDate *date) {
    NSString *lastDateString = [[NSUserDefaults standardUserDefaults] objectForKey:@"kLastLoggingCreateDateKey"];
    NSDateFormatter *fileNameFormatter = [[NSDateFormatter alloc] init];
    [fileNameFormatter setDateFormat:@"yyyy-MM-dd"];
    [fileNameFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT+08:00"]];
    NSString *currentDateString = [fileNameFormatter stringFromDate:date];
    if (![currentDateString isEqualToString:lastDateString]) {
        [[NSUserDefaults standardUserDefaults] setObject:currentDateString forKey:@"kLastLoggingCreateDateKey"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return currentDateString;
    }
    
    return lastDateString;
}

void aj_logMessage_f(AJLoggingLevel logLevel,const char *filename,int lineNumber, const char * functionName, NSString *format, ...) {
    va_list arglist;
    va_start(arglist, format);
    NSString *message = [[NSString alloc] initWithFormat:format arguments:arglist];
    va_end(arglist);
    
    @autoreleasepool {
        NSDate *today = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.sss"];
        [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT+08:00"]]; // 取北京时间
        NSString *dateTimeLoggingContentString = [formatter stringFromDate:today];
        
        NSString *level = @"DEBUG";
        switch (logLevel) {
            case AJLoggingInfo:
                level = @"INFO";
                break;
            case AJLoggingError:
                level = @"ERROR";
                break;
            case AJLoggingWarn:
                level = @"WARN";
                break;
            case AJLoggingDebug:
                level = @"DEBUG";
                break;
            case AJLoggingFatal:
                level = @"FATAL";
                break;
            default:
                break;
        }
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *fileString = [[[NSString stringWithUTF8String:filename] componentsSeparatedByString:@"/"] lastObject];
        NSString *log = [NSString stringWithFormat:@"[%@][%@] - %@(%@) |- %@\n", dateTimeLoggingContentString, level, fileString, @(lineNumber), message];
        if ([[AJMediaPlayerInfrastructureContext settings] loggingOption] & AJMediaPlayerInfrastructureConsoleLogging) {
            printf("** %s", [log cStringUsingEncoding:NSUTF8StringEncoding]);
        }
        
        if ([[AJMediaPlayerInfrastructureContext settings] loggingOption] & AJMediaPlayerInfrastructureFileLogging) {
            NSString *dailyLogFileNamePrefix = [NSString stringWithFormat:@"%@%@",kPlayerDailyLogFilePrefix,aj_loggingDateFormattedString_f(today)];
            
            NSArray *stuffs = [fileManager contentsOfDirectoryAtPath:[AJMediaPlayerInfrastructureContext settings].logMessageFileDirectoryPath error:nil];
            __block NSInteger fileNumber = 0;
            [stuffs enumerateObjectsUsingBlock:^(NSString *files, NSUInteger idx, BOOL *stop) {
                BOOL isLogFile = [files hasSuffix:@".log"] && [files hasPrefix:kPlayerDailyLogFilePrefix];
                if (isLogFile) {
                    NSString *fileName = [files substringToIndex:files.length - @".log".length];
                    NSArray *components = [fileName componentsSeparatedByString:@" "];
                    if ([components count] > 1) {
                        fileNumber = fileNumber > [components[1] integerValue] ? fileNumber : [components[1] integerValue];
                    }
                }
            }];
            
            NSString *finalFileName = nil;
            if (fileNumber > 0) {
                finalFileName = [NSString stringWithFormat:@"%@ %@.log",dailyLogFileNamePrefix, @(fileNumber)];
            } else {
                finalFileName = [NSString stringWithFormat:@"%@.log", dailyLogFileNamePrefix];
            }
            NSString *finalFilePath = [NSString stringWithFormat:@"%@%@", [AJMediaPlayerInfrastructureContext settings].logMessageFileDirectoryPath,finalFileName];
            NSDictionary *attributes = [fileManager attributesOfItemAtPath:finalFilePath error:nil];
            long long fileSize = [attributes[NSFileSize] longLongValue];
            
            if (fileSize >= 5 * 1024 * 1024) {
                finalFileName = [NSString stringWithFormat:@"%@%@ %@.log",kPlayerDailyLogFilePrefix,aj_loggingDateFormattedString_f(today), @(fileNumber + 1)];
                finalFilePath = [[AJMediaPlayerInfrastructureContext settings].logMessageFileDirectoryPath stringByAppendingPathComponent:finalFileName];
            }
            
            
            if (![fileManager fileExistsAtPath:finalFilePath]) {
                [fileManager createFileAtPath:finalFilePath contents:nil attributes:nil];
            }
            NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:finalFilePath];
            if(handle){
                [handle seekToEndOfFile];
                [handle writeData:[log dataUsingEncoding:NSUTF8StringEncoding]];
                [handle closeFile];
            }
        }
    }
}