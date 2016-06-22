//
//  AJMediaPlayerRemoteDisplay.m
//  Pods
//
//  Created by Zhangqibin on 5/22/15.
//
//

#import "AJMediaPlayerRemoteDisplay.h"

@interface AJMediaPlayerRemoteDisplay ()
@end

@implementation AJMediaPlayerRemoteDisplay {
    id __mediaplayerStateObserver;
}

- (BOOL)isConnected {return NO;}
- (void)setup {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateState) name:UIScreenDidConnectNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateState) name:UIScreenDidDisconnectNotification object:nil];
    
    [self updateState];
}
- (void)activate:(AJMediaPlayer *)player {
    _player = player;
    _player.remoteDisplay = self;
    __mediaplayerStateObserver = [[NSNotificationCenter defaultCenter] addObserverForName:AJMediaPlayerStateChangedNotificationName object:nil queue:nil usingBlock:^(NSNotification *note) {
        AJMediaPlayerState oldState = (AJMediaPlayerState)[[note.userInfo valueForKeyPath:@"oldState"] intValue];
        AJMediaPlayerState newState = (AJMediaPlayerState)[[note.userInfo valueForKeyPath:@"newState"] intValue];
        [self changePlayerStateFrom:oldState to:newState];
    }];
}
- (void)deactivate {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (__mediaplayerStateObserver) {
        [[NSNotificationCenter defaultCenter] removeObserver:__mediaplayerStateObserver name:AJMediaPlayerStateChangedNotificationName object:nil];
    }
}

- (NSString*)deviceName {return nil;}
- (void)changePlayerStateFrom:(AJMediaPlayerState)oldState to:(AJMediaPlayerState)newState {
}

- (void)updateState {
    if ([UIScreen screens].count > 1) {
        self.currentState = AJMediaPlayerRemoteDisplayStateConnected;
    } else {
        self.currentState = AJMediaPlayerRemoteDisplayStateDisconnected;
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end