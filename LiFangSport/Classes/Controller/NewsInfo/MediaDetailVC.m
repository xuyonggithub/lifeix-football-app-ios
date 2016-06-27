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
    self.title = @"正文";
    self.bgScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, self.likeBtn.frame.origin.y + 55);
    //    [self requestLikes];
    [self requestData];
    //    [self.contentWebView loadRequest:];
}

-(void)requestData{
    NSString *urlStr = [NSString stringWithFormat:@"wemedia/posts/%@", self.media.mediaId];
    [CommonRequest requstPath:urlStr loadingDic:nil queryParam:nil success:^(CommonRequest *request, id jsonDict) {
        NSDictionary *dic = jsonDict;
        self.htmlStr = [dic objectForKey:@"content"];
        [self.contentWebView loadHTMLString:self.htmlStr baseURL:nil];
    } failure:^(CommonRequest *request, NSError *error) {
        NSLog(@"error = %@", error);
    }];
    
}

-(void)requestLikes{
    NSString *urlStr = [NSString stringWithFormat:@"like/likes/%@?type=post", self.media.mediaId];
    [CommonRequest requstPath:urlStr loadingDic:nil queryParam:nil success:^(CommonRequest *request, id jsonDict) {
        NSLog(@"data = %@", jsonDict);
        NSDictionary *dic = jsonDict;
        int like = [[dic objectForKey:@"likeNum"] integerValue];
        int unLike = [[dic objectForKey:@"unlikeNum"] integerValue];
        [self.likeBtn setTitle:[NSString stringWithFormat:@"%d", like] forState:UIControlStateNormal];
        [self.unLikeBtn setTitle:[NSString stringWithFormat:@"%d", unLike] forState:UIControlStateNormal];
    } failure:^(CommonRequest *request, NSError *error) {
        NSLog(@"error = %@", error);
    }];
}

#pragma mark - btn点击事件

-(void)shareBtnClicked{
    NSLog(@"分享");
}

-(void)likeBtnClicked{
    NSLog(@"like");
    [self isLike:YES];
}

-(void)unLikeBtnClicked{
    NSLog(@"unLike");
    [self isLike:NO];
}

-(void)isLike:(BOOL)islike{
    
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


@end
