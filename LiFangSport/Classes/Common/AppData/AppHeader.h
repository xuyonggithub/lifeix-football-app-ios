//
//  AppHeader.h
//  LiFangSport
//
//  Created by 张毅 on 16/6/12.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#ifndef AppHeader_h
#define AppHeader_h
#define ABOVE_IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0)
//typedef NS_ENUM(NSInteger, RankType){
//    ClassRank=0,
//    SchoolRank=1,
//    CountryRank=2,
//    TotalRank
//    
//};

#define NavigationBarHeight 44
#define BAR_TITLE_Y (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0") ? 20.0f : 0.0f)


//color
#define kBasicColor                  HEXRGBCOLOR(0xfd675b)
#define kDetailTitleColor            HEXRGBCOLOR(0x5f5f5f)
#define knavibarColor                HEXRGBACOLOR(0xce1126,1.0)
#define kclearColor                  [UIColor clearColor]
#define kwhiteColor                  [UIColor whiteColor]
#define kBlackColor                  [UIColor blackColor]

//font
#define kBasicBigTitleFont          [UIFont systemFontOfSize:15]
#define kBasicSmallTitleFont        [UIFont systemFontOfSize:14]
#define kBasicBigDetailTitleFont    [UIFont systemFontOfSize:13]

//size
#define kTabBarSize       16
#define kScreenWidth               [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight           [[UIScreen mainScreen] bounds].size.height
#define kDefaultRefreshHeight 30

#define kQiNiuHeaderPathPrifx @"http://o8rg11ywr.bkt.clouddn.com/"

//pad及iphone屏幕特殊处理(6p为基准)
#define kScreenRatioBase6Plus           (DEVICE_IS_IPAD?1.0:([[UIScreen mainScreen] bounds].size.width / 540.0))

#endif
