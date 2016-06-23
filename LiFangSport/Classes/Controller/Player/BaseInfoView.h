//
//  BaseInfoView.h
//  LiFangSport
//
//  Created by 卢亚林 on 16/6/23.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseInfoView : UIView

-(instancetype)initWithFrame:(CGRect)frame andAvatar:(NSString *)avatar andName:(NSString *)name andBirday:(NSString *)birday andHeight:(NSString *)height andWeight:(NSString *)weight andPosition:(NSString *)position andBirthplace:(NSString *)birthplace andClub:(NSString *)club;
@end
