//
//  UIAlertView+UserInfo.h
//  TingIPhone
//
//

#import <UIKit/UIKit.h>

@interface UIAlertView (UserInfo)
typedef void(^AlertViewDismissBlock)(NSInteger selectIndex);

@property (nonatomic, strong) id userInfo;
@property (nonatomic, copy) AlertViewDismissBlock didmissBlock;

@end
