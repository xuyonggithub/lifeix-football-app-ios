//
//  CoachCenterVC.m
//  LiFangSport
//
//  Created by Lifeix on 16/6/17.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import "CoachCenterVC.h"
#import "CommonRequest.h"
#import "CategoryView.h"
#import "CoachModel.h"
#import "CoachCell.h"
#import "CoachDetailVC.h"

#define kReuseId  @"collectionCell"
#define kHeaderReuseId  @"Header"

@interface CoachCenterVC()<UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property(nonatomic, retain)NSMutableArray *topNameArr;
@property(nonatomic, retain)NSMutableArray *categoryNameArr;
@property(nonatomic, retain)NSMutableArray *coachArr;
@property(nonatomic, retain)NSMutableArray *selectedDataArr;
@property(nonatomic, retain)NSMutableArray *selectedTitleArr;
@property(nonatomic, retain)UICollectionView *coachView;
@property(nonatomic, retain)CategoryView *CategoryView;
@property(nonatomic, assign)NSInteger selectedIndex;

@end

@implementation CoachCenterVC

-(void)viewDidLoad{
    [super viewDidLoad];
    _topNameArr = [NSMutableArray array];
    _selectedDataArr = [NSMutableArray array];
    _selectedTitleArr = [NSMutableArray array];
    _categoryNameArr = [NSMutableArray array];
    _coachArr = [NSMutableArray array];
    self.view.backgroundColor = [UIColor whiteColor];
    [self requestData];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

-(void)requestData{
    NSString *urlStr = [NSString stringWithFormat:@"games/coaches/national"];
    [CommonRequest requstPath:urlStr loadingDic:@{kLoadingType : @(RLT_OverlayLoad), kLoadingView : (self.view)} queryParam:nil success:^(CommonRequest *request, id jsonDict) {
        
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
        NSMutableArray *refereeArr = [NSMutableArray array];
        for(int i = 0; i < categoryArr.count; i++){
            [titleCategoryArr addObject:[categoryArr[i] objectForKey:@"categoryName"]];
            NSArray *referees = [categoryArr[i] objectForKey:@"coaches"];
            NSMutableArray *sectionReffeeArr = [NSMutableArray array];
            for(int j = 0; j < referees.count; j++){
                NSDictionary *dic = referees[j];
                CoachModel *coach = [[CoachModel alloc] initWithDictionary:dic error:nil];
                [sectionReffeeArr addObject:coach];
            }
            [refereeArr addObject:sectionReffeeArr];
        }
        [_categoryNameArr addObject:titleCategoryArr];
        [_coachArr addObject:refereeArr];
    }
    
    [self addCoachCategoryView];
    [self clickBtn:0];
}

-(void)addCoachCategoryView{
    DefineWeak(self);
    _CategoryView = [[CategoryView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, 44) category:self.topNameArr];
    _CategoryView.ClickBtn = ^(CGFloat index){
        [Weak(self) clickBtn:(index)];
    };
    [self.view addSubview:_CategoryView];
    //    _CategoryView.backgroundColor = kwhiteColor;
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 118, SCREEN_WIDTH, 1)];
    lineView.backgroundColor = HEXRGBCOLOR(0xe4e3e6);
    [self.view addSubview:lineView];
    
    if(_coachView == nil){
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _coachView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 119, SCREEN_WIDTH, SCREEN_HEIGHT - 119) collectionViewLayout:flowLayout];
        _coachView.delegate = self;
        _coachView.dataSource = self;
        _coachView.backgroundColor = kwhiteColor;
        _coachView.showsVerticalScrollIndicator = NO;
        [_coachView registerClass:[CoachCell class] forCellWithReuseIdentifier:kReuseId];
        [_coachView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeaderReuseId];
        [self.view addSubview:_coachView];
    }
    
}

-(void)clickBtn:(CGFloat)tag{
    self.selectedIndex = tag;
    [_selectedDataArr removeAllObjects];
    [_selectedTitleArr removeAllObjects];
    NSArray *cateArr = [self.coachArr objectAtIndex:tag];
    [self.selectedTitleArr addObjectsFromArray:[self.categoryNameArr objectAtIndex:tag]];
    [_selectedDataArr addObjectsFromArray:cateArr];
    [self.coachView reloadData];
}

#pragma mark -- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
{
    
    NSArray *arr = [_selectedDataArr objectAtIndex:section];
    return arr.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _selectedDataArr.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *arr = [_selectedDataArr objectAtIndex:indexPath.section];
    CoachModel *coach = [arr objectAtIndex:indexPath.item];
    CoachCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kReuseId forIndexPath:indexPath];
    [cell displayCell:coach];
    return cell;
}

// 区头标题
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeaderReuseId forIndexPath:indexPath];
    headerView.backgroundColor = HEXRGBCOLOR(0xf0f0f0);
    UILabel *sectionLabel = [[UILabel alloc] initWithFrame:headerView.bounds];
    sectionLabel.backgroundColor = HEXRGBCOLOR(0xf0f0f0);
    sectionLabel.tintColor = HEXRGBCOLOR(0x666666);
    sectionLabel.font = kBasicSmallTitleFont;
    sectionLabel.textAlignment = NSTextAlignmentCenter;
    sectionLabel.text = self.selectedTitleArr[indexPath.section];
    [headerView addSubview:sectionLabel];
    
    return headerView;
}

#pragma mark --UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((SCREEN_WIDTH - 40) / 3,(SCREEN_WIDTH - 40) / 9 * 4);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10,10,10,10);
}

// 区头高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(SCREEN_WIDTH, 44);
}

#pragma mark --UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *arr = [_selectedDataArr objectAtIndex:indexPath.section];
    CoachModel *coach = [arr objectAtIndex:indexPath.item];
    CoachDetailVC *coachDetailVC = [[CoachDetailVC alloc] init];
    coachDetailVC.coachId = coach.coachaId;
    coachDetailVC.coachName = coach.name;
    [self.navigationController pushViewController:coachDetailVC animated:YES];

}
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


@end
