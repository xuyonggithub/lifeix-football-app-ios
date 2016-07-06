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
#import "VideoLearningDetModel.h"
#import "LearningInfoVC.h"
#import "LFSimulationCenterCell.h"

@interface VideoCenterVC ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *centerTableview;
@property(nonatomic,strong)NSMutableArray *dataArray;

@end

@implementation VideoCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [NSMutableArray array];
    self.view.backgroundColor = [UIColor clearColor];
    
    [self createTableview];
    [self requestData];
}
-(void)requestData{
    [CommonRequest requstPath:kvideoListPath loadingDic:@{kLoadingType : @(RLT_OverlayLoad), kLoadingView : (self.view)} queryParam:nil success:^(CommonRequest *request, id jsonDict) {
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
        _centerTableview.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"videolearningbackground"]];
    }
    _centerTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    _centerTableview.rowHeight = 15 + (SCREEN_WIDTH - 25) / 2.0;
}
#pragma mark-tableviewdelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    static NSString *cellid = @"VideoCenterVCcellid";
//    
//    VideoLearningCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
//    if (cell == nil) {
//        cell = [[VideoLearningCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
//    }
//    cell.model = _dataArray[indexPath.row];
//    return cell;
    static NSString *customCellID = @"LFSimulationCenterCellID";
    
    LFSimulationCenterCell * cell = [tableView dequeueReusableCellWithIdentifier:customCellID];
    if (!cell) {
        cell = [[LFSimulationCenterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:customCellID];
    }
    [cell refreshContentWithVideoListModel:self.dataArray[indexPath.row]];
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    VideoListModel *model = _dataArray[indexPath.row];
    if (model.type == 1) {//视频列表
        VideoLearningDetVC *dVC = [[VideoLearningDetVC alloc]init];
        dVC.catsArr = [VideoLearningDetModel arrayOfModelsFromDictionaries:model.cats];
        dVC.title = model.name;
        [self.navigationController pushViewController:dVC animated:YES];
    }else if(model.type == 2){
        LearningInfoVC *IVC = [[LearningInfoVC alloc]init];
        IVC.catsArr = [VideoLearningDetModel arrayOfModelsFromDictionaries:model.cats];
        IVC.title = model.name;
        [self.navigationController pushViewController:IVC animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
