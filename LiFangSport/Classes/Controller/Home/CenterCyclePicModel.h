//
//  CenterCyclePicModel.h
//  LiFangSport
//
//  Created by 张毅 on 16/6/14.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface CenterCyclePicModel : JSONModel

@property(nonatomic,strong)NSDictionary<Optional> *author;
@property(nonatomic,strong)NSArray<Optional> *categoryIds;
@property(nonatomic,strong)NSString<Optional> *createTime;
@property (nonatomic, strong) NSString<Optional> *KID;
@property(nonatomic,strong)NSArray<Optional> *images;
@property(nonatomic,assign)NSInteger status;
@property (nonatomic, strong) NSString<Optional> *title;
@property (nonatomic, strong) NSArray<Optional> *videos;


@end
