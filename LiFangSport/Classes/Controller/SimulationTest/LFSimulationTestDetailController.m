//
//  LFSimulationTestDetailController.m
//  LiFangSport
//
//  Created by Zhangqibin on 16/6/21.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import "LFSimulationTestDetailController.h"
#import "AJMediaPlayerKit.h"
#import "LFSimulationCenterPromptView.h"
#import "LFSimulationCenterQuestionView.h"
#import "CommonRequest.h"

@interface LFSimulationTestDetailController ()
    <AJMediaViewControllerDelegate, LFSimulationCenterPromptViewDelegate, LFSimulationCenterQuestionViewDelegate>
{
    NSInteger _currentPlayVideoIndex;
}

//播放器
@property (nonatomic, strong) AJMediaPlayerViewController *mediaPlayerViewController;
@property (nonatomic, strong) LFSimulationCenterPromptView *promptView;
@property (nonatomic, strong) LFSimulationCenterQuestionView *questionView;

@property (nonatomic, strong) NSArray *questionArray;
@property (nonatomic, strong) LFSimulationQuestionModel *currentQuestionModel;

@end

@implementation LFSimulationTestDetailController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _currentPlayVideoIndex = 0;
    
    __weak typeof(self) weakSelf = self;
    
    [self.view addSubview:self.mediaPlayerViewController.view];
    [self.mediaPlayerViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view);
    }];
    [self addChildViewController:self.mediaPlayerViewController];
    [_mediaPlayerViewController initialShowFullScreen];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [self.view addSubview:self.questionView];
    [self.questionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view);
    }];

    [self.view addSubview:self.promptView];
    [self.promptView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view);
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
    if (_currentPlayVideoIndex < self.questionArray.count) {
        [self.view bringSubviewToFront:self.mediaPlayerViewController.view];
        self.currentQuestionModel = self.questionArray[_currentPlayVideoIndex];
        //[NSString stringWithFormat:@"%@%@/LD", kQiNiuHeaderPath, self.currentQuestionModel.videoPath]
        [self.questionView refreshWithModel:self.currentQuestionModel andIsEnd:_currentPlayVideoIndex + 1 == self.questionArray.count];
        AJMediaPlayRequest *playRequest = [AJMediaPlayRequest playRequestWithVideoPath:self.currentQuestionModel.videoPath type:AJMediaPlayerVODStreamItem name:self.model.name uid:@"uid"];
        [self.mediaPlayerViewController startToPlay:playRequest];
    }
}

#pragma mark - AJMediaViewControllerDelegate
- (void)mediaPlayerViewController:(AJMediaPlayerViewController *)mediaPlayerViewController videoDidPlayToEnd:(AJMediaPlayerItem *)playerItem
{
    [self.view bringSubviewToFront:self.questionView];
}

- (void)mediaPlayerViewControllerWillDismiss:(AJMediaPlayerViewController *)mediaPlayerViewController
{
    [self.view bringSubviewToFront:self.promptView];
}

#pragma mark - LFSimulationCenterPromptViewDelegate
- (void)startTest:(NSInteger)index
{
    _currentPlayVideoIndex = 0;
    __weak typeof(self) weakSelf = self;
    [CommonRequest requstPath:[NSString stringWithFormat:@"elearning/quiz_categories/%@/pages", self.model.subArray.count == 0 ? self.model.categoryId : [self.model.subArray[index] categoryId]] loadingDic:nil queryParam:nil success:^(CommonRequest *request, id jsonDict) {
        weakSelf.questionArray = [LFSimulationQuestionModel simulationQuestionModelArrayWithArray:jsonDict];
        [weakSelf toPlayWithAJMediaPlayerItem];
    } failure:^(CommonRequest *request, NSError *error) {
        NSLog(@"+++error: %@", error);
    }];
}

- (void)quitTest
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - LFSimulationCenterQuestionViewDelegate
- (void)nextTest
{
    if (_currentPlayVideoIndex == self.questionArray.count) {
        
    }else {
        _currentPlayVideoIndex++;
        [self toPlayWithAJMediaPlayerItem];
    }
}

- (void)quitQuestionTest
{
    [self.view bringSubviewToFront:self.mediaPlayerViewController.view];
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

- (LFSimulationCenterPromptView *)promptView
{
    if (!_promptView) {
        _promptView = [[LFSimulationCenterPromptView alloc] initWithModel:self.model];
        _promptView.delegate = self;
    }
    return _promptView;
}

- (LFSimulationCenterQuestionView *)questionView
{
    if (!_questionView) {
        _questionView = [[LFSimulationCenterQuestionView alloc] init];
        _questionView.delegate = self;
    }
    return _questionView;
}

@end
