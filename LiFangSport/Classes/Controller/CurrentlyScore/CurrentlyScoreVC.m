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

//http://192.168.2.160:8080/cbs/fb/contest/list?start_time=2016-07-01&end_time=2016-07-05
@interface CurrentlyScoreVC ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *kTableview;
@property(nonatomic,strong)NSMutableArray *dataArray;

@end

@implementation CurrentlyScoreVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.kTableview];
    NSString *startStr = [self getOneDayDate:0];
    NSString *endStr = [self getOneDayDate:6];
    [self requestDataWithStart:startStr andWithEnd:endStr isHeaderRefresh:YES];
    [self setupRefresh];

}
-(void)requestDataWithStart:(NSString *)startStr andWithEnd:(NSString *)endStr isHeaderRefresh:(BOOL)isHeaderRefresh{
    [CommonRequest requstPath:[NSString stringWithFormat:@"%@start_time=%@&end_time=%@",kCurrentlyScorePath,startStr,endStr] loadingDic:nil queryParam:nil success:^(CommonRequest *request, id jsonDict) {
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
    self.dataArray = [CurrentlyScoreModel arrayOfModelsFromDictionaries:dic[@"data"][@"contests"]];
    if (isHeaderRefresh) {
        [self.kTableview ins_endPullToRefresh];

    
    } else{
        [self.kTableview ins_endInfinityScroll];
        [self.kTableview ins_endInfinityScrollWithStoppingContentOffset:self.dataArray.count > 0];

    }
    [self.kTableview reloadData];
}

#pragma mark - UITableViewDelegate and UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *customCellID = @"LeftSwitchCellid";
    
    CurrentlyScoreCell * cell = [tableView dequeueReusableCellWithIdentifier:customCellID];
    if (!cell) {
        cell = [[CurrentlyScoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:customCellID];
    }
    CurrentlyScoreModel *model = self.dataArray[indexPath.row];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Getter and Setter
-(UITableView *)kTableview{
    if (!_kTableview) {
        _kTableview = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _kTableview.delegate = self;
        _kTableview.dataSource = self;
        _kTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _kTableview.rowHeight = 130*kScreenRatioBase6Iphone;
    }
    return _kTableview;
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
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
//    [self requestDataWithBtnTag:_catsArrIndex isHeaderRefresh:YES];
}

- (void)footerRereshing
{
//    [self requestDataWithBtnTag:_catsArrIndex isHeaderRefresh:NO];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
