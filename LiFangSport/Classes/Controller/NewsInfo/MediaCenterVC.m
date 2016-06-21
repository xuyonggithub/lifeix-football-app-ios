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

@interface MediaCenterVC ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, retain)NSMutableArray *dataArr;
@property(nonatomic, retain)UITableView *tableView;
@property(nonatomic, retain)UIImageView *bgImgView;

@end

@implementation MediaCenterVC

-(void)loadView{
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
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
//    self.title = @"资讯";
    
    self.dataArr = [NSMutableArray arrayWithCapacity:0];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[MediaCell class] forCellReuseIdentifier:@"cell"];
    [self requestData];
}

#pragma mark - 数据请求

-(void)requestData{
    NSMutableString *urlStr = [NSMutableString string];
    if(self.categoryIds == nil){
        urlStr = [NSMutableString stringWithString:@"wemedia/posts/search"] ;
    }else{
        urlStr = [NSMutableString stringWithFormat:@"wemedia/posts/search?categoryId=%@", self.categoryIds];
    }
    [CommonRequest requstPath:urlStr loadingDic:nil queryParam:nil success:^(CommonRequest *request, id jsonDict) {
        NSLog(@"data = %@", jsonDict);
        for(NSDictionary *dic in jsonDict){
            MediaModel *media = [[MediaModel alloc] initWithDictionary:dic error:nil];
            [self.dataArr addObject:media];
        }
        NSLog(@"%d", [_dataArr count]);
        [self.tableView reloadData];
        
    } failure:^(CommonRequest *request, NSError *error) {
        NSLog(@"error = %@", error);
    }];
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


@end
