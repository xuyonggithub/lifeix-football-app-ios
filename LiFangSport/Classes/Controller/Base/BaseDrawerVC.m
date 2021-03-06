//
//  BaseDrawerVC.m
//  LiFangSport
//
//  Created by 张毅 on 16/6/13.
//  Copyright © 2016年 zhangyi. All rights reserved.
//
#import "CenterViewController.h"
#import "RightViewController.h"
#import "LeftViewController.h"
#import "UIImage+ImageEffects.h"
#import "BaseDrawerVC.h"
#import "UIBarButtonItem+SimAdditions.h"
#import "LFNavigationController.h"

@interface BaseDrawerVC ()
{
    BOOL _isChange;
    BOOL _isH;
}
@end

@implementation BaseDrawerVC

/**
 *  重写init方法
 */
- (id)initWithCenterVC:(CenterViewController *)centerVC rightVC:(RightViewController *)rightVC leftVC:(LeftViewController *)leftVC {
    
    if (self = [super init]) {
        self.centerV = centerVC;
        self.leftV = leftVC;
        self.rightV = rightVC;
        
//        [self createDrawer];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self createDrawer];
}

-(void)viewWillDisappear:(BOOL)animated{

}

-(void)createDrawer{
    if (_leftV) {
    [self addChildViewController:_leftV];
    }
    if (_rightV) {
    [self addChildViewController:_rightV];
    }
    
    UINavigationController *centerNC = [[LFNavigationController alloc] initWithRootViewController:_centerV];
    [self addChildViewController:centerNC];
    if (_leftV) {
        _leftV.view.frame = CGRectMake(0, 0, 250, [UIScreen mainScreen].bounds.size.height);
    }
    if (_rightV) {
        _rightV.view.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 250, 0, 250, [UIScreen mainScreen].bounds.size.height);
    }
    
    centerNC.view.frame = [UIScreen mainScreen].bounds;
    if (_leftV) {
        [self.view addSubview:_leftV.view];
    }
    if (_rightV) {
        [self.view addSubview:_rightV.view];
    }
    [self.view addSubview:centerNC.view];
    
    _centerV.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcons:@[@"list_left"] target:self action:@selector(leftAction:)];

    
//    _centerV.navigationItem.leftBarButtonItem = ({
//        UIBarButtonItem *leftB = [[UIBarButtonItem alloc] initWithTitle:@"左边" style:(UIBarButtonItemStylePlain) target:self action:@selector(leftAction:)];
//        leftB;
//    });
    if (self.hideCenterLeftNaviBtn==YES || _leftV == nil) {
        _centerV.navigationItem.leftBarButtonItem = nil;
    }
    _centerV.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithIcons:@[@"list_right"] target:self action:@selector(rightAction:)];

//    _centerV.navigationItem.rightBarButtonItem = ({
//        UIBarButtonItem *rightB = [[UIBarButtonItem alloc] initWithTitle:@"右边" style:(UIBarButtonItemStylePlain) target:self action:@selector(rightAction:)];
//        rightB;
//    });
    if (self.hideCenterRightNaviBtn==YES || _rightV == nil) {
        _centerV.navigationItem.rightBarButtonItem = nil;
    }
}

/**
 *  左边按钮事件: rightVC 和 centerNC 向右偏移
 */
- (void)leftAction:(UIBarButtonItem *)sender {
    UINavigationController *centerNC = self.childViewControllers.lastObject;
    RightViewController *rightVC = self.childViewControllers[1];
    LeftViewController *leftVC = self.childViewControllers.firstObject;
    [UIView animateWithDuration:0.5 animations:^{
        
        if ( centerNC.view.center.x != self.view.center.x ) {
            NSLog(@"1回来");
            leftVC.view.frame = CGRectMake(0, 0, 250, [UIScreen mainScreen].bounds.size.height);
            rightVC.view.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 250, 0, 250, [UIScreen mainScreen].bounds.size.height);
            centerNC.view.frame = [UIScreen mainScreen].bounds;
            _isChange = !_isChange;
            return;
        }{
            centerNC.view.frame = CGRectMake(250, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
            rightVC.view.frame = CGRectMake(250, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        }
    }];
}

/**
 * 右边按钮事件: leftVC 和 centerNC 向左偏移
 */
- (void)rightAction:(UIBarButtonItem *)sender {
    UINavigationController *centerNC = self.childViewControllers.lastObject;
    LeftViewController *leftVC = self.childViewControllers.firstObject;
    RightViewController *rightVC = self.childViewControllers[1];
    [UIView animateWithDuration:0.5 animations:^{
        
        if ( centerNC.view.center.x != self.view.center.x ) {
            
            NSLog(@"1回来");
            leftVC.view.frame = CGRectMake(0, 0, 250, [UIScreen mainScreen].bounds.size.height);
            rightVC.view.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 250, 0, 250, [UIScreen mainScreen].bounds.size.height);
            centerNC.view.frame = [UIScreen mainScreen].bounds;
            
        }else{
            centerNC.view.frame = CGRectMake(-250, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
            leftVC.view.frame =CGRectMake(-250, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        }
    }];
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
