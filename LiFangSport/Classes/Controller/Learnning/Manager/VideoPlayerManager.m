//
//  VideoPlayerManager.m
//  ModuoGM
//
//  Created by 张毅 on 16/5/29.
//  Copyright © 2016年 com.knowbox. All rights reserved.
//

#import "VideoPlayerManager.h"

@implementation VideoPlayerManager

+(instancetype)shareKnowInstance
{
    static id managerInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        managerInstance = [[self alloc] init];
    });
    return managerInstance;
}


@end
