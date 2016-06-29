//
//  VideoLearningDetModel.h
//  LiFangSport
//
//  Created by 张毅 on 16/6/20.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface VideoLearningDetModel : JSONModel
@property(nonatomic,strong)NSString<Optional> *KID;
@property(nonatomic,strong)NSString<Optional> *name;
@property(nonatomic,assign)NSInteger type;
@property(nonatomic,assign)NSInteger pageCount;
@property(nonatomic,strong)NSString<Optional> *contentUri;

@end
