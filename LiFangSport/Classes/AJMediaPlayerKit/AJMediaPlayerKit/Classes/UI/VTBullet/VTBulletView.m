//
//  VTBulletView.m
//  VTBulletDemo
//
//  Created by Zhangqibin on 2/22/16.
//  Copyright © 2016 Zhangqibin. All rights reserved.
//

#import "VTBulletView.h"
#import "VTBulletLabel.h"

#define iOS_VERSION_GREATER_THAN_OR_EQUAL(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define iOS7_OR_LATRE (iOS_VERSION_GREATER_THAN_OR_EQUAL(@"7.0"))

typedef struct {
    unsigned int dataSourceItem : 1;
} VTBulletFlags;

@interface VTBulletView()

@property (nonatomic, strong) NSArray *trackList;
@property (nonatomic, strong) NSMutableArray *bufferList;
@property (nonatomic, strong) NSMutableArray *visibleBullets;
@property (nonatomic, strong) NSTimer *bulletTimer;
@property (nonatomic, assign) VTBulletFlags bulletFlags;

@end

@implementation VTBulletView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _bulletDuration = 8.f;
        _bufferInterval = 0.1f;
        _bufferList = [[NSMutableArray alloc] init];
        _visibleBullets = [[NSMutableArray alloc] init];
        [self setTrackCount:6];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat height = CGRectGetHeight(self.frame)/_trackCount;
    for (VTBulletTrack *track in _trackList) {
        track.position = CGPointMake(0, height * track.trackIndex);
        track.height = height;
    }
}

#pragma mark - public method
- (void)start
{
    _state = VTBulletStateOpened;
}

- (void)pause
{
    _state = VTBulletStatePaused;
    for (VTBulletModel *bullet in _visibleBullets.objectEnumerator) {
        CALayer *layer = bullet.bulletItem.layer;
        CGRect rect = bullet.bulletItem.frame;
        if (layer.presentationLayer) {
            rect = ((CALayer *)layer.presentationLayer).frame;
            rect.origin.x -= 1;
        }
        bullet.bulletItem.frame = rect;
        [bullet.bulletItem.layer removeAllAnimations];
    }
}

- (void)resume
{
    _state = VTBulletStateOpened;
}

- (void)stop
{
    _state = VTBulletStateStoped;
}

- (void)clearBuffer
{
    [self invalidTimer];
    [_bufferList removeAllObjects];
}

- (void)shootBullet:(VTBulletModel *)bullet
{
    if (!bullet) return;
    VTBulletTrack *track = [self fetchAvailableTrack];
    track.isLocked = YES;
    if (!track) {
        [_bufferList addObject:bullet];
        [self bulletTimer];
        return;
    }
    
    __block UIView *singleBullet = [self creatBullet:bullet track:track];
    [self addSubview:singleBullet];
    CGFloat bulletWidth = singleBullet.frame.size.width;
    CGFloat speed = CGRectGetWidth(self.frame)/_bulletDuration;
    CGFloat duration = _bulletDuration + bulletWidth/speed;
    [UIView animateWithDuration:duration animations:^{
        CGRect frame = singleBullet.frame;
        frame.origin.x = -CGRectGetWidth(frame);
        singleBullet.frame = frame;
    } completion:^(BOOL finished) {
        [singleBullet removeFromSuperview];
        singleBullet = nil;
    }];
    
    CGFloat offset = _bulletDuration/50.0;
    CGFloat delayTime = duration - _bulletDuration + offset;
    [self performSelector:@selector(unlockBulletTrack:) withObject:track afterDelay:delayTime];
}

#pragma mark - creat bullet label
- (UIView *)creatBullet:(VTBulletModel *)bullet track:(VTBulletTrack *)track
{
    UIView *singleBullet = nil;
    if (_bulletFlags.dataSourceItem) {
        singleBullet = [_dataSource bulletView:self itemForModel:bullet];
    } else {
        singleBullet = [[VTBulletLabel alloc] init];
        [(VTBulletLabel *)singleBullet setBullet:bullet];
    }
    
    if (CGRectIsEmpty(singleBullet.frame)) {
        CGSize constrainedSize = CGSizeMake(10000, 20);
        CGSize size = [self bulletSize:bullet constrainedToSize:constrainedSize lineBreakMode:NSLineBreakByWordWrapping];
        singleBullet.frame = (CGRect){CGPointZero, size};
    }
    CGRect frame = singleBullet.frame;
    frame.origin.x = CGRectGetWidth(self.frame);
    frame.origin.y = track.position.y + (track.height - frame.size.height)/2;
    singleBullet.frame = frame;
    return singleBullet;
}

- (CGSize)bulletSize:(VTBulletModel *)bullet constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)mode
{
    NSAssert(bullet.font != nil, @"the font of bullet:%@ couldn't be nil!", bullet);
    CGSize bulletSize = CGSizeZero;
    if (iOS7_OR_LATRE) {
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.lineBreakMode = mode;
        CGRect rect = [bullet.message boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: bullet.font, NSParagraphStyleAttributeName:style} context:nil];
        bulletSize = rect.size;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        bulletSize =[bullet.message sizeWithFont:bullet.font constrainedToSize:size lineBreakMode:mode];
#pragma clang diagnostic pop
    }
    return bulletSize;
}

#pragma mark lock/unlock track
- (VTBulletTrack *)fetchAvailableTrack
{
    VTBulletTrack *track = nil;
    for (VTBulletTrack *aTrack in _trackList) {
        if (![aTrack isLocked]) {
            track = aTrack;
            break;
        }
    }
    return track;
}

- (void)unlockBulletTrack:(VTBulletTrack *)track
{
    track.isLocked = NO;
}

#pragma mark - buffer bullet
- (void)shootBufferBullet
{
    while ([self fetchAvailableTrack]) {
        VTBulletModel *bullet = [_bufferList firstObject];
        [_bufferList removeObject:bullet];
        [self shootBullet:bullet];
        if (!_bufferList.count) {
            [self invalidTimer];
            break;
        }
    }
}

- (void)invalidTimer
{
    if (!_bulletTimer) return;
    [_bulletTimer invalidate];
    _bulletTimer = nil;
}

#pragma mark - accessors
- (void)setTrackCount:(NSInteger)trackCount
{
    _trackCount = trackCount;
    CGFloat height = CGRectGetHeight(self.frame)/trackCount;
    NSMutableArray *trackList = [[NSMutableArray alloc] initWithCapacity:trackCount];
    for (NSInteger index = 0; index < trackCount; index++) {
        VTBulletTrack *track = [[VTBulletTrack alloc] init];
        track.position = CGPointMake(0, height * index);
        track.trackIndex = index;
        track.height = height;
        [trackList addObject:track];
    }
    _trackList = [NSArray arrayWithArray:trackList];
}

- (void)setDataSource:(id<VTBulletViewDataSource>)dataSource
{
    _dataSource = dataSource;
    _bulletFlags.dataSourceItem = [dataSource respondsToSelector:@selector(bulletView:itemForModel:)];
}

- (NSTimer *)bulletTimer
{
    if (!_bulletTimer) {
        _bulletTimer = [NSTimer scheduledTimerWithTimeInterval:_bufferInterval
                                                        target:self
                                                      selector:@selector(shootBufferBullet)
                                                      userInfo:nil
                                                       repeats:YES];
    }
    return _bulletTimer;
}

@end
