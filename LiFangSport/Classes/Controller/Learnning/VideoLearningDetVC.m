//
//  VideoLearningDetVC.m
//  LiFangSport
//
//  Created by 张毅 on 16/6/16.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import "VideoLearningDetVC.h"
#import "VideoLearningDetCell.h"
#import "UIBarButtonItem+SimAdditions.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "VideoPlayerManager.h"
#import "MulSwitchBannerView.h"
#import "CommonRequest.h"
#import "VideoLearningDetModel.h"
#import "VideoLearningUnitModel.h"
#import "CategoryView.h"
#import "UIScrollView+INSPullToRefresh.h"

#define kvideoCollectionviewcellid  @"videoCollectionviewcellid"
#define kvideodetPath @"elearning/training_categories/"

@interface VideoLearningDetVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    UIView *playView;
}
@property(nonatomic,strong)UICollectionView *videoCollectionview;
@property(nonatomic,assign)NSInteger catsArrIndex;
@property(nonatomic,strong)NSMutableArray *dataArr;
@property(nonatomic, strong)CategoryView *CategoryView;
@property(nonatomic, retain)NSMutableArray *topNameArr;

@end

@implementation VideoLearningDetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArr = [NSMutableArray array];
    _topNameArr = [NSMutableArray array];
    _catsArrIndex = 0;
    for (VideoLearningDetModel *model in _catsArr) {
        [_topNameArr addObject:model.name];
    }
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcons:@[@"backIconwhite"] target:self action:@selector(rollBack)];
    [self createCollectionView];
    [self addCoachCategoryView];

    [self requestDataWith:_catsArrIndex];
    [self setupRefresh];
}

-(void)requestDataWith:(NSInteger)index{
    VideoLearningDetModel *model = _catsArr[index];
    [CommonRequest requstPath:[NSString stringWithFormat:@"%@%@/pages?start=%d&limit=%d",kvideodetPath,model.KID,0,20] loadingDic:@{kLoadingType : @(RLT_OverlayLoad), kLoadingView : (self.view)} queryParam:nil success:^(CommonRequest *request, id jsonDict) {
        [self dealWithJason:jsonDict];
        
    } failure:^(CommonRequest *request, NSError *error) {
        
    }];
}
-(void)dealWithJason:(id )dic{
    [_dataArr removeAllObjects];
    _dataArr = [VideoLearningUnitModel arrayOfModelsFromDictionaries:dic];
    [_videoCollectionview reloadData];
}

-(void)addCoachCategoryView{
    DefineWeak(self);
    _CategoryView = [[CategoryView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, 44) category:self.topNameArr];
    _CategoryView.ClickBtn = ^(CGFloat index){
        [Weak(self) clickBtn:(index)];
    };
    [self.view addSubview:_CategoryView];
    _CategoryView.backgroundColor = kwhiteColor;
}

-(void)clickBtn:(CGFloat)index{
    _catsArrIndex = index;
    [self requestDataWith:_catsArrIndex];
}

#pragma mark - Reresh
- (void)setupRefresh
{
    DefineWeak(self);
    [_videoCollectionview ins_addPullToRefreshWithHeight:kDefaultRefreshHeight handler:^(UIScrollView *scrollView) {
        [Weak(self) headerRereshing];
    }];
    
    [_videoCollectionview ins_addInfinityScrollWithHeight:kDefaultRefreshHeight handler:^(UIScrollView *scrollView) {
        [Weak(self) footerRereshing];
    }];
    [_videoCollectionview ins_setInfinityScrollEnabled:NO];
    
    UIView <INSAnimatable> *infinityIndicator = [self infinityIndicatorViewFromCurrentStyle];
    NSLog(@"22");
    [_videoCollectionview.ins_infiniteScrollBackgroundView addSubview:infinityIndicator];
    [infinityIndicator startAnimating];
    UIView <INSPullToRefreshBackgroundViewDelegate> *pullToRefresh = [self pullToRefreshViewFromCurrentStyle];
    _videoCollectionview.ins_pullToRefreshBackgroundView.delegate = pullToRefresh;
    [_videoCollectionview.ins_pullToRefreshBackgroundView addSubview:pullToRefresh];
}

