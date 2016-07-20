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
#import "CommonLoading.h"
#import "LocalNotiPush.h"
#import "YDMenuSwitchView.h"
#import "CoachDetailVC.h"
#import "StaffsDetVC.h"

#define bannerHeight 44

#define krightCollectionviewcellid  @"rightCollectionviewcellid"
@interface HomeCenterVC ()<SDCycleScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIWebViewDelegate, UIScrollViewDelegate>
{
    UILabel *ruleLab;
    UIView *centerBannerView;
}
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSMutableArray *picArray;
@property(nonatomic,strong)NSMutableArray *leftDataArray;
@property(nonatomic,strong)NSMutableArray *centerDataArray;
@property(nonatomic,strong)NSMutableArray *centerAListDataArray;
@property(nonatomic,strong)NSMutableArray *centerBListDataArray;

@property(nonatomic,strong)NSMutableArray *rightDataArray;
@property(nonatomic,strong)NSMutableArray *mediaArray;
@property(nonatomic,strong)TopBannerSwitchView *topBannnerView;
@property(nonatomic,strong)UITableView *leftTableview;
@property(nonatomic,strong)UITableView *centerTableview;
@property(nonatomic,strong)UICollectionView *rightCollectionview;
@property(nonatomic,strong)NSString *ruleStr;
@property(nonatomic,strong)NSString *leftSubtitlePrifxStr;
@property(nonatomic,strong)UIScrollView *topScrollView;

@end

