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
#import "CommonLoading.h"
#import "PopViewKit.h"
#import "RefereeCatePopView.h"
#import "UIBarButtonItem+SimAdditions.h"

#define kReuseId  @"tableViewCell"
#define kHeaderReuseId  @"Header"
#define kRefereePath  @"games/referees?level=fifa"
@interface RefereeCenterVC()<UITableViewDelegate, UITableViewDataSource, RefereeCellDelegate, RefereeCatePopViewDelegate>{
    PopViewKit *popKit;
    RefereeCatePopView *rightView;
}
//@property(nonatomic, retain)NSMutableDictionary *dataDic;
@property(nonatomic, retain)NSMutableArray *topNameArr; // 裁判员 五人制 沙滩足球
@property(nonatomic, retain)NSMutableArray *categoryNameArr; // [[男足裁判，男足助理],[array2], ...]
@property(nonatomic, retain)NSMutableArray *refereeArr; //三个分类下的球员数组
@property(nonatomic, retain)NSMutableArray *selectedDataArr;
@property(nonatomic, retain)NSMutableArray *selectedTitleArr;
@property(nonatomic, retain)UITableView *refereeView;
@property(nonatomic, retain)CategoryView *CategoryView;
@property(nonatomic, assign)NSInteger selectedIndex;

@property(nonatomic, assign)int likeNum;
@end

@implementation RefereeCenterVC

-(void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"FIFA";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithIcons:@[@"list_right.png"] target:self action:@selector(rightDrawerAction:)];
    //    _dataDic = [NSMutableDictionary dictionary];
    self.automaticallyAdjustsScrollViewInsets = false;
    
    _topNameArr = [NSMutableArray array];
    _selectedDataArr = [NSMutableArray array];
    _selectedTitleArr = [NSMutableArray array];
    _categoryNameArr = [NSMutableArray array];
    _refereeArr = [NSMutableArray array];
    self.view.backgroundColor = [UIColor whiteColor];
    [self requestData];
}

- (void)rightDrawerAction:(UIBarButtonItem *)sender {
    if (!popKit) {
        popKit = [[PopViewKit alloc] init];
        popKit.bTapDismiss = YES;
        popKit.bInnerTapDismiss = NO;
    }
    if (!rightView) {
        rightView = [[RefereeCatePopView alloc]initWithFrame:CGRectMake(0, 0, 200, kScreenHeight)];
        rightView.delegate = self;
    }
    rightView.frame = CGRectMake(0, 0, 200, kScreenHeight);
    popKit.contentOrigin = CGPointMake(APP_DELEGATE.window.width-rightView.width, 0);
    [popKit popView:rightView animateType:PAT_WidthRightToLeft];
}

