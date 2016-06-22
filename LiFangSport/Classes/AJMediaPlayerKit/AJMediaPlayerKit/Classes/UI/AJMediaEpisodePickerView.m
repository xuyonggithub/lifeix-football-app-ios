//
//  AJMediaEpisodePickerView.m
//  Pods
//
//  Created by Zhangqibin on 8/24/15.
//
//

#import "AJMediaEpisodePickerView.h"
#import "AJMediaPlayerUtilities.h"
#import "AJMediaPlayRequest.h"
#import "AJMediaStreamSchedulingMetadataFetcher.h"

@interface AJMediaEpisodePickerHeadView : UIView
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *aboveSeperator;
@property (nonatomic, strong) UILabel *belowSeperator;
@end

@implementation AJMediaEpisodePickerHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.dateLabel = [[UILabel alloc] init];
        self.dateLabel.backgroundColor = [UIColor clearColor];
        self.dateLabel.textAlignment = NSTextAlignmentCenter;
        self.dateLabel.font = [UIFont systemFontOfSize:9];
        self.dateLabel.textColor = [UIColor colorWithHTMLColorMark:@"999999"];
        [self addSubview:_dateLabel];
        
        self.aboveSeperator = [[UILabel alloc] init];
        self.aboveSeperator.backgroundColor = [UIColor colorWithHTMLColorMark:@"ffffff"];
        self.aboveSeperator.alpha = 0.21;
        self.aboveSeperator.hidden = YES;
        [self addSubview:self.aboveSeperator];
        
        self.belowSeperator = [[UILabel alloc] init];
        self.belowSeperator.backgroundColor = [UIColor colorWithHTMLColorMark:@"ffffff"];
        self.belowSeperator.alpha = 0.21;
        [self addSubview:self.belowSeperator];
    }
    return self;
}

- (void)updateDateLabelWith:(NSString *)dateString {
    [self.dateLabel setText:dateString];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.dateLabel.frame = CGRectMake(14, 0, self.frame.size.width-28, 21);
    self.aboveSeperator.frame = CGRectMake(14, 0, self.frame.size.width-28, 0.5);
    self.belowSeperator.frame = CGRectMake(14, self.frame.size.height-0.5, self.frame.size.width-28,0.5);
}
@end

@interface AJMediaEpisodePickerCell : UITableViewCell
@property (nonatomic, strong) UILabel *videoNameLabel;
@property (nonatomic, strong) UILabel *durationLabel;
@property (nonatomic, strong) UILabel *belowSeperator;
@property (nonatomic, assign) AJMediaPlayerAppearenceStyle appearenceStyle;
@end

@implementation AJMediaEpisodePickerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withAppearenceStyle:(AJMediaPlayerAppearenceStyle )appearenceStyle {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle =  UITableViewCellSelectionStyleNone;
        self.appearenceStyle = appearenceStyle;
        
        float videoNameLabelSize = _appearenceStyle==AJMediaPlayerStyleForiPhone?12:15;
        self.videoNameLabel = [[UILabel alloc] init];
        self.videoNameLabel.backgroundColor = [UIColor clearColor];
        self.videoNameLabel.textAlignment = NSTextAlignmentLeft;
        self.videoNameLabel.font = [UIFont systemFontOfSize:videoNameLabelSize];
        [self.contentView addSubview:self.videoNameLabel];
        
        float durationLabelSize = _appearenceStyle==AJMediaPlayerStyleForiPhone?9:12;
        self.durationLabel = [[UILabel alloc] init];
        self.durationLabel.backgroundColor = [UIColor clearColor];
        self.durationLabel.textAlignment = NSTextAlignmentLeft;
        self.durationLabel.font = [UIFont systemFontOfSize:durationLabelSize];
        self.durationLabel.textColor = [UIColor colorWithHTMLColorMark:@"999999"];
        [self.contentView addSubview:self.durationLabel];
        
        self.belowSeperator = [[UILabel alloc] init];
        self.belowSeperator.backgroundColor = [UIColor colorWithHTMLColorMark:@"ffffff"];
        self.belowSeperator.alpha = 0.21;
        [self.contentView addSubview:self.belowSeperator];
    }
    return self;
}

