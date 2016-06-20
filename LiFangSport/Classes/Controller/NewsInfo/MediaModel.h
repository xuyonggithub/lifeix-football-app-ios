//
//  MediaModel.h
//  LiFangSport
//
//  Created by Lifeix on 16/6/12.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface MediaModel : JSONModel

@property(nonatomic, retain)NSArray<Optional> *images;
@property(nonatomic, retain)NSArray<Optional> *categoryIds;
@property(nonatomic, retain)NSString<Optional> *createTime;
@property(nonatomic, retain)NSString<Optional> *author;
@property(nonatomic, retain)NSArray<Optional> *videos;
@property(nonatomic, retain)NSString<Optional> *mediaId;
@property(nonatomic, retain)NSString<Optional> *title;
@property(nonatomic, retain)NSString<Optional> *content;
@property(nonatomic, assign)NSInteger status;

@end
