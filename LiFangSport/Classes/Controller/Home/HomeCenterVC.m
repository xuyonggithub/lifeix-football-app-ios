//
//  HomeCenterVC.m
//  LiFangSport
//
//  Created by 张毅 on 16/6/13.
//  Copyright © 2016年 zhangyi. All rights reserved.
//
#import "AFNetworking.h"
#import "HomeCenterVC.h"
#import "SDCycleScrollView.h"
#import "CommonRequest.h"
#import "CenterCyclePicModel.h"
#import "UIImageView+WebCache.h"
#import "TopBannerSwitchView.h"
#import "LeftSwitchModel.h"
#import "CenterSwitchModel.h"
#import "RightSwitchModel.h"
#import "RightHeroCell.h"
#import "LeftSwitchCell.h"
#import "CenterSwitchCell.h"
#import "NSString+WPAttributedMarkup.h"
#import "MediaModel.h"
#import "MediaDetailVC.h"
#import "PlayerDetailVC.h"
#import "LeftSwitcDetVC.h"

#define krightCollectionviewcellid  @"rightCollectionviewcellid"
@interface HomeCenterVC ()<SDCycleScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    UILabel *ruleLab;
}
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSMutableArray *picArray;
@property(nonatomic,strong)NSMutableArray *leftDataArray;
@property(nonatomic,strong)NSMutableArray *centerDataArray;
@property(nonatomic,strong)NSMutableArray *rightDataArray;
@property(nonatomic,strong)NSMutableArray *mediaArray;
@property(nonatomic,strong)TopBannerSwitchView *topBannnerView;
@property(nonatomic,strong)UITableView *leftTableview;
@property(nonatomic,strong)UITableView *centerTableview;
@property(nonatomic,strong)UICollectionView *rightCollectionview;
@property(nonatomic,strong)NSString *ruleStr;
@property(nonatomic,strong)NSString *leftSubtitlePrifxStr;

@end

@implementation HomeCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [NSMutableArray array];
    _picArray = [NSMutableArray array];
    _leftDataArray = [NSMutableArray array];
    _centerDataArray = [NSMutableArray array];
    _rightDataArray = [NSMutableArray array];
    _mediaArray = [NSMutableArray array];
    self.view.backgroundColor = [UIColor purpleColor];

    [self requestDataWithCaID:_kidStr ? _kidStr:@"8089916318445"];

    [self addTopBannnerView];
    [self requestTopBannerSwitchData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateRequest:) name:khomeKidNotiFicationStr object:nil];

}
- (void)updateRequest:(NSNotification *)noti {
    
    NSDictionary *dic = [NSDictionary dictionary];
    dic = noti.userInfo;
    _kidStr = dic[@"khomeKidNotiFicationStr"];
    self.title = dic[@"title"];
    [self requestDataWithCaID:_kidStr];
}
-(void)requestDataWithCaID:(NSString *)string{
    [CommonRequest requstPath:[NSString stringWithFormat:@"wemedia/tops/?categoryIds=%@",string] loadingDic:@{kLoadingType : @(RLT_OverlayLoad), kLoadingView : (self.view)} queryParam:nil success:^(CommonRequest *request, id jsonDict) {
        [self dealWithJason:jsonDict];
    } failure:^(CommonRequest *request, NSError *error) {
        
    }];
}
-(void)requestTopBannerSwitchData{
    //左
    NSString *leftPath = @"games/competitions/5/matches?teamId=1";
    [CommonRequest requstPath:leftPath loadingDic:@{kLoadingType : @(RLT_OverlayLoad), kLoadingView : (self.view)} queryParam:nil success:^(CommonRequest *request, id jsonDict) {
        [self dealWithLeftData:jsonDict];
    } failure:^(CommonRequest *request, NSError *error) {
        
    }];
    //中
    NSString *centerPath = [NSString stringWithFormat:@"games/competitionCategory/%@/lastestCompetition",_kidStr ? _kidStr:@"8089916318445"];//@"games/competitionCategory/8089916318445/lastestCompetition";

    [CommonRequest requstPath:centerPath loadingDic:@{kLoadingType : @(RLT_OverlayLoad), kLoadingView : (self.view)} queryParam:nil success:^(CommonRequest *request, id jsonDict) {
        [self dealWithCenterData:jsonDict];
    } failure:^(CommonRequest *request, NSError *error) {
        
    }];
    //右
    NSString *rightPath = @"games/competitions/5/teams/1/competitionTeam";

    [CommonRequest requstPath:rightPath loadingDic:@{kLoadingType : @(RLT_OverlayLoad), kLoadingView : (self.view)} queryParam:nil success:^(CommonRequest *request, id jsonDict) {
        [self dealWithRightData:jsonDict];
    } failure:^(CommonRequest *request, NSError *error) {
        
    }];
}
-(void)dealWithLeftData:(id )dic{
    [_leftDataArray removeAllObjects];
    _leftDataArray = [LeftSwitchModel arrayOfModelsFromDictionaries:dic];
    [_leftTableview reloadData];
}
-(void)dealWithCenterData:(id )dic{
    [_centerDataArray removeAllObjects];
    _leftSubtitlePrifxStr = [NSString stringWithFormat:@"%@",dic[@"competitionCategory"][@"name"]];
    _centerDataArray = [CenterSwitchModel arrayOfModelsFromDictionaries:dic[@"matches"]];
    _ruleStr = [NSString stringWithFormat:@"%@",dic[@"competitionCategory"][@"rule"]];
    
    [_centerTableview reloadData];
}
-(void)dealWithRightData:(id )dic{
    [_rightDataArray removeAllObjects];
    NSMutableArray *assistantCoachArr = [NSMutableArray array];
    assistantCoachArr = [RightSwitchModel arrayOfModelsFromDictionaries:dic[@"assistantCoach"]];
    NSMutableArray *chiefCoachArr = [NSMutableArray array];
    chiefCoachArr = (NSMutableArray*)[RightSwitchModel modelDealDataFromWithDic:dic[@"chiefCoach"]];
    NSMutableArray *playersArr = [NSMutableArray array];
    playersArr = [RightSwitchModel arrayOfModelsFromDictionaries:dic[@"players"]];
    
    for (RightSwitchModel *model in assistantCoachArr) {
        model.menberType = @"assistantCoach";
        [_rightDataArray addObject:model];
    }
    for (RightSwitchModel *model in chiefCoachArr) {
        model.menberType = @"chiefCoach";
        [_rightDataArray addObject:model];
    }
    for (RightSwitchModel *model in playersArr) {
        model.menberType = @"player";
        [_rightDataArray addObject:model];
    }
    [_rightCollectionview reloadData];
}

