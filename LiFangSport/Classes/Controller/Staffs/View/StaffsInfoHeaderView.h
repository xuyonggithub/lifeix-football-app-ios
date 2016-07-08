//
//  StaffsInfoHeaderView.h
//  LiFangSport
//
//  Created by 张毅 on 16/7/8.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import "PersonInfoHeaderView.h"
#import "StaffsInfoModel.h"
typedef void(^StaffsInfoHeaderViewBlock)(void);

@interface StaffsInfoHeaderView : PersonInfoHeaderView
@property (nonatomic, copy) StaffsInfoHeaderViewBlock clickBC;
@property(nonatomic,strong)UIButton* likeBtn;

-(instancetype)initWithFrame:(CGRect)frame andDataModel:(StaffsInfoModel*)model;

@end
