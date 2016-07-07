//
//  PlayerDetailVC.m
//  LiFangSport
//
//  Created by 卢亚林 on 16/6/22.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import "PlayerDetailVC.h"
#import "CategoryView.h"
#import "BaseInfoView.h"
#import "CommonRequest.h"
#import "PlayerVideoModel.h"
#import "PlayerVideoCell.h"
#import "UIBarButtonItem+SimAdditions.h"
#import "PlayerVideoVC.h"
#import "CommonLoading.h"
#import "PlayerModel.h"
#import "UMSocial.h"
#import "UMSocialSnsData.h"
#import "WeiboSDK.h"
#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>

#define kReuseId @"cell"
@interface PlayerDetailVC ()<UIWebViewDelegate, UITableViewDelegate, UITableViewDataSource, BaseInfoViewDelegate>

@property(nonatomic, retain)NSMutableArray *categoryArr;
@property(nonatomic, retain)NSMutableArray *categoryUrlArr;
@property(nonatomic, retain)NSMutableArray *playerVideosArr;

@property(nonatomic, assign)int likeNum;
@property(nonatomic, assign)BOOL isClick;
@property(nonatomic, assign)BOOL isLike;
@property(nonatomic, retain)UIView *loadingView;

@property(nonatomic, retain)NSMutableArray *shareArr;
@property(nonatomic, retain)UIView *lbl;
@end

@implementation PlayerDetailVC

-(void)loadView{
    [super loadView];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"球员介绍";
    // 分享
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithIcons:@[@"share.png"] target:self action:@selector(shareBtnClicked:)];
    
    self.categoryArr = [NSMutableArray array];
    self.categoryUrlArr = [NSMutableArray array];
    self.playerVideosArr = [NSMutableArray array];
    [self requestData];
}

-(void)requestData{
    NSString *urlStr = [NSString stringWithFormat:@"games/players/%@/basic", self.playerId];
    [CommonRequest requstPath:urlStr loadingDic:nil queryParam:nil success:^(CommonRequest *request, id jsonDict) {
        [self dealWithDic: jsonDict];
    } failure:^(CommonRequest *request, NSError *error) {
        NSLog(@"error = %@", error);
    }];
}

-(void)requestLikes:(UIView *)view{
    BaseInfoView *baseView = (BaseInfoView *)view;
    UIButton *likeButton = baseView.likeBtn;
    NSString *urlStr = [NSString stringWithFormat:@"like/likes/%@?type=player", self.playerId];
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
    NSMutableArray *cateArr = [NSMutableArray arrayWithArray:[dict objectForKey:@"urls"]];
    self.playerVideosArr = [PlayerVideoModel arrayOfModelsFromDictionaries:[dict objectForKey:@"playerVideos"]];
    
    for(NSDictionary *dic in cateArr){
        [self.categoryArr addObject:dic.allKeys[0]];
        [self.categoryUrlArr addObject:dic.allValues[0]];
    }
    if(self.playerVideosArr.count != 0){
        [self.categoryArr addObject:@"高光时刻"];
    }
    //基本信息
    NSString *birthday = [self timeStampChangeTimeWithTimeStamp:[dict objectForKey:@"birthday"] timeStyle:@"YYYY-MM-dd"];
    NSString *position;
    if([[dict objectForKey:@"nationTeam"] isKindOfClass:[NSDictionary class]]){
        position = [[dict objectForKey:@"nationTeam"] objectForKey:@"position"] != nil?[[dict objectForKey:@"nationTeam"] objectForKey:@"position"]:@"-";
    }else{
        position = @"-";
    }
    NSString *club;
    if([[dict objectForKey:@"club"] isKindOfClass:[NSDictionary class]]){
        club = [[dict objectForKey:@"club"] objectForKey:@"name"] != nil?[[dict objectForKey:@"club"] objectForKey:@"name"]:@"-";
    }else{
        club = @"-";
    }
    
    BaseInfoView *baseView = [[BaseInfoView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 167) andAvatar:[dict objectForKey:@"avatar"] andName:[dict objectForKey:@"name"] andBirday:birthday andHeight:[dict objectForKey:@"height"] andWeight:[dict objectForKey:@"weight"] andPosition:position andBirthplace:[dict objectForKey:@"birthplace"] andClub:club];
    baseView.delegate = self;
    [self.view addSubview:baseView];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, baseView.bottom, SCREEN_WIDTH, 1)];
    lineView.backgroundColor = HEXRGBCOLOR(0x9a9a9a);
    [self.view addSubview:lineView];
    // 类目栏
    DefineWeak(self);
    CategoryView *cateView = [[CategoryView alloc] initWithFrame:CGRectMake(0, lineView.bottom, SCREEN_WIDTH, 32) category:self.categoryArr];
    cateView.ClickBtn = ^(CGFloat index){
        [Weak(self) clickBtn:(index)];
    };
    [self.view addSubview:cateView];
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, cateView.bottom - 1, SCREEN_WIDTH, 1)];
    lineView1.backgroundColor = HEXRGBCOLOR(0x9a9a9a);
    [self.view addSubview:lineView1];
    
    [self requestLikes:baseView];
    [self clickBtn:0];
}

