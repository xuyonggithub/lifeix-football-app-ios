//
//  SelectRootViewController.m
//  LiFangSport
//
//  Created by 张毅 on 16/6/27.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import "SelectRootViewController.h"
#import "LFNavigationController.h"
#import "LeftCategoryVC.h"
#import "HomeCenterVC.h"

@implementation SelectRootViewController

+(RESideMenu *)rootViewController {
    LFNavigationController *navigationController = [[LFNavigationController alloc] initWithRootViewController:[[HomeCenterVC alloc] init]];
    
    
    LeftCategoryVC *leftVC = [[LeftCategoryVC alloc]init];
    
    RESideMenu *sideMenuViewController = [[RESideMenu alloc] initWithContentViewController:navigationController
                                                                    leftMenuViewController:leftVC
                                                                   rightMenuViewController:nil];
    sideMenuViewController.backgroundImage = [UIImage imageNamed:@"Stars"];
    
    return sideMenuViewController;
}

@end
