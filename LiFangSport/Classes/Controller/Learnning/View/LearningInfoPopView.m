//
//  LearningInfoPopView.m
//  LiFangSport
//
//  Created by 张毅 on 16/6/27.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import "LearningInfoPopView.h"
#import "LearningInfoPopCell.h"
#import "VideoLearningDetModel.h"

@interface LearningInfoPopView()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSMutableArray *newdataArr;

@end
@implementation LearningInfoPopView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame WithData:(NSArray*)arr{
    self = [super initWithFrame:frame];
    _dataArr = [[NSMutableArray alloc]initWithArray:arr];
    _newdataArr = [_dataArr copy];
    if (self) {
        self.backgroundColor = HEXRGBCOLOR(0xf1f1f1);
        CGFloat statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
        CGFloat barHeight = statusBarHeight - self.frame.origin.y;
        self.tableView.backgroundColor = HEXRGBCOLOR(0xf1f1f1);
        [self.tableView setSeparatorColor:HEXRGBCOLOR(0xdbdbdb)];
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, barHeight, self.width, self.height - barHeight) style:UITableViewStylePlain];
        self.tableView.tableFooterView = [UIButton buttonWithType:UIButtonTypeCustom];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.tableView registerClass:[LearningInfoPopCell class] forCellReuseIdentifier:@"LearningInfoPopCellid"];
        self.dataArr = [NSMutableArray array];
        UIView *headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 44)];
        UILabel *headerViewLab = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 150, 44)];
        [headerV addSubview: headerViewLab];
        headerViewLab.font = [UIFont systemFontOfSize:11];
        headerViewLab.text = @"文章分类";
        headerViewLab.centerY = 22;
        headerViewLab.textColor = HEXRGBCOLOR(0x929292);
        self.tableView.tableHeaderView = headerV;
        [self addSubview:self.tableView];
    }
    return self;
}
#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.newdataArr.count;;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseCell = @"LearningInfoPopCellid";
    LearningInfoPopCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseCell forIndexPath:indexPath];
    if(!cell){
        cell = [[LearningInfoPopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseCell];
    }
    VideoLearningDetModel *model = [self.newdataArr objectAtIndex:indexPath.row];
    cell.titleLab.text = model.name;
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = HEXRGBCOLOR(0x951c22);
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
        if (self.cellClickBc) {
            self.cellClickBc(indexPath.row);
        }
}

@end
