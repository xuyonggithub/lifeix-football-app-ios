//
//  YDMenuSwitchView.h
//
//  Created by 张毅 on 16/7/3.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YDMenuSwitchView : UIView
@property (nonatomic,strong)UIScrollView *topscrView;
@property (nonatomic,strong)UIScrollView *scrView;

- (instancetype)initWithVCNames:(NSArray*)VcArr frame:(CGRect)frame VCBlock:(void(^)(UIViewController *vc, NSInteger index))vcBlock;

@end
