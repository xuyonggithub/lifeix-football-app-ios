//
//  AJMediaPlayerFeedback.h
//  Pods
//
//  Created by Zhangqibin on 8/24/15.
//
//

#import <Foundation/Foundation.h>



@interface AJMediaPlayerFeedback : NSObject
@property(nonatomic, copy) NSString *currentSchedulingUri;
@property(nonatomic, copy) NSDictionary *cdnInfo;

- (NSString *)feedbackEmailContent; //反馈邮件
- (NSString *)complaintEmailContent; //投诉邮件
- (NSArray *)mailRecipients;

- (instancetype)initWithSchedulingUri:(NSString *)uri cdnInfo:(NSDictionary *)cdnInfo;

@end
