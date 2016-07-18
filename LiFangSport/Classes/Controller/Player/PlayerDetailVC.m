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
#define kBaseViewTag 100036
#define kWebViewTag 100037
#define kShareViewTag 1144

@interface PlayerDetailVC ()<UIWebViewDelegate, UITableViewDelegate, UITableViewDataSource, BaseInfoViewDelegate, UIScrollViewDelegate>

@property(nonatomic, retain)NSMutableArray *categoryArr;
@property(nonatomic, retain)NSMutableArray *categoryUrlArr;
@property(nonatomic, retain)NSMutableArray *playerVideosArr;

@property(nonatomic, assign)int likeNum;
@property(nonatomic, assign)BOOL isClick;
@property(nonatomic, assign)BOOL isLike;
@property(nonatomic, retain)UIView *loadingView;

@property(nonatomic, retain)NSMutableArray *shareArr;
@property(nonatomic, retain)UIView *lbl;
@property(nonatomic,strong)UIView *cateView;

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIWebView *webView;
@property(nonatomic,strong)UIScrollView *topScrollView;

@property(nonatomic, retain)NSMutableArray *shareNameArr;
@end

@implementation PlayerDetailVC

-(void)loadView{
    [super loadView];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"球员介绍";
    // 分享
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithIcons:@[@"share"] target:self action:@selector(shareBtnClicked:)];
    
    self.categoryArr = [NSMutableArray array];
    self.categoryUrlArr = [NSMutableArray array];
    self.playerVideosArr = [NSMutableArray array];
    [self requestData];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UIView *view = [self.view viewWithTag:kShareViewTag];
    for(UITouch *touch in touches){
        if([touch view] != view){
            UIView *view = [self.view viewWithTag:12345];
            [view removeFromSuperview];
        }
    }
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
    NSString *birthday;
    if(![[dic objectForKey:@"birthday"] isEqual:[NSNull null]]){
        birthday = [self timeStampChangeTimeWithTimeStamp:[dict objectForKey:@"birthday"] timeStyle:@"YYYY-MM-dd"];
    }else{
        birthday = @"-";
    }

    NSString *name;
    if(![[dic objectForKey:@"name"] isEqual:[NSNull null]]){
        name = [dict objectForKey:@"name"];
    }else{
        name = @"-";
    }
    
    NSString *position;
    if([[dict objectForKey:@"nationTeam"] isKindOfClass:[NSDictionary class]]){
        position = ![[[dict objectForKey:@"nationTeam"] objectForKey:@"position"] isEqual:[NSNull null]]?[[dict objectForKey:@"nationTeam"] objectForKey:@"position"]:@"-";
    }else{
        position = @"-";
    }
    NSString *club;
    if([[dict objectForKey:@"club"] isKindOfClass:[NSDictionary class]]){
        club = ![[[dict objectForKey:@"club"] objectForKey:@"name"] isEqual:[NSNull null]]?[[dict objectForKey:@"club"] objectForKey:@"name"]:@"-";
    }else{
        club = @"-";
    }
    
    NSString *birthplace;
    if(![[dic objectForKey:@"birthplace"] isEqual:[NSNull null]]){
        birthplace = [dict objectForKey:@"birthplace"];
    }else{
        birthplace = @"-";
    }
    
    NSString *height;
    if(![[dic objectForKey:@"height"] isEqual:[NSNull null]]){
        height = [NSString stringWithFormat:@"%@cm", [dict objectForKey:@"height"]];
    }else{
        height = @"-";
    }
    
    NSString *weight;
    if(![[dic objectForKey:@"weight"] isEqual:[NSNull null]]){
        weight = [NSString stringWithFormat:@"%@kg", [dict objectForKey:@"weight"]];
    }else{
        weight = @"-";
    }
    
    BaseInfoView *baseView = [[BaseInfoView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 167) andAvatar:[dict objectForKey:@"avatar"] andName:name andBirday:birthday andHeight:height andWeight:weight andPosition:position andBirthplace:birthplace andClub:club];
    baseView.delegate = self;
    baseView.tag = kBaseViewTag;
    [self.view addSubview:baseView];
    
    self.cateView = [[UIView alloc] initWithFrame:CGRectMake(0, baseView.bottom, SCREEN_WIDTH, 34)];
    [self.view addSubview:self.cateView];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    lineView.backgroundColor = HEXRGBCOLOR(0x9a9a9a);
    [self.cateView addSubview:lineView];
    // 类目栏
    DefineWeak(self);
    CategoryView *cateView = [[CategoryView alloc] initWithFrame:CGRectMake(0, lineView.bottom, SCREEN_WIDTH, 32) category:self.categoryArr];
    cateView.ClickBtn = ^(CGFloat index){
        [Weak(self) clickBtn:(index)];
    };
    [self.cateView addSubview:cateView];
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, cateView.bottom - 1, SCREEN_WIDTH, 1)];
    lineView1.backgroundColor = HEXRGBCOLOR(0x9a9a9a);
    [self.cateView addSubview:lineView1];
    
    [self requestLikes:baseView];
    [self clickBtn:0];
}

