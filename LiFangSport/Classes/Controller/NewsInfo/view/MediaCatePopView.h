//
//  MediaCatePopView.h
//  LiFangSport
//
//  Created by 卢亚林 on 16/6/27.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MediaCatePopViewDelegate<NSObject>

-(void)popViewDidSelectCategory:(NSString *)cateId andName:(NSString *)name;

@end

@interface MediaCatePopView : UIView

@property(nonatomic, assign)id<MediaCatePopViewDelegate> delegate;

@end
