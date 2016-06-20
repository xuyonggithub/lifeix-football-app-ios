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
    self.view.backgroundColor = [UIColor grayColor];
    self.title = self.categoryName;
    [self requestData];
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
    
    [self addPlayerCategoryViewWithCategory: _categoryName];
    [self clickBtn:0];
}

-(void)addPlayerCategoryViewWithCategory:(NSString *)category{
    DefineWeak(self);
    NSArray *arr;
    if([category isEqualToString:@"男足"]){
        arr = [NSArray arrayWithArray:self.categoryNameArr[0]];
    }else{
        arr = [NSArray arrayWithArray:self.categoryNameArr[1]];
    }
    _CategoryView = [[CategoryView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, 44) category:arr];
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
    [_selectedDataArr removeAllObjects];
    NSArray *arr;
    if([self.categoryName isEqualToString:@"男足"]){
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