@implementation HomeCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;

    _dataArray = [NSMutableArray array];
    _picArray = [NSMutableArray array];
    _leftDataArray = [NSMutableArray array];
    _centerDataArray = [NSMutableArray array];
    _rightDataArray = [NSMutableArray array];
    _mediaArray = [NSMutableArray array];
    _centerAListDataArray = [NSMutableArray array];
    _centerBListDataArray = [NSMutableArray array];
    self.view.backgroundColor = [UIColor whiteColor];
    [self requestDataWithCaID:_kidStr ? _kidStr:@"8089916318445"];
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
    [CommonRequest requstPath:[NSString stringWithFormat:@"wemedia/tops/?categoryIds=%@",string] loadingDic:@{kLoadingType : @(RLT_OverlayLoad), kLoadingView : (self.topScrollView?self.topScrollView:self.view)} queryParam:nil success:^(CommonRequest *request, id jsonDict) {
        [self dealWithJason:jsonDict];
    } failure:^(CommonRequest *request, NSError *error) {
        
    }];
}
-(void)requestTopBannerSwitchData{
    //左
    NSString *leftPath = @"games/competitions/5/matches?teamId=1";
    [CommonRequest requstPath:leftPath loadingDic:@{kLoadingType : @(RLT_OverlayLoad), kLoadingView : (self.topScrollView?self.topScrollView:self.view)} queryParam:nil success:^(CommonRequest *request, id jsonDict) {
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
    for (CenterSwitchModel *model in _centerDataArray) {
        if ([model.group isEqualToString:@"A"]) {
            [_centerAListDataArray addObject:model];
        }else{
            [_centerBListDataArray addObject:model];
        }
    }
    [_centerTableview reloadData];
}
-(void)dealWithRightData:(id )dic{
    [_rightDataArray removeAllObjects];
    NSMutableArray *assistantCoachArr = [NSMutableArray array];
    assistantCoachArr = [RightSwitchModel arrayOfModelsFromDictionaries:dic[@"assistantCoach"]];
    NSMutableArray *chiefCoachArr = [NSMutableArray array];
    if ([dic[@"chiefCoach"] isKindOfClass:[NSDictionary class]]) {
        chiefCoachArr = (NSMutableArray*)[RightSwitchModel modelDealDataFromWithDic:dic[@"chiefCoach"]];
    }else if ([dic[@"chiefCoach"] isKindOfClass:[NSArray class]]){
        chiefCoachArr = (NSMutableArray*)[RightSwitchModel arrayOfModelsFromDictionaries:dic[@"chiefCoach"]];
    }
    NSMutableArray *playersArr = [NSMutableArray array];
    playersArr = [RightSwitchModel arrayOfModelsFromDictionaries:dic[@"players"]];
    NSMutableArray *teamLeaderArr = [NSMutableArray array];
    if ([dic[@"teamLeader"] isKindOfClass:[NSDictionary class]]) {
        teamLeaderArr = (NSMutableArray*)[RightSwitchModel modelDealDataFromWithDic:dic[@"teamLeader"]];
    }else if ([dic[@"teamLeader"] isKindOfClass:[NSArray class]]){
        teamLeaderArr = (NSMutableArray*)[RightSwitchModel arrayOfModelsFromDictionaries:dic[@"teamLeader"]];
    }
    NSMutableArray *staffsArr = [NSMutableArray array];
    if ([dic[@"staffs"] isKindOfClass:[NSDictionary class]]) {
        staffsArr = (NSMutableArray*)[RightSwitchModel modelDealDataFromWithDic:dic[@"staffs"]];
    }else if ([dic[@"staffs"] isKindOfClass:[NSArray class]]){
        staffsArr = (NSMutableArray*)[RightSwitchModel arrayOfModelsFromDictionaries:dic[@"staffs"]];
    }
    for (RightSwitchModel *model in teamLeaderArr) {
        model.menberType = @"teamLeader";
        [_rightDataArray addObject:model];
    }
    for (RightSwitchModel *model in chiefCoachArr) {
        model.menberType = @"chiefCoach";
        [_rightDataArray addObject:model];
    }
    for (RightSwitchModel *model in assistantCoachArr) {
        model.menberType = @"assistantCoach";
        [_rightDataArray addObject:model];
    }
    for (RightSwitchModel *model in staffsArr) {
        model.menberType = @"staffs";
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
            model.image = [NSString stringWithFormat:@"%@?imageView/1/w/%@/h/%@",model.image,@(SCREEN_WIDTH * 2), [NSNumber numberWithInt:SCREEN_WIDTH * 9 / 8.0]];//七牛图片处理
            [_picArray addObject:[NSURL URLWithString:model.image]];
        }
    }
    if (_picArray&&_picArray.count) {
        [self dealAdvImages:_picArray With:_dataArray];
    }
    [self addTopBannnerView];
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
            _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0,64, kScreenWidth, kScreenWidth*9 / 16.0) imageURLsGroup:imagesURL];
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
    _topBannnerView = [[TopBannerSwitchView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, bannerHeight)];
    _topBannnerView.top = _cycleScrollView.bottom;
    _topBannnerView.backgroundColor = [UIColor whiteColor];
    _topBannnerView.isShowIcon = NO;
    _topBannnerView.leftTitleStr = @"中国队赛程";
    _topBannnerView.centerTitleStr = @"赛事介绍";
    _topBannnerView.rightTitleStr = @"英雄榜";
    _topBannnerView.clickLeftBtn = ^(void){
        [Weak(self) createLeftView];
        [Weak(self) resetScrollViewTop];
    };
    _topBannnerView.clickCenterBtn = ^(void){
        [Weak(self) createCenterView];
        [Weak(self) resetScrollViewTop];
    };
    _topBannnerView.clickRightBtn = ^(void){
        [Weak(self) createRightView];
        [Weak(self) resetScrollViewTop];
    };
    [self.view addSubview:_topBannnerView];
    [self createLeftView];
}
//创建leftview
-(void)createLeftView{
    if (_leftTableview == nil) {
        _leftTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-_cycleScrollView.bottom-bannerHeight) style:UITableViewStylePlain];
        _leftTableview.top = _topBannnerView.bottom;
        _leftTableview.backgroundColor = kwhiteColor;
        _leftTableview.delegate = self;
        _leftTableview.dataSource = self;
        _leftTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_leftTableview];
    }

    [self.view bringSubviewToFront:_leftTableview];
    self.topScrollView = _leftTableview;

}
-(void)createCenterView{
    if (_centerTableview==nil) {
        _centerTableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-_cycleScrollView.bottom-bannerHeight) style:UITableViewStylePlain];
        _centerTableview.top = _topBannnerView.bottom;
        _centerTableview.backgroundColor = kwhiteColor;
        _centerTableview.delegate = self;
        _centerTableview.dataSource = self;
        _centerTableview.separatorStyle = UITableViewCellSelectionStyleNone;
        [self.view addSubview:_centerTableview];
        centerBannerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 235)];
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, centerBannerView.width, 35)];
        lab.backgroundColor = kGrayBannerColor;
        lab.text = @"2018年世界杯预选赛亚洲区赛制方案";
        lab.textColor = kDetailTitleColor;
        lab.font = [UIFont systemFontOfSize:13];
        lab.textAlignment = NSTextAlignmentCenter;
        [centerBannerView addSubview:lab];
        
        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, lab.bottom, kScreenWidth, 200)];
        webView.scrollView.bounces = NO;
        webView.scrollView.alwaysBounceVertical = NO;
        webView.userInteractionEnabled = NO;
        [webView loadHTMLString:_ruleStr baseURL:nil];
        webView.delegate = self;
        [centerBannerView addSubview:webView];
        centerBannerView.backgroundColor = [UIColor whiteColor];
        _centerTableview.tableHeaderView = centerBannerView;
    }
    [self.view bringSubviewToFront:_centerTableview];
    self.topScrollView = _centerTableview;
    

}
#pragma mark-webviewdelegate
-(void)webViewDidFinishLoad:(UIWebView*)webView{
    CGFloat webViewHeight=[[webView stringByEvaluatingJavaScriptFromString: @"document.body.offsetHeight"]floatValue];
    CGRect newFrame=webView.frame;
    newFrame.size.height=webViewHeight+10;
    centerBannerView.height = webViewHeight+35+10;
    webView.frame=newFrame;
    _centerTableview.tableHeaderView = centerBannerView;

}
-(void)createRightView{
    if (_rightCollectionview == nil) {
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        _rightCollectionview = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-_cycleScrollView.bottom-bannerHeight) collectionViewLayout:flowLayout];
        _rightCollectionview.top = _topBannnerView.bottom;
        _rightCollectionview.delegate = self;
        _rightCollectionview.dataSource = self;
        _rightCollectionview.scrollEnabled = YES;
        _rightCollectionview.backgroundColor = kwhiteColor;
        [_rightCollectionview registerClass:[RightHeroCell class] forCellWithReuseIdentifier:krightCollectionviewcellid];
        
        [self.view addSubview:_rightCollectionview];
    }
    [self.view bringSubviewToFront:_rightCollectionview];
    self.topScrollView = _rightCollectionview;
}
#pragma mark-tableviewdelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _leftTableview) {
        return _leftDataArray.count;
    }else{
        if (section==0) {
            return _centerAListDataArray.count;
        }else
        {
        return _centerBListDataArray.count;
        }
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
        LeftSwitchModel *kmodel = _leftDataArray[indexPath.row];
        cell.model = kmodel;
        cell.leftSubtitlePrifxStr = _leftSubtitlePrifxStr;
        DefineWeak(cell);
        NSUserDefaults *userDefaultsorigin=[NSUserDefaults standardUserDefaults];
        NSString *userindex=[userDefaultsorigin objectForKey:[NSString stringWithFormat:@"%zd%@%@%@",kmodel.KID,kmodel.startDate,kmodel.position,kmodel.stage]];
        NSString *notiId = [NSString stringWithFormat:@"%@&&%zd%@%@",kmodel.startDate,kmodel.KID,kmodel.position,kmodel.stage];
        NSString *notiValue = [NSString stringWithFormat:@"%zd%@%@",kmodel.KID,kmodel.position,kmodel.stage];
        NSString *alertBody = [NSString stringWithFormat:@"%@ 和 %@%@",kmodel.hostTeam[@"teamInfo"][@"name"],kmodel.awayTeam[@"teamInfo"][@"name"],@"的比赛已经开始了"];
        if (userindex) {//查询是否变更过比赛时间
            NSTimeInterval timeIN=(NSTimeInterval)[kmodel.startTime integerValue];
            NSDate * fireDate=[NSDate dateWithTimeIntervalSince1970:timeIN];
            [LocalNotiPush queryLocalNotificationWithNotiObject:notiValue WithStartdate:fireDate WithalertBody:alertBody WithNotiID:notiId];
        }
        
        cell.likeBC = ^(void){
            NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
            NSString *index=[userDefaults objectForKey:[NSString stringWithFormat:@"%zd%@%@%@",kmodel.KID,kmodel.startDate,kmodel.position,kmodel.stage]];
        if (index) {
            Weak(cell).likeView.image = UIImageNamed(@"guanzhu02");
            [userDefaults removeObjectForKey:[NSString stringWithFormat:@"%zd%@%@%@",kmodel.KID,kmodel.startDate,kmodel.position,kmodel.stage]];
            [CommonLoading showTips:@"您已取消该比赛提醒"];
            [LocalNotiPush cancelLocalNotificationWithNotiID:notiId];
        }else{
            [userDefaults setObject:[NSString stringWithFormat:@"%zd%@%@%@",kmodel.KID,kmodel.startDate,kmodel.position,kmodel.stage] forKey:[NSString stringWithFormat:@"%zd%@%@%@",kmodel.KID,kmodel.startDate,kmodel.position,kmodel.stage]];
            [userDefaults synchronize];
            Weak(cell).likeView.image = UIImageNamed(@"guanzhu01");
            [CommonLoading showTips:@"您已增加该比赛提醒"];
            NSTimeInterval timeIN=(NSTimeInterval)[kmodel.startTime integerValue];
            NSDate * fireDate=[NSDate dateWithTimeIntervalSince1970:timeIN];
//            NSDate *fireDate = [NSDate dateWithTimeIntervalSinceNow:5];//测试
            [LocalNotiPush registerLocalNotification:fireDate WithalertBody:[NSString stringWithFormat:@"%@ 和 %@%@",kmodel.hostTeam[@"teamInfo"][@"name"],kmodel.awayTeam[@"teamInfo"][@"name"],@"的比赛已经开始了"] WithNotiID:notiId WithNotiValue:notiValue];
        }
    };
        return cell;
    }else if(tableView == _centerTableview){
        static NSString *cellidx = @"centertableviewcellid";
        CenterSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:cellidx];
        if (cell==nil) {
            cell = [[CenterSwitchCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellidx];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.section == 0) {
            cell.model = _centerAListDataArray[indexPath.row];
        }else{
            cell.model = _centerBListDataArray[indexPath.row];
        }
        return cell;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _leftTableview) {
        return 130;
    }else{
        return 60;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == _centerTableview) {
        return 35;
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
        UIView *hview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 35)];
        hview.backgroundColor = kGrayBannerColor;
        UILabel *hlab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 35)];
        hlab.textColor = kDetailTitleColor;
        hlab.textAlignment = NSTextAlignmentCenter;
        hlab.font = [UIFont systemFontOfSize:13];
        if (section==0) {
            hlab.text = @"亚洲十二强赛A组";
        }
        if (section==1) {
            hlab.text = @"亚洲十二强赛B组";
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
        svc.urlStr = model.url;
        [self.navigationController pushViewController:svc animated:YES];
    }else{
        if (indexPath.section == 0) {
            CenterSwitchModel *mode = _centerAListDataArray[indexPath.row];
            NSLog(@"aamodel==%@",mode);
        }
    }
}

