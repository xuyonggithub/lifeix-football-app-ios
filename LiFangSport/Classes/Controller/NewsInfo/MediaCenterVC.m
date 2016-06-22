//
//  MediaTVC.m
//  LiFangSport
//
//  Created by Lifeix on 16/6/12.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import "MediaCenterVC.h"
#import "MediaModel.h"
#import "MediaCell.h"
#import "MediaDetailVC.h"
#import "CommonRequest.h"
#import "UIScrollView+INSPullToRefresh.h"

@interface MediaCenterVC ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, retain)NSMutableArray *dataArr;
@property(nonatomic, retain)UITableView *tableView;
@property(nonatomic, retain)UIImageView *bgImgView;
@property(nonatomic, retain)NSString *date;
@property(nonatomic, assign)NSInteger limit;

@end

@implementation MediaCenterVC

-(void)loadView{
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    self.bgImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"allBg.jpg"]];
    if([self.title isEqualToString:@"男足"]){
        self.bgImgView.image = [UIImage imageNamed:@"playerBg.jpg"];
    }else if ([self.title isEqualToString:@"女足"]){
        self.bgImgView.image = [UIImage imageNamed:@"womanPlayerBg.jpg"];
    }else if ([self.title isEqualToString:@"裁判"]){
        self.bgImgView.image = [UIImage imageNamed:@"refereeBg.jpg"];
    }else if ([self.title isEqualToString:@"教练"]){
        self.bgImgView.image = [UIImage imageNamed:@"coachBg.jpg"];
    }
    
    self.bgImgView.frame = self.view.bounds;
    self.bgImgView.userInteractionEnabled = YES;
    self.tableView.backgroundView = self.bgImgView;
    
}

-(void)viewDidLoad{
    [super viewDidLoad];
    if(!self.title){
        self.title = @"资讯";
    }
    
    _limit = 5;
    
    self.dataArr = [NSMutableArray arrayWithCapacity:0];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[MediaCell class] forCellReuseIdentifier:@"cell"];
    [self requestDataWithisHeaderRefresh: YES];
    [self setupRefresh];
}

#pragma mark - 数据请求

-(void)requestDataWithisHeaderRefresh:(BOOL)isHeaderRefresh{
    NSMutableString *urlStr = [NSMutableString string];
    if(self.categoryIds == nil){
        if(!_date){
            urlStr = [NSMutableString stringWithFormat:@"wemedia/posts/search?limit=%zd", _limit];
        }else{
            urlStr = [NSMutableString stringWithFormat:@"wemedia/posts/search?date=%@&limit=%zd", _date, _limit];
        }
    }else{
        if(!_date){
            urlStr = [NSMutableString stringWithFormat:@"wemedia/posts/search?categoryId=%@&limit=%zd", self.categoryIds, _limit];
        }else{
            urlStr = [NSMutableString stringWithFormat:@"wemedia/posts/search?categoryId=%@&date=%@&limit=%zd", self.categoryIds, _date, _limit];
        }
    }
    [CommonRequest requstPath:urlStr loadingDic:nil queryParam:nil success:^(CommonRequest *request, id jsonDict) {
        NSLog(@"data = %@", jsonDict);
        NSArray *arr = [MediaModel arrayOfModelsFromDictionaries:jsonDict];
        
        if(isHeaderRefresh){
            [_tableView ins_endPullToRefresh];
            [_dataArr removeAllObjects];
            [_dataArr addObjectsFromArray:arr];
        }else{
            [_tableView ins_endInfinityScroll];
            [_tableView ins_endInfinityScrollWithStoppingContentOffset:arr.count > 0];
            [_dataArr addObjectsFromArray:arr];
        }
        
        [self.tableView reloadData];
        
    } failure:^(CommonRequest *request, NSError *error) {
        NSLog(@"error = %@", error);
    }];
}

#pragma mark - Reresh
- (void)setupRefresh
{
    DefineWeak(self);
    [_tableView ins_addPullToRefreshWithHeight:kDefaultRefreshHeight handler:^(UIScrollView *scrollView) {
        [Weak(self) headerRereshing];
    }];
    
    [_tableView ins_addInfinityScrollWithHeight:kDefaultRefreshHeight handler:^(UIScrollView *scrollView) {
        [Weak(self) footerRereshing];
    }];
    [_tableView ins_setPullToRefreshEnabled:YES];
    [_tableView ins_setInfinityScrollEnabled:YES];
    
    UIView <INSAnimatable> *infinityIndicator = [self infinityIndicatorViewFromCurrentStyle];
    [_tableView.ins_infiniteScrollBackgroundView addSubview:infinityIndicator];
    [infinityIndicator startAnimating];
    UIView <INSPullToRefreshBackgroundViewDelegate> *pullToRefresh = [self pullToRefreshViewFromCurrentStyle];
    _tableView.ins_pullToRefreshBackgroundView.delegate = pullToRefresh;
    [_tableView.ins_pullToRefreshBackgroundView addSubview:pullToRefresh];
    //    _tableView.top = _CategoryView.bottom-50;
}

// 刷新
- (void)headerRereshing
{
    [self requestDataWithisHeaderRefresh:YES];
}

// 加载
- (void)footerRereshing
{
    MediaModel *media = self.dataArr[self.dataArr.count - 1];
    self.date = [self TimeStamp:media.createTime];
    [self requestDataWithisHeaderRefresh:NO];
}

#pragma mark - tableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseCell = @"cell";
    MediaCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseCell forIndexPath:indexPath];
    if(!cell){
        cell = [[MediaCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseCell];
    }
    cell.backgroundColor = kclearColor;
    MediaModel *media = [self.dataArr objectAtIndex:indexPath.row];
    [cell displayCell:media];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 155;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    MediaDetailVC *MDVC = [[MediaDetailVC alloc] init];
    // 传值
    MediaModel *media = [self.dataArr objectAtIndex:indexPath.row];
    MDVC.media = media;
    [self.navigationController pushViewController:MDVC animated:YES];
}

// 时间戳转时间
-(NSString *)TimeStamp:(double)intTime{
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:intTime];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:detaildate];
    NSDate *localeDate = [detaildate dateByAddingTimeInterval: interval];
    
    NSDateFormatter*dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSXXX"];
    NSString *currentDateStr = [dateFormatter stringFromDate:localeDate];
    return currentDateStr;
}


@end
