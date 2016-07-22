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
#import "UIBarButtonItem+SimAdditions.h"
#import "UMSocial.h"
#import "UMSocialSnsData.h"
#import "WeiboSDK.h"
#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>

#define kShareViewTag 1144
@interface StaffsDetVC ()<UIWebViewDelegate>{
    NSInteger likeNum;
    NSInteger isLike;
}
@property(nonatomic,strong)NSArray *dataArr;
@property(nonatomic,strong)UIWebView *kwebView;
@property(nonatomic,strong)StaffsInfoHeaderView *headerInfoView;
@property(nonatomic,strong)UIView *separateView;
@property(nonatomic,strong)UIView *kheaderView;

@property(nonatomic, retain)UIView *lbl;
@property(nonatomic, retain)NSMutableArray *shareArr;
@property(nonatomic, retain)NSMutableArray *shareNameArr;

@end

@implementation StaffsDetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArr = [NSArray new];
    self.view.backgroundColor = kwhiteColor;
    self.title = @"职员";
    // 分享
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithIcons:@[@"share"] target:self action:@selector(shareBtnClicked:)];
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


#pragma mark - share
-(void)shareBtnClicked:(UIButton *)btn{
    if(self.lbl == nil || ![self.view.subviews containsObject:_lbl]){
        _lbl = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
        UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 175)];
        topView.backgroundColor = HEXRGBCOLOR(0x000000);
        topView.alpha = 0.3;
        [_lbl addSubview:topView];
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, _lbl.height - 175, SCREEN_WIDTH, 1)];
        lineView.backgroundColor = HEXRGBCOLOR(0xae1417);
        [_lbl addSubview:lineView];
        UIView *wView = [[UIView alloc] initWithFrame:CGRectMake(0, lineView.bottom, SCREEN_WIDTH, 175)];
        wView.backgroundColor = [UIColor whiteColor];
        wView.tag = kShareViewTag;
        [_lbl addSubview:wView];
        CGFloat btnWidth = (SCREEN_WIDTH - 170)/4;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 58 - btnWidth)];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:12];
        label.text = @"分享";
        label.textColor = HEXRGBCOLOR(0x9a9a9a);
        [wView addSubview:label];
        self.shareArr = [NSMutableArray array];
        self.shareNameArr = [NSMutableArray array];
        if(![WXApi isWXAppInstalled]){
            if([QQApiInterface isQQInstalled] && [QQApiInterface isQQSupportApi]){
                [self.shareArr addObjectsFromArray:@[@"sina", @"Qzone"]];
                [self.shareNameArr addObjectsFromArray:@[@"新浪微博", @"QQ空间"]];
            }else{
                [self.shareArr addObjectsFromArray:@[@"sina"]];
                [self.shareNameArr addObjectsFromArray:@[@"新浪微博"]];
            }
            
        }else{
            if([QQApiInterface isQQInstalled] && [QQApiInterface isQQSupportApi]){
                [self.shareArr addObjectsFromArray:@[@"wechat", @"timeline", @"sina", @"Qzone"]];
                [self.shareNameArr addObjectsFromArray:@[@"微信好友", @"朋友圈", @"新浪微博", @"QQ空间"]];
            }else{
                [self.shareArr addObjectsFromArray:@[@"wechat", @"timeline", @"sina"]];
                [self.shareNameArr addObjectsFromArray:@[@"微信好友", @"朋友圈", @"新浪微博"]];
            }
        }
        for(int i = 0; i < self.shareArr.count; i++){
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(i==0?25:(25 + (40 + btnWidth) * i), label.bottom + 20, btnWidth, btnWidth);
            [btn addTarget:self action:@selector(didSelectedShareBtnIndex:) forControlEvents:UIControlEventTouchUpInside];
            [btn setImage:[UIImage imageNamed:self.shareArr[i]] forState:UIControlStateNormal];
            btn.tag = 1000 + i;
            [wView addSubview:btn];
            UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(btn.left, btn.bottom + 10, btn.width, 10)];
            lbl.text = self.shareNameArr[i];
            lbl.font = [UIFont systemFontOfSize:10];
            lbl.textAlignment = NSTextAlignmentCenter;
            [wView addSubview:lbl];
        }
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, label.bottom + 20 + btnWidth + 32, SCREEN_WIDTH, 1)];
        line2.backgroundColor = HEXRGBCOLOR(0xdfdfdf);
        [wView addSubview:line2];
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame = CGRectMake(0, line2.bottom, SCREEN_WIDTH, 35);
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:HEXRGBCOLOR(0x1f1f1f) forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        [cancelBtn addTarget:self action:@selector(cancelBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [wView addSubview:cancelBtn];
        [self.view addSubview:_lbl];
        _lbl.tag = 12345;
    }
}

