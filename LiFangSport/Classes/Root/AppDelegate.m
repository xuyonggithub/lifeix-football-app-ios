//
//  AppDelegate.m
//  LiFangSport
//
//  Created by 张毅 on 16/6/12.
//  Copyright © 2016年 zhangyi. All rights reserved.
//
#import "CenterViewController.h"
#import "RightViewController.h"
#import "LeftViewController.h"
#import "LeftCategoryVC.h"
#import "AppDelegate.h"
#import "HomeViewController.h"
#import "HomeCenterVC.h"
#import "LaunchInfoManager.h"
#import "SelectRootViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {


    [self setupUIInterface];
    //SDImageCache设置缓存时间为30天
    [SDImageCache sharedImageCache].maxCacheAge = 60 * 60 * 24 * 30;
//    UIImage *backIndicatorImage = [UIImage imageNamed:@"backIconwhite"];
//    [UINavigationBar appearance].backIndicatorImage = backIndicatorImage;
//    [UINavigationBar appearance].backIndicatorTransitionMaskImage = backIndicatorImage;
//    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -300) forBarMetrics:UIBarMetricsDefault];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
//        [[LaunchInfoManager sharedInstance]fetchLaunchInfoForce:NO];
    

}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)setupUIInterface{
    
    //设置状态栏不隐藏
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    //UINavigationBar UIBarButtonItem 配置
//    if (ABOVE_IOS7) {
//        //统一更改UINavigationBarItem颜色和标题
//        [UINavigationBar appearance].barTintColor = [UIColor whiteColor];
//        [UINavigationBar appearance].barStyle = UIBarStyleBlackTranslucent;
//        [UINavigationBar appearance].tintColor = [UIColor whiteColor];
//        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
//    }else{
//        [UINavigationBar appearance].tintColor = kBasicColor;
//        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];//状态栏不透明
//    }
    
//    [SimNavController setFont:[UIFont boldSystemFontOfSize:18] textColor:[UIColor whiteColor]];
//    [SimNavController setNavBgImage:[UIImage imageWithColor:kBasicColor]];
    
    //显示界面
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    HomeCenterVC *centerV=[[HomeCenterVC alloc]init];
    LeftCategoryVC *leftV=[[LeftCategoryVC alloc]init];
//    RightViewController *rightV=[[RightViewController alloc]init];
    
//    HomeViewController *_rootVC = [[HomeViewController alloc] initWithCenterVC:centerV rightVC:nil leftVC:leftV];
//    self.window.rootViewController = _rootVC;
    self.window.rootViewController = [SelectRootViewController rootViewController];

    [self.window makeKeyAndVisible];

}


@end
