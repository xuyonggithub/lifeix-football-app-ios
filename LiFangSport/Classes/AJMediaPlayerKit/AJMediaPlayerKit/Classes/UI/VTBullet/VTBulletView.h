//
//  VTBulletView.h
//  VTBulletDemo
//
//  Created by tianzhuo on 2/22/16.
//  Copyright © 2016 tianzhuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VTBulletModel.h"

typedef NS_ENUM(NSInteger, VTBulletState) {
    /** 开启状态，默认 */
    VTBulletStateOpened,
    /** 暂停状态 */
    VTBulletStatePaused,
    /** 停止状态 */
    VTBulletStateStoped,
};

@class VTBulletView;
@protocol VTBulletViewDataSource <NSObject>

@optional
/**
 *  根据弹幕模型生成对应弹幕视图
 *
 *  @param bulletView self
 *  @param model      弹幕模型
 *
 *  @return 弹幕视图
 */
- (UIView *)bulletView:(VTBulletView *)bulletView itemForModel:(VTBulletModel *)model;

@end

@interface VTBulletView : UIView

/**
 *  弹幕集合
 */
@property (nonatomic, strong) NSArray<__kindof VTBulletModel *> *bulletList;
/**
 *  弹道数，默认6
 */
@property (nonatomic, assign) NSInteger trackCount;
/**
 *  缓冲弹幕发射时间间隔，默认0.1s
 */
@property (nonatomic, assign) CGFloat bufferInterval;
/**
 *  弹幕中单个字符的显示时长，默认8s
 *  总时长还需算上当前速度下，移动弹幕长度的距离所需的时间
 */
@property (nonatomic, assign) CGFloat bulletDuration;
/**
 *  视频总时长
 */
@property (nonatomic, assign) CGFloat duration;
/**
 *  弹幕状态
 */
@property (nonatomic, assign) VTBulletState state;
/**
 *  数据源
 */
@property (nonatomic, weak) id<VTBulletViewDataSource> dataSource;

/**
 *  开启弹幕
 */
- (void)start;
/**
 *  暂停弹幕
 */
- (void)pause;
/**
 *  恢复弹幕
 */
- (void)resume;
/**
 *  停止弹幕
 */
- (void)stop;
/**
 *  清空所有缓冲弹幕
 */
- (void)clearBuffer;
/**
 *  发射单个弹幕
 *
 *  @param bullet 单枚子弹消息
 */
- (void)shootBullet:(VTBulletModel *)bullet;

@end
