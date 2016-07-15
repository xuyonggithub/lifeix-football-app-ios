//
//  CoachDetailVC.m
//  LiFangSport
//
//  Created by 卢亚林 on 16/6/22.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import "CoachDetailVC.h"
#import "CoachInfoView.h"
#import "CommonRequest.h"
#import "CommonLoading.h"
#import "CoachModel.h"
#import "UMSocial.h"
#import "UMSocialSnsData.h"
#import "UIBarButtonItem+SimAdditions.h"
#import "WeiboSDK.h"
#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>

@interface CoachDetailVC ()<CoachInfoViewDelegate, UIWebViewDelegate>

@property(nonatomic, assign)int likeNum;
@property(nonatomic, assign)BOOL isClick;
@property(nonatomic, assign)BOOL isLike;

@property(nonatomic, retain)NSMutableArray *shareArr;
@property(nonatomic, retain)UIView *lbl;
@property(nonatomic, copy)NSString *url;
@property(nonatomic,strong)UIScrollView *scrollView;

@end

@implementation CoachDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"教练介绍";
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 0)];
    [self.view addSubview:_scrollView];
    // 分享
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithIcons:@[@"share.jpg"] target:self action:@selector(shareBtnClicked:)];
    
    [self requestData];
}

-(void)requestData{
    NSString *urlStr = [NSString stringWithFormat:@"games/coaches/%@", self.coachId];
    [CommonRequest requstPath:urlStr loadingDic:nil queryParam:nil success:^(CommonRequest *request, id jsonDict) {
        [self dealWithDic: jsonDict];
    } failure:^(CommonRequest *request, NSError *error) {
        NSLog(@"error = %@", error);
    }];
}

-(void)requestLikes:(UIView *)view{
    CoachInfoView *baseView = (CoachInfoView *)view;
    UIButton *likeButton = baseView.likeBtn;
    NSString *urlStr = [NSString stringWithFormat:@"like/likes/%@?type=coach", self.coachId];
    [CommonRequest requstPath:urlStr loadingDic:nil queryParam:nil success:^(CommonRequest *request, id jsonDict) {
        NSLog(@"data = %@", jsonDict);
        NSDictionary *dic = jsonDict;
        if(![[dic objectForKey:@"like"] isEqual:[NSNull null]]){
            if([[dic objectForKey:@"like"] boolValue] == YES){
                self.isLike = YES;
                [likeButton setImage:[UIImage imageNamed:@"fired"] forState:UIControlStateNormal];
            }
        }
        int like = [[dic objectForKey:@"likeNum"] intValue];
        _likeNum = like;
        [likeButton setTitle:[NSString stringWithFormat:@"%d", like] forState:UIControlStateNormal];
    } failure:^(CommonRequest *request, NSError *error) {
        NSLog(@"error = %@", error);
    }];
}

-(void)dealWithDic:(id)dic{
    NSDictionary *dict = dic;
    NSString *birthday;
    if(![[dic objectForKey:@"birthday"] isEqual:[NSNull null]]){
        birthday = [self timeStampChangeTimeWithTimeStamp:[dict objectForKey:@"birthday"] timeStyle:@"YYYY-MM-dd"];
    }else{
        birthday = @"-";
    }

    NSString *club;
    if(![[dic objectForKey:@"company"] isEqual:[NSNull null]]){
        club = [dict objectForKey:@"company"];
    }else{
        club = @"-";
    }
    
    NSString *name;
    if(![[dic objectForKey:@"name"] isEqual:[NSNull null]]){
        name = [dict objectForKey:@"name"];
    }else{
        name = @"-";
    }
    
    NSString *birthplace;
    if(![[dic objectForKey:@"birthplace"] isEqual:[NSNull null]]){
        birthplace = [dict objectForKey:@"birthplace"];
    }else{
        birthplace = @"-";
    }
    
    NSString *part;
    if(![[dic objectForKey:@"team"] isEqual:[NSNull null]] && ![[[dic objectForKey:@"team"] objectForKey:@"position"] isEqual:[NSNull null]]){
        part = [[dict objectForKey:@"team"] objectForKey:@"position"];
    }else{
        part = @"-";
    }
    
    NSString *country;
    if(![[dic objectForKey:@"country"] isEqual:[NSNull null]]){
        country = [dict objectForKey:@"country"];
    }else{
        country = @"-";
    }
    
    CoachInfoView *coachView = [[CoachInfoView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 150) andAvatar:[dict objectForKey:@"avatar"] andName:name andBirday:birthday andBirthplace:birthplace andPart:part andClub:club andCountry:country];
    coachView.delegate = self;
    [self.scrollView addSubview:coachView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, coachView.bottom, 200, 100/3)];
    label.text = @"执教生涯";
    label.font = [UIFont systemFontOfSize:10];
    label.textColor = HEXRGBCOLOR(0x5f5f5f);
    [self.scrollView addSubview:label];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, label.bottom, SCREEN_WIDTH, 1)];
    lineView.backgroundColor = HEXRGBCOLOR(0x9a9a9a);
    [self.scrollView addSubview:lineView];
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, lineView.bottom, SCREEN_WIDTH, SCREEN_HEIGHT - lineView.bottom)];
    webView.backgroundColor = kwhiteColor;
    webView.delegate = self;
    webView.scrollView.scrollEnabled = false;
    if(![[dict objectForKey:@"url"] isEqual:[NSNull null]]){
        self.url = [NSString stringWithFormat:@"%@", [dict objectForKey:@"url"]];
        NSURL *url = [NSURL URLWithString:[dict objectForKey:@"url"]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [webView loadRequest:request];
    }
    [self.scrollView addSubview:webView];
    [self requestLikes:coachView];
}

