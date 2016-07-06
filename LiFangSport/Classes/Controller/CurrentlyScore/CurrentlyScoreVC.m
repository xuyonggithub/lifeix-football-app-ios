//
//  CurrentlyScoreVC.m
//  LiFangSport
//
//  Created by 张毅 on 16/6/27.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import "CurrentlyScoreVC.h"
#import "LeftSwitchCell.h"

@interface CurrentlyScoreVC ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *kTableview;
@property(nonatomic,strong)NSMutableArray *dataArray;

@end

@implementation CurrentlyScoreVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.kTableview];
    
}

#pragma mark - UITableViewDelegate and UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;//self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 25 + (SCREEN_WIDTH - 25) / 2.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *customCellID = @"LeftSwitchCellid";
    
    LeftSwitchCell * cell = [tableView dequeueReusableCellWithIdentifier:customCellID];
    if (!cell) {
        cell = [[LeftSwitchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:customCellID];
    }
//    [cell refreshContent:self.dataArray[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   
}

#pragma mark - Getter and Setter
-(UITableView *)kTableview{
    if (!_kTableview) {
        _kTableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _kTableview.backgroundColor = [UIColor lightGrayColor];
        _kTableview.delegate = self;
        _kTableview.dataSource = self;
//        _kTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _kTableview.tableFooterView = [UIButton buttonWithType:UIButtonTypeCustom];
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
