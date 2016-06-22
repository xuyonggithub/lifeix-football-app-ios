//
//  AJMediaPlayerInfrastructureContext.h
//  Pods
//
//  Created by Zhangqibin on 5/22/15.
//
//

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

///\enum AJMediaPlayerInfrastructureLoggerOption
typedef NS_OPTIONS(NSInteger, AJMediaPlayerInfrastructureLoggerOption) {
    AJMediaPlayerInfrastructureConsoleLogging = 0x0001,
    AJMediaPlayerInfrastructureFileLogging = 0x0001 << 1,
    AJMediaPlayerInfrastructureNetworkingLogging = 0x0001 << 2
};


///\todo Since v2.0,  All facade server requests should be sent at player level --- Kipp
///\brief Each client needs to use mediaPlayer module should tell us these configurations


/**
 {
    "live_platid" : 10,
    "live_splatid" : 1031,
    "vod_platid" : 16,
    "vod_splatid" : 1601,
    "station_platid" : 10,
    "station_splatid" : 1031,
    "app_id" : 31234
 }

*/

typedef NS_ENUM(NSInteger, AJMediaStreamFormat) {
    AJMediaStreamFormatM3u8,
    AJMediaStreamFormatMp4
};

@interface AJMediaPlayerConfiguration : NSObject <NSCopying>
@property(nonatomic, copy) NSString *appIdentifier;
@property(nonatomic, copy) NSString *designatedLocalHLSServerPort;
@property(nonatomic, copy) NSString *liveBackendSubplatID;
@property(nonatomic, copy) NSString *liveBackendPlatID;
@property(nonatomic, copy) NSString *vrsBackendPlatID;
@property(nonatomic, copy) NSString *vrsBackendSubplatID;
@property(nonatomic, copy) NSString *stationClientID; //!\deprecated using liveBackendPlatID instead
@property(nonatomic, assign) AJMediaStreamFormat streamFormat;
@property(nonatomic, assign) BOOL enableDebug;
@property(nonatomic, assign) AJMediaPlayerInfrastructureLoggerOption loggingOption;
@property(nonatomic, copy) NSString *logMessageFileDirectoryPath;
@property(nonatomic, assign) BOOL useDistributionNetworkingApi;
@end

@interface AJMediaPlayerInfrastructureContext : NSObject
+ (AJMediaPlayerConfiguration *)settings;
+ (void)registerApplicationWithConfiguration:(nonnull AJMediaPlayerConfiguration *)playerConfiguration;
+ (int)cdeVersionNumber;
+ (NSString *)applicationIdentifier;
+ (NSString *)supportUrl;
+ (NSString *)supportUrlWithContactNumber:(NSString *)contactNumber;
+ (NSString *)stateUrl;
@end

NS_ASSUME_NONNULL_END

