//
//  UIImageView+UserInfo.m
//  Knowbox
//
//  Created by LiuXubin on 15/1/23.
//  Copyright (c) 2015年 knowin. All rights reserved.
//

#import "UIImageView+UserInfo.h"
#import <objc/runtime.h>

@implementation UIImageView (UserInfo)

static char KN_UIImageViewUserInfoPrivateKey;

- (void)setUserInfo:(id)userInfo
{
    objc_setAssociatedObject(self, &KN_UIImageViewUserInfoPrivateKey, userInfo, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)userInfo
{
    return objc_getAssociatedObject(self, &KN_UIImageViewUserInfoPrivateKey);
}


@end
