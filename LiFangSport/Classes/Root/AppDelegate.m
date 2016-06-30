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
#import "HomeCenterVC.h"
#import "LaunchInfoManager.h"
#import "SelectRootViewController.h"
#import "UMSocial.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSinaSSOHandler.h"
#import "UMSocialWechatHandler.h"

#define UmengAppkey @"5730424be0f55acd85001eef"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self setupUIInterface];
    //SDImageCache设置缓存时间为30天
    [SDImageCache sharedImageCache].maxCacheAge = 60 * 60 * 24 * 30;
    [SDImageCache sharedImageCache].maxCacheSize = 1024 * 1024 * 100; // 100M
    [self setupUMengShare];
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
    
    UIImage *backIndicatorImage = [UIImage imageNamed:@"backIconwhite"];
    [UINavigationBar appearance].backIndicatorImage = backIndicatorImage;
    [UINavigationBar appearance].backIndicatorTransitionMaskImage = backIndicatorImage;
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -300) forBarMetrics:UIBarMetricsDefault];
    [UINavigationBar appearance].tintColor = kwhiteColor;
    
    //显示界面
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [SelectRootViewController rootViewController];
    [self.window makeKeyAndVisible];
    
}

-(void)setupUMengShare{
    //设置友盟社会化组件appkey
    [UMSocialData setAppKey:UmengAppkey];
    //设置微信AppId、appSecret，分享url
    [UMSocialWechatHandler setWXAppId:@"wxd930ea5d5a258f4f" appSecret:@"db426a9829e4b49a0dcac7b4162da6b6" url:@"http://www.umeng.com/social"];
    //设置手机QQ 的AppId，Appkey，和分享URL，需要#import "UMSocialQQHandler.h"
    [UMSocialQQHandler setQQWithAppId:@"100424468" appKey:@"c7394704798a158208a74ab60104f0ba" url:@"http://www.umeng.com/social"];
    //打开新浪微博的SSO开关，设置新浪微博回调地址，这里必须要和你在新浪微博后台设置的回调地址一致。需要 #import "UMSocialSinaSSOHandler.h"
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"3921700954"
                                              secret:@"04b48b094faeb16683c32669824ebdad"
                                         RedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
    
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == FALSE) {
        //调用其他SDK，例如支付宝SDK等
    }
    return result;
}

@end
