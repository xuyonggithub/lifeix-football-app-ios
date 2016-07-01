//
//  SelectRootViewController.h
//  LiFangSport
//
//  Created by 张毅 on 16/6/27.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RESideMenu.h>
#import "LeftCategoryVC.h"

@interface SelectRootViewController : NSObject
//+(RESideMenu *)rootViewController;
+(RESideMenu *)rootViewControllerWithController:(UIViewController *)HVC;

+(RESideMenu *)resetRootViewControllerWithController:(UIViewController *)HVC WithLeftVC:(LeftCategoryVC *)leftVC;

@end
