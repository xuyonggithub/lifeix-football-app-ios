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
#import "CommonRequest.h"

@interface LFSimulationTestDetailController ()
    <AJMediaViewControllerDelegate, LFSimulationCenterPromptViewDelegate>
{
    BOOL _isFullScreen;
}

//播放器
@property (nonatomic, strong) AJMediaPlayerViewController *mediaPlayerViewController;
@property (nonatomic, strong) UIView *disPlayView;
@property (nonatomic, strong) NSMutableArray *constraintList;
@property (nonatomic, strong) AJMediaPlayRequest *playRequest;

@end

@implementation LFSimulationTestDetailController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    LFSimulationCenterPromptView *promptView = [[LFSimulationCenterPromptView alloc] initWithModel:self.model];
    promptView.delegate = self;
    [self.view addSubview:promptView];
    [promptView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self showFullScreen];
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

#pragma mark - initPlayer
- (void)initPlayer
{
    self.mediaPlayerViewController = [[AJMediaPlayerViewController alloc] initWithStyle:AJMediaPlayerStyleForiPhone delegate:self];
    self.mediaPlayerViewController.needsBackButtonInPortrait = YES;
    self.disPlayView = self.mediaPlayerViewController.view;
    self.disPlayView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.disPlayView];
    [self.disPlayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self addChildViewController:self.mediaPlayerViewController];
    [self.mediaPlayerViewController showFullScreen];
    [[UIApplication sharedApplication] setStatusBarHidden:self.mediaPlayerViewController.mediaPlayerControlBar.hidden withAnimation:NO];
}

- (void)toPlayWithAJMediaPlayerItem
{
    AJMediaPlayRequest *playRequest = [AJMediaPlayRequest playRequestWithIdentifier:@"http://7xumx6.com1.z0.glb.clouddn.com/elearning/fmc2014/part1/medias/flv/fwc14-m01-bra-cro-06/HD" type:AJMediaPlayerVODStreamItem name:@"test" uid:@"uid"];
    [self.mediaPlayerViewController startToPlay:playRequest];
}

#pragma mark - AJMediaViewControllerDelegate
- (void)mediaPlayerViewController:(AJMediaPlayerViewController *)mediaPlayerViewController videoDidPlayToEnd:(AJMediaPlayerItem *)playerItem {
    
}

- (void)mediaPlayerViewControllerWillDismiss:(AJMediaPlayerViewController *)mediaPlayerViewController {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - LFSimulationCenterPromptViewDelegate
- (void)startTest:(NSInteger)index
{
    [CommonRequest requstPath:[NSString stringWithFormat:@"elearning/quiz_categories/%@/pages", self.model.subArray.count == 0 ? self.model.categoryId : [self.model.subArray[index] categoryId]] loadingDic:nil queryParam:nil success:^(CommonRequest *request, id jsonDict) {
        self.constraintList = [NSMutableArray arrayWithCapacity:0];
        
        [self initPlayer];
        [self toPlayWithAJMediaPlayerItem];
        
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
    //    self.constraintList = [NSMutableArray arrayWithCapacity:0];
    //
    //    [self initPlayer];
    //    [self toPlayWithAJMediaPlayerItem];
}

- (void)quitQuestionTest
{
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

@end
