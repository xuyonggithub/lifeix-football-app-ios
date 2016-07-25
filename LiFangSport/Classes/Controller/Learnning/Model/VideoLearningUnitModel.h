//
//  VideoLearningUnitModel.h
//  LiFangSport
//
//  Created by 张毅 on 16/6/21.
//  Copyright © 2016年 zhangyi. All rights reserved.
//
//  规则培训视频Model

#import <JSONModel/JSONModel.h>

@interface VideoLearningUnitModel : JSONModel

@property(nonatomic, copy) NSString<Optional> *KID;
@property(nonatomic, copy) NSString<Optional> *title;
//@property(nonatomic,assign)NSInteger type;
@property(nonatomic, strong) NSDictionary<Optional> *video;

@end
