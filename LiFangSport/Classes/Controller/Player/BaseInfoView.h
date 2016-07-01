//
//  BaseInfoView.h
//  LiFangSport
//
//  Created by 卢亚林 on 16/6/23.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BaseInfoViewDelegate <NSObject>

-(void)likeBtnClicked:(UIButton *)btn;

@end

@interface BaseInfoView : UIView

@property(nonatomic, retain)UIButton *likeBtn;
@property(nonatomic, assign)id<BaseInfoViewDelegate> delegate;

-(instancetype)initWithFrame:(CGRect)frame andAvatar:(NSString *)avatar andName:(NSString *)name andBirday:(NSString *)birday andHeight:(NSString *)height andWeight:(NSString *)weight andPosition:(NSString *)position andBirthplace:(NSString *)birthplace andClub:(NSString *)club;
@end
