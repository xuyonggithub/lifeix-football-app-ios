//
//  AJMediaPlayerInfrastructureContext.m
//  Pods
//
//  Created by Gang Li on 5/22/15.
//
//

@import UIKit;
#import "AJMediaPlayerInfrastructureContext.h"
#import "AJMediaPlayerInfrastructureContext_Internal.h"
#import "AJFoundation.h"
#import <Reachability/Reachability.h>
#import "AJFoundation.h"
#import "AJMediaPlayer.h"

#define kCDEServiceLogFileName @"cde-service.log"

NSString * const CDEServiceErrorDomain = @"com.lesports.cde.error";
static volatile AJMediaPlayerInfrastructureContext *__aj_mediaplayer_infrastructure_ctxt;

@interface AJCloudService ()
@property(nonatomic ,strong)NSURL *localCachePath;
@property(nonatomic ,copy)NSString *stopUrl;

@property(nonatomic, copy, readwrite) NSString * currentPlayURL;
@property(nonatomic, copy, readwrite) NSString * currentLinkshellURL;
- (void)activate;
- (void)invalidate;

@end

@implementation AJCloudService

- (instancetype)initWithConfiguration:(AJMediaPlayerConfiguration *)configuration {
    self = [super init];
    if (self) {
        NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
        NSString *logFilePath = [configuration.logMessageFileDirectoryPath stringByAppendingPathComponent:kCDEServiceLogFileName];
        NSString *params = [NSString stringWithFormat:@"port=%@&app_id=%@&auto_active=1&data_dir=%@&log_type=4&log_file=%@&app_version=%@",configuration.designatedLocalHLSServerPort, configuration.appIdentifier, cachePath, logFilePath,[[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"]];
    }
    return self;
}

- (void)activate {

}

- (void)invalidate {

}

-(void)syncSecuredStreamURLWithSchedulingURL:(NSString *)schedulingURL success:(void (^)(NSError *error, NSURL *cdeLinkUrl))completionHandler {
    
}

-(NSURL *)securedStreamURLWithSchedulingURL:(NSString *)schedulingURL {
    return nil;
}

-(NSURL *)securedSchedulingURL:(NSString *)schedulingURL {
    return nil;
}

-(void)stopSchedulingURL{
    if (!self.stopUrl) {
        return;
    }
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"GET"];
    [request setURL:[NSURL URLWithString:self.stopUrl]];
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if (!error && [httpResponse statusCode] == 200) {
            self.stopUrl = nil;
        } else {
            //Make a error and deliver to someone who concern about -- Kipp
            aj_logMessage(AJLoggingError, @"CDE service stop url with error %@, HTTP status code %li", self.stopUrl, (long)[httpResponse statusCode]);
        }
        dispatch_semaphore_signal(semaphore);
    }] resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
}

@end

@interface AJMediaPlayerInfrastructureContext ()
@property(nonatomic, strong)NSOperationQueue *operationQueue;
@property(nonatomic, strong)AJCloudService *cloudService;
@property(nonatomic, assign)BOOL isCloudServiceReady;
@property(nonatomic, copy) AJMediaPlayerConfiguration *configuration;
+ (void)bootstrap;
@end

@implementation AJMediaPlayerInfrastructureContext {
    id __appLifecycleObserver;
}

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (__aj_mediaplayer_infrastructure_ctxt == nil) {
            __aj_mediaplayer_infrastructure_ctxt = [[AJMediaPlayerInfrastructureContext alloc] init];
        }
    });
}

+ (void)registerApplicationWithConfiguration:(nonnull AJMediaPlayerConfiguration *)playerConfiguration {
    ///\note Honor configurations feature
    if (playerConfiguration) {
        __aj_mediaplayer_infrastructure_ctxt.configuration = playerConfiguration;
    }
    AJCloudService *cloudService = [[AJCloudService alloc] initWithConfiguration:playerConfiguration];
    __aj_mediaplayer_infrastructure_ctxt.cloudService = cloudService;
    aj_logMessage(AJLoggingInfo, @"CDE (version: %@) service registerred with an application: id = %@, bundle = %@",@( [[self class] cdeVersionNumber]), playerConfiguration.appIdentifier, [[NSBundle bundleForClass:self] infoDictionary][(NSString *) kCFBundleIdentifierKey]);
    UIDevice *device = [UIDevice currentDevice];
    [device setBatteryMonitoringEnabled:YES];
    [[self class] bootstrap];
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NSDictionary *deviceInfo = @{@"system name" :device.systemName,
                                 @"system version" :device.systemVersion,
                                 @"model" : device.localizedModel,
                                 @"battery status" : @(device.batteryState),
                                 @"battery level" : [NSString stringWithFormat:@"%@%%", @(device.batteryLevel * 100.f)],
                                 @"networking status" : reachability.isReachable ? @"enabled" : @"disabled",
                                 @"networking type" : reachability.isReachableViaWiFi ? @"Wifi" : @"3G"};
    aj_logMessage(AJLoggingDebug, @"Current Device Info: %@", deviceInfo);
}

