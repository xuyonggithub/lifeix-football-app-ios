//
//  VideoCenterVC.m
//  LiFangSport
//
//  Created by 张毅 on 16/6/15.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import "VideoCenterVC.h"
#import "VideoLearningCell.h"
#import "VideoLearningDetVC.h"
#import "CommonRequest.h"
#import "VideoListModel.h"

@interface VideoCenterVC ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *centerTableview;
@property(nonatomic,strong)NSMutableArray *dataArray;

@end

@implementation VideoCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [NSMutableArray array];
    self.title = @"规则培训";
    [self createTableview];
    [self requestData];
}
-(void)requestData{
    [CommonRequest requstPath:kvideoListPath loadingDic:nil queryParam:nil success:^(CommonRequest *request, id jsonDict) {
        [self dealWithJason:jsonDict];
    } failure:^(CommonRequest *request, NSError *error) {
        
    }];
}

-(void)dealWithJason:(id )dic{
    [_dataArray removeAllObjects];
    _dataArray = [VideoListModel arrayOfModelsFromDictionaries:dic];
    [_centerTableview reloadData];
}
-(void)createTableview{
    if (_centerTableview==nil) {
        _centerTableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
        _centerTableview.backgroundColor = kclearColor;
        _centerTableview.delegate = self;
        _centerTableview.dataSource = self;
        [self.view addSubview:_centerTableview];
    }
}
#pragma mark-tableviewdelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellid = @"VideoCenterVCcellid";
    
    VideoLearningCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) {
        cell = [[VideoLearningCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.model = _dataArray[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    VideoLearningDetVC *dVC = [[VideoLearningDetVC alloc]init];
    [self.navigationController pushViewController:dVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
