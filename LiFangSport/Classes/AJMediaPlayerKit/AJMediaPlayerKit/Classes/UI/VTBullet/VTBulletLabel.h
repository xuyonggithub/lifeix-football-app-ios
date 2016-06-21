//
//  VTBulletLabel.h
//  VTBulletDemo
//
//  Created by tianzhuo on 2/24/16.
//  Copyright © 2016 tianzhuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VTBulletModel;
@interface VTBulletLabel : UILabel

/**
 *  弹幕子弹模型
 */
@property (nonatomic, strong) VTBulletModel *bullet;
/**
 *  是否需要描边
 */
@property (nonatomic, assign) BOOL showStroke;
/**
 *  描边颜色，默认黑色
 */
@property (nonatomic, strong) UIColor *strokeColor;
/**
 *  描边宽度，默认0.5f
 */
@property (nonatomic, assign) CGFloat strokeWidth;


@end
