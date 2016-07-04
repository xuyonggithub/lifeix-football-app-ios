//
//  LeftCategoryVC.m
//  LiFangSport
//
//  Created by 张毅 on 16/6/14.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import "LeftCategoryVC.h"
#import "CommonRequest.h"
#import "LeftCategoryCell.h"
#import "HomeLeftCategModel.h"
#import "HomeCenterVC.h"
#import "RightViewController.h"
#import "MediaVC.h"
#import "MediaCenterVC.h"
#import "MediaRightVC.h"
#import "PlayerCenterViewController.h"
#import "PlayerVC.h"
#import "VideoCenterVC.h"
#import "CoachVC.h"
#import "CoachCenterVC.h"
#import "RefereeVC.h"
#import "RefereeCenterVC.h"
#import "SimulationCenterVC.h"
#import <RESideMenu.h>
#import "LFNavigationController.h"
#import "SelectRootViewController.h"

@interface LeftCategoryVC ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *kTableView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@end

@implementation LeftCategoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [NSMutableArray array];
    self.view.backgroundColor = HEXRGBCOLOR(0xf1f1f1);
    [self requestData];
    [self createTableview];
}

-(void)requestData{
    [CommonRequest requstPath:kcategoryPath loadingDic:@{kLoadingType : @(RLT_OverlayLoad), kLoadingView : (self.view)} queryParam:nil success:^(CommonRequest *request, id jsonDict) {
        [self dealWithJason:jsonDict];
    } failure:^(CommonRequest *request, NSError *error) {
        
    }];
}
-(void)dealWithJason:(id )dic{
    [_dataArray removeAllObjects];
    _dataArray = [HomeLeftCategModel arrayOfModelsFromDictionaries:dic];
    _kTableView.height = 55*_dataArray.count;
    [_kTableView reloadData];

    if (_dataArray.count > 0) {
        HomeLeftCategModel *model = _dataArray[0];
        NSDictionary *notidic = [NSDictionary dictionaryWithObjectsAndKeys:model.KID, @"khomeKidNotiFicationStr", model.name, @"title", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:khomeKidNotiFicationStr object:nil userInfo:notidic];
    }
    if (_dataArray.count > 0) {//重设主页面
    HomeLeftCategModel *model = _dataArray[0];
    if([model.page isEqualToString:@"medialist_page"]){
        MediaCenterVC *mvc = [[MediaCenterVC alloc]init];
    APP_DELEGATE.window.rootViewController = [SelectRootViewController resetRootViewControllerWithController:mvc WithLeftVC:self];
     }
    }
}
-(void)createTableview{
    _kTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 80, self.view.width, 550) style:UITableViewStylePlain];
    _kTableView.backgroundColor = kclearColor;
    _kTableView.delegate = self;
    _kTableView.dataSource = self;
    _kTableView.scrollEnabled =NO;
    [self.view addSubview:_kTableView];
    _kTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"categorycell";
    LeftCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[LeftCategoryCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    if (_dataArray.count) {
        cell.model = _dataArray[indexPath.section];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_dataArray.count) {
        HomeLeftCategModel *model = _dataArray[indexPath.section];
            if ([model.page isEqualToString:@"competition_page"]) {
            [self pushToController:[[HomeCenterVC alloc]init] andWithTitle:model.name];
    }
        else if([model.page isEqualToString:@"medialist_page"]){
            [self pushToController:[[MediaCenterVC alloc]init]  andWithTitle:model.name];
        }else if ([model.page isEqualToString:@"training_category_page"]){
            
            [self pushToController:[[VideoCenterVC alloc]init]  andWithTitle:model.name];

        }else if ([model.page isEqualToString:@"playerlist_page"]){
            [self pushToController:[[PlayerCenterViewController alloc]init]  andWithTitle:model.name];

        }else if ([model.page isEqualToString:@"refeerlist_page"]){
            [self pushToController:[[RefereeCenterVC alloc]init]  andWithTitle:model.name];

        }else if ([model.page isEqualToString:@"coachlist_page"]){
            
            [self pushToController:[[CoachCenterVC alloc]init]  andWithTitle:model.name];

        }else if ([model.page isEqualToString:@"quiz_categroy_page"]){
            
            [self pushToController:[[SimulationCenterVC alloc]init]  andWithTitle:model.name];
        }
    }
}

-(void)pushToController:(UIViewController *)controller andWithTitle:(NSString *)title{
    controller.title = title;
    LFNavigationController *Nav = [[LFNavigationController alloc]initWithRootViewController:controller];
    [self.sideMenuViewController setContentViewController:Nav animated:YES];
    [self.sideMenuViewController hideMenuViewController];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
