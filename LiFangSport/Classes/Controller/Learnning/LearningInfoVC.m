//
//  LearningInfoVC.m
//  LiFangSport
//
//  Created by 张毅 on 16/6/22.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import "LearningInfoVC.h"
#import "UIBarButtonItem+SimAdditions.h"

@interface LearningInfoVC ()<UINavigationBarDelegate,UINavigationControllerDelegate>

@end

@implementation LearningInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.delegate = self;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.centerV.hideLeftNaviBtnGesture = YES;

    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcons:@[@"backIconwhite"] target:self action:@selector(rollBack)];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}

-(void)rollBack{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //如果是当前控制器，则隐藏背景；如果不是当前控制器，则显示背景
    if (viewController == self) {
        for (UIView *view in [self.navigationController.navigationBar subviews]) {
            if ([view isKindOfClass:NSClassFromString(@"_UINavigationBarBackground")]) {
                view.hidden = YES;
            }
        }
    } else {
        for (UIView *view in [self.navigationController.navigationBar subviews]) {
            if ([view isKindOfClass:NSClassFromString(@"_UINavigationBarBackground")]) {
                view.hidden = NO;
            }
        }
    }
}

@end
