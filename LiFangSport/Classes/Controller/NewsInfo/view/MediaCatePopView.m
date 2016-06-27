//
//  MediaCatePopView.m
//  LiFangSport
//
//  Created by 卢亚林 on 16/6/27.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import "MediaCatePopView.h"
#import "MediaCategoryCell.h"
#import "CommonRequest.h"
#import "MediaCenterVC.h"

@interface MediaCatePopView()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, retain)NSMutableArray *dataArr;
@property(nonatomic, retain)UITableView *tableView;

@end

@implementation MediaCatePopView

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = HEXRGBCOLOR(0xf1f1f1);
//        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        CGFloat statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
        CGFloat barHeight = statusBarHeight - self.frame.origin.y;
        self.tableView.backgroundColor = HEXRGBCOLOR(0xf1f1f1);
        [self.tableView setSeparatorColor:HEXRGBCOLOR(0xdbdbdb)];
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, barHeight, self.width, self.height - barHeight) style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.tableView registerClass:[MediaCategoryCell class] forCellReuseIdentifier:@"cell"];
        self.dataArr = [NSMutableArray array];
        UIView *headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 44)];
        UILabel *headerView = [[UILabel alloc] initWithFrame:CGRectMake(80, 0, 150, 44)];
        [headerV addSubview: headerView];
        headerView.font = [UIFont systemFontOfSize:19];
        headerView.text = @"资讯的分类";
        headerView.centerY = 22;
        headerView.textColor = HEXRGBCOLOR(0x929292);
        self.tableView.tableHeaderView = headerV;
        [self addSubview:self.tableView];
        
        [self requsetCategory];
    }
    return self;
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
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = HEXRGBCOLOR(0x951c22);
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.row == 0){
        [self.delegate popViewDidSelectCategory:nil andName:@"全部"];
    }else{
        NSDictionary *dic = [self.dataArr objectAtIndex:indexPath.row - 1];
        [self.delegate popViewDidSelectCategory:[dic objectForKey:@"id"] andName:[dic objectForKey:@"name"]];
    }
}

@end
