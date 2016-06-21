//
//  AJMediaQualityPickerView.h
//  Pods
//
//  Created by Gang Li on 8/24/15.
//
//

#import <UIKit/UIKit.h>
#import "AJMediaPlayerStyleDefines.h"
@class AJMediaQualityPickerView;
@protocol AJMediaQualityPickerViewDelegate <NSObject>
- (void)qualityPickerView:(AJMediaQualityPickerView *)pickerView didSelectAtIndex:(NSUInteger)index;
@end

@interface AJMediaQualityPickerView : UIControl
@property (nonatomic, copy) NSString *streamID;
@property (nonatomic, copy) NSArray *qualifiedItems;
@property (nonatomic, assign) AJMediaPlayerAppearenceStyle appearenceStyle;
@property (nonatomic, weak) id<AJMediaQualityPickerViewDelegate> delegate;

@end
