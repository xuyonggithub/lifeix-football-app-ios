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
#import "HomeViewController.h"
#import "RightViewController.h"
#import "MediaVC.h"
#import "MediaCenterVC.h"
#import "MediaRightVC.h"
#import "PlayerCenterViewController.h"
#import "PlayerVC.h"
#import "VideoLearningVC.h"
#import "VideoCenterVC.h"
#import "CoachVC.h"
#import "CoachCenterVC.h"
#import "RefereeVC.h"
#import "RefereeCenterVC.h"
#import "SimulationTestVC.h"
#import "SimulationCenterVC.h"

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
    [CommonRequest requstPath:kcategoryPath loadingDic:nil queryParam:nil success:^(CommonRequest *request, id jsonDict) {
        [self dealWithJason:jsonDict];
    } failure:^(CommonRequest *request, NSError *error) {
        
    }];
}
-(void)dealWithJason:(id )dic{
    [_dataArray removeAllObjects];
    _dataArray = [HomeLeftCategModel arrayOfModelsFromDictionaries:dic];
    _kTableView.height = 55*_dataArray.count;
    [_kTableView reloadData];
}
-(void)createTableview{
    _kTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 80, self.view.width, 550) style:UITableViewStylePlain];
    _kTableView.backgroundColor = kclearColor;
    _kTableView.delegate = self;
    _kTableView.dataSource = self;
    _kTableView.scrollEnabled =NO;
    [self.view addSubview:_kTableView];
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
            HomeCenterVC *centerV=[[HomeCenterVC alloc]init];
            centerV.kidStr = model.KID;
            RightViewController *rightV=[[RightViewController alloc]init];
            HomeViewController *homeVC = [[HomeViewController alloc] initWithCenterVC:centerV rightVC:rightV leftVC:self];
//            [ self presentViewController:homeVC animated:NO completion:nil];
            [ self dismissViewControllerAnimated: NO completion: nil ];
            APP_DELEGATE.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
            APP_DELEGATE.window.backgroundColor = [UIColor whiteColor];
            APP_DELEGATE.window.rootViewController = homeVC;
            [APP_DELEGATE.window makeKeyAndVisible];
        }else if([model.page isEqualToString:@"medialist_page"]){
            MediaCenterVC *centerVC = [[MediaCenterVC alloc] init];
//            centerVC.title = @"全部";
            MediaRightVC *rightVC = [[MediaRightVC alloc] init];
            // 传值
            MediaVC *mediaVC = [[MediaVC alloc] initWithCenterVC:centerVC rightVC:rightVC leftVC:self];
            [ self dismissViewControllerAnimated: NO completion: nil ];
            APP_DELEGATE.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
            APP_DELEGATE.window.backgroundColor = [UIColor whiteColor];
            APP_DELEGATE.window.rootViewController = mediaVC;
            [APP_DELEGATE.window makeKeyAndVisible];
        }else if ([model.page isEqualToString:@"training_category_page"]){
            VideoCenterVC *centerV=[[VideoCenterVC alloc]init];
//            RightViewController *rightV=[[RightViewController alloc]init];
            VideoLearningVC *VideoVC = [[VideoLearningVC alloc] initWithCenterVC:centerV rightVC:nil leftVC:self];
            [ self dismissViewControllerAnimated: NO completion: nil ];
            APP_DELEGATE.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
            APP_DELEGATE.window.backgroundColor = [UIColor whiteColor];
            APP_DELEGATE.window.rootViewController = VideoVC;
            [APP_DELEGATE.window makeKeyAndVisible];
        }else if ([model.page isEqualToString:@"playerlist_page"]){
            PlayerCenterViewController *centerVC = [[PlayerCenterViewController alloc] init];
            centerVC.categoryName = model.name;
            PlayerVC *playerVC = [[PlayerVC alloc] initWithCenterVC:centerVC rightVC:nil leftVC:self];
            [ self dismissViewControllerAnimated: NO completion: nil ];
            APP_DELEGATE.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
            APP_DELEGATE.window.backgroundColor = [UIColor whiteColor];
            APP_DELEGATE.window.rootViewController = playerVC;
            [APP_DELEGATE.window makeKeyAndVisible];
        }else if ([model.page isEqualToString:@"refeerlist_page"]){
            RefereeCenterVC *centerVC = [[RefereeCenterVC alloc] init];
            RefereeVC *refereeVC = [[RefereeVC alloc] initWithCenterVC:centerVC rightVC:nil leftVC:self];
            [ self dismissViewControllerAnimated: NO completion: nil ];
            APP_DELEGATE.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
            APP_DELEGATE.window.backgroundColor = [UIColor whiteColor];
            APP_DELEGATE.window.rootViewController = refereeVC;
            [APP_DELEGATE.window makeKeyAndVisible];
        }else if ([model.page isEqualToString:@"coachlist_page"]){
            CoachCenterVC *centerVC = [[CoachCenterVC alloc] init];
            centerVC.categoryId = model.KID;
            CoachVC *coachVC = [[CoachVC alloc] initWithCenterVC:centerVC rightVC:nil leftVC:self];
            [ self dismissViewControllerAnimated: NO completion: nil ];
            APP_DELEGATE.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
            APP_DELEGATE.window.backgroundColor = [UIColor whiteColor];
            APP_DELEGATE.window.rootViewController = coachVC;
            [APP_DELEGATE.window makeKeyAndVisible];
        }else if ([model.page isEqualToString:@"quiz_categroy_page"]){
        SimulationCenterVC *centerVC = [[SimulationCenterVC alloc] init];
        centerVC.categoryId = model.KID;
        SimulationTestVC *coachVC = [[SimulationTestVC alloc] initWithCenterVC:centerVC rightVC:nil leftVC:self];
        [ self dismissViewControllerAnimated: NO completion: nil ];
        APP_DELEGATE.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        APP_DELEGATE.window.backgroundColor = [UIColor whiteColor];
        APP_DELEGATE.window.rootViewController = coachVC;
        [APP_DELEGATE.window makeKeyAndVisible];
        }
    
    
    }
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
