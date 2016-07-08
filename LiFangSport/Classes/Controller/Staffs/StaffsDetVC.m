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

@interface StaffsDetVC ()<UIWebViewDelegate>{
    NSInteger likeNum;
}
@property(nonatomic,strong)NSArray *dataArr;
@property(nonatomic,strong)UIWebView *kwebView;
@property(nonatomic,strong)StaffsInfoHeaderView *headerView;
@property(nonatomic,strong)UIView *separateView;

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
    model.likeNum = [NSString stringWithFormat:@"%@",dic[@"likeNum"]];
    likeNum = [model.likeNum integerValue];
    [self dealWitaDataForUI];
}
-(void)dealWitaDataForUI{
    StaffsInfoModel *model = _dataArr[0];
    _headerView = [[StaffsInfoHeaderView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, 150) andDataModel:model];
    [self.view addSubview:_headerView];
    DefineWeak(self);
    _headerView.clickBC = ^(void){
        [Weak(self) likePerson];
    };
    _separateView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
    _separateView.top = _headerView.bottom+10;
    [self.view addSubview:_separateView];
    UILabel *titleLab = [[UILabel alloc]initWithFrame:_separateView.bounds];
    titleLab.text = @"  个人介绍";
    titleLab.textAlignment = NSTextAlignmentLeft;
    titleLab.font = [UIFont systemFontOfSize:14];
    titleLab.textColor = [UIColor blackColor];
    LineView *line = [[LineView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
    line.bottom = _separateView.height;
    line.lineColor = [UIColor lightGrayColor];
    [_separateView addSubview:titleLab];
    [_separateView addSubview:line];
    
    _kwebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, _separateView.bottom, kScreenWidth, kScreenHeight-_headerView.height-_separateView.height-64)];
    _kwebView.backgroundColor = kwhiteColor;
    [self.view addSubview:_kwebView];
    _kwebView.delegate = self;
    NSURL *url = [NSURL URLWithString:model.url];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_kwebView loadRequest:request];
}

-(void)likePerson{//点赞
    NSDictionary *dic = @{@"type":@"staffs", @"target":self.personId, @"like":@1};
    [CommonRequest requstPath:@"like/likes" loadingDic:nil postParam:dic success:^(CommonRequest *request, id jsonDict) {
        [_headerView.likeBtn setImage:[UIImage imageNamed:@"fired"] forState:UIControlStateNormal];
//        int like = [[dic objectForKey:@"likeNum"] intValue];
        likeNum ++;
        [_headerView.likeBtn setTitle:[NSString stringWithFormat:@"%zd", likeNum] forState:UIControlStateNormal];
    } failure:^(CommonRequest *request, NSError *error) {

    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
