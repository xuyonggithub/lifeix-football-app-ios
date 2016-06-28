//
//  SimulationCenterVC.m
//  LiFangSport
//
//  Created by 张毅 on 16/6/20.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import "SimulationCenterVC.h"
#import "LFSimulationTestDetailController.h"

#import "LFSimulationCenterCell.h"

#import "CommonRequest.h"

@interface SimulationCenterVC ()
    <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation SimulationCenterVC

#pragma mark - View Life Cycle
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.view addSubview:self.tableView];
    __weak typeof(self) weakSelf = self;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view);
    }];
    [CommonRequest requstPath:@"elearning/quiz_categories" loadingDic:nil queryParam:nil success:^(CommonRequest *request, id jsonDict) {
        weakSelf.dataArray = [LFSimulationCategoryModel simulationTestModelArrayWithArray:jsonDict];
        [weakSelf.tableView reloadData];
    } failure:^(CommonRequest *request, NSError *error) {
        NSLog(@"+++error: %@", error);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate and UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 10 + (SCREEN_WIDTH - 20) / 2.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *customCellID = @"LFSimulationCenterCellID";
    
    LFSimulationCenterCell * cell = [tableView dequeueReusableCellWithIdentifier:customCellID];
    if (!cell) {
        cell = [[LFSimulationCenterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:customCellID];
    }
    [cell refreshContent:self.dataArray[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LFSimulationTestDetailController *simulationTestDetailCtrl = [[LFSimulationTestDetailController alloc] init];
    simulationTestDetailCtrl.categoryModel = self.dataArray[indexPath.row];
    [self.navigationController pushViewController:simulationTestDetailCtrl animated:YES];
}

#pragma mark - Getter and Setter
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [UIButton buttonWithType:UIButtonTypeCustom];
        _tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"videolearningbackground"]];
    }
    return _tableView;
}

@end
