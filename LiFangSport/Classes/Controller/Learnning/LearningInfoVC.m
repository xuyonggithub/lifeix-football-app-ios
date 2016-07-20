//
//  LearningInfoVC.m
//  LiFangSport
//
//  Created by 张毅 on 16/6/22.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import "LearningInfoVC.h"
#import "UIBarButtonItem+SimAdditions.h"
#import "CommonRequest.h"
#import "PopViewKit.h"
#import "LearningInfoPopView.h"
#import "VideoLearningDetModel.h"
@interface LearningInfoVC ()<UIWebViewDelegate>{
    PopViewKit *popKit;
}
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)UIWebView *bwebView;
@property(nonatomic,strong)LearningInfoPopView *rightView;

@property(nonatomic, retain)UIView *loadingView;
@end

@implementation LearningInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [[NSMutableArray alloc]initWithArray:_catsArr];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    _bwebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _bwebView.delegate = self;
    VideoLearningDetModel *model = _dataArray[0];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kQiNiuHeaderPathPrifx,model.contentUri]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_bwebView loadRequest:request];
    [self.view addSubview:_bwebView];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)rightDrawerAction:(UIBarButtonItem *)sender {
    if (!popKit) {
        popKit = [[PopViewKit alloc] init];
        popKit.bTapDismiss = YES;
        popKit.bInnerTapDismiss = NO;
    }
    if (!_rightView) {
        _rightView = [[LearningInfoPopView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth/2, kScreenHeight) WithData:_catsArr];
    }
    DefineWeak(self);
    DefineWeak(popKit);
    _rightView.cellClickBc = ^(NSInteger index){
        if ((index)>_dataArray.count-1) {
            return ;
        }
        VideoLearningDetModel *model = Weak(self).dataArray[index];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kQiNiuHeaderPathPrifx,model.contentUri]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [Weak(self).bwebView loadRequest:request];
        [Weak(popKit) dismiss:YES];
    };
    _rightView.frame = CGRectMake(0, 0, kScreenWidth/2, kScreenHeight);
    popKit.contentOrigin = CGPointMake(APP_DELEGATE.window.width-_rightView.width, 0);
    
    [popKit popView:_rightView animateType:PAT_WidthRightToLeft];
}
#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView{
    if(self.loadingView == nil){
        self.loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
        _loadingView.backgroundColor = kwhiteColor;
        [self.view addSubview:_loadingView];
    }
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    imageView.image = [UIImage imageNamed:@"placeHold_newsLoading.jpg"];
    imageView.center = CGPointMake(self.view.centerX, self.view.centerY - 100);
    [_loadingView addSubview:imageView];
    
    UILabel *reminderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, imageView.bottom + 15, SCREEN_WIDTH, 20)];
    reminderLabel.text = @"内容正飞奔在网络中";
    reminderLabel.textAlignment = NSTextAlignmentCenter;
    reminderLabel.font = [UIFont systemFontOfSize:14];
    reminderLabel.textColor = HEXRGBCOLOR(0xd9d9d9);
    [_loadingView addSubview:reminderLabel];

}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [_loadingView removeFromSuperview];
    _loadingView = nil;
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error{
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
