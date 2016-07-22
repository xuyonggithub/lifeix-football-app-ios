//
//  VideoLearningUnitModel.h
//  LiFangSport
//
//  Created by 张毅 on 16/6/21.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface VideoLearningUnitModel : JSONModel
@property(nonatomic,strong)NSString<Optional> *KID;
@property(nonatomic,strong)NSString<Optional> *title;
//@property(nonatomic,assign)NSInteger type;
@property(nonatomic,strong)NSDictionary<Optional> *video;

+(NSArray *)modelDealDataFromWithDic:(NSDictionary *)dic;

@end
