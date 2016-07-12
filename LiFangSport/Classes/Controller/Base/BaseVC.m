//
//  BaseVC.m
//  LiFangSport
//
//  Created by 张毅 on 16/6/12.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import "BaseVC.h"
#import "INSLappsyPullToRefresh.h"
#import "INSLappsyInfiniteIndicator.h"

@interface BaseVC ()

@end

@implementation BaseVC

-(void)loadView {
    [super loadView];
    
    self.navigationController.navigationBar.barTintColor = knavibarColor;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:18],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.view.backgroundColor = [UIColor whiteColor];
}



#pragma mark - UIBarButtonItem
- (UIView <INSPullToRefreshBackgroundViewDelegate> *)pullToRefreshViewFromCurrentStyle {
    
    CGRect defaultFrame = CGRectMake(0, 0, 24, 24);
    return [[INSLappsyPullToRefresh alloc] initWithFrame:defaultFrame];
}

- (UIView <INSAnimatable> *)infinityIndicatorViewFromCurrentStyle {
    
    CGRect defaultFrame = CGRectMake(0, 0, 24, 24);
    return [[INSLappsyInfiniteIndicator alloc] initWithFrame:defaultFrame];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIViewControllerRotation
- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if (![self shouldAutorotate]) {
        return UIInterfaceOrientationMaskPortrait;
    }
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscape;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    if (![self shouldAutorotate]) {
        return UIInterfaceOrientationPortrait;
    }
    return UIInterfaceOrientationPortrait | UIInterfaceOrientationLandscapeLeft | UIInterfaceOrientationLandscapeRight;
}

@end
