//
//  AJMediaPlayerFeedback.m
//  Pods
//
//  Created by Gang Li on 8/24/15.
//
//

#import "AJMediaPlayerFeedback.h"
#import "AJFoundation.h"
#import "AJMediaPlayerInfrastructureContext_Internal.h"

#define GET_REMOTE_ADDRESS @"http://www.letvhelp.com/getRemoteIP.php?c=setRemoteIP_27173852&r=14416320127289917"
#define GET_DSN_INFO @"http://www.letvhelp.com/getLocalDNS.php?c=setLocalDNS_27173852&k=27173852&r=14416320131548588"

#define kPlaceholderDeviceModel     @"%%__device_model__%%"
#define kPlaceholderSystemName      @"%%__system_name__%%"
#define kPlaceholderSystemVersion   @"%%__system_version__%%"
#define kPlaceholderDeviceName      @"%%__device_name__%%"
#define kPlaceholderAppName         @"%%__app_name__%%"
#define kPlaceholderAppVersion      @"%%__app_version__%%"
#define kPlaceholderDeviceUDID      @"%%__device_udid__%%"
#define kPlaceholderCDEServiceCode  @"%%__cde_service_code__%%"
#define kPlaceholderStartupTime     @"%%__startup_timestamp__%%"
#define kPlaceholderIPAddress       @"%%__ip_address__%%"
#define kPlaceholderLocalDNS        @"%%__local_dns__%%"
#define kPlaceholderSchedulingAddr  @"%%__scheduling_address__%%"
#define kPlaceholderSchedulingInfo  @"%%__scheduling_info__%%"

@interface AJNetworkCondition : NSObject<NSCopying>
@property(nonatomic, copy) NSString *remoteIPInfo;
@property(nonatomic, copy) NSString *localDNSInfo;
+(instancetype)capture;
@end

@interface AJMediaPlayerFeedback ()
@property(nonatomic, copy) AJNetworkCondition *networkCondition;
@property(nonatomic, copy) NSString *systemName;
@property(nonatomic, copy) NSString *systemVersion;
@property(nonatomic, copy) NSString *deviceModel;
@property(nonatomic, copy) NSString *appName;
@property(nonatomic, copy) NSString *appVersion;
@property(nonatomic, copy) NSString *deviceName;

@end

@implementation AJMediaPlayerFeedback

- (instancetype)initWithSchedulingUri:(NSString *)uri cdnInfo:(NSDictionary *)cdnInfo {
    self = [super init];
    if (self) {
        self.currentSchedulingUri = uri ?: @"N/A";
        self.cdnInfo = cdnInfo;
        UIDevice *currentDevice = [UIDevice currentDevice];
        self.systemName = currentDevice.systemName;
        self.systemVersion = currentDevice.systemVersion;
        self.deviceModel = currentDevice.localizedModel;
        self.deviceName = currentDevice.name;
        NSBundle *targetBundle = [NSBundle bundleForClass:[self class]];
        self.appName = [NSString stringWithFormat:@"%@ : %@", [targetBundle infoDictionary][@"CFBundleName"], [targetBundle infoDictionary][@"CFBundleIdentifier"]];
        self.appVersion = [targetBundle infoDictionary][@"CFBundleShortVersionString"];
        self.networkCondition = [AJNetworkCondition capture];
    }
    return self;
}

- (NSArray *)mailRecipients {
    NSString *receiverPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"feedback_recipients" ofType:@"plist"];
    NSData *data = [NSData dataWithContentsOfFile:receiverPath];
    id content = [NSPropertyListSerialization propertyListWithData:data options:NSPropertyListImmutable format:NULL error:nil];
    NSParameterAssert([content isKindOfClass:[NSDictionary class]]);
    NSDictionary *receivers = content;
    NSMutableArray *formattedReceivers = [NSMutableArray array];
    [receivers enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSString *formattedReceiver = [NSString stringWithFormat:@"%@<%@>", key, obj];
        [formattedReceivers addObject:formattedReceiver];
    }];
    return formattedReceivers;
}

- (NSString *)complaintEmailContent {
    return nil;
}