-(void)clickBtn:(CGFloat)tag{
    [self resetScrollViewTop];
    NSString *cate = [self.categoryArr objectAtIndex:tag];
    if([cate isEqualToString:@"高光时刻"]){
        [self.webView removeFromSuperview];
        if(!_tableView){
            _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 264, SCREEN_WIDTH, SCREEN_HEIGHT - 264) style:UITableViewStylePlain];
            _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            _tableView.delegate = self;
            _tableView.dataSource = self;
            [_tableView registerClass:[PlayerVideoCell class] forCellReuseIdentifier:kReuseId];
        }
        [self.view addSubview:_tableView];
//        [self.view bringSubviewToFront:_tableView];
    }else{
        [self.tableView removeFromSuperview];
        if(!_webView){
            _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 264, SCREEN_WIDTH, SCREEN_HEIGHT - 264)];
            _webView.delegate = self;
            _webView.scrollView.delegate = self;
            _webView.tag = kWebViewTag;
            _webView.backgroundColor = kwhiteColor;
        }
        [self.view addSubview:_webView];
//        [self.view bringSubviewToFront:_webView];
        NSURL *url = [NSURL URLWithString:[self.categoryUrlArr objectAtIndex:tag]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [_webView loadRequest:request];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    BaseInfoView *baseView = [self.view viewWithTag:kBaseViewTag];
    if(scrollView.contentOffset.y < 0){
        baseView.top = 64;
    }
    if([scrollView isKindOfClass:[UITableView class]]){
        CGFloat offsetY = scrollView.contentOffset.y;
        if (offsetY > baseView.height) {
            baseView.top = 64 - baseView.height;
        }else{
            baseView.top = 64 - offsetY;
        }
        _cateView.top = baseView.bottom;
        _tableView.top = _cateView.bottom;
        _tableView.height = kScreenHeight - _tableView.top;
        return;
    }
    UIWebView *webview = [self.view viewWithTag:kWebViewTag];
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > baseView.height) {
        baseView.top = 64 - baseView.height;
    }else{
        baseView.top = 64 - offsetY;
    }
    _cateView.top = baseView.bottom;
    webview.top = _cateView.bottom;
    webview.height = kScreenHeight - webview.top;
}

- (void)resetScrollViewTop
{
    BaseInfoView *baseView = [self.view viewWithTag:kBaseViewTag];
    [self.view bringSubviewToFront:baseView];
    [self.view bringSubviewToFront:_cateView];
    //  复位
    baseView.top = 64;
    _cateView.top = baseView.bottom;
    self.topScrollView.top = _cateView.bottom;
    self.topScrollView.height = kScreenHeight - self.topScrollView.top;
    self.topScrollView.contentOffset = CGPointMake(0, 0);
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

#pragma mark - UIWebviewdelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView{
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
    NSString *title = video.title;
    PlayerVideoVC *playerVideoVC = [[PlayerVideoVC alloc] init];
    playerVideoVC.url = urlStr;
    playerVideoVC.name = title;
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
