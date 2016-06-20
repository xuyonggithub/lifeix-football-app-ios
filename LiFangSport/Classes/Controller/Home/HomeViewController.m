//
//  HomeViewController.m
//  LiFangSport
//
//  Created by 张毅 on 16/6/12.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //一定要在viewDidLoad里面设置隐藏左边手势/按钮或者右边手势/按钮
    self.centerV.hideRightNaviBtnGesture = YES;
    self.hideCenterRightNaviBtn = YES;

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
