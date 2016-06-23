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
    NSInteger _currentQuestionIndex;
    LFQuestionMode _questionMode;
}

//播放器
@property (nonatomic, strong) AJMediaPlayerViewController *mediaPlayerViewController;
@property (nonatomic, strong) LFSimulationCenterPromptView *promptView;
@property (nonatomic, strong) LFSimulationCenterQuestionView *questionView;

@property (nonatomic, strong) NSArray *questionArray;
@property (nonatomic, strong) LFSimulationQuestionModel *currentQuestionModel;

@property (nonatomic, copy) NSString *modeString;

@end

@implementation LFSimulationTestDetailController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    __weak typeof(self) weakSelf = self;
    
    //  播放器界面
    [self.view addSubview:self.mediaPlayerViewController.view];
    [self.mediaPlayerViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view);
    }];
    [self addChildViewController:self.mediaPlayerViewController];
    [_mediaPlayerViewController initialShowFullScreen];
    
    //  答题界面
    [self.view addSubview:self.questionView];
    [self.questionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view);
    }];

    //  提示界面
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
    if (_currentQuestionIndex < self.questionArray.count) {
        [self.view bringSubviewToFront:self.mediaPlayerViewController.view];
        self.currentQuestionModel = self.questionArray[_currentQuestionIndex];
        
        [self.questionView refreshWithModel:self.currentQuestionModel questionMode:_questionMode];
        
        AJMediaPlayRequest *playRequest = [AJMediaPlayRequest playRequestWithVideoPath:self.currentQuestionModel.videoPath type:AJMediaPlayerVODStreamItem name:[self.categoryModel.name stringByAppendingString:self.modeString ? self.modeString : @""] uid:@"uid"];
        [self.mediaPlayerViewController startToPlay:playRequest];
    }
}

#pragma mark - LFSimulationCenterPromptViewDelegate
- (void)promptViewStartTesting:(NSInteger)modeIndex
{
    _currentQuestionIndex = 0;
    _questionMode = modeIndex;
    __weak typeof(self) weakSelf = self;
    if (self.categoryModel.subArray.count > 0) {
        self.modeString = [NSString stringWithFormat:@"--%@", [self.categoryModel.subArray[modeIndex - 1] name]];
    }
    [CommonRequest requstPath:[NSString stringWithFormat:@"elearning/quiz_categories/%@/pages", _questionMode == LFQuestionModeDefaultFoul ? self.categoryModel.categoryId : [self.categoryModel.subArray[modeIndex - 1] categoryId]] loadingDic:nil queryParam:nil success:^(CommonRequest *request, id jsonDict) {
        weakSelf.questionArray = [LFSimulationQuestionModel simulationQuestionModelArrayWithArray:jsonDict];
        weakSelf.questionView.questionCnt = weakSelf.questionArray.count;
        [weakSelf toPlayWithAJMediaPlayerItem];
    } failure:^(CommonRequest *request, NSError *error) {
        NSLog(@"+++error: %@", error);
    }];
}

- (void)promptViewQuitTesting
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - AJMediaViewControllerDelegate
- (void)mediaPlayerViewController:(AJMediaPlayerViewController *)mediaPlayerViewController videoDidPlayToEnd:(AJMediaPlayerItem *)playerItem
{
    [self.view bringSubviewToFront:self.questionView];
}

- (void)mediaPlayerViewControllerWillDismiss:(AJMediaPlayerViewController *)mediaPlayerViewController
{
    [self.mediaPlayerViewController stop];
    [self.view bringSubviewToFront:self.promptView];
}

#pragma mark - LFSimulationCenterQuestionViewDelegate
- (void)questionViewNextQuestion
{
    if (_currentQuestionIndex + 1 == self.questionArray.count) {
        //  重新挑战
        _currentQuestionIndex = 0;
    }else {
        _currentQuestionIndex++;
    }
    [self toPlayWithAJMediaPlayerItem];
}

- (void)questionViewQuitQuesiotn
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
        _promptView = [[LFSimulationCenterPromptView alloc] initWithModel:self.categoryModel];
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
