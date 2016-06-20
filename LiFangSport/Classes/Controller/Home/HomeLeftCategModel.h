//
//  HomeLeftCategModel.h
//  LiFangSport
//
//  Created by 张毅 on 16/6/14.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface HomeLeftCategModel : JSONModel
@property(nonatomic,strong)NSString<Optional> *iconUrl;
@property (nonatomic, strong) NSString<Optional> *KID;

@property(nonatomic,strong)NSArray<Optional> *menus;
@property(nonatomic,strong)NSString<Optional> *name;
@property(nonatomic,strong)NSString<Optional> *page;

@end
