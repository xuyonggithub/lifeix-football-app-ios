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

#define kReuseId  @"collectionCell"

@interface PlayerCenterViewController()<UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property(nonatomic, retain)NSMutableDictionary *dataDic;
@property(nonatomic, retain)NSMutableArray *categoryArr;
@property(nonatomic, retain)NSMutableArray *dataArr;
@property(nonatomic, retain)UICollectionView *playerView;
@property(nonatomic, retain)CategoryView *CategoryView;
@property(nonatomic, assign)NSInteger selectedIndex;

@end

@implementation PlayerCenterViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    _dataDic = [NSMutableDictionary dictionary];
    _categoryArr = [NSMutableArray array];
    _dataArr = [NSMutableArray array];
    self.view.backgroundColor = [UIColor grayColor];
    self.title = @"球员";
    [self requestDataWithCaID:self.categoryId];
//    [self addPlayerCategoryView];
}

-(void)requestDataWithCaID:(NSString *)string{
    [CommonRequest requstPath:[NSString stringWithFormat:@"games/players/teamcategory/%@",string] loadingDic:@{kLoadingType : @(RLT_OverlayLoad), kLoadingView : (self.view)} queryParam:nil success:^(CommonRequest *request, id jsonDict) {
        NSDictionary *dic = (NSDictionary *)jsonDict;
        [self.categoryArr addObjectsFromArray:[dic allKeys]];
        [self.dataDic setDictionary:dic];
        [self addPlayerCategoryView];
        [self clickBtn:0];
    } failure:^(CommonRequest *request, NSError *error) {
        NSLog(@"+++error: %@", error);
    }];
}

-(void)addPlayerCategoryView{
    DefineWeak(self);
    _CategoryView = [[CategoryView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, 44) category:self.categoryArr];
    _CategoryView.ClickBtn = ^(CGFloat index){
        [Weak(self) clickBtn:(index)];
    };
    [self.view addSubview:_CategoryView];
    _CategoryView.backgroundColor = kwhiteColor;
    if(_playerView == nil){
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _playerView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 114, SCREEN_WIDTH, SCREEN_HEIGHT - 114) collectionViewLayout:flowLayout];
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
    [_dataArr removeAllObjects];
    NSArray *arr = self.dataDic.allValues;
    NSArray *playerArr = [arr objectAtIndex:tag];
    for(NSDictionary *dic in playerArr){
        PlayerModel *player = [[PlayerModel alloc] initWithDictionary:dic error:nil];
        [_dataArr addObject:player];
    }
    [self.playerView reloadData];
}

#pragma mark -- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
{
    return _dataArr.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PlayerModel *player = [self.dataArr objectAtIndex:indexPath.item];
    PlayerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kReuseId forIndexPath:indexPath];
    cell.playerModel = player;
    cell.backgroundColor = kBlackColor;
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(90,120);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(4,4,4,4);
}

#pragma mark --UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

@end
