//
//  LearningPlayPopDeciModel.h
//  LiFangSport
//
//  Created by 张毅 on 16/6/24.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface LearningPlayPopDeciModel : JSONModel
@property(nonatomic,assign)NSInteger index;
@property(nonatomic,strong)NSString<Optional> *text;
@property(nonatomic,assign)NSInteger right;

@end
