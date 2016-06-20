//
//  LaunchInfoModel.h
//  LiFangSport
//
//  Created by 张毅 on 16/6/15.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface LaunchInfoModel : JSONModel

@property(nonatomic,strong)NSArray *noticeList;
@property(nonatomic,strong)NSArray *setting;

@end
