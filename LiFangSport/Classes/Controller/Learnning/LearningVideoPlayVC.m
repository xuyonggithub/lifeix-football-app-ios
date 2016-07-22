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
    <AJMediaViewControllerDelegate, UITableViewDelegate, UITableViewDataSource>
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
@property (nonatomic, strong) UITableView *playControlView;
@property (nonatomic, strong) LearningPlayPopView *playPopView;
@property (nonatomic, strong) NSMutableArray *playControlItems;
@property (nonatomic, strong) UIView *promptView;
@property (nonatomic, strong) UITextView *contentTextView;
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

    self.view.backgroundColor = [UIColor whiteColor];
    
    self.playControlItems = [NSMutableArray arrayWithCapacity:0];
    self.videoIdsArr = [NSMutableArray arrayWithCapacity:0];
    for (VideoLearningUnitModel *mod in _videosArr) {
        NSString *str = [NSString stringWithFormat:@"%@",mod.video[@"id"]];
        [self.videoIdsArr addObject:str];
    }
    
    _currentPlayVideoIndex = [self.videoIdsArr indexOfObject:self.videoId];;
    
    //  播放器界面
    [self.view addSubview:self.mediaPlayerViewController.view];
    [self.mediaPlayerViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self addChildViewController:self.mediaPlayerViewController];
    [_mediaPlayerViewController initialShowFullScreen];//全屏
    [self.mediaPlayerViewController showFastControl];

    [self requestSingleVideoInfoWith:self.videoId];
    
    [self.view addSubview:self.playControlView];
    [self.playControlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.and.right.equalTo(self.view);
        make.width.equalTo(@100);
        make.height.equalTo(@(33*self.playControlItems.count));
    }];
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
    if (_currentPlayVideoIndex<self.videoIdsArr.count) {
        NSString *videoid = [NSString stringWithFormat:@"%@",self.videoIdsArr[_currentPlayVideoIndex]];
        [self requestSingleVideoInfoWith:videoid];
    }else if(_currentPlayVideoIndex>=self.videoIdsArr.count && self.videoIdsArr.count<=_pageCount){
        //请求下一组数据http://api.c-f.com:8000/football/elearning/training_categories/{categoryId}/pages/{index}
        _currentIndex ++;
        [CommonRequest requstPath:[NSString stringWithFormat:@"%@/%@%@%zd",kvideoListPath,_categoryID,@"/video_pages/",_currentIndex] loadingDic:@{kLoadingType : @(RLT_OverlayLoad), kLoadingView : (self.view)} queryParam:nil success:^(CommonRequest *request, id jsonDict) {
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
    [self requestSingleVideoInfoWith:model.video[@"id"]];
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
    //[self.view addSubview:self.ctrView];
    [self.playControlItems removeAllObjects];
    
    [self.playControlItems addObject:@"重放"];
    
    VideoSingleInfoModel *model = _videoInfoArr[0];
    if (model.considerations.length > 0) {
        [self.playControlItems addObject:@"考虑因素"];
    }
    
    if (model.r1.count > 0 || model.r2.count > 0) {
        [self.playControlItems addObject:@"判罚决定"];
    }
    
    if (model.explanation.length > 0) {
        [self.playControlItems addObject:@"解释说明"];
    }
    
    if (model.rule.length > 0) {
        [self.playControlItems addObject:@"规则依据"];
    }
    
    [self.playControlView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(33*self.playControlItems.count));
    }];
    [self.playControlView reloadData];
    
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

- (void)closeBtnTouched:(id)sender
{
    [self.promptView removeFromSuperview];
    [self.mediaPlayerViewController playByAdditionView];
    [self.mediaPlayerViewController fireMediaPlayerNavigationBarTimer];
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
    if (_currentPlayVideoIndex < _pageCount) {//self.videoIdsArr.count
        AJMediaPlayRequest *playRequest = [AJMediaPlayRequest playRequestWithVideoPath:currentModel.videoPath type:AJMediaPlayerVODStreamItem name:currentModel.title uid:@"uid"];
        [self.mediaPlayerViewController startToPlay:playRequest];
    }
    //[self.view bringSubviewToFront:self.ctrView];
    [self.view bringSubviewToFront:self.nextBtn];
}

#pragma mark - UITableViewDelegate and UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.playControlItems.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 3;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 3)];
    footerView.backgroundColor = [UIColor clearColor];
    return footerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *customCellID = @"LFSimulationCenterCellID";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:customCellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:customCellID];
        //cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2];
    }
    cell.textLabel.text = self.playControlItems[indexPath.section];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *title = self.playControlItems[indexPath.section];
    if ([title isEqualToString:@"重放"]) {
        [self.promptView removeFromSuperview];
        [self.playPopView removeFromSuperview];
        [self toPlayWithAJMediaPlayerItem];
    }else if ([title isEqualToString:@"判罚决定"]) {
        [self.mediaPlayerViewController pauseByAdditionView];
        [self.mediaPlayerViewController invalidateMediaPlayerNavigationBarTimer];
        
        VideoSingleInfoModel *model = self.videoInfoArr[0];
        [self.playPopView setModel:model WithType:LPPOP_DECISION];
        if (!self.playPopView.superview) {
            [self.view addSubview:self.playPopView];
        }
        [self.promptView removeFromSuperview];
        
        [self.view bringSubviewToFront:self.playControlView];
    }else {
        [self.mediaPlayerViewController pauseByAdditionView];
        [self.mediaPlayerViewController invalidateMediaPlayerNavigationBarTimer];

        if (!self.promptView.superview) {
            [self.view addSubview:self.promptView];
        }
        [self.playPopView removeFromSuperview];
        
        VideoSingleInfoModel *model = self.videoInfoArr[0];
        
        NSString *content = nil;
        
        if ([title isEqualToString:@"考虑因素"]) {
            content = model.considerations;
        }else if ([title isEqualToString:@"解释说明"]) {
            content = model.explanation;
        }else if ([title isEqualToString:@"规则依据"]) {
            content = model.rule;
        }
        
        NSMutableParagraphStyle *contentParagraphStyle = [[NSMutableParagraphStyle alloc] init];
        contentParagraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        contentParagraphStyle.lineSpacing = 6;
        contentParagraphStyle.alignment = NSTextAlignmentJustified;
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[self replaceXFrom:content] attributes:[NSDictionary dictionaryWithObjectsAndKeys:contentParagraphStyle, NSParagraphStyleAttributeName, [UIFont systemFontOfSize:18], NSFontAttributeName, [UIColor whiteColor], NSForegroundColorAttributeName, @0.5, NSKernAttributeName, nil]];
        
        _contentTextView.attributedText = attributedString;
        

        [self.view bringSubviewToFront:self.playControlView];
    }
