//
//  CurrentlyScoreVC.m
//  LiFangSport
//
//  Created by 张毅 on 16/6/27.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import "CurrentlyScoreVC.h"
#import "CurrentlyScoreCell.h"
#import "CurrentlyScoreModel.h"
#import "CommonRequest.h"
#import "UIScrollView+INSPullToRefresh.h"

#define diffValue 2
#define headerUpdateDiffValue 1

//http://192.168.2.160:8080/cbs/fb/contest/list?start_time=2016-07-01&end_time=2016-07-05
@interface CurrentlyScoreVC ()<UITableViewDataSource,UITableViewDelegate>{
    NSInteger startIndex;
    NSInteger endIndex;
}
@property(nonatomic,strong)UITableView *kTableview;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSString *startStr;
@property(nonatomic,strong)NSString *endStr;
@property(nonatomic,strong)NSMutableArray *dataSourceArray;
@property(nonatomic,strong)NSDictionary *weekDic;
@property(nonatomic,strong)NSDictionary *monthDic;
@end

@implementation CurrentlyScoreVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.kTableview];
    _startStr = [NSString new];
    _endStr = [NSString new];
    startIndex = 0;
    endIndex = startIndex + diffValue;
    _startStr = [self getOneDayDate:startIndex];
    _endStr = [self getOneDayDate:endIndex];
    [self requestDataWithStart:_startStr andWithEnd:_endStr isHeaderRefresh:YES];
    [self setupRefresh];

}
-(void)requestDataWithStart:(NSString *)startStr andWithEnd:(NSString *)endStr isHeaderRefresh:(BOOL)isHeaderRefresh{
    [CommonRequest requstPath:[NSString stringWithFormat:@"%@start_time=%@&end_time=%@",kCurrentlyScorePath,startStr,endStr] loadingDic:@{kLoadingType : @(RLT_OverlayLoad), kLoadingView : (self.view)} queryParam:nil success:^(CommonRequest *request, id jsonDict) {
        [self dealWithData:jsonDict isHeaderRefresh:isHeaderRefresh];
    } failure:^(CommonRequest *request, NSError *error) {
        NSLog(@"+++error: %@", error);
        if (isHeaderRefresh) {
            [self.kTableview ins_endPullToRefresh];
        }else{
            [self.kTableview ins_endInfinityScroll];
        }
    }];
}

-(void)dealWithData:(id )dic isHeaderRefresh:(BOOL)isHeaderRefresh{
    [self.dataArray removeAllObjects];
    self.dataSourceArray = [CurrentlyScoreModel arrayOfModelsFromDictionaries:dic[@"data"][@"contests"]];
    NSMutableArray *array = [NSMutableArray arrayWithArray:_dataSourceArray];
    for(int i = 0; i < array.count; i++){
        CurrentlyScoreModel *model = array[i];
        NSArray *dateTimeArr = [[NSArray alloc]initWithArray:[self dateTimeArrFromOfStr:model.start_time]];
        NSString *dataStr = [NSString stringWithFormat:@"%@月%@日 %@",[self.monthDic objectForKey:dateTimeArr[1]],dateTimeArr[2],[self.weekDic objectForKey:dateTimeArr[0]]];
        NSMutableArray *tempArray = [@[] mutableCopy];
        [tempArray addObject:model];
        
        for(int j = i + 1; j < array.count; j++){
            CurrentlyScoreModel *model1 = array[j];
            NSArray *dateTimeArr = [[NSArray alloc]initWithArray:[self dateTimeArrFromOfStr:model1.start_time]];
            NSString *dataStr1 = [NSString stringWithFormat:@"%@月%@日 %@",[self.monthDic objectForKey:dateTimeArr[1]],dateTimeArr[2],[self.weekDic objectForKey:dateTimeArr[0]]];
            if([dataStr1 isEqualToString:dataStr]){
                [tempArray addObject:model1];
                [array removeObjectAtIndex:j];
                j--;
            }
        }
        [self.dataArray addObject:tempArray];
    }
    
    if (isHeaderRefresh) {
        [self.kTableview ins_endPullToRefresh];

    } else{
        [self.kTableview ins_endInfinityScroll];
        [self.kTableview ins_endInfinityScrollWithStoppingContentOffset:self.dataArray.count > 0];
    }
    [self.kTableview reloadData];
}

