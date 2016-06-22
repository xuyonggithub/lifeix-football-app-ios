//
//  LFSimulationTestDetailController.m
//  LiFangSport
//
//  Created by Zhangqibin on 16/6/21.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import "LFSimulationTestDetailController.h"
#import "AJMediaPlayerKit.h"

@interface LFSimulationTestDetailController ()
    <AJMediaViewControllerDelegate>
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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.constraintList = [NSMutableArray arrayWithCapacity:0];
    
    [self initPlayer];
    //[self addNotification];
    
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self addLandscapeConstrains];
    [self toPlayWithAJMediaPlayerItem];
}


- (void)addPortraitConstraints
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];

        

    [self.constraintList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_disPlayView]|"
                                                                                             options:0
                                                                                             metrics:nil
                                                                                               views:NSDictionaryOfVariableBindings(_disPlayView)]];
    
    [self.constraintList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_disPlayView]"
                                                                                     options:0
                                                                                     metrics:nil
                                                                                       views:NSDictionaryOfVariableBindings(_disPlayView)]];
    
        [self.constraintList addObject:[NSLayoutConstraint constraintWithItem:_disPlayView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_disPlayView attribute:NSLayoutAttributeWidth multiplier:9/16.0 constant:1]];

    [self.view addConstraints:self.constraintList];
}


- (void)addLandscapeConstrains
{
    [[UIApplication sharedApplication] setStatusBarHidden:self.mediaPlayerViewController.mediaPlayerControlBar.hidden withAnimation:NO];
    [self.constraintList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_disPlayView]|"
                                                                                     options:0
                                                                                     metrics:nil
                                                                                       views:NSDictionaryOfVariableBindings(_disPlayView)]];
    
    [self.constraintList addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_disPlayView]|"
                                                                                     options:0
                                                                                     metrics:nil
                                                                                       views:NSDictionaryOfVariableBindings(_disPlayView)]];
    [self.view addConstraints:self.constraintList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Notification
- (void)addNotification
{
    [self removeNotification];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarOrientationChange:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];

}

- (void)removeNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - Notification
- (void)statusBarOrientationChange:(NSNotification *)notification
{
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        _isFullScreen = YES;
    } else if (UIInterfaceOrientationIsPortrait(orientation)) {
        _isFullScreen = NO;
    }
    //[self interactivePopGestureEnabled:!_isFullScreen];
    [self.mediaPlayerViewController transitionToFullScreenModel:YES];

}

- (void)mediaPlayerViewControllerAddtionView:(NSNotification *)notification
{
    self.mediaPlayerViewController.isAddtionView = [notification.object boolValue];
}

#pragma mark - UIViewControllerRotation
- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationLandscapeLeft | UIInterfaceOrientationLandscapeRight;
}

#pragma mark - initPlayer
- (void)initPlayer
{
    self.mediaPlayerViewController = [[AJMediaPlayerViewController alloc] initWithStyle:AJMediaPlayerStyleForiPhone delegate:self];
    self.mediaPlayerViewController.needsBackButtonInPortrait = YES;
    self.disPlayView = self.mediaPlayerViewController.view;
    self.disPlayView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.disPlayView];
    [self addChildViewController:self.mediaPlayerViewController];
    [self.mediaPlayerViewController showFullScreen];
}

- (void)toPlayWithAJMediaPlayerItem
{
    AJMediaPlayRequest *playRequest = [AJMediaPlayRequest playRequestWithIdentifier:@"http://7xumx6.com1.z0.glb.clouddn.com/elearning/fmc2014/part1/medias/flv/fwc14-m01-bra-cro-06/HD" type:AJMediaPlayerVODStreamItem name:@"test" uid:@"uid"];
    [self.mediaPlayerViewController startToPlay:playRequest];
}

#pragma mark - AJMediaViewControllerDelegate
- (void)mediaPlayerViewController:(AJMediaPlayerViewController *)mediaPlayerViewController didClickOnShareButton:(AJMediaPlayerItem *)playerItem
{

}

- (void)mediaPlayerViewController:(AJMediaPlayerViewController *)mediaPlayerViewController videoDidPlayToEnd:(AJMediaPlayerItem *)playerItem {

}

- (void)mediaPlayerViewControllerWillDismiss:(AJMediaPlayerViewController *)mediaPlayerViewController {
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