+ (AJMediaPlayerConfiguration *)settings {
    return __aj_mediaplayer_infrastructure_ctxt.configuration;
}

+ (NSString *)applicationIdentifier {
    return __aj_mediaplayer_infrastructure_ctxt.configuration.appIdentifier;
}

+ (int)cdeVersionNumber {
    return 0;
   
}

+ (NSString *)supportUrl {
    return nil;
}

+ (NSString *)supportUrlWithContactNumber:(NSString *)contactNumber {
   return nil;
}

+ (NSString *)stateUrl {
   return nil;
}

+ (void)bootstrap {
    [__aj_mediaplayer_infrastructure_ctxt addObservers];
}

+ (AJCloudService *)cloudService {
    return __aj_mediaplayer_infrastructure_ctxt.cloudService;
}


- (void)addObservers {
    if (!self.operationQueue) {
        self.operationQueue = [[NSOperationQueue alloc] init];
    }
    
    __appLifecycleObserver = [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidBecomeActiveNotification
                                                      object:nil
                                                       queue:self.operationQueue
                                                  usingBlock:^(NSNotification *note) {
                                                      //Fisrt of all, checkup for cleaning deprecated log files
                                                      //Clean up all log file except these created at yesterday and today, that means we only remains last 2 days log files
                                                      NSDate *today = [NSDate date];
                                                      NSFileManager *fileManager = [NSFileManager defaultManager];
                                                      NSMutableArray *filesNeedToDelete = [NSMutableArray array];
                                                      NSDateComponents *components = [[NSDateComponents alloc] init];
                                                      [components setDay:-1];
                                                      
                                                      NSDate *yesterday = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:today options:0];
                                                      NSString *yesterdayDailyLogName = [NSString stringWithFormat:@"%@%@",kPlayerDailyLogFilePrefix,aj_loggingDateFormattedString(yesterday)];
                                                      NSString *todayDailyLogName = [NSString stringWithFormat:@"%@%@",kPlayerDailyLogFilePrefix,aj_loggingDateFormattedString(today)];
                                                      [[fileManager contentsOfDirectoryAtPath:[AJMediaPlayerInfrastructureContext settings].logMessageFileDirectoryPath error:nil] enumerateObjectsUsingBlock:^(NSString *logName, NSUInteger idx, BOOL *stop) {
                                                          if (!([logName hasPrefix:yesterdayDailyLogName] || [logName hasPrefix:todayDailyLogName] || [logName isEqualToString:kCDEServiceLogFileName])) {
                                                              [filesNeedToDelete addObject:logName];
                                                          }
                                                      }];
                                                      
                                                      [filesNeedToDelete enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                                          NSString *fileNeedToDeletePath = [NSString stringWithFormat:@"%@%@", [AJMediaPlayerInfrastructureContext settings].logMessageFileDirectoryPath,obj];
                                                          [fileManager removeItemAtPath:fileNeedToDeletePath error:nil];
                                                      }];

                                                      [self activateCloudDataEntryService];
                                                      aj_logMessage(AJLoggingInfo, @"Application did become active, thus CDE service has also been activated");
                                                      
    }];
}

- (void)activateCloudDataEntryService {
    if (!self.cloudService) {
        return;
    }
    [self.cloudService activate];
}

- (BOOL)isCloudServiceReady {
    return YES;
}

+ (BOOL)isCloudServiceReady {
    return __aj_mediaplayer_infrastructure_ctxt.isCloudServiceReady;
}

- (void)dealloc {
    if (__appLifecycleObserver) {
        [[NSNotificationCenter defaultCenter] removeObserver:__appLifecycleObserver name:UIApplicationDidBecomeActiveNotification object:nil];
    }
}


@end

@implementation AJMediaPlayerConfiguration

-(instancetype)init {
    self = [super init];
    if (self) {
        self.loggingOption = AJMediaPlayerInfrastructureConsoleLogging | AJMediaPlayerInfrastructureFileLogging;
        self.enableDebug = NO;
        self.useDistributionNetworkingApi = NO;
        self.logMessageFileDirectoryPath = NSTemporaryDirectory();
        self.designatedLocalHLSServerPort = @"6990";
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

@end
