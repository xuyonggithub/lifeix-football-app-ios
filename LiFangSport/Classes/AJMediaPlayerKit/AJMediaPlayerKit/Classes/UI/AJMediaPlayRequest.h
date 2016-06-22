//
//  AJMediaPlayRequest.h
//  Pods
//
//  Created by Zhangqibin on 7/31/15.
//
//

#import <Foundation/Foundation.h>
#import "AJMediaPlayerHeaders.h"

NS_ASSUME_NONNULL_BEGIN
@interface AJMediaPlayRequest : NSObject
@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, copy) NSString *resourceName;
@property (nonatomic, assign) AJMediaPlayerItemType type;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *duration;
@property (nonatomic, copy) NSString *episodeid;
@property (nonatomic, copy) NSString *channelEname;

+ (instancetype)playRequestWithIdentifier:(NSString *)identifier type:(AJMediaPlayerItemType)type name:(NSString *)name uid:(NSString *)uid;
+ (instancetype)playRequestWithIdentifier:(NSString *)identifier type:(AJMediaPlayerItemType)type name:(NSString *)name uid:(NSString *)uid duration:(NSString *)duration;
+ (instancetype)playRequestWithIdentifier:(NSString *)identifier type:(AJMediaPlayerItemType)type name:(NSString *)name uid:(NSString *)uid episodeid:(NSString *)episodeid;
+ (instancetype)playRequestWithIdentifier:(NSString *)identifier type:(AJMediaPlayerItemType)type name:(NSString *)name uid:(NSString *)uid channelEname:(NSString *)channelEname;

@end
NS_ASSUME_NONNULL_END
