//
//  HomeBannnerDetVC.m
//  LiFangSport
//
//  Created by 张毅 on 16/6/15.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import "HomeBannnerDetVC.h"
#import "UIBarButtonItem+SimAdditions.h"
#import "CommonRequest.h"

@interface HomeBannnerDetVC ()

@end

@implementation HomeBannnerDetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"正文";    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcons:@[@"backIconwhite"] target:self action:@selector(rollBack)];
    
    
    [CommonRequest requstPath:[NSString stringWithFormat:@"%@%@",ksinglepagePath,_postId] loadingDic:@{kLoadingType : @(RLT_OverlayLoad), kLoadingView : (self.view)} queryParam:nil success:^(CommonRequest *request, id jsonDict) {
//        [self dealWithLeftData:jsonDict];
    } failure:^(CommonRequest *request, NSError *error) {
        
    }];
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