//    LFSimulationTestDetailController *simulationTestDetailCtrl = [[LFSimulationTestDetailController alloc] init];
//    simulationTestDetailCtrl.categoryModel = self.dataArray[indexPath.row];
//    [self.navigationController pushViewController:simulationTestDetailCtrl animated:YES];

}

-(NSString *)replaceXFrom:(NSString *)string{
    if (string) {
        NSMutableString *ms = [[NSMutableString alloc]initWithString:string];
        [ms replaceOccurrencesOfString:@"<p>" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, ms.length)];
        [ms replaceOccurrencesOfString:@"</p>" withString:@"\n" options:NSCaseInsensitiveSearch range:NSMakeRange(0, ms.length)];
        return ms;
    }
    return nil;
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
    //_ctrView.hidden = NO;
    self.playControlView.hidden = NO;
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
    //_ctrView.hidden = YES;
    self.playControlView.hidden = YES;
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

- (UITableView *)playControlView
{
    if (!_playControlView) {
        _playControlView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _playControlView.delegate = self;
        _playControlView.dataSource = self;
        _playControlView.rowHeight = 30;
        _playControlView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _playControlView.tableFooterView = [UIButton buttonWithType:UIButtonTypeCustom];
        _playControlView.scrollEnabled = NO;
        _playControlView.backgroundColor = [UIColor clearColor];
    }
    return _playControlView;
}

- (UIView *)promptView
{
    if (!_promptView) {
        _promptView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _promptView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
        _contentTextView = [[UITextView alloc]init];
        _contentTextView.frame = CGRectMake(0, 70, kScreenWidth-290, kScreenHeight-125);
        _contentTextView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
        _contentTextView.editable = NO;
        _contentTextView.selectable = NO;
        [_promptView addSubview:_contentTextView];
        [_contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_promptView.mas_top).offset(70);
            make.centerX.equalTo(_promptView);
            make.width.equalTo(@(kScreenWidth-290));
            make.height.equalTo(@(kScreenHeight-125));
        }];
        
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeBtn setImage:[UIImage imageNamed:@"popclose"] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(closeBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
        [_promptView addSubview:closeBtn];
        [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_promptView.mas_top).offset(ALDFullScreenVertical(15));
            make.right.equalTo(_promptView.mas_right).offset(ALDFullScreenHorizontal(-30));
            make.width.and.height.equalTo(@40);
        }];
    }
    return _promptView;
}

