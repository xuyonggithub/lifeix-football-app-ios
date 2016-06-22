//
//  AJMediaMailComposeViewController.m
//  Pods
//
//  Created by Zhangqibin on 15/9/7.
//
//

#import "AJMediaMailComposeViewController.h"

#define AJLocalizedString(key, comment) \
[[NSBundle bundleForClass:[self class]] localizedStringForKey:key value:@"" table:nil]

@interface AJMediaMailComposeViewController ()

@end

@implementation AJMediaMailComposeViewController

- (void)setTintColor:(UIColor *)tintColor {
    self.navigationBar.tintColor = tintColor;
}

- (void)setNavigationBarBackgroundColor:(UIColor *)navigationBarBackgroundColor {
    self.navigationBar.backgroundColor = navigationBarBackgroundColor;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    
}

#pragma mark - Rotate Controll Method

- (BOOL)shouldAutorotate NS_AVAILABLE_IOS(6_0) {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations NS_AVAILABLE_IOS(6_0) {
    return UIInterfaceOrientationMaskPortrait;//只支持这一个方向(正常的方向)
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation NS_AVAILABLE_IOS(6_0) {
    return UIInterfaceOrientationPortrait;
}

@end