#pragma mark - UITableViewDelegate and UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSLog(@"分区：%lu", (unsigned long)_dataArray.count);
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *arr = self.dataArray[section];
    return arr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    titleLabel.backgroundColor = HEXRGBCOLOR(0xf1f1f1);
    NSArray *arr = self.dataArray[section];
    CurrentlyScoreModel *model = arr[0];
    NSArray *dateTimeArr = [[NSArray alloc]initWithArray:[self dateTimeArrFromOfStr:model.start_time]];
    NSString *dataStr = [NSString stringWithFormat:@"%@月%@日 %@",[self.monthDic objectForKey:dateTimeArr[1]],dateTimeArr[2],[self.weekDic objectForKey:dateTimeArr[0]]];
    titleLabel.text = dataStr;
    titleLabel.font = [UIFont systemFontOfSize:13];
    titleLabel.textColor = HEXRGBCOLOR(0x666666);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    return titleLabel;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *customCellID = @"LeftSwitchCellid";
    
    CurrentlyScoreCell * cell = [tableView dequeueReusableCellWithIdentifier:customCellID];
    if (!cell) {
        cell = [[CurrentlyScoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:customCellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSArray *arr = self.dataArray[indexPath.section];
    CurrentlyScoreModel *model = arr[indexPath.row];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CurrentlyScoreModel *model = self.dataArray[indexPath.row];

}

#pragma mark - Getter and Setter
-(UITableView *)kTableview{
    if (!_kTableview) {
        _kTableview = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _kTableview.delegate = self;
        _kTableview.dataSource = self;
        _kTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _kTableview.rowHeight = 100;
        _kTableview.backgroundColor= [UIColor whiteColor];
    }
    return _kTableview;
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}

-(NSMutableArray *)dataSourceArray{
    if (!_dataSourceArray) {
        _dataSourceArray = [NSMutableArray new];
    }
    return _dataSourceArray;
}

-(NSString *)getOneDayDate:(NSInteger)dateIndex{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [NSDate date];//当前的时间
    NSDate *getDate = [NSDate dateWithTimeInterval:dateIndex*24*60*60 sinceDate:date];//前后多少天，0表示当天,+表示后几天。-号表示前几天
    NSString *dateTime = [formatter stringFromDate:getDate];
    return dateTime;
}

#pragma mark - Reresh
- (void)setupRefresh
{
    DefineWeak(self);
    [self.kTableview ins_addPullToRefreshWithHeight:kDefaultRefreshHeight handler:^(UIScrollView *scrollView) {
        [Weak(self) headerRereshing];
    }];
    
    [self.kTableview ins_addInfinityScrollWithHeight:kDefaultRefreshHeight handler:^(UIScrollView *scrollView) {
        [Weak(self) footerRereshing];
    }];
    [self.kTableview ins_setPullToRefreshEnabled:YES];
    [self.kTableview ins_setInfinityScrollEnabled:YES];
    
    UIView <INSAnimatable> *infinityIndicator = [self infinityIndicatorViewFromCurrentStyle];
    [self.kTableview.ins_infiniteScrollBackgroundView addSubview:infinityIndicator];
    [infinityIndicator startAnimating];
    UIView <INSPullToRefreshBackgroundViewDelegate> *pullToRefresh = [self pullToRefreshViewFromCurrentStyle];
    self.kTableview.ins_pullToRefreshBackgroundView.delegate = pullToRefresh;
    [self.kTableview.ins_pullToRefreshBackgroundView addSubview:pullToRefresh];
}

- (void)headerRereshing
{
    startIndex -=headerUpdateDiffValue;
    _startStr = [self getOneDayDate:startIndex];
    _endStr = [self getOneDayDate:endIndex];
    [self requestDataWithStart:_startStr andWithEnd:_endStr isHeaderRefresh:YES];
}

- (void)footerRereshing
{
    endIndex +=diffValue;
    _startStr = [self getOneDayDate:startIndex];
    _endStr = [self getOneDayDate:endIndex];
    [self requestDataWithStart:_startStr andWithEnd:_endStr isHeaderRefresh:NO];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 解析数据工具
-(NSDictionary *)weekDic{
    NSDictionary* dic = @{@"Mon":@"周一",@"Tue":@"周二",@"Wed":@"周三",@"Thu":@"周四",@"Fri":@"周五",@"Sat":@"周六",@"Sun":@"周日"};
    if (!_weekDic) {
        _weekDic = [[NSDictionary alloc]initWithDictionary:dic];
    }
    return _weekDic;
}
-(NSDictionary *)monthDic{
    NSDictionary* monthDic = @{@"Jan":@"01",@"Feb":@"02",@"Mar":@"03",@"Apr":@"04",@"May":@"05",@"Jun":@"06",@"Jul":@"07",@"Aug":@"08",@"Sep":@"09",@"Oct":@"10",@"Nov":@"11",@"Dec":@"12"};
    if (_monthDic==nil) {
        _monthDic = [[NSDictionary alloc]initWithDictionary:monthDic];
    }
    return _monthDic;
}

-(NSArray *)dateTimeArrFromOfStr:(NSString *)str{
    NSArray* ndateTimeArr = [str componentsSeparatedByString:@" "];
    return ndateTimeArr;
}

@end
