//
//  HomeHeroDetVC.m
//  LiFangSport
//
//  Created by 张毅 on 16/6/16.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import "HomeHeroDetVC.h"
#import "UIBarButtonItem+SimAdditions.h"

@interface HomeHeroDetVC ()

@end

@implementation HomeHeroDetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcons:@[@"backIconwhite"] target:self action:@selector(rollBack)];
}

-(void)rollBack{
    [self.navigationController popViewControllerAnimated:YES];
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
