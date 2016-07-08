//
//  StaffsDetVC.m
//  LiFangSport
//
//  Created by 张毅 on 16/7/8.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import "StaffsDetVC.h"
#import "CommonRequest.h"
#import "StaffsInfoModel.h"

@interface StaffsDetVC ()<UIWebViewDelegate>
@property(nonatomic,strong)NSArray *dataArr;
@property(nonatomic,strong)UIWebView *kwebView;

@end

@implementation StaffsDetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArr = [NSArray new];
    self.view.backgroundColor = kwhiteColor;
    self.title = @"职员";
    [self requestData];
}

-(void)requestData{
    NSString *urlStr = [NSString stringWithFormat:@"games/staffs/%@", self.personId];

    [CommonRequest requstPath:urlStr loadingDic:@{kLoadingType : @(RLT_OverlayLoad), kLoadingView : (self.view)} queryParam:nil success:^(CommonRequest *request, id jsonDict) {
        [self dealWithJason:jsonDict];
    } failure:^(CommonRequest *request, NSError *error) {
        
    }];
}
-(void)dealWithJason:(id )dic{
    _dataArr = [StaffsInfoModel arrayOfModelsFromDictionaries:@[dic]];
    [self dealWitaDataForUI];
}

-(void)dealWitaDataForUI{
    _kwebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 200, kScreenWidth, kScreenHeight-200)];
    _kwebView.backgroundColor = kwhiteColor;
    [self.view addSubview:_kwebView];
    _kwebView.delegate = self;
    StaffsInfoModel *model = _dataArr[0];
    NSURL *url = [NSURL URLWithString:model.url];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_kwebView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