-(void)dealWithJason:(id )dic{
    [_dataArray removeAllObjects];
    [_picArray removeAllObjects];
    _dataArray = [CenterCyclePicModel arrayOfModelsFromDictionaries:dic];
    _mediaArray = [MediaModel arrayOfModelsFromDictionaries:dic];

    for (CenterCyclePicModel *model in _dataArray) {
        if (model.images.count) {
            [_picArray addObject:[NSURL URLWithString:model.image]];
        }
    }
    if (_picArray&&_picArray.count) {
        [self dealAdvImages:_picArray With:_dataArray];
    }
//    [self addTopBannnerView];
}
- (void)dealAdvImages:(NSArray *)imagesURL With:(NSArray *)dataArr
{
    NSMutableArray *titleArr = [NSMutableArray array];
    if (dataArr.count) {
        for (CenterCyclePicModel *model in dataArr) {
            [titleArr addObject:model.title];
        }
    }
    if (imagesURL.count == 0) {
        [_cycleScrollView removeFromSuperview];
        _cycleScrollView = nil;
        
    }else{
        if (!_cycleScrollView) {
            _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0,64, kScreenWidth, 150) imageURLsGroup:imagesURL];
            [self.view addSubview:_cycleScrollView];
            _cycleScrollView.titlesGroup = titleArr;

            _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
            _cycleScrollView.delegate = self;
            _cycleScrollView.autoScrollTimeInterval = 3.0;
        }else{
            _cycleScrollView.imageURLsGroup = imagesURL;
            _cycleScrollView.titlesGroup = titleArr;
        }
    }
}

- (void)addTopBannnerView
{
    DefineWeak(self);
    _topBannnerView = [[TopBannerSwitchView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 44)];
    _topBannnerView.top = _cycleScrollView.bottom;
    _topBannnerView.top = 214;
    _topBannnerView.backgroundColor = [UIColor whiteColor];
    _topBannnerView.isShowIcon = NO;
    _topBannnerView.leftTitleStr = @"中国队赛程";
    _topBannnerView.centerTitleStr = @"赛事介绍";
    _topBannnerView.rightTitleStr = @"英雄榜";
    _topBannnerView.clickLeftBtn = ^(void){
        [Weak(self) createLeftView];
    };
    _topBannnerView.clickCenterBtn = ^(void){
        [Weak(self) createCenterView];
    };
    _topBannnerView.clickRightBtn = ^(void){
        [Weak(self) createRightView];
    };
    [self.view addSubview:_topBannnerView];
    [self createLeftView];
}
//创建leftview
-(void)createLeftView{
    if (_leftTableview == nil) {
        _leftTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-214-44) style:UITableViewStylePlain];
        _leftTableview.top = _topBannnerView.bottom;
        _leftTableview.backgroundColor = kwhiteColor;
        _leftTableview.delegate = self;
        _leftTableview.dataSource = self;
        _leftTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_leftTableview];
    }

    [self.view bringSubviewToFront:_leftTableview];

}
-(void)createCenterView{
    if (_centerTableview==nil) {
        _centerTableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-214-44) style:UITableViewStylePlain];
        _centerTableview.top = _topBannnerView.bottom;
        _centerTableview.backgroundColor = kwhiteColor;
        _centerTableview.delegate = self;
        _centerTableview.dataSource = self;
        [self.view addSubview:_centerTableview];
        UIView *hview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 250)];
