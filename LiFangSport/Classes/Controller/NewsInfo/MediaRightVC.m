//
//  MediaRightVC.m
//  LiFangSport
//
//  Created by Lifeix on 16/6/13.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import "MediaRightVC.h"
#import "MediaCenterVC.h"
#import "MediaVC.h"
#import "LeftCategoryVC.h"
#import "MediaCategoryCell.h"
#import "CommonRequest.h"

@interface MediaRightVC()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, retain)NSMutableArray *dataArr;
@property(nonatomic, retain)UITableView *tableView;

@end

@implementation MediaRightVC

-(void)loadView{
    [super loadView];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    CGFloat statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    CGFloat barHeight = statusBarHeight - self.view.frame.origin.y;
    self.tableView.backgroundColor = HEXRGBCOLOR(0xf1f1f1);
    [self.tableView setSeparatorColor:HEXRGBCOLOR(0xdbdbdb)];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, barHeight, self.view.frame.size.width, self.view.frame.size.height - barHeight) style:UITableViewStylePlain];
    UIView *headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    UILabel *headerView = [[UILabel alloc] initWithFrame:CGRectMake(80, 0, 150, 44)];
    [headerV addSubview: headerView];
    headerView.font = [UIFont systemFontOfSize:19];
    headerView.text = @"资讯的分类";
//    headerView.textAlignment = NSTextAlignmentLeft;
    headerView.centerY = 22;
    headerView.textColor = HEXRGBCOLOR(0x929292);
    self.tableView.tableHeaderView = headerV;
    [self.view addSubview:self.tableView];
}

-(void)viewDidLoad{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[MediaCategoryCell class] forCellReuseIdentifier:@"cell"];
//    self.dataArr = [NSArray arrayWithObjects:@"全部", @"男足", @"女足", @"裁判", @"教练", nil];
    self.dataArr = [NSMutableArray array];
    [self requsetCategory];
}

-(void)requsetCategory{
    [CommonRequest requstPath:@"category/menus/app_wemedia" loadingDic:nil queryParam:nil success:^(CommonRequest *request, id jsonDict) {
        self.dataArr = jsonDict;
        [self.tableView reloadData];
    } failure:^(CommonRequest *request, NSError *error) {
        NSLog(@"+++error:%@", error);
    }];
}

#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count + 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseCell = @"cell";
    MediaCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseCell forIndexPath:indexPath];
    if(!cell){
        cell = [[MediaCategoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseCell];
    }
    if(indexPath.row == 0){
        cell.titleLab.text = @"全部";
    }else{
        NSDictionary *dic = [self.dataArr objectAtIndex:indexPath.row - 1];
        cell.titleLab.text = [dic objectForKey:@"name"];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MediaCenterVC *centerVC = [[MediaCenterVC alloc] init];
    if(indexPath.row == 0){
        centerVC.categoryIds = nil;
        centerVC.title = @"全部";
    }else{
        NSDictionary *dic = [self.dataArr objectAtIndex:indexPath.row - 1];
        centerVC.categoryIds = [dic objectForKey:@"id"];
        centerVC.title = [dic objectForKey:@"name"];
    }
    LeftCategoryVC *leftVC = [[LeftCategoryVC alloc] init];
    MediaVC *mediaVC = [[MediaVC alloc]initWithCenterVC:centerVC rightVC:self leftVC:leftVC];
    [ self dismissViewControllerAnimated: NO completion: nil ];
    APP_DELEGATE.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    APP_DELEGATE.window.backgroundColor = [UIColor whiteColor];
    APP_DELEGATE.window.rootViewController = mediaVC;
    [APP_DELEGATE.window makeKeyAndVisible];
    
}


@end
