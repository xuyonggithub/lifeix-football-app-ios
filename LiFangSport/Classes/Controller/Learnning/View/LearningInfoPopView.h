//
//  LearningInfoPopView.h
//  LiFangSport
//
//  Created by 张毅 on 16/6/27.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^LearningInfoPopViewBC)(NSInteger);

@interface LearningInfoPopView : UIView

-(instancetype)initWithFrame:(CGRect)frame WithData:(NSArray*)arr;
@property(nonatomic, strong)NSMutableArray *dataArr;
@property(nonatomic,copy)LearningInfoPopViewBC cellClickBc;

@end
