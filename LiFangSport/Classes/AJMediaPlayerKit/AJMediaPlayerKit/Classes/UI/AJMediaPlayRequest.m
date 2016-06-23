//
//  AJMediaPlayRequest.m
//  Pods
//
//  Created by Zhangqibin on 7/31/15.
//
//

#import "AJMediaPlayRequest.h"
#import "AJMediaPlayerUtilities.h"

@implementation AJMediaPlayRequest

- (instancetype)initWithVideoPath:(NSString *)videoPath type:(AJMediaPlayerItemType)type name:(NSString *)name uid:(NSString *)uid duration:(NSString *)duration
{
    self = [super init];
    if (self) {
        self.resourceName = name;
        self.type = type;
        self.videoPath = videoPath;
        self.uid = uid;
        self.duration = duration;
    }
    return self;
}

+ (instancetype)playRequestWithVideoPath:(NSString *)videoPath type:(AJMediaPlayerItemType)type name:(NSString *)name uid:(NSString *)uid {
    return [[[self class] alloc] initWithVideoPath:videoPath type:type name:name uid:uid duration:@""];
}

+ (instancetype)playRequestWithVideoPath:(NSString *)videoPath type:(AJMediaPlayerItemType)type name:(NSString *)name uid:(NSString *)uid duration:(NSString *)duration
{
    return [[[self class] alloc] initWithVideoPath:videoPath type:type name:name uid:uid duration:duration];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"PlayRequest: \"%@\" <%@:%@>", self.resourceName, aj_stringValueForPlayerItemType(self.type),self.videoPath];
}

@end
