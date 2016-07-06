//
//  RefereeCatePopView.h
//  LiFangSport
//
//  Created by 卢亚林 on 16/7/5.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RefereeCatePopViewDelegate<NSObject>

-(void)popViewDidSelectCategory:(NSString *)cate;

@end

@interface RefereeCatePopView : UIView

@property(nonatomic, assign)id<RefereeCatePopViewDelegate> delegate;

@end