- (LearningPlayPopView *)playPopView
{
    if (!_playPopView) {
        _playPopView = [[LearningPlayPopView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _playPopView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
        WS(weakSelf);
        _playPopView.closeBc = ^(){
            [weakSelf.mediaPlayerViewController playByAdditionView];
            [weakSelf.mediaPlayerViewController fireMediaPlayerNavigationBarTimer];
        };
    }
    return _playPopView;
}

//- (LearningPlayControlView *)ctrView
//{
//    if (_ctrView) {
//        _ctrView = nil;
//    }
//        VideoSingleInfoModel *model = [[VideoSingleInfoModel alloc]init];
//    if (!_videoInfoArr) {
//        return nil;
//    }
//    model = _videoInfoArr[0];
//    _ctrView = [[LearningPlayControlView alloc]initWithFrame:CGRectMake(0, 200, 120, 175) WithModel:model];
//    _ctrView.userInteractionEnabled = YES;
//    _ctrView.right = kScreenWidth;
//    _ctrView.centerY = kScreenHeight/2;
//
//    DefineWeak(self);
//    DefineWeak(_videoIdsArr);
//    DefineWeak(_currentPlayVideoIndex);
//    _ctrView.replayBlock = ^(void){
//        if (Weak(self).videoInfoArr) {
//            [Weak(self) toPlayWithAJMediaPlayerItem];
//            //操控
//            [Weak(self).view addSubview:Weak(self).ctrView];
//            //next
//            [Weak(self).view addSubview:Weak(self).nextBtn];
//        }
//    };
//    if (!popKit) {
//        popKit = [[PopViewKit alloc] init];
//        popKit.bTapDismiss = YES;
//        popKit.bInnerTapDismiss = NO;
//    }
//    if (!rview) {
//        rview = [[LearningPlayPopView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
//        rview.center = Weak(self).view.center;
//        rview.backgroundColor = kclearColor;
//    }
//    DefineWeak(popKit);
//    DefineWeak(rview);
//    _ctrView.factorsBlock = ^(void){
//        [Weak(self).mediaPlayerViewController pauseByAdditionView];
//        [Weak(self).mediaPlayerViewController invalidateMediaPlayerNavigationBarTimer];
//        [Weak(popKit) popView:Weak(rview) animateType:PAT_Alpha];
//        Weak(rview).closeBc = ^(void){
//            [Weak(popKit) dismiss:YES];
//        };
//        Weak(popKit).dismissBlock = ^(void){
//            [Weak(self).mediaPlayerViewController playByAdditionView];
//            [Weak(self).mediaPlayerViewController fireMediaPlayerNavigationBarTimer];
//        };
//        [Weak(rview) setModel:model WithType:LPPOP_FACTORS];
//    };
//    _ctrView.decisionBlock = ^(void){
//        [Weak(self).mediaPlayerViewController pauseByAdditionView];
//        [Weak(self).mediaPlayerViewController invalidateMediaPlayerNavigationBarTimer];
//        [Weak(popKit) popView:Weak(rview) animateType:PAT_Alpha];
//        Weak(rview).closeBc = ^(void){
//            [Weak(popKit) dismiss:YES];
//        };
//        Weak(popKit).dismissBlock = ^(void){
//            [Weak(self).mediaPlayerViewController playByAdditionView];
//            [Weak(self).mediaPlayerViewController fireMediaPlayerNavigationBarTimer];
//        };
//        [Weak(rview) setModel:model WithType:LPPOP_DECISION];
//    };
//    _ctrView.detailBlock = ^(void){
//        [Weak(self).mediaPlayerViewController pauseByAdditionView];
//        [Weak(self).mediaPlayerViewController invalidateMediaPlayerNavigationBarTimer];
//        [Weak(popKit) popView:Weak(rview) animateType:PAT_Alpha];
//        Weak(rview).closeBc = ^(void){
//            [Weak(popKit) dismiss:YES];
//        };
//        Weak(popKit).dismissBlock = ^(void){
//            [Weak(self).mediaPlayerViewController playByAdditionView];
//            [Weak(self).mediaPlayerViewController fireMediaPlayerNavigationBarTimer];
//        };
//        [Weak(rview) setModel:model WithType:LPPOP_DETAIL];
//    };
//    _ctrView.ruleBlock = ^(void){
//        [Weak(self).mediaPlayerViewController pauseByAdditionView];
//        [Weak(self).mediaPlayerViewController invalidateMediaPlayerNavigationBarTimer];
//        [Weak(popKit) popView:Weak(rview) animateType:PAT_Alpha];
//        Weak(rview).closeBc = ^(void){
//            [Weak(popKit) dismiss:YES];
//        };
//        Weak(popKit).dismissBlock = ^(void){
//            [Weak(self).mediaPlayerViewController playByAdditionView];
//            [Weak(self).mediaPlayerViewController fireMediaPlayerNavigationBarTimer];
//        };
//        [Weak(rview) setModel:model WithType:LPPOP_RULE];
//    };
//
//    return _ctrView;
//}

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