#pragma mark - popViewDelegate
-(void)popViewDidSelectCategory:(NSString *)cate{
    self.title = cate;
    if(_selectedTitleArr.count){
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.refereeView scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
    [self requestDataWithCate:cate];
    [popKit dismiss:YES];
}

-(void)requestDataWithCate:(NSString *)cate{
    if([cate isEqualToString:@"FIFA"]){
        [self requestData];
    }
    NSString *urlStr = [[NSString stringWithFormat:@"games/referees/league?league=%@", cate] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [CommonRequest requstPath:urlStr loadingDic:@{kLoadingType : @(RLT_OverlayLoad), kLoadingView : (self.view)} queryParam:nil success:^(CommonRequest *request, id jsonDict) {
        
        [self dealWithCateData: jsonDict];
        
    } failure:^(CommonRequest *request, NSError *error) {
        NSLog(@"+++error: %@", error);
    }];
}

-(void)dealWithCateData:(id)jsonDict{
    NSArray *jsonArr = jsonDict;
//    NSDictionary *dict = [jsonArr objectAtIndex:1];
    _selectedTitleArr = [NSMutableArray array];
    _selectedDataArr = [NSMutableArray array];
    //分组
//    NSArray *a = [dict objectForKey:@"referees"];
    if(jsonArr.count > 1){
        for(NSDictionary *dic in jsonArr){
            [_selectedTitleArr addObject:[dic objectForKey:@"categoryName"]];
            NSArray *referees = [dic objectForKey:@"referees"];
            NSMutableArray *sectionReffeeArr = [NSMutableArray array];
            for(int j = 0; j < referees.count; j++){
                NSDictionary *dic = referees[j];
                RefereeModel *referee = [[RefereeModel alloc] initWithDictionary:dic error:nil];
                [sectionReffeeArr addObject:referee];
            }
            [_selectedDataArr addObject:sectionReffeeArr];
        }
    }else{ // 无分组
        NSDictionary *dict = [jsonArr objectAtIndex:0];
        NSArray *referees = [dict objectForKey:@"referees"];
        NSMutableArray *sectionReffeeArr = [NSMutableArray array];
        for(int j = 0; j < referees.count; j++){
            NSDictionary *dic = referees[j];
            RefereeModel *referee = [[RefereeModel alloc] initWithDictionary:dic error:nil];
            [sectionReffeeArr addObject:referee];
        }
        [_selectedDataArr addObject:sectionReffeeArr];
        _selectedTitleArr = nil;
    }
    [self addRefereeTableView];
}

-(void)addRefereeTableView{
    _refereeView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    _refereeView.delegate = self;
    _refereeView.dataSource = self;
    _refereeView.backgroundColor = kwhiteColor;
    _refereeView.showsVerticalScrollIndicator = NO;
    [_refereeView registerClass:[RefereeCell class] forCellReuseIdentifier:kReuseId];
    _refereeView.allowsSelection = NO;
//    _refereeView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_refereeView];
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
    [_topNameArr removeAllObjects];
    [_categoryNameArr removeAllObjects];
    [_refereeArr removeAllObjects];
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
    _CategoryView = [[CategoryView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, 32) category:self.topNameArr];
    _CategoryView.ClickBtn = ^(CGFloat index){
        [Weak(self) clickBtn:(index)];
    };
    [self.view addSubview:_CategoryView];
    _CategoryView.backgroundColor = kwhiteColor;
    _refereeView = [[UITableView alloc] initWithFrame:CGRectMake(0, 98, SCREEN_WIDTH, SCREEN_HEIGHT - 98) style:UITableViewStylePlain];
    _refereeView.delegate = self;
    _refereeView.dataSource = self;
    _refereeView.backgroundColor = kwhiteColor;
    _refereeView.showsVerticalScrollIndicator = NO;
    [_refereeView registerClass:[RefereeCell class] forCellReuseIdentifier:kReuseId];
    _refereeView.allowsSelection = NO;
    [self.view addSubview:_refereeView];
}


-(void)clickBtn:(NSUInteger)tag{
    self.selectedIndex = tag;
//    [_selectedDataArr removeAllObjects];
//    [_selectedTitleArr removeAllObjects];
    NSArray *ceteArr = [self.refereeArr objectAtIndex:self.selectedIndex];
    //获取所有分区标题
    self.selectedTitleArr = [NSMutableArray array];
    [self.selectedTitleArr addObjectsFromArray:[self.categoryNameArr objectAtIndex:self.selectedIndex]];
    //获取对应分区下列表
    self.selectedDataArr = [NSMutableArray array];
    [_selectedDataArr addObjectsFromArray:ceteArr];
    [self.refereeView reloadData];
    if(_selectedDataArr.count){
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.refereeView scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(_selectedTitleArr != nil){
        return _selectedTitleArr.count;
    }
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arr = [_selectedDataArr objectAtIndex:section];
    return arr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 170;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *arr = [_selectedDataArr objectAtIndex:indexPath.section];
    RefereeModel *referee = [arr objectAtIndex:indexPath.row];
    
    //    RefereeCell *cell = [tableView dequeueReusableCellWithIdentifier:kReuseId forIndexPath:indexPath];
    RefereeCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(!cell){
        cell = [[RefereeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kReuseId];
    }else{
        if([cell.contentView.subviews lastObject] != nil){
            [[cell.contentView.subviews lastObject] removeAllSubviews];
        }
    }
    [cell displayCell:referee];
    cell.delegate = self;
    return cell;
}
// 区头标题
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(_selectedTitleArr != nil){
        return 30;
    }
    return 0;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    headerView.backgroundColor = HEXRGBCOLOR(0xf1f1f1);
    UILabel *sectionLabel = [[UILabel alloc] initWithFrame:headerView.bounds];
    sectionLabel.backgroundColor = HEXRGBCOLOR(0xf1f1f1);
    sectionLabel.tintColor = HEXRGBCOLOR(0x666666);
    sectionLabel.font = kBasicBigDetailTitleFont;
    sectionLabel.textAlignment = NSTextAlignmentCenter;
    sectionLabel.text = self.selectedTitleArr[section];
    [headerView addSubview:sectionLabel];
    
    return headerView;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - BaseInfoViewDelegate
-(void)likeBtnClicked:(UIButton *)btn cell:(RefereeCell *)cell{
    NSLog(@"like");
    NSIndexPath *indexpath = [_refereeView indexPathForCell:cell];
    NSArray *arr = [_selectedDataArr objectAtIndex:indexpath.section];
    RefereeModel *referee = [arr objectAtIndex:indexpath.row];
    NSString *urlStr = [NSString stringWithFormat:@"like/likes/%@?type=referee", referee.refefeeId];
    [CommonRequest requstPath:urlStr loadingDic:nil queryParam:nil success:^(CommonRequest *request, id jsonDict) {
        NSLog(@"data = %@", jsonDict);
        NSDictionary *dic = jsonDict;
        if(![[dic objectForKey:@"like"] isEqual:[NSNull null]]){
            return ;
        }else{
            _likeNum = [[dic objectForKey:@"likeNum"] intValue];
            NSDictionary *dic = @{@"type":@"referee", @"target":referee.refefeeId, @"like":@1};
            [CommonRequest requstPath:@"like/likes" loadingDic:nil postParam:dic success:^(CommonRequest *request, id jsonDict) {
                NSLog(@"succeed!%@", jsonDict);
                [btn setTitle:[NSString stringWithFormat:@"%d", _likeNum + 1] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"fired"] forState:UIControlStateNormal];
            } failure:^(CommonRequest *request, NSError *error) {
                NSLog(@"error: %@", error);
            }];
        }
    } failure:^(CommonRequest *request, NSError *error) {
        NSLog(@"error = %@", error);
    }];
}

@end
