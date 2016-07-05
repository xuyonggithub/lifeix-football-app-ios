//
//  LearningVideoPlayVC.h
//  LiFangSport
//
//  Created by 张毅 on 16/6/22.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import "BaseVC.h"

@interface LearningVideoPlayVC : BaseVC
@property(nonatomic,strong)NSString *videoId;
@property(nonatomic,strong)NSArray *videosArr;
@property(nonatomic,assign)NSInteger pageCount;
@property(nonatomic,assign)NSInteger currentIndex;
@property(nonatomic,strong)NSString *categoryID;
@property(nonatomic,strong)NSString *isOffsideHard;


@end
