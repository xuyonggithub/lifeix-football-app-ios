//
//  MediaDetailVC.m
//  LiFangSport
//
//  Created by Lifeix on 16/6/12.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import "MediaDetailVC.h"
#import "UIImageView+WebCache.h"
#import "CommonRequest.h"
#import "UIBarButtonItem+SimAdditions.h"
#import "UMSocial.h"
#import "UMSocialSnsData.h"
#import "CommonLoading.h"

const CGFloat topViewH = 180;
@interface MediaDetailVC ()<UIWebViewDelegate>

@property(nonatomic, retain)UIScrollView *bgScrollView;
@property(nonatomic, retain)UIImageView *topView;
@property(nonatomic, retain)UILabel *titleLbl;
@property(nonatomic, retain)UILabel *timeLbl;
@property(nonatomic, retain)UILabel *contentLbl;
@property(nonatomic, retain)UIWebView *contentWebView;
@property(nonatomic, retain)UIButton *likeBtn;
@property(nonatomic, retain)UIButton *unLikeBtn;
@property(nonatomic, retain)UIButton *shareBtn;
@property(nonatomic, copy)NSString *htmlStr;

@property(nonatomic, assign)int likeNum;
@property(nonatomic, assign)int unLikeNum;
@property(nonatomic, assign)BOOL isClick;
@property(nonatomic, assign)BOOL isLike;
@end

@implementation MediaDetailVC

-(void)loadView{
    [super loadView];
    
    //分享
    self.shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.shareBtn.frame = CGRectMake(0, self.view.height - 44, SCREEN_WIDTH, 44);
    [self.shareBtn setTitle:@"分享" forState: UIControlStateNormal];
    [self.shareBtn setImage:[UIImage imageNamed:@"share.png"] forState:UIControlStateNormal];
    self.shareBtn.titleLabel.textColor = [UIColor whiteColor];
    self.shareBtn.titleLabel.font = kBasicBigTitleFont;
    self.shareBtn.backgroundColor = HEXRGBCOLOR(0xae1417);
    [self.shareBtn addTarget:self action:@selector(shareBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.shareBtn];
    
    //webView
    self.contentWebView = [[UIWebView alloc] initWithFrame: CGRectMake(0, 0, SCREEN_WIDTH, self.view.height - 108)];
    self.contentWebView.delegate = self;
    //    UIScrollView *tempView = self.contentWebView.scrollView;
    //    tempView.scrollEnabled = false;
    
    //    [self.view addSubview: self.contentWebView];
    
}

-(void)viewDidLoad{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcons:@[@"backIconwhite"] target:self action:@selector(rollBack)];
    
    self.title = @"正文";
    self.bgScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, self.likeBtn.frame.origin.y + 55);
    NSString *urlStr = self.media.url;
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *requset = [NSURLRequest requestWithURL:url];
    [self.contentWebView loadRequest:requset];
    self.isClick = NO;
}
-(void)rollBack{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)requestLikes{
    NSString *urlStr = [NSString stringWithFormat:@"like/likes/%@?type=post", self.media.mediaId];
    [CommonRequest requstPath:urlStr loadingDic:nil queryParam:nil success:^(CommonRequest *request, id jsonDict) {
        NSLog(@"data = %@", jsonDict);
        NSDictionary *dic = jsonDict;
        if(![[dic objectForKey:@"like"] isEqual:[NSNull null]]){
            self.isLike = [[dic objectForKey:@"like"] boolValue];
        }else{
            self.isLike = nil;
        }
        int like = [[dic objectForKey:@"likeNum"] intValue];
        int unLike = [[dic objectForKey:@"unlikeNum"] intValue];
        self.likeNum = like;
        self.unLikeNum = unLike;
        [self.likeBtn setTitle:[NSString stringWithFormat:@"%d", like] forState:UIControlStateNormal];
        [self.unLikeBtn setTitle:[NSString stringWithFormat:@"%d", unLike] forState:UIControlStateNormal];
    } failure:^(CommonRequest *request, NSError *error) {
        NSLog(@"error = %@", error);
    }];
}

#pragma mark - btn点击事件

-(void)shareBtnClicked{
    NSLog(@"分享");
    [self setupShareView];
}

-(void)likeBtnClicked{
    NSLog(@"like");
    if(_isClick == YES){
        [CommonLoading showTips:@"重复操作"];
        return;
    }else if (self.isLike != nil){
        if(_isLike == YES){
            [CommonLoading showTips:@"不能重复点赞"];
        }else{
            [CommonLoading showTips:@"重复操作"];
        }
        return;
    };
    NSDictionary *dic = @{@"type":@"post", @"target":self.media.mediaId, @"like":@1};
    [CommonRequest requstPath:@"like/likes" loadingDic:nil postParam:dic success:^(CommonRequest *request, id jsonDict) {
        NSLog(@"succeed!%@", jsonDict);
        [self.likeBtn setTitle:[NSString stringWithFormat:@"%d", _likeNum + 1] forState:UIControlStateNormal];
    } failure:^(CommonRequest *request, NSError *error) {
        NSLog(@"error: %@", error);
    }];
    _isClick = YES;
}

