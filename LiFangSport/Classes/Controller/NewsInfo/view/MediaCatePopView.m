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
@property(nonatomic, retain)NSIndexPath *lastSelected;
@end

@implementation MediaCatePopView

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = RGBCOLOR(240, 241, 242);
        CGFloat statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
        CGFloat barHeight = statusBarHeight - self.frame.origin.y;
        self.tableView.backgroundColor = RGBCOLOR(240, 241, 242);
        [self.tableView setSeparatorColor:HEXRGBCOLOR(0xdcdcdc)];
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, barHeight, self.width, self.height - barHeight) style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.tableView registerClass:[MediaCategoryCell class] forCellReuseIdentifier:@"cell"];
        self.dataArr = [NSMutableArray array];
        UIView *headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 40)];
        UILabel *headerView = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, 140, 40)];
        [headerV addSubview: headerView];
        headerView.font = [UIFont systemFontOfSize:11];
        headerView.text = @"资讯的分类";
        headerView.centerY = 20;
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
//    cell.backgroundColor = RGBCOLOR(240, 241, 242);
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = HEXRGBCOLOR(0xae141c);
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(_lastSelected != nil){
        MediaCategoryCell *cell = [tableView cellForRowAtIndexPath:_lastSelected];
        cell.backgroundColor = HEXRGBCOLOR(0xffffff);
        cell.titleLab.textColor = HEXRGBCOLOR(0x929292);
    }
    MediaCategoryCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.backgroundColor = HEXRGBCOLOR(0xae141c);
    cell.titleLab.textColor = HEXRGBCOLOR(0xffffff);
    _lastSelected = indexPath;
    if(indexPath.row == 0){
        [self.delegate popViewDidSelectCategory:nil andName:@"全部"];
    }else{
        NSDictionary *dic = [self.dataArr objectAtIndex:indexPath.row - 1];
        [self.delegate popViewDidSelectCategory:[dic objectForKey:@"id"] andName:[dic objectForKey:@"name"]];
    }
}

@end
