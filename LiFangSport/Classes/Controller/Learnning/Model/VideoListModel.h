//
//  VideoListModel.h
//  LiFangSport
//
//  Created by 张毅 on 16/6/20.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface VideoListModel : JSONModel
@property(nonatomic,strong)NSArray<Optional> *cats;
@property(nonatomic,strong)NSString<Optional> *KID;
@property(nonatomic,strong)NSString<Optional> *name;
@property(nonatomic,assign)NSInteger type;


@end
