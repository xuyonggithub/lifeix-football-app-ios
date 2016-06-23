//
//  LearningVideoPlayVC.m
//  LiFangSport
//
//  Created by 张毅 on 16/6/22.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import "LearningVideoPlayVC.h"
#import "AJMediaPlayerKit.h"
#import "CommonRequest.h"
#import "VideoSingleInfoModel.h"
#import "LearningPlayControlView.h"

@interface LearningVideoPlayVC ()<AJMediaViewControllerDelegate>
{
    BOOL _isFullScreen;
    NSInteger _currentPlayVideoIndex;
}
//播放器
@property (nonatomic, strong) AJMediaPlayerViewController *mediaPlayerViewController;
@property (nonatomic, strong) UIView *disPlayView;
@property (nonatomic, strong) NSMutableArray *constraintList;
@property (nonatomic, strong) AJMediaPlayRequest *playRequest;
@property (nonatomic, strong) NSMutableArray *videoInfoArr;
@property(nonatomic,strong)LearningPlayControlView *ctrView;

@end

@implementation LearningVideoPlayVC
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _videoInfoArr = [NSMutableArray array];
    self.view.backgroundColor = [UIColor whiteColor];
    DefineWeak(self);
    //  播放器界面
    [self.view addSubview:self.mediaPlayerViewController.view];
    [self.mediaPlayerViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(Weak(self).view);
    }];
    [self addChildViewController:self.mediaPlayerViewController];
    [_mediaPlayerViewController initialShowFullScreen];//全屏

    _currentPlayVideoIndex = [_videoIdsArr indexOfObject:_videoId];;
    [self requestSingleVideoInfoWith:_videoId];
    //操控
    [self.view addSubview:self.ctrView];
}

-(void)requestSingleVideoInfoWith:(NSString *)videoStr{
    [CommonRequest requstPath:[NSString stringWithFormat:@"%@%@",kvideoSinglePath,videoStr] loadingDic:@{kLoadingType : @(RLT_OverlayLoad), kLoadingView : (self.view)} queryParam:nil success:^(CommonRequest *request, id jsonDict) {
        [self dealWithSingleVideoData:jsonDict];
    } failure:^(CommonRequest *request, NSError *error) {
        
    }];
}

-(void)dealWithSingleVideoData:(id )dic{
    [_videoInfoArr removeAllObjects];
    _videoInfoArr = (NSMutableArray *)[VideoSingleInfoModel modelDealDataFromWithDic:dic];
    [self toPlayWithAJMediaPlayerItem];
}

#pragma mark - FullScreen
- (void)showFullScreen
{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = UIInterfaceOrientationLandscapeRight;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

- (void)resignFullScreen
{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = UIInterfaceOrientationPortrait;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

- (void)toPlayWithAJMediaPlayerItem
{
    VideoSingleInfoModel *currentModel = _videoInfoArr[0];
    if (_currentPlayVideoIndex < _videoIdsArr.count) {
        [self.view bringSubviewToFront:self.mediaPlayerViewController.view];
        AJMediaPlayRequest *playRequest = [AJMediaPlayRequest playRequestWithVideoPath:currentModel.videoPath type:AJMediaPlayerVODStreamItem name:@"培训视频" uid:@"uid"];
        [self.mediaPlayerViewController startToPlay:playRequest];
    }
    [self.view bringSubviewToFront:self.ctrView];

}

#pragma mark - AJMediaViewControllerDelegate
- (void)mediaPlayerViewController:(AJMediaPlayerViewController *)mediaPlayerViewController videoDidPlayToEnd:(AJMediaPlayerItem *)playerItem
{

}
- (void)mediaPlayerViewControllerWillDismiss:(AJMediaPlayerViewController *)mediaPlayerViewController {
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UIViewControllerRotation
- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationLandscapeLeft | UIInterfaceOrientationLandscapeRight;
}

#pragma mark - Setter and Getter
- (AJMediaPlayerViewController *)mediaPlayerViewController
{
    if (!_mediaPlayerViewController) {
        _mediaPlayerViewController = [[AJMediaPlayerViewController alloc] initWithStyle:AJMediaPlayerStyleForiPhone delegate:self];
        _mediaPlayerViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _mediaPlayerViewController;
}

- (LearningPlayControlView *)ctrView
{
    if (!_ctrView) {
        _ctrView = [[LearningPlayControlView alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
        _ctrView.backgroundColor = kwhiteColor;
    }
    return _ctrView;
}

-(void)dealloc{
    [self resignFullScreen];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
