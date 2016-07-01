//
//  CoachInfoView.h
//  LiFangSport
//
//  Created by 卢亚林 on 16/6/24.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CoachInfoViewDelegate <NSObject>

-(void)likeBtnClicked:(UIButton *)btn;

@end

@interface CoachInfoView : UIView

@property(nonatomic, retain)UIButton *likeBtn;
@property(nonatomic, assign)id<CoachInfoViewDelegate> delegate;

-(instancetype)initWithFrame:(CGRect)frame andAvatar:(NSString *)avatar andName:(NSString *)name andBirday:(NSString *)birday andBirthplace:(NSString *)birthplace andPart:(NSString *)part andClub:(NSString *)club;
@end
