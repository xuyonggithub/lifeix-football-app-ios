//
//  AJMediaEpisodePickerView.h
//  Pods
//
//  Created by Gang Li on 8/24/15.
//
//

#import <UIKit/UIKit.h>
#import "AJMediaPlayerStyleDefines.h"
@class AJMediaEpisodePickerView;
@class AJMediaPlayRequest;
@protocol AJMediaEpisodePickerViewDelegate <NSObject>
- (void)episodePickerView:(AJMediaEpisodePickerView *)pickerView didSelectWithPlayRequest:(AJMediaPlayRequest *)playRequest;
@end

@interface AJMediaEpisodePickerView : UIControl
@property (nonatomic, weak) id<AJMediaEpisodePickerViewDelegate> delegate;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSString *streamID;
@property (nonatomic, assign) AJMediaPlayerAppearenceStyle appearenceStyle;
@property (nonatomic, copy) id episodeItems;

@end