- (NSString *)feedbackEmailContent {
    NSString *templatePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"feedback_email_template" ofType:@"html"];
    NSString *templateContent = [NSString stringWithContentsOfFile:templatePath encoding:NSUTF8StringEncoding error:nil];
    @try {
        templateContent = [templateContent stringByReplacingOccurrencesOfString:kPlaceholderDeviceModel withString:self.deviceModel];
        templateContent = [templateContent stringByReplacingOccurrencesOfString:kPlaceholderAppName withString:self.appName];
        templateContent = [templateContent stringByReplacingOccurrencesOfString:kPlaceholderAppVersion withString:self.appVersion];
        templateContent = [templateContent stringByReplacingOccurrencesOfString:kPlaceholderDeviceName withString:self.deviceName];
        templateContent = [templateContent stringByReplacingOccurrencesOfString:kPlaceholderIPAddress withString:self.networkCondition.remoteIPInfo];
        templateContent = [templateContent stringByReplacingOccurrencesOfString:kPlaceholderLocalDNS withString:self.networkCondition.localDNSInfo];
        templateContent = [templateContent stringByReplacingOccurrencesOfString:kPlaceholderSystemVersion withString:self.systemVersion];
        templateContent = [templateContent stringByReplacingOccurrencesOfString:kPlaceholderSystemName withString:self.systemName];
        
        templateContent = [templateContent stringByReplacingOccurrencesOfString:kPlaceholderSchedulingAddr withString:self.currentSchedulingUri];
        
        NSString *replacement = self.cdnInfo[@"CDN_info"] ? [self.cdnInfo[@"CDN_info"] description]: @"N/A";
        templateContent = [templateContent stringByReplacingOccurrencesOfString:kPlaceholderSchedulingInfo withString:replacement];
        replacement = self.cdnInfo[@"CDE_code"] ? : @"N/A";
        templateContent = [templateContent stringByReplacingOccurrencesOfString:kPlaceholderCDEServiceCode withString:replacement];
    }
    @catch (NSException *exception) {
        aj_logMessage(AJLoggingError, @"Compose feedback email content, exception happends %@", exception);
    }
    return templateContent;
}

@end



@implementation AJNetworkCondition

-(instancetype)init {
    self = [super init];
    if (self) {
        self.localDNSInfo = @"N/A";
        self.remoteIPInfo = @"N/A";
    }
    return self;
}

-(instancetype)copyWithZone:(NSZone *)zone {
    return self;
}

+(instancetype)capture {
    AJNetworkCondition *condition = [[AJNetworkCondition alloc] init];
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"GET"];
    [request setURL:[NSURL URLWithString:GET_REMOTE_ADDRESS]];
    [request setTimeoutInterval:1.5f];
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        BOOL ok = (!error && [httpResponse statusCode] == 200);
        if (ok) {
            @try {
                NSString *message = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                aj_logMessage(AJLoggingInfo, @"captured device IP address info : %@", message);
                NSArray *components = [message componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"()"]];
                condition.remoteIPInfo = components[1];
            }
            @catch (NSException *exception) {
                aj_logMessage(AJLoggingError, @"capture device IP, exception raising: %@", exception);
            }
        } else {
            aj_logMessage(AJLoggingWarn, @"capture device IP failed with error %@", error);
        }
        
        NSMutableURLRequest *request2 = [[NSMutableURLRequest alloc] init];
        [request2 setHTTPMethod:@"GET"];
        [request2 setURL:[NSURL URLWithString:GET_DSN_INFO]];
        [request2 setTimeoutInterval:1.5f];
        [[[NSURLSession sharedSession] dataTaskWithRequest:request2 completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            BOOL ok = (!error && [httpResponse statusCode] == 200);
            if (ok) {
                @try {
                    NSString *message = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    aj_logMessage(AJLoggingInfo, @"captured device DNS server address info : %@", message);
                    NSArray *components = [message componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"()"]];
                    condition.localDNSInfo = components[1];
                }
                @catch (NSException *exception) {
                    aj_logMessage(AJLoggingError, @"capture device DNS server info, exception raising: %@", exception);
                }
            } else {
                aj_logMessage(AJLoggingWarn, @"capture device DNS server info failed with error %@", error);
            }
            dispatch_semaphore_signal(semaphore);
        }] resume];
    }] resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return condition;
}

@end
