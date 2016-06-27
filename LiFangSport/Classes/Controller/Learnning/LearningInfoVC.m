//
//  LearningInfoVC.m
//  LiFangSport
//
//  Created by 张毅 on 16/6/22.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import "LearningInfoVC.h"
#import "UIBarButtonItem+SimAdditions.h"
#import "CommonRequest.h"
#import "PopViewKit.h"
#import "LearningInfoPopView.h"

@interface LearningInfoVC (){
    PopViewKit *popKit;
    LearningInfoPopView *rightView;
}
@property(nonatomic,strong)NSMutableArray *dataArray;

@end

@implementation LearningInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:YES];

    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcons:@[@"backIconwhite"] target:self action:@selector(rollBack)];
//    [self requestData];
}

-(void)requestData{
    [CommonRequest requstPath:kvideoListPath loadingDic:@{kLoadingType : @(RLT_OverlayLoad), kLoadingView : (self.view)} queryParam:nil success:^(CommonRequest *request, id jsonDict) {
        [self dealWithJason:jsonDict];
    } failure:^(CommonRequest *request, NSError *error) {
        
    }];
}

-(void)dealWithJason:(id )dic{
    [_dataArray removeAllObjects];

}

- (void)rightDrawerAction:(UIBarButtonItem *)sender {
    if (!popKit) {
        popKit = [[PopViewKit alloc] init];
        popKit.bTapDismiss = YES;
        popKit.bInnerTapDismiss = NO;
    }

    if (!rightView) {
        rightView = [[LearningInfoPopView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth-80, kScreenHeight)];
    }
    popKit.contentOrigin = CGPointMake(APP_DELEGATE.window.width-rightView.width, 0);

    [popKit popView:rightView animateType:PAT_HeightDownToUp];

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
#pragma mark - UIViewControllerRotation
- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}


@end
