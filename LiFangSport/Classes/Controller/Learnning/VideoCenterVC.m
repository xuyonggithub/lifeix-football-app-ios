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

@interface VideoCenterVC ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *centerTableview;
@end

@implementation VideoCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"规则培训";
    [self createTableview];
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
    return 5;
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