#pragma mark --UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (IPHONE_5||IPHONE_4) {
        return CGSizeMake(85,100);
    }else{
        return CGSizeMake(110*kScreenRatioBase6Iphone,130*kScreenRatioBase6Iphone);
    }
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(4,11*kScreenRatioBase6Iphone,4,11*kScreenRatioBase6Iphone);
}

#pragma mark --UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
        RightSwitchModel *model = _rightDataArray[indexPath.row];
    if ([model.menberType isEqualToString:@"player"]) {
        PlayerDetailVC *pVC = [[PlayerDetailVC alloc]init];
        pVC.playerId = [NSString stringWithFormat:@"%@",model.KID];
        pVC.playerName = model.name;
        [self.navigationController pushViewController:pVC animated:YES];
    }else if ([model.menberType isEqualToString:@"chiefCoach"]||[model.menberType isEqualToString:@"assistantCoach"]){
        CoachDetailVC *cvc = [[CoachDetailVC alloc]init];
        cvc.coachId = [NSString stringWithFormat:@"%@",model.KID];
        cvc.coachName = model.name;
        [self.navigationController pushViewController:cvc animated:YES];
    }else if([model.menberType isEqualToString:@"staffs"]||[model.menberType isEqualToString:@"teamLeader"]){
        StaffsDetVC *svc = [[StaffsDetVC alloc]init];
        svc.personId =[NSString stringWithFormat:@"%@",model.KID];
        svc.personName = model.name;
        [self.navigationController pushViewController:svc animated:YES];
    }

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

#pragma mark- UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y < _cycleScrollView.height + _topBannnerView.height + 64 && [scrollView isEqual:self.topScrollView]) {
        if (scrollView.contentOffset.y > 0) {
            //  向上拖动
            _cycleScrollView.top = 64-scrollView.contentOffset.y;
        }else {
            //  向下拖动
            _cycleScrollView.top = 64;
        }
        _topBannnerView.top = _cycleScrollView.bottom;
        if (_topBannnerView.top < 64) {
            _topBannnerView.top = 64;
        }
        scrollView.top = _topBannnerView.bottom;
//        if (scrollView.top < 64) {
//            scrollView.top = 64;
//        }
        scrollView.height = kScreenHeight - scrollView.top;
    }
}

- (void)resetScrollViewTop
{
    [self.view bringSubviewToFront:_cycleScrollView];
    [self.view bringSubviewToFront:_topBannnerView];
    
    //  复位
    _cycleScrollView.top = 64;
    _topBannnerView.top = _cycleScrollView.bottom;
    self.topScrollView.top = _topBannnerView.bottom;
    self.topScrollView.height = kScreenHeight - self.topScrollView.top;
    self.topScrollView.contentOffset = CGPointMake(0, 0);
}

@end
