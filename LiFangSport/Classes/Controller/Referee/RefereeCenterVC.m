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

#define kReuseId  @"tableViewCell"
#define kHeaderReuseId  @"Header"
#define kRefereePath  @"games/referees?level=s"
@interface RefereeCenterVC()<UITableViewDelegate, UITableViewDataSource>
//@property(nonatomic, retain)NSMutableDictionary *dataDic;
@property(nonatomic, retain)NSMutableArray *topNameArr; // 裁判员 五人制 沙滩足球
@property(nonatomic, retain)NSMutableArray *categoryNameArr; // [[男足裁判，男足助理],[array2], ...]
@property(nonatomic, retain)NSMutableArray *refereeArr; //三个分类下的球员数组
@property(nonatomic, retain)NSMutableArray *selectedDataArr;
@property(nonatomic, retain)NSMutableArray *selectedTitleArr;
@property(nonatomic, retain)UITableView *refereeView;
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
        _refereeView = [[UITableView alloc] initWithFrame:CGRectMake(0, 114, SCREEN_WIDTH, SCREEN_HEIGHT - 114) style:UITableViewStylePlain];
        _refereeView.delegate = self;
        _refereeView.dataSource = self;
        _refereeView.backgroundColor = kwhiteColor;
        _refereeView.showsVerticalScrollIndicator = NO;
        [_refereeView registerClass:[RefereeCell class] forCellReuseIdentifier:kReuseId];
        _refereeView.allowsSelection = NO;
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

    [self.refereeView reloadData];
}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _selectedDataArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arr = [_selectedDataArr objectAtIndex:section];
    return arr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 190;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *arr = [_selectedDataArr objectAtIndex:indexPath.section];
    RefereeModel *referee = [arr objectAtIndex:indexPath.row];
    
    RefereeCell *cell = [tableView dequeueReusableCellWithIdentifier:kReuseId forIndexPath:indexPath];
    if(!cell){
        cell = [[RefereeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kReuseId];
    }
    [cell displayCell:referee];
    return cell;
}
// 区头标题
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    headerView.backgroundColor = HEXRGBCOLOR(0xf0f0f0);
    UILabel *sectionLabel = [[UILabel alloc] initWithFrame:headerView.bounds];
    sectionLabel.backgroundColor = HEXRGBCOLOR(0xf0f0f0);
    sectionLabel.tintColor = HEXRGBCOLOR(0x666666);
    sectionLabel.font = kBasicSmallTitleFont;
    sectionLabel.textAlignment = NSTextAlignmentCenter;
    sectionLabel.text = self.selectedTitleArr[section];
    [headerView addSubview:sectionLabel];
    
    return headerView;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