#pragma mark - BaseInfoViewDelegate
-(void)likeBtnClicked:(UIButton *)btn{
    NSLog(@"like");
    if(_isClick == YES){
        [CommonLoading showTips:@"重复操作"];
        return;
    }else if (_isLike == YES){
        [CommonLoading showTips:@"不能重复点赞"];
        return;
    };
    NSDictionary *dic = @{@"type":@"coach", @"target":self.coachId, @"like":@1};
    [CommonRequest requstPath:@"like/likes" loadingDic:nil postParam:dic success:^(CommonRequest *request, id jsonDict) {
        NSLog(@"succeed!%@", jsonDict);
        [btn setTitle:[NSString stringWithFormat:@"%d", _likeNum + 1] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"fired"] forState:UIControlStateNormal];
    } failure:^(CommonRequest *request, NSError *error) {
        NSLog(@"error: %@", error);
    }];
    _isClick = YES;
    
}

#pragma mark - UIWebviewdelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    CGFloat webViewHeight=[[webView stringByEvaluatingJavaScriptFromString: @"document.body.scrollHeight"]floatValue];
    webView.height = webViewHeight;
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, webViewHeight + webView.top);
}

/**
 *  时间戳转时间
 *
 *  @param timeStamp 时间戳 （eg:@"1296035591"）
 *  @param timeStyle 时间格式（eg: @"YYYY-MM-dd HH:mm:ss" ）
 *
 *  @return 返回转化好格式的时间字符串
 */
-(NSString *)timeStampChangeTimeWithTimeStamp:(NSString *)timeStamp timeStyle:(NSString *)timeStyle{
    NSTimeInterval interval = [timeStamp doubleValue]/1000.0;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:timeStyle];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSString *strDate = [formatter stringFromDate:date];
    NSString *formatterStr = [strDate stringByReplacingOccurrencesOfString:@"+08:00" withString:@"Z"];
    return formatterStr;
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
        [_lbl addSubview:wView];
        CGFloat btnWidth = (SCREEN_WIDTH - 170)/4;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 58 - btnWidth)];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:12];
        label.text = @"分享";
        label.textColor = HEXRGBCOLOR(0x9a9a9a);
        [wView addSubview:label];
        self.shareArr = [NSMutableArray array];
        if(![WXApi isWXAppInstalled]){
            if([QQApiInterface isQQInstalled] && [QQApiInterface isQQSupportApi]){
                [self.shareArr addObjectsFromArray:@[@"sina", @"Qzone"]];
            }else{
                [self.shareArr addObjectsFromArray:@[@"sina"]];
            }
            
        }else{
            if([QQApiInterface isQQInstalled] && [QQApiInterface isQQSupportApi]){
                [self.shareArr addObjectsFromArray:@[@"wechat", @"timeline", @"sina", @"Qzone"]];
            }else{
                [self.shareArr addObjectsFromArray:@[@"wechat", @"timeline", @"sina"]];
            }
        }
        for(int i = 0; i < self.shareArr.count; i++){
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(i==0?25:(25 + (40 + btnWidth) * i), label.bottom + 20, btnWidth, btnWidth);
            [btn addTarget:self action:@selector(didSelectedShareBtnIndex:) forControlEvents:UIControlEventTouchUpInside];
            [btn setImage:[UIImage imageNamed:self.shareArr[i]] forState:UIControlStateNormal];
            btn.tag = 1000 + i;
            [wView addSubview:btn];
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
    NSString *shareText = [NSString stringWithFormat:@"%@", _coachName];
    NSString *shareUrl = self.url;
    
    NSString *avatarUrl = [NSString stringWithFormat:@"%@%@", kQiNiuHeaderPathPrifx, _coach.avatar];
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
