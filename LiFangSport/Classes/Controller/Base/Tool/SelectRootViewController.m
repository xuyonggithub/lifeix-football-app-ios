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
#import "MediaCenterVC.h"
#import "CoachCenterVC.h"
#import "RefereeCenterVC.h"
#import "VideoCenterVC.h"
#import "SimulationCenterVC.h"
#import "PlayerCenterViewController.h"
#import "CurrentlyScoreVC.h"

@implementation SelectRootViewController

+(RESideMenu *)rootViewController {
    LFNavigationController *navigationController = [[LFNavigationController alloc] initWithRootViewController:[[HomeCenterVC alloc] init]];
    
    
    LeftCategoryVC *leftVC = [[LeftCategoryVC alloc]init];
    
    RESideMenu *sideMenuViewController = [[RESideMenu alloc] initWithContentViewController:navigationController
                                                                    leftMenuViewController:leftVC
                                                                   rightMenuViewController:nil];
    
    return sideMenuViewController;
}

@end
