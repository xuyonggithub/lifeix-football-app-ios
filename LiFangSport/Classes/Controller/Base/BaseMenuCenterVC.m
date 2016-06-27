//
//  BaseMenuCenterVC.m
//  LiFangSport
//
//  Created by 张毅 on 16/6/27.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import "BaseMenuCenterVC.h"
#import "UIBarButtonItem+SimAdditions.h"

@interface BaseMenuCenterVC ()

@end

@implementation BaseMenuCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *leftBarItem = [UIBarButtonItem itemWithIcons:@[@"list_left"] target:self action:@selector(presentLeftMenuViewController:)];
    
    self.navigationItem.leftBarButtonItem = leftBarItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
