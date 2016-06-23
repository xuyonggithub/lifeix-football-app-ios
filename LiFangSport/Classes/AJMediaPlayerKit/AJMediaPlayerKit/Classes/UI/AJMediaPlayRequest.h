//
//  AJMediaPlayRequest.h
//  Pods
//
//  Created by Zhangqibin on 7/31/15.
//
//  播放单元

#import <Foundation/Foundation.h>
#import "AJMediaPlayerHeaders.h"

NS_ASSUME_NONNULL_BEGIN
@interface AJMediaPlayRequest : NSObject
@property (nonatomic, copy) NSString *videoPath;    //  播放路径
@property (nonatomic, copy) NSString *resourceName; //  题目
@property (nonatomic, assign) AJMediaPlayerItemType type;   //  类型
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *duration;

+ (instancetype)playRequestWithVideoPath:(NSString *)videoPath type:(AJMediaPlayerItemType)type name:(NSString *)name uid:(NSString *)uid;

+ (instancetype)playRequestWithVideoPath:(NSString *)videoPath type:(AJMediaPlayerItemType)type name:(NSString *)name uid:(NSString *)uid duration:(NSString *)duration;

@end
NS_ASSUME_NONNULL_END