//        ruleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
//        ruleLab.font = [UIFont systemFontOfSize:11];
//        ruleLab.numberOfLines = 0;
//        ruleLab.text = _ruleStr;
//        NSDictionary *detstyleDic = @{@"bigFont":[UIFont systemFontOfSize:12],@"color":HEXRGBCOLOR(0x787878)};
//        [ruleLab setAttributedText:[_ruleStr attributedStringWithStyleBook:detstyleDic]];
//        
//        [ruleLab sizeToFit];
//        [hview addSubview:ruleLab];
        
        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 250)];
        [webView loadHTMLString:_ruleStr baseURL:nil];
        [hview addSubview:webView];
        hview.backgroundColor = [UIColor whiteColor];
        _centerTableview.tableHeaderView = hview;
    }
    [self.view bringSubviewToFront:_centerTableview];

}
-(void)createRightView{
    if (_rightCollectionview == nil) {
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        _rightCollectionview = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-214-44) collectionViewLayout:flowLayout];
        _rightCollectionview.top = _topBannnerView.bottom;
        _rightCollectionview.delegate = self;
        _rightCollectionview.dataSource = self;
        _rightCollectionview.scrollEnabled = YES;
        _rightCollectionview.backgroundColor = kwhiteColor;
        [_rightCollectionview registerClass:[RightHeroCell class] forCellWithReuseIdentifier:krightCollectionviewcellid];
        
        [self.view addSubview:_rightCollectionview];
    }
    [self.view bringSubviewToFront:_rightCollectionview];

}
#pragma mark-tableviewdelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _leftTableview) {
        return _leftDataArray.count;
    }else{
        return _centerDataArray.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _leftTableview) {
        static NSString *cellid = @"lefttableviewcellid";
        LeftSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if (cell==nil) {
            cell = [[LeftSwitchCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellid];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = _leftDataArray[indexPath.row];
        cell.leftSubtitlePrifxStr = _leftSubtitlePrifxStr;
        return cell;
    }else if(tableView == _centerTableview){
        static NSString *cellidx = @"centertableviewcellid";
        CenterSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:cellidx];
        if (cell==nil) {
            cell = [[CenterSwitchCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellidx];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = _centerDataArray[indexPath.row];
        return cell;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _leftTableview) {
        return 130;
    }else{
        return 70;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == _centerTableview) {
        return 20;
    }
    return 0;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"分组";
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView==_centerTableview) {
        return 2;
    }
    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView==_centerTableview) {
        UIView *hview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
        hview.backgroundColor = [UIColor lightGrayColor];
        UILabel *hlab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
        hlab.textColor = [UIColor redColor];
        hlab.textAlignment = NSTextAlignmentCenter;
        hlab.font = [UIFont systemFontOfSize:12];
        if (section==0) {
            hlab.text = @"亚洲12强A组";
        }
        if (section==1) {
            hlab.text = @"亚洲12强B组";
        }
        [hview addSubview:hlab];
        return hview;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _leftTableview) {
        LeftSwitchModel *model = _leftDataArray[indexPath.row];
        LeftSwitcDetVC *svc = [[LeftSwitcDetVC alloc]init];
        svc.title = [NSString stringWithFormat:@"%@%@%@",model.hostTeam[@"teamInfo"][@"name"],@"VS",model.awayTeam[@"teamInfo"][@"name"]];
        [self.navigationController pushViewController:svc animated:YES];
    }
}

#pragma mark --UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(80,100);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(4,4,4,4);
}

#pragma mark --UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
        PlayerDetailVC *pVC = [[PlayerDetailVC alloc]init];
        RightSwitchModel *model = _rightDataArray[indexPath.row];
        pVC.playerId = [NSString stringWithFormat:@"%@",model.KID];
        pVC.playerName = model.name;
        pVC.title = model.name;
        [self.navigationController pushViewController:pVC animated:YES];
}
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _rightDataArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = krightCollectionviewcellid;
    RightHeroCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    if (_rightDataArray.count) {
        cell.model = _rightDataArray[indexPath.item];
    }
    return cell;
}

#pragma mark
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    MediaDetailVC *DVC = [[MediaDetailVC alloc]init];
    DVC.media = _mediaArray[index];
    [self.navigationController pushViewController:DVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
