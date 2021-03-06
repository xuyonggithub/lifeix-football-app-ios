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
#import "MediaCenterVC.h"
#import "PlayerCenterViewController.h"
#import "VideoCenterVC.h"
#import "CoachCenterVC.h"
#import "RefereeCenterVC.h"
#import "SimulationCenterVC.h"
#import <RESideMenu.h>
#import "LFNavigationController.h"
#import "SelectRootViewController.h"
#import "CurrentlyScoreVC.h"

@interface LeftCategoryVC ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
@property(nonatomic,strong)UITableView *kTableView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)UIScrollView *baseScrollview;
@property(nonatomic,strong)UIImageView *logoView;

@end

@implementation LeftCategoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [NSMutableArray array];
    self.view.backgroundColor = HEXRGBCOLOR(0xf1f1f1);
    [self.view addSubview:self.baseScrollview];
    [self requestData];
    [self createLogoViewAndTableview];
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

    [self resetHomePage];//重设主界面
}
-(void)createLogoViewAndTableview{
    _logoView = [[UIImageView alloc]initWithImage:UIImageNamed(@"C-FheaderLogo")];
    _logoView.left = 30 ;
    _logoView.top = 30;
    [self.baseScrollview addSubview:_logoView];

    _kTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 80, self.view.width, 550) style:UITableViewStylePlain];
    _kTableView.backgroundColor = kclearColor;
    _kTableView.delegate = self;
    _kTableView.dataSource = self;
    _kTableView.scrollEnabled =NO;
    [self.baseScrollview addSubview:_kTableView];
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
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = HEXRGBCOLOR(0x951c22);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
        }else if ([model.page isEqualToString:@"fraction_page"]){
    
            [self pushToController:[[CurrentlyScoreVC alloc]init]  andWithTitle:model.name];
        }
    }
}

-(void)pushToController:(UIViewController *)controller andWithTitle:(NSString *)title{
    controller.title = title;
    LFNavigationController *Nav = [[LFNavigationController alloc]initWithRootViewController:controller];
    [self.sideMenuViewController setContentViewController:Nav animated:YES];
    [self.sideMenuViewController hideMenuViewController];
}

-(UIScrollView *)baseScrollview{
    if (_baseScrollview==nil) {
    _baseScrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    _baseScrollview.delegate = self;
    _baseScrollview.showsVerticalScrollIndicator=NO;
    _baseScrollview.showsHorizontalScrollIndicator=NO;
    _baseScrollview.scrollsToTop=YES;
    _baseScrollview.bounces=NO;
    _baseScrollview.contentSize = CGSizeMake(self.view.width, 667) ;
    }
    return _baseScrollview;
}

-(void)resetHomePage{
    if (_dataArray.count > 0) {//重设主页面
        HomeLeftCategModel *model = _dataArray[0];
        if([model.page isEqualToString:@"medialist_page"]){
            MediaCenterVC *vc = [[MediaCenterVC alloc]init];
            APP_DELEGATE.window.rootViewController = [SelectRootViewController resetRootViewControllerWithController:vc WithLeftVC:self];
        }else if ([model.page isEqualToString:@"training_category_page"]){
            VideoCenterVC *vc = [[VideoCenterVC alloc]init];
            APP_DELEGATE.window.rootViewController = [SelectRootViewController resetRootViewControllerWithController:vc WithLeftVC:self];
        }else if ([model.page isEqualToString:@"playerlist_page"]){
            PlayerCenterViewController *vc = [[PlayerCenterViewController alloc]init];
            APP_DELEGATE.window.rootViewController = [SelectRootViewController resetRootViewControllerWithController:vc WithLeftVC:self];
        }else if ([model.page isEqualToString:@"refeerlist_page"]){
            RefereeCenterVC *vc = [[RefereeCenterVC alloc]init];
            APP_DELEGATE.window.rootViewController = [SelectRootViewController resetRootViewControllerWithController:vc WithLeftVC:self];
        }else if ([model.page isEqualToString:@"coachlist_page"]){
            CoachCenterVC *vc = [[CoachCenterVC alloc]init];
            APP_DELEGATE.window.rootViewController = [SelectRootViewController resetRootViewControllerWithController:vc WithLeftVC:self];
        }else if ([model.page isEqualToString:@"quiz_categroy_page"]){
            SimulationCenterVC *vc = [[SimulationCenterVC alloc]init];
            APP_DELEGATE.window.rootViewController = [SelectRootViewController resetRootViewControllerWithController:vc WithLeftVC:self];
        }else if ([model.page isEqualToString:@"fraction_page"]){
            CurrentlyScoreVC *vc = [[CurrentlyScoreVC alloc]init];
            APP_DELEGATE.window.rootViewController = [SelectRootViewController resetRootViewControllerWithController:vc WithLeftVC:self];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
