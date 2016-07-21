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
#import "PopViewKit.h"
#import "LearningPlayPopView.h"
#import "CommonLoading.h"
#import "VideoLearningUnitModel.h"

#define offsideHard  @"offsideTypeHard"

@interface LearningVideoPlayVC ()
    <AJMediaViewControllerDelegate>
{
    BOOL _isFullScreen;
    NSInteger _currentPlayVideoIndex;
    PopViewKit *popKit;
    LearningPlayPopView *rview;
}

//播放器
@property (nonatomic, strong) AJMediaPlayerViewController *mediaPlayerViewController;
@property (nonatomic, strong) UIView *disPlayView;
@property (nonatomic, strong) NSMutableArray *constraintList;
@property (nonatomic, strong) AJMediaPlayRequest *playRequest;
@property (nonatomic, strong) NSArray *videoInfoArr;
@property (nonatomic, strong) LearningPlayControlView *ctrView;
@property (nonatomic, strong) UIButton *nextBtn;
@property (nonatomic, strong) NSMutableArray *videoIdsArr;
@property (nonatomic, strong) NSArray *updateNextVideoArr;//超出原有数组后请求的

@end

@implementation LearningVideoPlayVC
#pragma mark - View Life Cycle
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.mediaPlayerViewController.currentMediaPlayerState == AJMediaPlayerStateContentPlaying||self.mediaPlayerViewController.currentMediaPlayerState == AJMediaPlayerStateContentLoading||self.mediaPlayerViewController.currentMediaPlayerState == AJMediaPlayerStateContentInit||self.mediaPlayerViewController.currentMediaPlayerState == AJMediaPlayerStateContentBuffering) {
        [self.mediaPlayerViewController stop];
    }
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _videoInfoArr = [NSArray array];
    _videoIdsArr = [NSMutableArray array];
    for (VideoLearningUnitModel *mod in _videosArr) {
        NSString *str = [NSString stringWithFormat:@"%@",mod.videos[0][@"id"]];
        [_videoIdsArr addObject:str];
    }
    self.view.backgroundColor = [UIColor whiteColor];
    DefineWeak(self);
    //  播放器界面
    [self.view addSubview:self.mediaPlayerViewController.view];
    [self.mediaPlayerViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(Weak(self).view);
    }];
    [self addChildViewController:self.mediaPlayerViewController];
    [_mediaPlayerViewController initialShowFullScreen];//全屏
    [self.mediaPlayerViewController showFastControl];

    _currentPlayVideoIndex = [_videoIdsArr indexOfObject:_videoId];;
    [self requestSingleVideoInfoWith:_videoId];
}

