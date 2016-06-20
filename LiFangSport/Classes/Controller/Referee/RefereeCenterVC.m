//
//  RefereeCenterVC.m
//  LiFangSport
//
//  Created by Lifeix on 16/6/17.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import "RefereeCenterVC.h"
#import "CommonRequest.h"
#import "CategoryView.h"
#import "RefereeModel.h"
#import "RefereeCell.h"

#define kReuseId  @"collectionCell"
#define kHeaderReuseId  @"Header"
#define kRefereePath  @"games/referees?level=s"
@interface RefereeCenterVC()<UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
//@property(nonatomic, retain)NSMutableDictionary *dataDic;
@property(nonatomic, retain)NSMutableArray *topNameArr; // 裁判员 五人制 沙滩足球
@property(nonatomic, retain)NSMutableArray *categoryNameArr; // [[男足裁判，男足助理],[array2], ...]
@property(nonatomic, retain)NSMutableArray *refereeArr; //三个分类下的球员数组
@property(nonatomic, retain)NSMutableArray *selectedDataArr;
@property(nonatomic, retain)NSMutableArray *selectedTitleArr;
@property(nonatomic, retain)UICollectionView *refereeView;
@property(nonatomic, retain)CategoryView *CategoryView;
@property(nonatomic, assign)NSInteger selectedIndex;

@end

@implementation RefereeCenterVC

-(void)viewDidLoad{
    [super viewDidLoad];
    //    _dataDic = [NSMutableDictionary dictionary];
    _topNameArr = [NSMutableArray array];
    _selectedDataArr = [NSMutableArray array];
    _selectedTitleArr = [NSMutableArray array];
    _categoryNameArr = [NSMutableArray array];
    _refereeArr = [NSMutableArray array];
    self.view.backgroundColor = [UIColor grayColor];
    self.title = @"裁判";
    [self requestData];
}

-(void)requestData{
    [CommonRequest requstPath:kRefereePath loadingDic:@{kLoadingType : @(RLT_OverlayLoad), kLoadingView : (self.view)} queryParam:nil success:^(CommonRequest *request, id jsonDict) {
        
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
            NSArray *referees = [categoryArr[i] objectForKey:@"referees"];
            NSMutableArray *sectionReffeeArr = [NSMutableArray array];
            for(int j = 0; j < referees.count; j++){
                NSDictionary *dic = referees[j];
                RefereeModel *referee = [[RefereeModel alloc] initWithDictionary:dic error:nil];
                [sectionReffeeArr addObject:referee];
            }
            [refereeArr addObject:sectionReffeeArr];
        }
        [_categoryNameArr addObject:titleCategoryArr];
        [_refereeArr addObject:refereeArr];
    }
    
    [self addRefereeCategoryView];
    [self clickBtn:0];
}

-(void)addRefereeCategoryView{
    DefineWeak(self);
    _CategoryView = [[CategoryView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, 44) category:self.topNameArr];
    _CategoryView.ClickBtn = ^(CGFloat index){
        [Weak(self) clickBtn:(index)];
    };
    [self.view addSubview:_CategoryView];
    _CategoryView.backgroundColor = kwhiteColor;
    if(_refereeView == nil){
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _refereeView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 114, SCREEN_WIDTH, SCREEN_HEIGHT - 114) collectionViewLayout:flowLayout];
        _refereeView.delegate = self;
        _refereeView.dataSource = self;
        _refereeView.backgroundColor = kwhiteColor;
        _refereeView.showsVerticalScrollIndicator = NO;
        [_refereeView registerClass:[RefereeCell class] forCellWithReuseIdentifier:kReuseId];
        [_refereeView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeaderReuseId];
        [self.view addSubview:_refereeView];
    }
}


-(void)clickBtn:(NSUInteger)tag{
    self.selectedIndex = tag;
    [_selectedDataArr removeAllObjects];
    NSArray *ceteArr = [self.refereeArr objectAtIndex:tag];
    //获取所有分区标题
    [self.selectedTitleArr addObjectsFromArray:[self.categoryNameArr objectAtIndex:tag]];
    //获取对应分区下列表
    [_selectedDataArr addObjectsFromArray:ceteArr];
//    for(NSArray *secRefereeArr in [refereeDic objectForKey:[self.sectionArr[i]]]){
//        NSMutableArray *sectionRefereeArr = [NSMutableArray array];
//        for(NSDictionary *dic in secRefereeArr){
//            RefereeModel *referee = [[RefereeModel alloc] initWithDictionary:dic error:nil];
//            [sectionRefereeArr addObject:referee];
//        }
//        [_dataArr addObject:sectionRefereeArr];
//    }
    [self.refereeView reloadData];
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
    RefereeModel *referee = [arr objectAtIndex:indexPath.item];
    RefereeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kReuseId forIndexPath:indexPath];
    //    [cell displayCell:player];
    cell.backgroundColor = kBlackColor;
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
    return CGSizeMake(90,120);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(4,4,4,4);
}

// 区头高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(SCREEN_WIDTH, 44);
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
