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
#import "StaffsInfoHeaderView.h"
#import "LineView.h"
#import "CommonLoading.h"
@interface StaffsDetVC ()<UIWebViewDelegate>{
    NSInteger likeNum;
    NSInteger isLike;
}
@property(nonatomic,strong)NSArray *dataArr;
@property(nonatomic,strong)UIWebView *kwebView;
@property(nonatomic,strong)StaffsInfoHeaderView *headerInfoView;
@property(nonatomic,strong)UIView *separateView;
@property(nonatomic,strong)UIView *kheaderView;

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
    [self requestLikes];//请求like
}

-(void)requestLikes{
    NSString *urlStr = [NSString stringWithFormat:@"like/likes/%@?type=staffs", self.personId];
    [CommonRequest requstPath:urlStr loadingDic:nil queryParam:nil success:^(CommonRequest *request, id jsonDict) {
        [self dealWitkLikedata:jsonDict];
    } failure:^(CommonRequest *request, NSError *error) {
        NSLog(@"error = %@", error);
    }];
}

-(void)dealWitkLikedata:(id)dic{
    StaffsInfoModel *model = _dataArr[0];
    model.like = [NSString stringWithFormat:@"%@",dic[@"like"]];
    isLike = [model.like integerValue];
    model.likeNum = [NSString stringWithFormat:@"%@",dic[@"likeNum"]];
    likeNum = [model.likeNum integerValue];
    [self dealWitaDataForUI];
}
-(void)dealWitaDataForUI{
    StaffsInfoModel *model = _dataArr[0];
    _headerInfoView = [[StaffsInfoHeaderView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, 150) andDataModel:model];
    DefineWeak(self);
    _headerInfoView.clickBC = ^(void){
        [Weak(self) likePerson];
    };
    _separateView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    _separateView.top = _headerInfoView.bottom+10;
    UILabel *titleLab = [[UILabel alloc]initWithFrame:_separateView.bounds];
    titleLab.text = @"个人介绍";
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = [UIFont systemFontOfSize:14];
    titleLab.textColor = kDetailTitleColor;
    LineView *topline = [[LineView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
    topline.top = 0;
    topline.lineColor = [UIColor lightGrayColor];

    LineView *line = [[LineView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
    line.bottom = _separateView.height;
    line.lineColor = [UIColor lightGrayColor];
    [_separateView addSubview:titleLab];
    [_separateView addSubview:line];
    [_separateView addSubview:topline];

    _kheaderView = [[UIView alloc]initWithFrame:CGRectMake(0, -180-10-64, kScreenWidth, 170)];
    [_kheaderView addSubview:_headerInfoView];
    [_kheaderView addSubview:_separateView];

    _kwebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _kwebView.backgroundColor = kwhiteColor;
    [self.view addSubview:_kwebView];
    _kwebView.delegate = self;
    _kwebView.scrollView.contentInset = UIEdgeInsetsMake(180+10+64, 0, 0, 0);

    NSURL *url = [NSURL URLWithString:model.url];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_kwebView loadRequest:request];

    [_kwebView.scrollView addSubview:_kheaderView];
}

-(void)likePerson{//点赞
    if (isLike) {
        [CommonLoading showTips:@"不能重复点赞"];
        return;
    }
    NSDictionary *dic = @{@"type":@"staffs", @"target":self.personId, @"like":@1};
    [CommonRequest requstPath:@"like/likes" loadingDic:nil postParam:dic success:^(CommonRequest *request, id jsonDict) {
        [_headerInfoView.likeBtn setImage:[UIImage imageNamed:@"fired"] forState:UIControlStateNormal];
        likeNum ++;
        isLike = 1;
        [_headerInfoView.likeBtn setTitle:[NSString stringWithFormat:@"%zd", likeNum] forState:UIControlStateNormal];
    } failure:^(CommonRequest *request, NSError *error) {

    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
