//
//  CurrentlyScoreVC.m
//  LiFangSport
//
//  Created by 张毅 on 16/6/27.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import "CurrentlyScoreVC.h"
#import "LeftSwitchCell.h"
#import "LeftSwitchModel.h"
#import "CommonRequest.h"
//http://192.168.2.160:8080/cbs/fb/contest/list?start_time=2016-07-01&end_time=2016-07-05
@interface CurrentlyScoreVC ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *kTableview;
@property(nonatomic,strong)NSMutableArray *dataArray;

@end

@implementation CurrentlyScoreVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.kTableview];
    [self requestDataWithStart:@"" andWithEnd:@""];
}
-(void)requestDataWithStart:(NSString *)startStr andWithEnd:(NSString *)endStr{
    [CommonRequest requstPath:[NSString stringWithFormat:@"%@start_time=%@&end_time=%@",kCurrentlyScorePath,startStr,endStr] loadingDic:nil queryParam:nil success:^(CommonRequest *request, id jsonDict) {
        [self dealWithData:jsonDict];
    } failure:^(CommonRequest *request, NSError *error) {
        NSLog(@"+++error: %@", error);
    }];
}

-(void)dealWithData:(id )dic{
    [self.dataArray removeAllObjects];
    
    
    [self.kTableview reloadData];
}

#pragma mark - UITableViewDelegate and UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;//self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *customCellID = @"LeftSwitchCellid";
    
    LeftSwitchCell * cell = [tableView dequeueReusableCellWithIdentifier:customCellID];
    if (!cell) {
        cell = [[LeftSwitchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:customCellID];
    }
//    cell.model = model;
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
//        _kTableview.tableFooterView = [UIButton buttonWithType:UIButtonTypeCustom];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
