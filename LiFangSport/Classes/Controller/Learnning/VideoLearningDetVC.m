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
#import "VideoSingleInfoModel.h"

#define kvideoCollectionviewcellid  @"videoCollectionviewcellid"
#define kvideodetPath @"elearning/training_categories/"

@interface VideoLearningDetVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    UIView *playView;
    NSInteger startNum;
    NSInteger limitNum;
}
@property(nonatomic,strong)UICollectionView *videoCollectionview;
@property(nonatomic,assign)NSInteger catsArrIndex;
@property(nonatomic,strong)NSMutableArray *dataArr;
@property(nonatomic, strong)CategoryView *CategoryView;
@property(nonatomic, strong)NSMutableArray *topNameArr;
@property(nonatomic, strong)UIImageView *backPicView;

@end

@implementation VideoLearningDetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArr = [NSMutableArray array];
    _topNameArr = [NSMutableArray array];
    limitNum = 20;
    _catsArrIndex = 0;
    _backPicView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    _backPicView.image = UIImageNamed(@"videolearningbackground");
    [self.view addSubview:_backPicView];
    for (VideoLearningDetModel *model in _catsArr) {
        [_topNameArr addObject:model.name];
    }
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcons:@[@"backIconwhite"] target:self action:@selector(rollBack)];
    [self createCollectionView];
    [self addCoachCategoryView];
    
    [self requestDataWithBtnTag:_catsArrIndex isHeaderRefresh:YES];
    [self setupRefresh];
}

-(void)requestDataWithBtnTag:(NSInteger)btnIndex isHeaderRefresh:(BOOL)isHeaderRefresh{
    VideoLearningDetModel *model = _catsArr[btnIndex];
    [CommonRequest requstPath:[NSString stringWithFormat:@"%@%@/pages?start=%zd&limit=%zd",kvideodetPath,model.KID,startNum,limitNum] loadingDic:@{kLoadingType : @(RLT_OverlayLoad), kLoadingView : (self.view)} queryParam:nil success:^(CommonRequest *request, id jsonDict) {
        [self dealWithJason:jsonDict isHeaderRefresh:isHeaderRefresh];
        
    } failure:^(CommonRequest *request, NSError *error) {
        if (isHeaderRefresh) {
            [_videoCollectionview ins_endPullToRefresh];
        }else{
            [_videoCollectionview ins_endInfinityScroll];
        }
    }];
}
-(void)dealWithJason:(id )dic isHeaderRefresh:(BOOL)isHeaderRefresh{
    NSArray *dataList = [VideoLearningUnitModel arrayOfModelsFromDictionaries:dic];
    if (isHeaderRefresh) {
        [_videoCollectionview ins_endPullToRefresh];
        [_dataArr removeAllObjects];
        [_dataArr addObjectsFromArray:dataList];
    } else{
        [_videoCollectionview ins_endInfinityScroll];
        [_videoCollectionview ins_endInfinityScrollWithStoppingContentOffset:dataList.count > 0];
        [_dataArr addObjectsFromArray:dataList];
    }
    [_videoCollectionview reloadData];
}

-(void)addCoachCategoryView{
    DefineWeak(self);
    _CategoryView = [[CategoryView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, 44) category:self.topNameArr];
    _CategoryView.btnNormalColor = kwhiteColor;
    _CategoryView.btnSelectColor = kwhiteColor;
    _CategoryView.selectLineColor = [UIColor redColor];
    _CategoryView.ClickBtn = ^(CGFloat index){
        [Weak(self) clickBtn:(index)];
    };
    [self.view addSubview:_CategoryView];
    _CategoryView.backgroundColor = kclearColor;
}

-(void)clickBtn:(CGFloat)index{
    _catsArrIndex = index;
    startNum = 0;
    [_dataArr removeAllObjects];
    [self requestDataWithBtnTag:_catsArrIndex isHeaderRefresh:YES];
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
    [_videoCollectionview ins_setPullToRefreshEnabled:YES];
    [_videoCollectionview ins_setInfinityScrollEnabled:YES];
    
    UIView <INSAnimatable> *infinityIndicator = [self infinityIndicatorViewFromCurrentStyle];
    [_videoCollectionview.ins_infiniteScrollBackgroundView addSubview:infinityIndicator];
    [infinityIndicator startAnimating];
    UIView <INSPullToRefreshBackgroundViewDelegate> *pullToRefresh = [self pullToRefreshViewFromCurrentStyle];
    _videoCollectionview.ins_pullToRefreshBackgroundView.delegate = pullToRefresh;
    [_videoCollectionview.ins_pullToRefreshBackgroundView addSubview:pullToRefresh];
}

- (void)headerRereshing
{
    startNum = 0;
    [self requestDataWithBtnTag:_catsArrIndex isHeaderRefresh:YES];
}

- (void)footerRereshing
{
    startNum += limitNum;
    [self requestDataWithBtnTag:_catsArrIndex isHeaderRefresh:NO];
}

-(void)rollBack{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)createCollectionView{
    if (_videoCollectionview == nil) {
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        _videoCollectionview = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 68, kScreenWidth, kScreenHeight-44) collectionViewLayout:flowLayout];
        _videoCollectionview.delegate = self;
        _videoCollectionview.dataSource = self;
        _videoCollectionview.scrollEnabled = YES;
        _videoCollectionview.backgroundColor = [UIColor clearColor];
        [_videoCollectionview registerClass:[VideoLearningDetCell class] forCellWithReuseIdentifier:kvideoCollectionviewcellid];

        [self.view addSubview:_videoCollectionview];
    }
//    _videoCollectionview.contentInset = UIEdgeInsetsMake(-40, 0, 0, 0);
}
#pragma mark -- UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArr.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = kvideoCollectionviewcellid;
    VideoLearningDetCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    if (_dataArr.count) {
        cell.model = _dataArr[indexPath.item];
    }
    return cell;
}
#pragma mark --UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(100,80);//290 220
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(4,4,4,4);
}

-(void)requestSingleVideoInfoWith:(NSString *)videoStr{
    [CommonRequest requstPath:[NSString stringWithFormat:@"%@%@",kvideoSinglePath,videoStr] loadingDic:@{kLoadingType : @(RLT_OverlayLoad), kLoadingView : (self.view)} queryParam:nil success:^(CommonRequest *request, id jsonDict) {
        [self dealWithSingleVideoData:jsonDict];
    } failure:^(CommonRequest *request, NSError *error) {
        
    }];
}
-(void)dealWithSingleVideoData:(id )dic{
//kQiNiuHeaderPath ,VideoSingleInfoModel
    
    
}
#pragma mark --UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    VideoLearningUnitModel *model = _dataArr[indexPath.row];
    NSString *videoId = [NSString stringWithFormat:@"%@",model.videos[0][@"id"]];
    
    [self requestSingleVideoInfoWith:videoId];
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



@end