- (void)setupWithItem:(NSArray *)itemArray streamID:(NSString *)streamID atIndexPath:(NSIndexPath *)indexPath {
    id item = (itemArray)[indexPath.row];
    if (item && [item isKindOfClass:[AJMediaPlayRequest class]]) {
        AJMediaPlayRequest *playRequest = (AJMediaPlayRequest *)item;
        self.videoNameLabel.text = playRequest.resourceName;
        if ([streamID isEqualToString:playRequest.identifier]) {
            self.videoNameLabel.textColor = [UIColor colorWithHTMLColorMark:@"29c4c6"];
        } else {
            self.videoNameLabel.textColor = [UIColor whiteColor];
        }
        if (playRequest.duration) {
            self.durationLabel.text = playRequest.duration;
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    float videoNameLabelY = _appearenceStyle==AJMediaPlayerStyleForiPhone?17:25;
    float durationLabelY = _appearenceStyle==AJMediaPlayerStyleForiPhone?37:50;
    float videoNameLabelHeight = _appearenceStyle==AJMediaPlayerStyleForiPhone?12:15;
    float durationLabelHeight = _appearenceStyle==AJMediaPlayerStyleForiPhone?9:12;
    self.videoNameLabel.frame = CGRectMake(14, videoNameLabelY, self.frame.size.width-28, videoNameLabelHeight);
    self.durationLabel.frame = CGRectMake(14, durationLabelY, self.frame.size.width-28, durationLabelHeight);
    self.belowSeperator.frame = CGRectMake(14, self.frame.size.height-0.5, self.frame.size.width-28,0.5);
}
@end

@interface AJMediaEpisodePickerView() <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSDictionary *sort_map;
@property (nonatomic, strong) NSArray *keysArray;
@end

@implementation AJMediaEpisodePickerView

- (instancetype)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.backgroundColor  = [UIColor colorWithPatternImage:[UIImage imageNamed:@"player_landscape_stream_bg"]];
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = YES;
        [self addSubview:_tableView];
        self.sort_map = @{@"昨天":@(10000),@"今天":@(10001),@"明天":@(10002)};
    }
    return self;
}

- (void)setEpisodeItems:(id)episodeItems {
    self.tableView.frame = CGRectMake(10, 10, self.frame.size.width-20, self.frame.size.height-20);
    if ([episodeItems isKindOfClass:[NSArray class]]) {
        NSArray *tmpArray = episodeItems;
        if (tmpArray && tmpArray.count > 0) {
            _episodeItems = tmpArray;
        }
    } else if ([episodeItems isKindOfClass:[NSDictionary class]]) {
        NSDictionary *tmpDic = episodeItems;
        if (tmpDic && tmpDic.count > 0) {
            _episodeItems = tmpDic;
            self.keysArray = [[self.episodeItems allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                if ([_sort_map[obj1] integerValue] < [_sort_map[obj2] integerValue]) {
                    return NSOrderedAscending;
                } else if ([_sort_map[obj1] integerValue] > [_sort_map[obj2] integerValue]) {
                    return NSOrderedDescending;
                } else {
                    return NSOrderedSame;
                }
            }];
        }
    }
    [self.tableView reloadData];
    
    __block NSIndexPath *indexPath;
    __weak typeof(self) weakSelf = self;
    if ([self.episodeItems isKindOfClass:[NSArray class]]) {
        [self.episodeItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isKindOfClass:[AJMediaPlayRequest class]]) {
                AJMediaPlayRequest *playRequest = obj;
                if ([weakSelf.streamID isEqualToString:playRequest.identifier]) {
                    indexPath = [NSIndexPath indexPathForRow:idx inSection:0];
                    *stop = YES;
                }
            }
        }];
    } else if ([self.episodeItems isKindOfClass:[NSDictionary class]]) {
        __weak typeof(self) weakSelf = self;
        [self.keysArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSUInteger section = idx;
            if ([obj isKindOfClass:[NSString class]]) {
                NSString *key = obj;
                if ([[weakSelf.episodeItems valueForKey:key] isKindOfClass:[NSArray class]]) {
                    NSArray *tmpArray = [weakSelf.episodeItems valueForKey:key];
                    [tmpArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        if ([obj isKindOfClass:[AJMediaPlayRequest class]]) {
                            AJMediaPlayRequest *playRequest = obj;
                            if ([weakSelf.streamID isEqualToString:playRequest.identifier]) {
                                indexPath = [NSIndexPath indexPathForRow:idx inSection:section];
                                *stop = YES;
                            }
                        }
                    }];
                }
            }
        }];
    }
    if (indexPath) {
        [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
    }
}

