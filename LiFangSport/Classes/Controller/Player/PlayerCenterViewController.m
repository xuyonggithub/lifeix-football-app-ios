//
//  PlayerCenterViewController.m
//  LiFangSport
//
//  Created by Lifeix on 16/6/16.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import "PlayerCenterViewController.h"
#import "CommonRequest.h"
#import "CategoryView.h"
#import "PlayerModel.h"
#import "PlayerCell.h"
#import "PlayerDetailVC.h"

#define kReuseId  @"collectionCell"

@interface PlayerCenterViewController()<UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property(nonatomic, retain)NSMutableArray *topNameArr;
@property(nonatomic, retain)NSMutableArray *categoryNameArr;
@property(nonatomic, retain)NSMutableArray *playerArr;
@property(nonatomic, retain)NSMutableArray *selectedDataArr;
@property(nonatomic, retain)NSMutableArray *selectedTitleArr;
@property(nonatomic, retain)UICollectionView *playerView;
@property(nonatomic, retain)CategoryView *CategoryView;
@property(nonatomic, assign)NSInteger selectedIndex;

@end

@implementation PlayerCenterViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    _topNameArr = [NSMutableArray array];
    _selectedDataArr = [NSMutableArray array];
    _selectedTitleArr = [NSMutableArray array];
    _categoryNameArr = [NSMutableArray array];
    _playerArr = [NSMutableArray array];
    self.view.backgroundColor = [UIColor whiteColor];
    [self requestData];
    self.automaticallyAdjustsScrollViewInsets = NO; 
}

-(void)requestData{
    [CommonRequest requstPath:[NSString stringWithFormat:@"games/players/national"] loadingDic:@{kLoadingType : @(RLT_OverlayLoad), kLoadingView : (self.view)} queryParam:nil success:^(CommonRequest *request, id jsonDict) {
        [self dealWithData: jsonDict];
    } failure:^(CommonRequest *request, NSError *error) {
        NSLog(@"+++error: %@", error);
    }];
}

-(void)dealWithData:(id)jsonDict{
    NSArray *jsonArr = jsonDict;
    for(NSDictionary *dic in jsonArr) {
        [self.topNameArr addObject:[dic objectForKey:@"topName"]];
        NSArray *categoryArr = [dic objectForKey:@"category"];
        NSMutableArray *titleCategoryArr = [NSMutableArray array];
        NSMutableArray *playerArr = [NSMutableArray array];
        for(int i = 0; i < categoryArr.count; i++){
            [titleCategoryArr addObject:[categoryArr[i] objectForKey:@"categoryName"]];
            NSArray *players = [categoryArr[i] objectForKey:@"players"];
            NSMutableArray *sectionPlayerArr = [NSMutableArray array];
            for(int j = 0; j < players.count; j++){
                NSDictionary *dic = players[j];
                PlayerModel *player = [[PlayerModel alloc] initWithDictionary:dic error:nil];
                [sectionPlayerArr addObject:player];
            }
            [playerArr addObject:sectionPlayerArr];
        }
        [_categoryNameArr addObject:titleCategoryArr];
        [_playerArr addObject:playerArr];
    }
    
    [self addPlayerCategoryViewWithCategory:self.title];
    [self clickBtn:0];
}

-(void)addPlayerCategoryViewWithCategory:(NSString *)category{
    DefineWeak(self);
    NSArray *arr;
    if([category isEqualToString:@"中国男足"]){
        arr = [NSArray arrayWithArray:self.categoryNameArr[0]];
    }else{
        arr = [NSArray arrayWithArray:self.categoryNameArr[1]];
    }
    _CategoryView = [[CategoryView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, 44) category:arr];
    _CategoryView.ClickBtn = ^(CGFloat index){
        [Weak(self) clickBtn:(index)];
    };
    [self.view addSubview:_CategoryView];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 118, SCREEN_WIDTH, 1)];
    lineView.backgroundColor = HEXRGBCOLOR(0xe4e3e6);
    [self.view addSubview:lineView];
    
    if(_playerView == nil){
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _playerView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 119, SCREEN_WIDTH, SCREEN_HEIGHT - 119) collectionViewLayout:flowLayout];
        _playerView.delegate = self;
        _playerView.dataSource = self;
        _playerView.backgroundColor = kwhiteColor;
        _playerView.showsVerticalScrollIndicator = NO;
        [_playerView registerClass:[PlayerCell class] forCellWithReuseIdentifier:kReuseId];
        [self.view addSubview:_playerView];
    }
    
}

-(void)clickBtn:(CGFloat)tag{
    self.selectedIndex = tag;
    [_selectedDataArr removeAllObjects];
    NSArray *arr;
    if([self.title isEqualToString:@"中国男足"]){
        arr = [NSArray arrayWithArray:self.playerArr[0]];
    }else{
        arr = [NSArray arrayWithArray:self.playerArr[1]];
    }
    [_selectedDataArr addObjectsFromArray:[arr objectAtIndex:tag]];
    [self.playerView reloadData];
}

#pragma mark -- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
{
    return _selectedDataArr.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PlayerModel *player = [self.selectedDataArr objectAtIndex:indexPath.item];
    PlayerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kReuseId forIndexPath:indexPath];
    //    cell.playerModel = player;
    UIImage *placehold;
    if([self.title isEqualToString:@"中国男足"]){
        placehold = [UIImage imageNamed:@"placeHold_player.jpg"];
    }else{
        placehold = [UIImage imageNamed:@"placeHold_womanPlayer.jpg"];
    }
    
    if(player.avatar != nil){
        NSString *bgImageUrl = [NSString stringWithFormat:@"%@%@?imageView/1/w/%d/h/%d", kQiNiuHeaderPathPrifx, player.avatar, (int)cell.bgImgView.width, (int)cell.bgImgView.height];
        [cell.bgImgView sd_setImageWithURL:bgImageUrl placeholderImage:placehold];
    }else{
        cell.bgImgView.image = placehold;
    }
    cell.titleLabel.text = [NSString stringWithFormat:@"【%@】%@", player.position, player.name];
    
    cell.backgroundColor = kBlackColor;
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((SCREEN_WIDTH - 40) / 3,(SCREEN_WIDTH - 40) / 9 * 4);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

#pragma mark --UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PlayerModel *player = [self.selectedDataArr objectAtIndex:indexPath.item];
    PlayerDetailVC *playerDetVC = [[PlayerDetailVC alloc] init];
    playerDetVC.playerId = player.playerId;
    playerDetVC.playerName = player.name;
    [self.navigationController pushViewController:playerDetVC animated:YES];
}

-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

@end
