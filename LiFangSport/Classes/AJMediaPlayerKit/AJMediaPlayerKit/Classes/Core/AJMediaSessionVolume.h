//
//  MediaSessionVolume.h
//  Pods
//
//  Created by Zhangqibin on 15/4/6.
//
//

@import Foundation;
#import <AudioToolbox/AudioToolbox.h>
#import <MediaPlayer/MediaPlayer.h>

extern NSString * const kMediaAudioSessionRouteDidChangeNotificationName;
extern NSString * const kMediaAudioSessionVolumeDidChangeNotificationName;

@interface AJMediaSessionVolume : NSObject

+ (AJMediaSessionVolume *)sharedVolume;
+ (BOOL)isMuted;
@property (NS_NONATOMIC_IOSONLY) float volume ;
- (void)setShouldMute:(BOOL)shouldMute;
@end