#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([self.episodeItems isKindOfClass:[NSArray class]]) {
        return 1;
    } else if ([self.episodeItems isKindOfClass:[NSDictionary class]]) {
        return self.keysArray.count;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.episodeItems isKindOfClass:[NSArray class]]) {
        return [self.episodeItems count];
    } else if ([self.episodeItems isKindOfClass:[NSDictionary class]]) {
        NSString *key = [self.keysArray objectAtIndex:section];
        if ([[self.episodeItems valueForKey:key] isKindOfClass:[NSArray class]]) {
            NSArray *tmpArray = [self.episodeItems valueForKey:key];
            return tmpArray.count;
        }
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if ([self.episodeItems isKindOfClass:[NSDictionary class]]) {
        AJMediaEpisodePickerHeadView *headView = [[AJMediaEpisodePickerHeadView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 21)];
        [headView updateDateLabelWith:[self.keysArray objectAtIndex:section]];
        if (section == 0) {
            headView.aboveSeperator.hidden = NO;
        }
        return headView;
    }
    return nil;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([self.episodeItems isKindOfClass:[NSDictionary class]]) {
        return 21;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.episodeItems isKindOfClass:[NSArray class]]) {
        AJMediaEpisodePickerCell *pickerCell = (AJMediaEpisodePickerCell*)[tableView dequeueReusableCellWithIdentifier:@"ExcerptsCell"];
        if (!pickerCell) {
            pickerCell = [[AJMediaEpisodePickerCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"ExcerptsCell" withAppearenceStyle:_appearenceStyle];
        }
        [pickerCell setupWithItem:_episodeItems streamID:_streamID atIndexPath:indexPath];
        return pickerCell;
    } else if ([self.episodeItems isKindOfClass:[NSDictionary class]]) {
        AJMediaEpisodePickerCell *pickerCell = (AJMediaEpisodePickerCell*)[tableView dequeueReusableCellWithIdentifier:@"ExcerptsCell"];
        if (!pickerCell) {
            pickerCell = [[AJMediaEpisodePickerCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"ExcerptsCell" withAppearenceStyle:_appearenceStyle];
        }
        NSString *key = [self.keysArray objectAtIndex:indexPath.section];
        if ([[self.episodeItems valueForKey:key] isKindOfClass:[NSArray class]]) {
            NSArray *tmpArray = [self.episodeItems valueForKey:key];
            [pickerCell setupWithItem:tmpArray streamID:_streamID atIndexPath:indexPath];
        }
        return pickerCell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _appearenceStyle==AJMediaPlayerStyleForiPhone?64:80;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.episodeItems isKindOfClass:[NSArray class]]) {
        AJMediaPlayRequest *playRequest = (AJMediaPlayRequest *)(self.episodeItems)[indexPath.row];
        if (self.streamID && [self.streamID isEqualToString:playRequest.identifier]) {
            return;
        }
        self.streamID = playRequest.identifier;
        [self.tableView reloadData];
        if (self.delegate && [self.delegate respondsToSelector:@selector(episodePickerView:didSelectWithPlayRequest:)]) {
            [self.delegate episodePickerView:self didSelectWithPlayRequest:playRequest];
        }
    } else if ([self.episodeItems isKindOfClass:[NSDictionary class]]) {
        NSString *key = [self.keysArray objectAtIndex:indexPath.section];
        if ([[self.episodeItems valueForKey:key] isKindOfClass:[NSArray class]]) {
            NSArray *tmpArray = [self.episodeItems valueForKey:key];
            AJMediaPlayRequest *playRequest = (AJMediaPlayRequest *)(tmpArray)[indexPath.row];
            if (self.streamID && [self.streamID isEqualToString:playRequest.identifier]) {
                return;
            }
            self.streamID = playRequest.identifier;
            [self.tableView reloadData];
            if (self.delegate && [self.delegate respondsToSelector:@selector(episodePickerView:didSelectWithPlayRequest:)]) {
                [self.delegate episodePickerView:self didSelectWithPlayRequest:playRequest];
            }
        }
    }
}

#pragma mark - ScrolleView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([self.episodeItems isKindOfClass:[NSDictionary class]]) {
        if (scrollView == self.tableView) {
            CGFloat sectionHeaderHeight = 21;
            if (scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y >= 0) {
                scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
            } else if (scrollView.contentOffset.y >= sectionHeaderHeight) {
                scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
            }
        }
    }
}

@end