-(void)clickBtn:(CGFloat)tag{
    NSString *cate = [self.categoryArr objectAtIndex:tag];
    if([cate isEqualToString:@"高光时刻"]){
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 264, SCREEN_WIDTH, SCREEN_HEIGHT - 264) style:UITableViewStylePlain];
        [self.view addSubview:tableView];
        tableView.delegate = self;
        tableView.dataSource = self;
        [tableView registerClass:[PlayerVideoCell class] forCellReuseIdentifier:kReuseId];
    }else{
        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 264, SCREEN_WIDTH, SCREEN_HEIGHT - 264)];
        [self.view addSubview:webView];
        webView.delegate = self;
        webView.backgroundColor = kwhiteColor;
        NSURL *url = [NSURL URLWithString:[self.categoryUrlArr objectAtIndex:tag]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [webView loadRequest:request];
    }
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
    NSDictionary *dic = @{@"type":@"player", @"target":self.playerId, @"like":@1};
    [CommonRequest requstPath:@"like/likes" loadingDic:nil postParam:dic success:^(CommonRequest *request, id jsonDict) {
        NSLog(@"succeed!%@", jsonDict);
        [btn setTitle:[NSString stringWithFormat:@"%d", _likeNum + 1] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"fired"] forState:UIControlStateNormal];
    } failure:^(CommonRequest *request, NSError *error) {
        NSLog(@"error: %@", error);
    }];
    _isClick = YES;
    
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView{
    NSLog(@"+++webViewDidStartLoad");
    //    self.loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, 274, SCREEN_WIDTH, SCREEN_HEIGHT - 274)];
    //    _loadingView.backgroundColor = kwhiteColor;
    //    [self.view addSubview:_loadingView];
    //
    //    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"placeHold_newsLoading.jpg"]];
    //    imageView.center = CGPointMake(self.view.centerX, self.view.centerY - 310);
    //    imageView.contentMode = UIViewContentModeScaleAspectFit;
    //    [_loadingView addSubview:imageView];
    //
    //    UILabel *reminderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, imageView.bottom + 15, SCREEN_WIDTH, 20)];
    //    reminderLabel.text = @"内容正飞奔在网络中";
    //    reminderLabel.textAlignment = NSTextAlignmentCenter;
    //    reminderLabel.font = [UIFont systemFontOfSize:14];
    //    reminderLabel.textColor = HEXRGBCOLOR(0xd9d9d9);
    //    [_loadingView addSubview:reminderLabel];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"succeed!");
    //    [_loadingView removeFromSuperview];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"error = %@", error);
}

#pragma mark - UITabView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.playerVideosArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PlayerVideoModel *video = self.playerVideosArr[indexPath.row];
    PlayerVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:kReuseId forIndexPath:indexPath];
    if(!cell){
        cell = [[PlayerVideoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kReuseId];
    }
    //  bu布局
    [cell displayCell:video];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SCREEN_WIDTH / 2;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PlayerVideoModel *video = self.playerVideosArr[indexPath.row];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", kQiNiuHeaderPathPrifx, video.url];
    NSURL *url = [NSURL URLWithString:urlStr];
    PlayerVideoVC *playerVideoVC = [[PlayerVideoVC alloc] initWithUrl:url];
    
    [self.navigationController pushViewController:playerVideoVC animated:YES];
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
    NSString *shareText = [NSString stringWithFormat:@"%@", _playerName];
    NSString *shareUrl = [self.categoryUrlArr objectAtIndex:0];
    
    NSString *avatarUrl = [NSString stringWithFormat:@"%@%@", kQiNiuHeaderPathPrifx, _player.avatar];
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
