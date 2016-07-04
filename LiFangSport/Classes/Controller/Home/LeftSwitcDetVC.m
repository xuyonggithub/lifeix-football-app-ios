//
//  LeftSwitcDetVC.m
//  LiFangSport
//
//  Created by 张毅 on 16/6/29.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import "LeftSwitcDetVC.h"

@interface LeftSwitcDetVC ()<UIWebViewDelegate>
@property(nonatomic,strong)UIWebView *bwebView;

@end

@implementation LeftSwitcDetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _bwebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _bwebView.delegate = self;
    NSURL *url = [NSURL URLWithString:_urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_bwebView loadRequest:request];
    [self.view addSubview:_bwebView];
    self.view.backgroundColor = [UIColor whiteColor];
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
