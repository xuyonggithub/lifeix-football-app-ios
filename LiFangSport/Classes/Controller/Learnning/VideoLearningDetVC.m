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
#import "CommonRequest.h"
#import "VideoLearningDetModel.h"
#import "VideoLearningUnitModel.h"
#import "CategoryView.h"
#import "UIScrollView+INSPullToRefresh.h"
#import "VideoSingleInfoModel.h"
#import "LearningVideoPlayVC.h"
#import "YDMenuSwitchView.h"

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
@property(nonatomic,assign)NSInteger pageCount;
@property(nonatomic, strong)NSString *categoryID;

@end

@implementation VideoLearningDetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArr = [NSMutableArray array];
    _topNameArr = [NSMutableArray array];
    limitNum = 30;
    _catsArrIndex = 0;
    _backPicView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    _backPicView.image = UIImageNamed(@"videolearningbackground");
    [self.view addSubview:_backPicView];
    for (VideoLearningDetModel *model in _catsArr) {
        [_topNameArr addObject:model.name];
    }

    [self createCollectionView];
    [self addCoachCategoryView];
    
    [self requestDataWithBtnTag:_catsArrIndex isHeaderRefresh:YES];
    [self setupRefresh];
}

-(void)requestDataWithBtnTag:(NSInteger)btnIndex isHeaderRefresh:(BOOL)isHeaderRefresh{
    VideoLearningDetModel *model = _catsArr[btnIndex];
    _pageCount = model.pageCount;
//    if (_categoryID == nil) {
//        _categoryID = [[NSString alloc]init];
//    }
    _categoryID = [NSString stringWithFormat:@"%@",model.KID];
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
    _CategoryView.backgroundColor = HEXRGBCOLOR(0x041337);
    
    UIView *bview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _CategoryView.width, 20)];
    bview.top = _CategoryView.bottom;
    bview.backgroundColor = HEXRGBCOLOR(0x041337);
    [self.view addSubview:bview];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, bview.width, 1)];
    line.backgroundColor = kwhiteColor;
    [bview addSubview:line];
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

-(void)createCollectionView{
    if (_videoCollectionview == nil) {
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        _videoCollectionview = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 68, kScreenWidth, kScreenHeight-68) collectionViewLayout:flowLayout];
        _videoCollectionview.delegate = self;
        _videoCollectionview.dataSource = self;
        _videoCollectionview.scrollEnabled = YES;
        _videoCollectionview.backgroundColor = [UIColor clearColor];
        [_videoCollectionview registerClass:[VideoLearningDetCell class] forCellWithReuseIdentifier:kvideoCollectionviewcellid];
        
        [self.view addSubview:_videoCollectionview];
    }
    _videoCollectionview.contentInset = UIEdgeInsetsMake(0, 0, 30, 0);
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
    if (IPHONE_5||IPHONE_4) {
        return CGSizeMake(80,60+20);
    }else{
        return CGSizeMake(100*kScreenRatioBase6Iphone,75*kScreenRatioBase6Iphone+20);//100 75+20
    }
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(4,15*kScreenRatioBase6Iphone,4,15*kScreenRatioBase6Iphone);
}

#pragma mark --UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    VideoLearningUnitModel *model = _dataArr[indexPath.row];

    LearningVideoPlayVC *LearningPlayVC = [[LearningVideoPlayVC alloc] init];
    LearningPlayVC.videoId = [NSString stringWithFormat:@"%@",model.videos[0][@"id"]];
    LearningPlayVC.videosArr = [NSArray arrayWithArray:_dataArr];
    LearningPlayVC.pageCount = _pageCount;
    if (_pageCount<limitNum) {
    LearningPlayVC.currentIndex = _pageCount;
    }else{
    LearningPlayVC.currentIndex = startNum+limitNum;
    }
    LearningPlayVC.categoryID = _categoryID;
    [self.navigationController pushViewController:LearningPlayVC animated:YES];
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
