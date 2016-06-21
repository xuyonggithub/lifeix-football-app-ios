//
//  VTBulletModel.h
//  VTBulletDemo
//
//  Created by tianzhuo on 2/23/16.
//  Copyright © 2016 tianzhuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *  单个弹幕对象
 */
@interface VTBulletModel : NSObject

/**
 *  消息内容
 */
@property (nonatomic, strong) NSString *message;
/**
 *  消息颜色
 */
@property (nonatomic, strong) UIColor *textColor;
/**
 *  消息字体，默认系统字体大小18
 */
@property (nonatomic, strong) UIFont *font;
/**
 *  消息显示时长
 */
@property (nonatomic, assign) CGFloat duration;
/**
 *  模型对象
 */
@property (nonatomic, strong) id model;
/**
 *  屏幕上显示的弹幕视图，默认自动创建
 */
@property (nonatomic, strong) UIView *bulletItem;

@end

@interface LEBubbletModel : VTBulletModel

/**
 *  角色，1:明星，2:运营，0:普通用户
 */
@property (nonatomic, copy) NSString *role;
/**
 *  弹幕图片
 */
@property (nonatomic, copy) NSString *image;
/**
 *  阵营，0:中立，1:主场，2:客场
 */
@property (nonatomic, copy) NSString *camp;
/**
 *  我的弹幕
 */
@property (nonatomic, assign) BOOL isMineBullet;

@end

/**
 *  弹道
 */
@interface VTBulletTrack : NSObject

/**
 *  弹道索引
 */
@property (nonatomic, assign) NSInteger trackIndex;
/**
 *  弹道位置
 */
@property (nonatomic, assign) CGPoint position;
/**
 *  弹道高度
 */
@property (nonatomic, assign) CGFloat height;
/**
 *  是否锁定，锁定时该弹道不可用
 */
@property (nonatomic, assign) BOOL isLocked;

@end