- (void)dealloc
{
    [self resignFullScreen];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Responder Methods
- (void)nextPlay
{
    _currentPlayVideoIndex ++;
    if (_currentPlayVideoIndex<_videoIdsArr.count) {
        NSString *videoid = [NSString stringWithFormat:@"%@",_videoIdsArr[_currentPlayVideoIndex]];
        [self requestSingleVideoInfoWith:videoid];
    }else if(_currentPlayVideoIndex>=_videoIdsArr.count && _videoIdsArr.count<=_pageCount){
        //请求下一组数据http://api.c-f.com:8000/football/elearning/training_categories/{categoryId}/pages/{index}
        _currentIndex ++;
        [CommonRequest requstPath:[NSString stringWithFormat:@"%@/%@%@%zd",kvideoListPath,_categoryID,@"/pages/",_currentIndex] loadingDic:@{kLoadingType : @(RLT_OverlayLoad), kLoadingView : (self.view)} queryParam:nil success:^(CommonRequest *request, id jsonDict) {
            [self dealWithJason:jsonDict];
            
        } failure:^(CommonRequest *request, NSError *error) {
            
        }];
        
    }else{
        [CommonLoading showTips:@"没有更多视频了"];
    }
}

//超出原有数组的下一个数据处理
-(void)dealWithJason:(id )dic
{
    _updateNextVideoArr = [VideoLearningUnitModel modelDealDataFromWithDic:dic];
    VideoLearningUnitModel *model = _updateNextVideoArr[0];
    [self requestSingleVideoInfoWith:model.videos[0][@"id"]];
}

- (void)requestSingleVideoInfoWith:(NSString *)videoStr
{
    [CommonRequest requstPath:[NSString stringWithFormat:@"%@%@",kvideoSinglePath,videoStr] loadingDic:@{kLoadingType : @(RLT_None), kLoadingView : (self.view)} queryParam:nil success:^(CommonRequest *request, id jsonDict) {
        [self dealWithSingleVideoData:jsonDict];
    } failure:^(CommonRequest *request, NSError *error) {
        
    }];
}

- (void)dealWithSingleVideoData:(id)dic
{
    _videoInfoArr = [VideoSingleInfoModel modelDealDataFromWithDic:dic];
    if (_isOffsideHard!=nil) {
        for (VideoSingleInfoModel *model in _videoInfoArr) {
            model.isOffsideHard = offsideHard;
        }
    }
    [self toPlayWithAJMediaPlayerItem];
    //操控
    [self.view addSubview:self.ctrView];
    //next
    if (_currentPlayVideoIndex < _pageCount-1) {
        [self.view addSubview:self.nextBtn];
        self.nextBtn.hidden = NO;
    }else{
        if (_nextBtn) {
            _nextBtn.hidden = YES;
        }
    }
}

#pragma mark - FullScreen
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
    if (_currentPlayVideoIndex < _pageCount) {//_videoIdsArr.count
        [self.view bringSubviewToFront:self.mediaPlayerViewController.view];
        AJMediaPlayRequest *playRequest = [AJMediaPlayRequest playRequestWithVideoPath:currentModel.videoPath type:AJMediaPlayerVODStreamItem name:currentModel.title uid:@"uid"];
        [self.mediaPlayerViewController startToPlay:playRequest];
    }
    [self.view bringSubviewToFront:self.ctrView];
    [self.view bringSubviewToFront:self.nextBtn];
}

#pragma mark - AJMediaViewControllerDelegate
- (void)mediaPlayerViewController:(AJMediaPlayerViewController *)mediaPlayerViewController videoDidPlayToEnd:(AJMediaPlayerItem *)playerItem
{
    self.mediaPlayerViewController.isAddtionView = YES;
    [self.mediaPlayerViewController showPlaybackControlsWhenPlayEnd];
}

- (void)mediaPlayerViewControllerWillDismiss:(AJMediaPlayerViewController *)mediaPlayerViewController
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}

//播放器控制栏即将出现
- (void)mediaPlayerViewControllerPlaybackControlsWillAppear:(AJMediaPlayerViewController *)mediaPlayerViewController
{
    _ctrView.hidden = NO;
    if (_currentPlayVideoIndex >= _pageCount-1) {
        if (_nextBtn==nil) {
            return;
        }
        _nextBtn.hidden = YES;
    }else{
    _nextBtn.hidden = NO;
    }
}

