//
//  AJMediaQualityPickerView.m
//  Pods
//
//  Created by Zhangqibin on 8/24/15.
//
//

#import "AJMediaQualityPickerView.h"
#import "AJMediaPlayerUtilities.h"

@interface AJMediaQualityPickerCell : UITableViewCell
@property (nonatomic,strong) UILabel *qualityNameLabel;
@property (nonatomic,strong) UILabel *belowSeperator;
@property (nonatomic,strong) UILabel *aboveSeperator;
@property (nonatomic,assign) AJMediaPlayerAppearenceStyle appearenceStyle;
@end

@implementation AJMediaQualityPickerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withAppearenceStyle:(AJMediaPlayerAppearenceStyle )appearenceStyle{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle =  UITableViewCellSelectionStyleNone;
        self.appearenceStyle = appearenceStyle;
        
        self.qualityNameLabel = [[UILabel alloc] init];
        self.qualityNameLabel.backgroundColor = [UIColor clearColor];
        self.qualityNameLabel.textAlignment = NSTextAlignmentCenter;
        self.qualityNameLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:self.qualityNameLabel];
        
        self.belowSeperator = [[UILabel alloc] init];
        self.belowSeperator.backgroundColor = [UIColor colorWithHTMLColorMark:@"ffffff"];
        self.belowSeperator.alpha = 0.21;
        [self.contentView addSubview:_belowSeperator];
        
        self.aboveSeperator = [[UILabel alloc] init];
        self.aboveSeperator.backgroundColor = [UIColor colorWithHTMLColorMark:@"ffffff"];
        self.aboveSeperator.alpha = 0.21;
        self.aboveSeperator.hidden = YES;
        [self.contentView addSubview:self.aboveSeperator];
    }
    return self;
}

- (void)configCellWithItem:(NSArray *)itemArray atIndexPath:(NSIndexPath *)indexPath {
    if ([itemArray[indexPath.row] isKindOfClass:[AJMediaPlayerItem class]]) {
        AJMediaPlayerItem *item = itemArray[indexPath.row];
        self.aboveSeperator.hidden = !(indexPath.row == 0);
        self.qualityNameLabel.text = [AJMediaPlayerUtilities humanReadableTitleWithQualityName:item.qualityName];
        NSString *currentStreamType = nil;
        if (item.type == AJMediaPlayerLiveStreamItem) {
            currentStreamType = aj_getCurrentUserStreamItem(YES);
        } else {
            currentStreamType = aj_getCurrentUserStreamItem(NO);
        }
        if ([currentStreamType isEqualToString:item.qualityName]) {
            self.qualityNameLabel.textColor = [UIColor colorWithHTMLColorMark:@"29c4c6"];
        } else {
            self.qualityNameLabel.textColor = [UIColor whiteColor];
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    float seperatorline = _appearenceStyle==AJMediaPlayerStyleForiPhone?14:64;
    _qualityNameLabel.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    _aboveSeperator.frame = CGRectMake(seperatorline, 0, self.frame.size.width-(seperatorline*2),  1);
    _belowSeperator.frame = CGRectMake(seperatorline, self.frame.size.height-1, self.frame.size.width-(seperatorline*2),1);
}

@end

@interface  AJMediaQualityPickerView() <UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong) UITableView *tableView;

@end

@implementation AJMediaQualityPickerView

- (instancetype)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.backgroundColor  = [UIColor colorWithPatternImage:[UIImage imageNamed:@"player_landscape_stream_bg"]];
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        [self addSubview:_tableView];
    }
    return self;
}

- (void)setQualifiedItems:(NSArray *)qualifiedItems {
    self.tableView.frame = CGRectMake(10, 0, self.frame.size.width-20, self.frame.size.height);
    _qualifiedItems = qualifiedItems;
    [self.tableView reloadData];
}

#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 1 ? [self.qualifiedItems count] : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        AJMediaQualityPickerCell *streamsCell = (AJMediaQualityPickerCell*)[tableView dequeueReusableCellWithIdentifier:@"StreamsCell"];
        if (!streamsCell) {
            streamsCell = [[AJMediaQualityPickerCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"StreamsCell" withAppearenceStyle:_appearenceStyle];
        }
        [streamsCell configCellWithItem:_qualifiedItems atIndexPath:indexPath];
        return streamsCell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EmptyCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"EmptyCell"];
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    float qualityPickerCellHeight = _appearenceStyle==AJMediaPlayerStyleForiPhone?48:60;
    if (indexPath.section == 1) {
        return qualityPickerCellHeight;
    } else {
        if ((self.frame.size.height - (self.qualifiedItems.count*qualityPickerCellHeight))/2 < 0) {
            return 0;
        }
        return (self.frame.size.height - (self.qualifiedItems.count*qualityPickerCellHeight))/2;
    }
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        AJMediaPlayerItem *item = (AJMediaPlayerItem *)(self.qualifiedItems)[indexPath.row];
        NSString *currentStreamType = nil;
        if (item.type == AJMediaPlayerLiveStreamItem) {
            currentStreamType = aj_getCurrentUserStreamItem(YES);
        } else {
            currentStreamType = aj_getCurrentUserStreamItem(NO);
        }
        if (![currentStreamType isEqualToString:item.qualityName]) {
            if (item.type == AJMediaPlayerLiveStreamItem) {
                aj_setCurrentUserStreamItem(item.qualityName,YES);
            } else {
                aj_setCurrentUserStreamItem(item.qualityName, NO);
            }
            [self.tableView reloadData];
            if (self.delegate && [self.delegate respondsToSelector:@selector(qualityPickerView:didSelectAtIndex:)]){
                [self.delegate qualityPickerView:self didSelectAtIndex:indexPath.row];
            }
        }
    }
}

@end
