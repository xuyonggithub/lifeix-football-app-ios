//
//  AJMediaStreamProvider.h
//  Pods
//
//  Created by Gang Li on 5/22/15.
//
//

@import Foundation;
@class AJMediaPlayerItem;
@class AVPlayerItem;
@protocol AJMediaStreamProvider <NSObject>
@optional
-(void)cancelTasks;
@required
-(void)loadPlayableItemWithMetadata:(AJMediaPlayerItem *)schedulingMetadata timeshift:(int)timeshift withParameter:(NSString *)parameter completionHandler:(void (^)(NSError *err, AVPlayerItem *item))completionHandler;
@end

@interface AJAbstractMediaStreamProvider : NSObject <AJMediaStreamProvider>
+(instancetype)provider;
@end

@interface AJLetvCDEStreamProviderImplementation : AJAbstractMediaStreamProvider //using CDE module
@end

@interface AJDefaultStreamProviderImplementation :  AJAbstractMediaStreamProvider //without CDE module
@end
