//
//  LearningInfoPopView.m
//  LiFangSport
//
//  Created by 张毅 on 16/6/27.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import "LearningInfoPopView.h"
#import "LearningInfoPopCell.h"

@interface LearningInfoPopView()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong)NSMutableArray *dataArr;
@property(nonatomic, strong)UITableView *tableView;

@end
@implementation LearningInfoPopView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = HEXRGBCOLOR(0xf1f1f1);
        CGFloat statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
        CGFloat barHeight = statusBarHeight - self.frame.origin.y;
        self.tableView.backgroundColor = HEXRGBCOLOR(0xf1f1f1);
        [self.tableView setSeparatorColor:HEXRGBCOLOR(0xdbdbdb)];
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, barHeight, self.width, self.height - barHeight) style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.tableView registerClass:[LearningInfoPopCell class] forCellReuseIdentifier:@"LearningInfoPopCellid"];
        self.dataArr = [NSMutableArray array];
        UIView *headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 44)];
        UILabel *headerView = [[UILabel alloc] initWithFrame:CGRectMake(80, 0, 150, 44)];
        [headerV addSubview: headerView];
        headerView.font = [UIFont systemFontOfSize:19];
        headerView.text = @"文章的分类";
        headerView.centerY = 22;
        headerView.textColor = HEXRGBCOLOR(0x929292);
        self.tableView.tableHeaderView = headerV;
        [self addSubview:self.tableView];
    }
    return self;
}

#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;//self.dataArr.count + 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseCell = @"LearningInfoPopCellid";
    LearningInfoPopCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseCell forIndexPath:indexPath];
    if(!cell){
        cell = [[LearningInfoPopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseCell];
    }
    if(indexPath.row == 0){
        cell.titleLab.text = @"全部";
    }else{
//        NSDictionary *dic = [self.dataArr objectAtIndex:indexPath.row - 1];
//        cell.titleLab.text = [dic objectForKey:@"name"];
        cell.titleLab.text = @"123";
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

    }else{
        
    }
}


@end
