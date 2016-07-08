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
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
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
