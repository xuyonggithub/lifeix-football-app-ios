//
//  AJMediaPlayRequest.m
//  Pods
//
//  Created by Gang Li on 7/31/15.
//
//

#import "AJMediaPlayRequest.h"
#import "AJMediaPlayerUtilities.h"

@implementation AJMediaPlayRequest

- (instancetype)initWithIdentifier:(NSString *)identifier type:(AJMediaPlayerItemType)type name:(NSString *)name uid:(NSString *)uid duration:(NSString *)duration episodeid:(NSString *)episodeid channelEname:(NSString *)channelEname {
    self = [super init];
    if (self) {
        self.resourceName = name;
        self.type = type;
        self.identifier = identifier;
        self.uid = uid;
        self.duration = duration;
        self.episodeid = episodeid;
        self.channelEname = channelEname;
    }
    return self;
}

+ (instancetype)playRequestWithIdentifier:(NSString *)identifier type:(AJMediaPlayerItemType)type name:(NSString *)name uid:(NSString *)uid {
    return [[[self class] alloc] initWithIdentifier:identifier type:type name:name uid:uid duration:@"" episodeid:@"" channelEname:@""];
}

+ (instancetype)playRequestWithIdentifier:(NSString *)identifier type:(AJMediaPlayerItemType)type name:(NSString *)name uid:(NSString *)uid episodeid:(NSString *)episodeid {
    return [[[self class] alloc] initWithIdentifier:identifier type:type name:name uid:uid duration:@"" episodeid:episodeid channelEname:@""];
}

+ (instancetype)playRequestWithIdentifier:(NSString *)identifier type:(AJMediaPlayerItemType)type name:(NSString *)name uid:(NSString *)uid duration:(NSString *)duration {
    return [[[self class] alloc] initWithIdentifier:identifier type:type name:name uid:uid duration:duration episodeid:@"" channelEname:@""];
}

+ (instancetype)playRequestWithIdentifier:(NSString *)identifier type:(AJMediaPlayerItemType)type name:(NSString *)name uid:(NSString *)uid channelEname:(NSString *)channelEname {
    return [[[self class] alloc] initWithIdentifier:identifier type:type name:name uid:uid duration:@"" episodeid:@"" channelEname:channelEname];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"PlayRequest: \"%@\" <%@:%@>", self.resourceName, aj_stringValueForPlayerItemType(self.type),self.identifier];
}

@end
