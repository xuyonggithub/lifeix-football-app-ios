//
//  VideoExerciseModel.h
//  LiFangSport
//
//  Created by Zhangqibin on 16/7/25.
//  Copyright © 2016年 zhangyi. All rights reserved.
//
//  训练Model

#import <JSONModel/JSONModel.h>

@interface VideoExerciseModel : JSONModel

@property (nonatomic, copy) NSString<Optional> *KID;
@property (nonatomic, copy) NSString<Optional> *title;
@property (nonatomic, copy) NSString<Optional> *image;
@property (nonatomic, strong) NSDictionary<Optional> *exercise;

/*
 exercise =     {
 id = 579173a4e385a8820f4aedee;
 };
 id = 579173a4e385a8820f4aedf9;
 image = "elearning/pe2016/medias/videosswf/ref/ejercicio6c-match.jpg";
 title = "\U7403\U70b9\U7403 1";
 
 */

@end
