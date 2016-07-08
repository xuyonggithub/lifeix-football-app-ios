//
//  PlayerVideoVC.m
//  LiFangSport
//
//  Created by 卢亚林 on 16/6/27.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import "PlayerVideoVC.h"
#import "AJMediaPlayerKit.h"

@interface PlayerVideoVC ()<AJMediaViewControllerDelegate>

//播放器
@property (nonatomic, strong) AJMediaPlayerViewController *mediaPlayerViewController;
@property (nonatomic, strong) AJMediaPlayRequest *playRequest;

@end

@implementation PlayerVideoVC

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
    if (self.mediaPlayerViewController.currentMediaPlayerState == AJMediaPlayerStateContentPlaying||self.mediaPlayerViewController.currentMediaPlayerState == AJMediaPlayerStateContentLoading||self.mediaPlayerViewController.currentMediaPlayerState == AJMediaPlayerStateContentInit||self.mediaPlayerViewController.currentMediaPlayerState == AJMediaPlayerStateContentBuffering) {
        [self.mediaPlayerViewController stop];
    }
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"高光时刻";
    
    //  播放器界面
    DefineWeak(self);
    [self.view addSubview:self.mediaPlayerViewController.view];
    [self.mediaPlayerViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(Weak(self).view);
    }];
    [self addChildViewController:self.mediaPlayerViewController];
    // 全屏
    [self.mediaPlayerViewController initialShowFullScreen];
    // 播放
    self.playRequest = [AJMediaPlayRequest playRequestWithVideoPath:self.url type:AJMediaPlayerVODStreamItem name:self.name uid:@"uid"];
    [self.mediaPlayerViewController startToPlay:_playRequest];

}

#pragma mark - AJMediaViewControllerDelegate
- (void)mediaPlayerViewController:(AJMediaPlayerViewController *)mediaPlayerViewController videoDidPlayToEnd:(AJMediaPlayerItem *)playerItem
{
    self.mediaPlayerViewController.isAddtionView = YES;
    [self.mediaPlayerViewController showPlaybackControlsWhenPlayEnd];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
@end