-(void)unLikeBtnClicked{
    NSLog(@"unLike");
    if(_isClick == YES){
        [CommonLoading showTips:@"重复操作"];
        return;
    }else if (_isLike != nil){
        if(_isLike == YES){
            [CommonLoading showTips:@"重复操作"];
        }else{
            [CommonLoading showTips:@"不能重复点踩"];
        }
        return;
    };
    NSDictionary *dic = @{@"type":@"post", @"target":self.media.mediaId, @"like":@0};
    [CommonRequest requstPath:@"like/likes" loadingDic:nil postParam:dic success:^(CommonRequest *request, id jsonDict) {
        NSLog(@"succeed!%@", jsonDict);
        [self.unLikeBtn setTitle:[NSString stringWithFormat:@"%d", _unLikeNum + 1] forState:UIControlStateNormal];
    } failure:^(CommonRequest *request, NSError *error) {
        NSLog(@"error: %@", error);
    }];
    _isClick = YES;
}

#pragma mark - webViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView{
    NSLog(@"+++webViewDidStartLoad");
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    NSLog(@"+++webViewDidFinishLoad");
    
    CGRect foo = self.contentWebView.frame;
    foo.size.height = [[self.contentWebView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] floatValue];
    self.contentWebView.frame = foo;
    
    // contentView
    UIScrollView *mainView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, self.view.height - 108)];
    [self.view addSubview:mainView];
    [mainView addSubview:self.contentWebView];
    
    // 顶踩
    self.likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.likeBtn.frame = CGRectMake((SCREEN_WIDTH - 210)/2, _contentWebView.bottom + 10, 100, 50);
    [self.likeBtn addTarget:self action:@selector(likeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.likeBtn setTitle:@"顶" forState: UIControlStateNormal];
    [self.likeBtn setImage:[UIImage imageNamed:@"good.png"] forState:UIControlStateNormal];
    [self.likeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [mainView addSubview:self.likeBtn];
    
    self.unLikeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.unLikeBtn.frame = CGRectMake((SCREEN_WIDTH - 210)/2 + 110, _contentWebView.bottom + 10, 100, 50);
    [self.unLikeBtn addTarget:self action:@selector(unLikeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.unLikeBtn setTitle:@"踩" forState: UIControlStateNormal];
    [self.unLikeBtn setImage:[UIImage imageNamed:@"bad.png"] forState:UIControlStateNormal];
    //    self.unLikeBtn.backgroundColor = HEXRGBCOLOR(0xae1417);
    [self.unLikeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [mainView addSubview:self.unLikeBtn];
    
    [self requestLikes];
    
    mainView.contentSize = CGSizeMake(SCREEN_WIDTH, _unLikeBtn.bottom);
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error{
    NSLog(@"+++error:%@", error);
}

// 时间戳转时间
-(NSString *)TimeStamp:(NSString *)strTime{
    NSTimeInterval time=[strTime doubleValue]+28800;
    NSDate*detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter*dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSXXX"];
    NSString *currentDateStr = [dateFormatter stringFromDate:detaildate];
    return currentDateStr;
}

-(void)setupShareView{
    UIView *lbl = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
    lbl.bottom = _shareBtn.top;
    NSArray *arr = @[@"sina", @"微信好友", @"微信朋友圈", @"QQ空间"];
    for(int i = 0; i < 4; i++){
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(90 * i, 0, 80, 80);
        btn.backgroundColor = [UIColor grayColor];
        [btn addTarget:self action:@selector(didSelectedShareBtnIndex:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        btn.tag = 1000 + i;
        [lbl addSubview:btn];
    }
    [self.view addSubview:lbl];
}

#pragma mark - shareDelegate
-(void)didSelectedShareBtnIndex:(UIButton *)btn{
    NSInteger index = btn.tag - 1000;
    NSString *snsName;
    NSString *shareTitle = @"中国足球网";
    NSString *shareText = [NSString stringWithFormat:@"%@", _media.title];
    NSString *shareUrl = [NSString stringWithFormat:@"%@", _media.url] ;
    
    NSString *avatarUrl = [NSString stringWithFormat:@"%@", _media.image];
    
    UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:avatarUrl];
    
    UMSocialData *socialData;
    switch (index) {
        case 0:{ // 新浪微博
            snsName                                             = UMShareToSina;
            socialData                                          = [[UMSocialData alloc] initWithIdentifier:@"sinaweibo"];
            socialData.extConfig.sinaData.shareText             = [NSString stringWithFormat:@"%@\n%@%@",shareTitle,shareText,shareUrl];
            socialData.extConfig.sinaData.urlResource           = urlResource;
        }
            break;
        case 1:{ // 微信好友
            snsName                                             = UMShareToWechatSession;
            socialData                                          = [[UMSocialData alloc] initWithIdentifier:@"wechatSession"];
            socialData.extConfig.wechatSessionData.title        = shareTitle;
            socialData.extConfig.wechatSessionData.url          = shareUrl;
            socialData.extConfig.wechatSessionData.shareText    = shareText;
            socialData.extConfig.wechatSessionData.urlResource  = urlResource;
            
        }
            break;
        case 2:{ // 微信朋友圈
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
    
    UMSocialControllerService *shareService             = [[UMSocialControllerService alloc] initWithUMSocialData:socialData];
    UMSocialSnsPlatform *snsPlatform                    = [UMSocialSnsPlatformManager getSocialPlatformWithName:snsName];
    snsPlatform.snsClickHandler(self,shareService,YES);
}

@end
