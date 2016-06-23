//
//  PlayerDetailVC.m
//  LiFangSport
//
//  Created by 卢亚林 on 16/6/22.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import "PlayerDetailVC.h"
#import "CategoryView.h"
#import "BaseInfoView.h"
#import "CommonRequest.h"

@interface PlayerDetailVC ()

@property(nonatomic, retain)NSMutableArray *categoryArr;
@property(nonatomic, retain)NSMutableArray *categoryUrlArr;
@property(nonatomic, retain)NSMutableArray *playerVideosArr;

@end

@implementation PlayerDetailVC

-(void)loadView{
    [super loadView];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.playerName;
    self.categoryArr = [NSMutableArray array];
    self.categoryUrlArr = [NSMutableArray array];
    self.playerVideosArr = [NSMutableArray array];
    [self requestData];
}

-(void)requestData{
    NSString *urlStr = [NSString stringWithFormat:@"games/players/%@/basic", self.playerId];
    [CommonRequest requstPath:urlStr loadingDic:nil queryParam:nil success:^(CommonRequest *request, id jsonDict) {
        [self dealWithDic: jsonDict];
    } failure:^(CommonRequest *request, NSError *error) {
        NSLog(@"error = %@", error);
    }];
}

-(void)dealWithDic:(id)dic{
    NSDictionary *dict = dic;
    NSMutableArray *cateArr = [NSMutableArray arrayWithArray:[dict objectForKey:@"urls"]];
    self.playerVideosArr = [dict objectForKey:@"playerVideos"];
    for(NSDictionary *dic in cateArr){
        [self.categoryArr addObject:dic.allKeys[0]];
        [self.categoryUrlArr addObject:dic.allValues[0]];
    }
    //基本信息
    BaseInfoView *baseView = [[BaseInfoView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, 190) andAvatar:[dic objectForKey:@"avator"] andName:[dic objectForKey:@"name"] andBirday:[dic objectForKey:@"birthday"] andHeight:[dic objectForKey:@"height"] andWeight:[dic objectForKey:@"weight"] andPosition:[dic objectForKey:@"position"] andBirthplace:[dic objectForKey:@"birthplace"] andClub:[dic objectForKey:@"club"]];
    [self.view addSubview:baseView];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, baseView.bottom, SCREEN_WIDTH, 1)];
    lineView.backgroundColor = HEXRGBCOLOR(0x989898);
    [self.view addSubview:lineView];
    // 类目栏
    DefineWeak(self);
    CategoryView *cateView = [[CategoryView alloc] initWithFrame:CGRectMake(0, lineView.bottom, SCREEN_WIDTH, 44) category:self.categoryArr];
    cateView.ClickBtn = ^(CGFloat index){
        [Weak(self) clickBtn:(index)];
    };
    
}

-(void)clickBtn:(CGFloat)tag{
//    self.selectedIndex = tag;
//    [_selectedDataArr removeAllObjects];
//    NSArray *arr;
//    if([self.categoryName isEqualToString:@"中国男足"]){
//        arr = [NSArray arrayWithArray:self.playerArr[0]];
//    }else{
//        arr = [NSArray arrayWithArray:self.playerArr[1]];
//    }
//    [_selectedDataArr addObjectsFromArray:[arr objectAtIndex:tag]];
//    [self.playerView reloadData];
}

@end