- (void)headerRereshing
{
//    self.minGroupClassID = @"0";
//    self.minHomeworkID = @"0";
//    
//    [self requestHomeworkListWithHeaderRefresh:YES loadCacheFirst:NO];
}

- (void)footerRereshing
{
//    [self requestHomeworkListWithHeaderRefresh:NO loadCacheFirst:NO];
}

-(void)rollBack{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)createCollectionView{
    if (_videoCollectionview == nil) {
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        _videoCollectionview = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 44, kScreenWidth, kScreenHeight-100) collectionViewLayout:flowLayout];
        _videoCollectionview.delegate = self;
        _videoCollectionview.dataSource = self;
        _videoCollectionview.scrollEnabled = YES;
        _videoCollectionview.backgroundColor = [UIColor clearColor];
        [_videoCollectionview registerClass:[VideoLearningDetCell class] forCellWithReuseIdentifier:kvideoCollectionviewcellid];
        [self.view addSubview:_videoCollectionview];
    }
    [self.view bringSubviewToFront:_videoCollectionview];
}
#pragma mark -- UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArr.count;//_rightDataArray.count
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = kvideoCollectionviewcellid;
    VideoLearningDetCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    if (_dataArr.count) {
        cell.model = _dataArr[indexPath.item];
    }
    return cell;
}
#pragma mark --UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(100,80);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(4,4,4,4);
}

#pragma mark --UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //初始化播放器
    
    [VideoPlayerManager shareKnowInstance].contentURL = [NSURL URLWithString:@"http://7xumx6.com1.z0.glb.clouddn.com/elearning/fmc2014/part1/medias/flv/fwc14-m01-bra-cro-06/HD"];
    if (playView == nil) {
        playView = [[UIView alloc]initWithFrame:self.view.bounds];
        playView.backgroundColor = [UIColor clearColor];
        [APP_DELEGATE.window addSubview:playView];
    }
    //设置播放器画面的尺寸frame
    
    [VideoPlayerManager shareKnowInstance].view.frame =CGRectMake(0, 0, kScreenHeight, kScreenWidth);
    [playView addSubview:[VideoPlayerManager shareKnowInstance].view];

    CGAffineTransform landscapeTransform = CGAffineTransformMakeRotation(M_PI / 2);
    [VideoPlayerManager shareKnowInstance].view.transform = landscapeTransform;
    [VideoPlayerManager shareKnowInstance].view.frame =CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    playView.hidden = NO;
    [VideoPlayerManager shareKnowInstance].view.hidden = NO;

    [[VideoPlayerManager shareKnowInstance] prepareToPlay];
    //监听播放状态
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(movieChagen:) name:MPMoviePlayerPlaybackStateDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(movieFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    [[VideoPlayerManager shareKnowInstance] play];
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
}
-(void)movieFinish:(NSNotification *)noti{
    playView.hidden = YES;
    [VideoPlayerManager shareKnowInstance].view.hidden = YES;
}

-(void)movieChagen:(NSNotification *)noti{
    NSLog(@"===%zd",[VideoPlayerManager shareKnowInstance].playbackState);
    /*
     //播放状态
     MPMoviePlaybackStateStopped,
     MPMoviePlaybackStatePlaying,
     MPMoviePlaybackStatePaused,
     MPMoviePlaybackStateInterrupted,
     MPMoviePlaybackStateSeekingForward,
     MPMoviePlaybackStateSeekingBackward
     */
    if ([VideoPlayerManager shareKnowInstance].playbackState==MPMoviePlaybackStatePlaying) {

    }
    
}
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
