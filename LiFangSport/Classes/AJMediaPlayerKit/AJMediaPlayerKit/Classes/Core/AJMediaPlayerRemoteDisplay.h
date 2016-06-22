//
//  AJMediaPlayerRemoteDisplay.h
//  Pods
//
//  Created by Zhangqibin on 5/22/15.
//
//

@import Foundation;
@import UIKit;

#import "AJMediaPlayer.h"

typedef NS_ENUM(NSInteger, AJMediaPlayerRemoteDisplayState) {
    AJMediaPlayerRemoteDisplayStateDisconnected = -1,
    AJMediaPlayerRemoteDisplayStateConnected = 0,
    AJMediaPlayerRemoteDisplayStateActive = 1
};

@protocol AJMediaPlayerRemoteDisplayable <NSObject>
@property(nonatomic, assign) AJMediaPlayerRemoteDisplayState currentState;
- (void)setup;
- (void)activate:(AJMediaPlayer *)player;
- (void)deactivate;
- (NSString*)deviceName;
- (void)changePlayerStateFrom:(AJMediaPlayerState)oldState to:(AJMediaPlayerState)newState;
@end

@interface AJMediaPlayerRemoteDisplay : NSObject <AJMediaPlayerRemoteDisplayable>
@property(nonatomic, assign) AJMediaPlayerRemoteDisplayState currentState;
@property(nonatomic, strong) UIWindow *window;
@property(nonatomic, strong) UIView *remoteView;
@property(nonatomic, weak, readonly) AJMediaPlayer *player;

@end