//播放器控制栏已经消失
- (void)mediaPlayerViewControllerPlaybackControlsDidDisappear:(AJMediaPlayerViewController *)mediaPlayerViewController
{
    _ctrView.hidden = YES;
    _nextBtn.hidden = YES;
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
    if (_ctrView) {
        _ctrView = nil;
    }
        VideoSingleInfoModel *model = [[VideoSingleInfoModel alloc]init];
    if (!_videoInfoArr) {
        return nil;
    }
    model = _videoInfoArr[0];
    _ctrView = [[LearningPlayControlView alloc]initWithFrame:CGRectMake(0, 200, 120, 175) WithModel:model];
    _ctrView.userInteractionEnabled = YES;
    _ctrView.right = kScreenWidth;
    _ctrView.centerY = kScreenHeight/2;

    DefineWeak(self);
    DefineWeak(_videoIdsArr);
    DefineWeak(_currentPlayVideoIndex);
    _ctrView.replayBlock = ^(void){
        if (Weak(self).videoInfoArr) {
            [Weak(self) toPlayWithAJMediaPlayerItem];
            //操控
            [Weak(self).view addSubview:Weak(self).ctrView];
            //next
            [Weak(self).view addSubview:Weak(self).nextBtn];
        }
    };
    if (!popKit) {
        popKit = [[PopViewKit alloc] init];
        popKit.bTapDismiss = YES;
        popKit.bInnerTapDismiss = NO;
    }
    if (!rview) {
        rview = [[LearningPlayPopView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        rview.center = Weak(self).view.center;
        rview.backgroundColor = kclearColor;
    }
    DefineWeak(popKit);
    DefineWeak(rview);
    _ctrView.factorsBlock = ^(void){
        [Weak(self).mediaPlayerViewController pauseByAdditionView];
        [Weak(self).mediaPlayerViewController invalidateMediaPlayerNavigationBarTimer];
        [Weak(popKit) popView:Weak(rview) animateType:PAT_Alpha];
        Weak(rview).closeBc = ^(void){
            [Weak(popKit) dismiss:YES];
        };
        Weak(popKit).dismissBlock = ^(void){
            [Weak(self).mediaPlayerViewController playByAdditionView];
            [Weak(self).mediaPlayerViewController fireMediaPlayerNavigationBarTimer];
        };
        [Weak(rview) setModel:model WithType:LPPOP_FACTORS];
    };
    _ctrView.decisionBlock = ^(void){
        [Weak(self).mediaPlayerViewController pauseByAdditionView];
        [Weak(self).mediaPlayerViewController invalidateMediaPlayerNavigationBarTimer];
        [Weak(popKit) popView:Weak(rview) animateType:PAT_Alpha];
        Weak(rview).closeBc = ^(void){
            [Weak(popKit) dismiss:YES];
        };
        Weak(popKit).dismissBlock = ^(void){
            [Weak(self).mediaPlayerViewController playByAdditionView];
            [Weak(self).mediaPlayerViewController fireMediaPlayerNavigationBarTimer];
        };
        [Weak(rview) setModel:model WithType:LPPOP_DECISION];
    };
    _ctrView.detailBlock = ^(void){
        [Weak(self).mediaPlayerViewController pauseByAdditionView];
        [Weak(self).mediaPlayerViewController invalidateMediaPlayerNavigationBarTimer];
        [Weak(popKit) popView:Weak(rview) animateType:PAT_Alpha];
        Weak(rview).closeBc = ^(void){
            [Weak(popKit) dismiss:YES];
        };
        Weak(popKit).dismissBlock = ^(void){
            [Weak(self).mediaPlayerViewController playByAdditionView];
            [Weak(self).mediaPlayerViewController fireMediaPlayerNavigationBarTimer];
        };
        [Weak(rview) setModel:model WithType:LPPOP_DETAIL];
    };
    _ctrView.ruleBlock = ^(void){
        [Weak(self).mediaPlayerViewController pauseByAdditionView];
        [Weak(self).mediaPlayerViewController invalidateMediaPlayerNavigationBarTimer];
        [Weak(popKit) popView:Weak(rview) animateType:PAT_Alpha];
        Weak(rview).closeBc = ^(void){
            [Weak(popKit) dismiss:YES];
        };
        Weak(popKit).dismissBlock = ^(void){
            [Weak(self).mediaPlayerViewController playByAdditionView];
            [Weak(self).mediaPlayerViewController fireMediaPlayerNavigationBarTimer];
        };
        [Weak(rview) setModel:model WithType:LPPOP_RULE];
    };

    return _ctrView;
}

- (UIButton *)nextBtn
{
    if (!_nextBtn) {
        _nextBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 20, 70, 30)];
        _nextBtn.right = kScreenWidth-10;
        _nextBtn.backgroundColor = kclearColor;
        [_nextBtn setTitle:@"下一个>>" forState:UIControlStateNormal];
        [_nextBtn setTitleColor:kwhiteColor forState:UIControlStateNormal];
        _nextBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        _nextBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_nextBtn addTarget:self action:@selector(nextPlay) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextBtn;
}

@end
