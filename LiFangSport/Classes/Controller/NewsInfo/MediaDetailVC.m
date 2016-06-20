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
@interface MediaDetailVC ()<UIScrollViewDelegate, UIWebViewDelegate>

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
    
    //    self.bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.height - 44)];
    //    self.bgScrollView.showsVerticalScrollIndicator = NO;
    //    self.bgScrollView.delegate = self;
    //    [self.view addSubview:self.bgScrollView];
    /*
     //topView
     UIImageView *topView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, topViewH)];
     [topView sd_setImageWithURL:self.media.images[0]];
     [self.view addSubview: topView];
     self.topView = topView;
     */
    //分享
    self.shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.shareBtn.frame = CGRectMake(0, self.view.height - 44, SCREEN_WIDTH, 44);
    [self.shareBtn setTitle:@"分享" forState: UIControlStateNormal];
    self.shareBtn.titleLabel.textColor = [UIColor whiteColor];
    self.shareBtn.titleLabel.font = kBasicBigTitleFont;
    self.shareBtn.backgroundColor = HEXRGBCOLOR(0xae1417);
    [self.shareBtn addTarget:self action:@selector(shareBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.shareBtn];
    
    //webView
    self.contentWebView = [[UIWebView alloc] initWithFrame: CGRectMake(0, 44, SCREEN_WIDTH, self.view.height - 88)];
    self.contentWebView.delegate = self;
    //    UIScrollView *tempView = self.contentWebView.scrollView;
    //    tempView.scrollEnabled = false;
    [self.view addSubview: self.contentWebView];
    
    /*
     //标题
     NSDictionary *attributes = [NSDictionary dictionaryWithObject:kBasicBigTitleFont forKey:NSFontAttributeName];
     CGRect rect = [self.media.title boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 20, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
     CGFloat titileHeight = rect.size.height;
     self.titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, topViewH + 10, SCREEN_WIDTH - 20, titileHeight)];
     self.titleLbl.font = kBasicBigDetailTitleFont;
     self.titleLbl.textColor = [UIColor blackColor];
     self.titleLbl.text = self.media.title;
     self.titleLbl.numberOfLines = 0;
     [self.view addSubview:self.titleLbl];
     
     //时间
     self.timeLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, topViewH + 20 + titileHeight, SCREEN_WIDTH - 20, 20)];
     self.timeLbl.textColor = HEXRGBACOLOR(0x999999, 1.0);
     NSString *timeStr = [self TimeStamp: self.media.createTime];
     self.timeLbl.text = timeStr;
     [self.bgScrollView addSubview:self.timeLbl];
     
     UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, topViewH + 45 + titileHeight, SCREEN_WIDTH, 1)];
     lineView.backgroundColor = HEXRGBACOLOR(0xffffff, 1.0);
     //    lineView.backgroundColor = [UIColor grayColor];
     [self.bgScrollView addSubview:lineView];
     
     // 计算正文高度
     NSDictionary *attribute = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize: 14] forKey:NSFontAttributeName];
     CGRect contnentRect = [self.media.content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 20, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil];
     CGFloat contentHeight = contnentRect.size.height;
     self.contentLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, topViewH + 55 + titileHeight, SCREEN_WIDTH - 20, contentHeight)];
     self.contentLbl.font = [UIFont systemFontOfSize:14];
     self.contentLbl.textColor = HEXRGBCOLOR(0x2a2a2a);
     self.contentLbl.text = self.media.content;
     [self.bgScrollView addSubview:self.contentLbl];
     
     // 顶踩
     self.likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
     self.likeBtn.frame = CGRectMake((SCREEN_WIDTH - 170)/2, self.contentLbl.frame.origin.y + contentHeight + 30, 80, 50);
     [self.likeBtn addTarget:self action:@selector(likeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
     [self.likeBtn setTitle:@"顶" forState: UIControlStateNormal];
     self.likeBtn.backgroundColor = HEXRGBCOLOR(0xae1417);
     self.likeBtn.titleLabel.textColor = [UIColor whiteColor];
     [self.bgScrollView addSubview:self.likeBtn];
     
     self.unLikeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
     self.unLikeBtn.frame = CGRectMake((SCREEN_WIDTH - 170)/2 + 90, self.contentLbl.frame.origin.y + contentHeight + 30, 80, 50);
     [self.unLikeBtn addTarget:self action:@selector(unLikeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
     [self.unLikeBtn setTitle:@"踩" forState: UIControlStateNormal];
     self.unLikeBtn.backgroundColor = HEXRGBCOLOR(0xae1417);
     self.unLikeBtn.titleLabel.textColor = [UIColor whiteColor];
     [self.bgScrollView addSubview:self.unLikeBtn];
     */
}

-(void)viewDidLoad{
    self.title = @"正文";
    self.bgScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, self.likeBtn.frame.origin.y + 55);
    //    [self requestLikes];
    [self requestData];
    //    [self.contentWebView loadRequest:];
}

-(void)requestData{
    NSString *urlStr = [NSString stringWithFormat:@"wemedia/posts/57636e13e4b08f4bfcedfd90"];
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
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonDict options:NSJSONReadingMutableContainers error:nil];
        NSString *likeNum = [dic objectForKey:@"likeNum"];
        NSString *unLikeNum = [dic objectForKey:@"unlikeNum"];
        [self.likeBtn setTitle:likeNum forState:UIControlStateNormal];
        [self.unLikeBtn setTitle:unLikeNum forState:UIControlStateNormal];
    } failure:^(CommonRequest *request, NSError *error) {
        NSLog(@"error = %@", error);
    }];
}

#pragma mark - btn点击事件
//-(void)backBtnClicked{
//    [self.navigationController popViewControllerAnimated:YES];
//}

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

#pragma mark - scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat offsetH = -topViewH * 0.5 - offsetY;
    if (offsetH < 0) return;
    CGRect frame = self.topView.frame;
    frame.size.height = topViewH + offsetH;
    self.topView.frame = frame;
}

#pragma mark - webViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView{
    NSLog(@"+++webViewDidStartLoad");
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    //    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    NSLog(@"+++webViewDidFinishLoad");
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error{
    NSLog(@"+++error:%@", error);
}

// 时间戳转时间
-(NSString *)TimeStamp:(NSString *)strTime{
    NSTimeInterval time=[strTime doubleValue]+28800;
    NSDate*detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter*dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *currentDateStr = [dateFormatter stringFromDate:detaildate];
    return currentDateStr;
}


@end