-(void)didSelectedShareBtnIndex:(UIButton *)btn{
    NSInteger index = btn.tag - 1000;
    NSString *snsName;
    NSString *shareTitle = @"中国足球网";
    StaffsInfoModel *model = _dataArr[0];
    NSString *shareText = [NSString stringWithFormat:@"%@", model.name];
    NSString *shareUrl = model.url;
    
    NSString *avatarUrl = [NSString stringWithFormat:@"%@%@", kQiNiuHeaderPathPrifx, model.avatar];
    UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:avatarUrl];
    
    UMSocialData *socialData;
    switch (self.shareArr.count) {
        case 1:
            snsName                                             = UMShareToSina;
            socialData                                          = [[UMSocialData alloc] initWithIdentifier:@"sinaweibo"];
            socialData.extConfig.sinaData.shareText             = [NSString stringWithFormat:@"%@\n%@%@",shareTitle,shareText,shareUrl];
            socialData.extConfig.sinaData.urlResource           = urlResource;
            break;
        case 2:
            switch (index) {
                case 0:{ // 新浪微博
                    snsName                                             = UMShareToSina;
                    socialData                                          = [[UMSocialData alloc] initWithIdentifier:@"sinaweibo"];
                    socialData.extConfig.sinaData.shareText             = [NSString stringWithFormat:@"%@\n%@%@",shareTitle,shareText,shareUrl];
                    socialData.extConfig.sinaData.urlResource           = urlResource;
                }
                    break;
                case 1:{ // QQ空间
                    snsName                                             = UMShareToQzone;
                    socialData                                          = [[UMSocialData alloc] initWithIdentifier:@"Qzone"];
                    socialData.extConfig.qzoneData.title       = shareTitle;
                    socialData.extConfig.qzoneData.url         = shareUrl;
                    socialData.extConfig.qzoneData.shareText   = shareText;
                    socialData.extConfig.qzoneData.urlResource = urlResource;
                }
                    break;
                default:
                    break;
            }
            break;
        case 3:
            switch (index) {
                case 2:{ // 新浪微博
                    snsName                                             = UMShareToSina;
                    socialData                                          = [[UMSocialData alloc] initWithIdentifier:@"sinaweibo"];
                    socialData.extConfig.sinaData.shareText             = [NSString stringWithFormat:@"%@\n%@%@",shareTitle,shareText,shareUrl];
                    socialData.extConfig.sinaData.urlResource           = urlResource;
                }
                    break;
                case 0:{ // 微信好友
                    snsName                                             = UMShareToWechatSession;
                    socialData                                          = [[UMSocialData alloc] initWithIdentifier:@"wechatSession"];
                    socialData.extConfig.wechatSessionData.title        = shareTitle;
                    socialData.extConfig.wechatSessionData.url          = shareUrl;
                    socialData.extConfig.wechatSessionData.shareText    = shareText;
                    socialData.extConfig.wechatSessionData.urlResource  = urlResource;
                    
                }
                    break;
                case 1:{ // 微信朋友圈
                    snsName                                             = UMShareToWechatTimeline;
                    socialData                                          = [[UMSocialData alloc] initWithIdentifier:@"wechatTimeline"];
                    socialData.extConfig.wechatTimelineData.title       = shareTitle;
                    socialData.extConfig.wechatTimelineData.url         = shareUrl;
                    socialData.extConfig.wechatTimelineData.shareText   = shareText;
                    
                    socialData.extConfig.wechatTimelineData.urlResource = urlResource;
                }
                    break;
                default:
                    break;
            }
            break;
        case 4:
            switch (index) {
                case 2:{ // 新浪微博
                    snsName                                             = UMShareToSina;
                    socialData                                          = [[UMSocialData alloc] initWithIdentifier:@"sinaweibo"];
                    socialData.extConfig.sinaData.shareText             = [NSString stringWithFormat:@"%@\n%@%@",shareTitle,shareText,shareUrl];
                    socialData.extConfig.sinaData.urlResource           = urlResource;
                }
                    break;
                case 0:{ // 微信好友
                    snsName                                             = UMShareToWechatSession;
                    socialData                                          = [[UMSocialData alloc] initWithIdentifier:@"wechatSession"];
                    socialData.extConfig.wechatSessionData.title        = shareTitle;
                    socialData.extConfig.wechatSessionData.url          = shareUrl;
                    socialData.extConfig.wechatSessionData.shareText    = shareText;
                    socialData.extConfig.wechatSessionData.urlResource  = urlResource;
                    
                }
                    break;
                case 1:{ // 微信朋友圈
                    snsName                                             = UMShareToWechatTimeline;
                    socialData                                          = [[UMSocialData alloc] initWithIdentifier:@"wechatTimeline"];
                    socialData.extConfig.wechatTimelineData.title       = shareTitle;
                    socialData.extConfig.wechatTimelineData.url         = shareUrl;
                    socialData.extConfig.wechatTimelineData.shareText   = shareText;
                    
                    socialData.extConfig.wechatTimelineData.urlResource = urlResource;
                }
                    break;
                case 3:{ // QQ空间
                    snsName                                             = UMShareToQzone;
                    socialData                                          = [[UMSocialData alloc] initWithIdentifier:@"Qzone"];
                    socialData.extConfig.qzoneData.title       = shareTitle;
                    socialData.extConfig.qzoneData.url         = shareUrl;
                    socialData.extConfig.qzoneData.shareText   = shareText;
                    socialData.extConfig.qzoneData.urlResource = urlResource;
                }
                    break;
                default:
                    break;
            }
            break;
        default:
            break;
    }
    
    UMSocialControllerService *shareService             = [[UMSocialControllerService alloc] initWithUMSocialData:socialData];
    UMSocialSnsPlatform *snsPlatform                    = [UMSocialSnsPlatformManager getSocialPlatformWithName:snsName];
    snsPlatform.snsClickHandler(self,shareService,YES);
    UIView *view = [self.view viewWithTag:12345];
    [view removeFromSuperview];
}

-(void)cancelBtnClicked:(UIButton *)cancelBtn{
    UIView *view = [self.view viewWithTag:12345];
    [view removeFromSuperview];
}

@end
