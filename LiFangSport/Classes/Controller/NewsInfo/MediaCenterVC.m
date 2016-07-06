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
#import "PopViewKit.h"
#import "MediaCatePopView.h"
#import "UIBarButtonItem+SimAdditions.h"

@interface MediaCenterVC ()<UITableViewDelegate, UITableViewDataSource, MediaCatePopViewDelegate>{
    PopViewKit *popKit;
    MediaCatePopView *rightView;
}
@property(nonatomic, retain)NSMutableArray *dataArr;
@property(nonatomic, retain)UITableView *tableView;
@property(nonatomic, retain)UIImageView *bgImgView;
@property(nonatomic, retain)NSString *date;

@end

@implementation MediaCenterVC

-(void)loadView{
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
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
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithIcons:@[@"list_right.png"] target:self action:@selector(rightDrawerAction:)];
    
    self.dataArr = [NSMutableArray arrayWithCapacity:0];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[MediaCell class] forCellReuseIdentifier:@"cell"];
    [self.tableView registerClass:[MediaCell class] forCellReuseIdentifier:@"cell1"];
    [self requestDataWithisHeaderRefresh: YES];
    [self setupRefresh];
}

- (void)rightDrawerAction:(UIBarButtonItem *)sender {
    if (!popKit) {
        popKit = [[PopViewKit alloc] init];
        popKit.bTapDismiss = YES;
        popKit.bInnerTapDismiss = NO;
    }
    if (!rightView) {
        rightView = [[MediaCatePopView alloc]initWithFrame:CGRectMake(0, 0, 200, kScreenHeight)];
        rightView.delegate = self;
    }
    rightView.frame = CGRectMake(0, 0, 200, kScreenHeight);
    popKit.contentOrigin = CGPointMake(APP_DELEGATE.window.width-rightView.width, 0);
    [popKit popView:rightView animateType:PAT_WidthRightToLeft];
}

#pragma mark - popViewDelegate
-(void)popViewDidSelectCategory:(NSString *)cateId andName:(NSString *)name{
    self.categoryIds = cateId;
    self.title = name;
    self.date = nil;
    [self requestDataWithisHeaderRefresh:YES];
    [popKit dismiss:YES];
}

#pragma mark - 数据请求

-(void)requestDataWithisHeaderRefresh:(BOOL)isHeaderRefresh{
    NSMutableString *urlStr = [NSMutableString string];
    if(self.categoryIds == nil){
        if(!_date){
            urlStr = [NSMutableString stringWithFormat:@"wemedia/posts/search"];
        }else{
            urlStr = [NSMutableString stringWithFormat:@"wemedia/posts/search?date=%@", _date];
        }
    }else{
        if(!_date){
            urlStr = [NSMutableString stringWithFormat:@"wemedia/posts/search?categoryId=%@", self.categoryIds];
        }else{
            urlStr = [NSMutableString stringWithFormat:@"wemedia/posts/search?categoryId=%@&date=%@", self.categoryIds, _date];
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
        self.date = nil;
        [self.tableView reloadData];
        
    } failure:^(CommonRequest *request, NSError *error) {
        NSLog(@"error = %@", error);
        self.date = nil;
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
    MediaModel *media = self.dataArr[_dataArr.count - 1];
    self.date = [self timeStampChangeTimeWithTimeStamp:[NSString stringWithFormat:@"%f", media.createTime] timeStyle:@"yyyy-MM-dd'T'HH:mm:ss.SSSXXX"];
    [self requestDataWithisHeaderRefresh:NO];
}

#pragma mark - tableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MediaModel *media = [self.dataArr objectAtIndex:indexPath.row];
    static NSString *reuseCell = @"cell";
    static NSString *reuseCell1 = @"cell1";
    MediaCell *cell;
    if(media.containVideo == YES){
        cell = [tableView dequeueReusableCellWithIdentifier:reuseCell forIndexPath:indexPath];
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:reuseCell1 forIndexPath:indexPath];
    }
    if(!cell){
        cell = [[MediaCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseCell];
    }
    cell.backgroundColor = kclearColor;
    [cell displayCell:media];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 370/2;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    MediaDetailVC *MDVC = [[MediaDetailVC alloc] init];
    // 传值
    MediaModel *media = [self.dataArr objectAtIndex:indexPath.row];
    MDVC.media = media;
    [self.navigationController pushViewController:MDVC animated:YES];
}


/**
 *  时间戳转时间
 *
 *  @param timeStamp 时间戳 （eg:@"1296035591"）
 *  @param timeStyle 时间格式（eg: @"YYYY-MM-dd HH:mm:ss" ）
 *
 *  @return 返回转化好格式的时间字符串
 */
-(NSString *)timeStampChangeTimeWithTimeStamp:(NSString *)timeStamp timeStyle:(NSString *)timeStyle{
    NSTimeInterval interval = [timeStamp doubleValue]/1000.0;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:timeStyle];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSTimeZone *zoneOne = [NSTimeZone systemTimeZone];
    NSInteger intervalOne = [zoneOne secondsFromGMTForDate:date];
    //得到我国时区的时间
    NSDate *locateDateOne = [date dateByAddingTimeInterval:-intervalOne];
    NSString *strDate = [formatter stringFromDate:locateDateOne];
    NSString *formatterStr = [strDate stringByReplacingOccurrencesOfString:@"+08:00" withString:@"Z"];
    return formatterStr;
}

@end
