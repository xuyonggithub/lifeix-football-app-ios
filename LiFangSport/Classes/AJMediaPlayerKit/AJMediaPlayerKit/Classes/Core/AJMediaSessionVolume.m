//
//  MediaSessionVolume.h
//  Pods
//
//  Created by le_cui on 15/4/6.
//
//

#import "AJMediaSessionVolume.h"
@import AVFoundation;
#import "AJFoundation.h"

NSString * const kMediaAudioSessionRouteDidChangeNotificationName = @"kMediaAudioSessionRouteDidChangeNotification";
NSString * const kMediaAudioSessionVolumeDidChangeNotificationName = @"kMediaAudioSessionVolumeDidChangeNotification";

//中断处理
void interruptionListenerCallback (
                                   void    *inUserData,                                                // 1
                                   UInt32  interruptionState                                           // 2
                                   ) 
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    if (interruptionState == kAudioSessionBeginInterruption) {
          AudioSessionSetActive (false);
        
        
    } else if (interruptionState == kAudioSessionEndInterruption) {
          AudioSessionSetActive (true);
    }
#pragma clang diagnostic pop
}

//音量大小改变
void audioVolumeChangeListenerCallback (
                                        void                      *inUserData,
                                        AudioSessionPropertyID    inID,
                                        UInt32                    inDataSize,
                                        const void                *inData)
{
    
    Float32 newGain = *(Float32 *)inData;
    NSNumber *value = @(newGain);
    [[NSNotificationCenter defaultCenter] postNotificationName:kMediaAudioSessionVolumeDidChangeNotificationName object:value userInfo:@{@"state": value}];
}

//输出设备改变／静音
void audioRouteChangeListenerCallback (
                                       void *inUserData, 
                                       AudioSessionPropertyID inPropertyID, 
                                       UInt32 size, 
                                       const void *inData)  
{  
   /* if (inPropertyID != kAudioSessionProperty_AudioRouteChange) 
        return;  
    BOOL muted = [MediaSessionVolume isMuted];  
    NSNumber *value = [NSNumber numberWithBool:muted];
    [[NSNotificationCenter defaultCenter] postNotificationName:kMediaAudioSessionRouteDidChangeNotificationName object:value userInfo:nil];
    */
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    UInt32 propertySize = sizeof(CFStringRef);
    AudioSessionInitialize(NULL, NULL, NULL, NULL);
    CFStringRef state = nil;
    AudioSessionGetProperty(kAudioSessionProperty_AudioRoute
                            ,&propertySize,&state);
#pragma clang diagnostic pop
    
    NSNumber *value = [NSNumber numberWithBool:1];
    
    NSString* st = (__bridge NSString *)state;
    if ([st isEqualToString:@"Speaker"]) {
        value = [NSNumber numberWithBool:0];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kMediaAudioSessionRouteDidChangeNotificationName object:value userInfo:@{@"state": st}];

     
} 

@implementation AJMediaSessionVolume

+ (instancetype)sharedVolume
{
    static AJMediaSessionVolume *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[AJMediaSessionVolume alloc] init];
    });
    
    return instance;
    
}

+ (BOOL)isMuted  
{  
    CFStringRef route;  
    UInt32 routeSize = sizeof(CFStringRef);  
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    OSStatus status = AudioSessionGetProperty(kAudioSessionProperty_AudioRoute, &routeSize, &route);
#pragma clang diagnostic pop
    if (status == kAudioSessionNoError)  
    {  
        if (route == NULL || !CFStringGetLength(route))  
            return TRUE;  
    }  
    
    return FALSE;  
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        //Your application does not instantiate its audio session. Instead, iOS provides a singleton audio session object to your application, which is available when your application has finished launching.
        //Do this just once, during application launch.
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        AudioSessionInitialize (NULL, NULL, interruptionListenerCallback, NULL);//初始化
        
        UInt32 sessionCategory = kAudioSessionCategory_SoloAmbientSound;
        AudioSessionSetProperty (
                                 kAudioSessionProperty_AudioCategory,
                                 sizeof (sessionCategory),
                                 &sessionCategory
                                 );
        
        AudioSessionAddPropertyListener (
                                         kAudioSessionProperty_CurrentHardwareOutputVolume ,
                                         audioVolumeChangeListenerCallback,
                                         (__bridge void *)(self)
                                         );
          
        
        AudioSessionAddPropertyListener(
                                        kAudioSessionProperty_AudioRouteChange, 
                                        audioRouteChangeListenerCallback, 
                                        (__bridge void *)(self));
             
#pragma clang diagnostic pop
    }
    
    return self;
}

- (void)dealloc
{

}


- (float)volume {
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Wdeprecated-declarations"
        return [MPMusicPlayerController iPodMusicPlayer].volume;
    #pragma clang diagnostic pop
}

- (void)setVolume:(float)newVolume {
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [[MPMusicPlayerController iPodMusicPlayer] setVolume:newVolume];
    #pragma clang diagnostic pop
}

- (void)setShouldMute:(BOOL)shouldMute
{
    //设置是否需要响应系统静音
    /*
     The primary mechanism for expressing audio intentions is to set the audio session category. A category is a key that identifies a set of audio behaviors. By setting the category, you indicate whether your audio should continue when the screen locks, whether you want iPod audio to continue playing along with your audio, and so on.
     
     Six audio session categories, along with a set of override and modifier switches, let you customize audio behavior according to your application’s personality or role. Various categories support playback, recording, playback along with recording, and offline audio processing. When the system knows your app’s audio role, it affords you appropriate access to hardware resources. The system also ensures that other audio on the device behaves in a way that works for your application; for example, if you need iPod audio to be silenced, it is.
     */
    /*
     An audio session comes with some default behavior. Specifically:
     
     Playback is enabled and recording is disabled.
     When the user moves the Silent switch (or Ring/Silent switch on iPhone) to the “silent” position, your audio is silenced.
     When the user presses the Sleep/Wake button to lock the screen, or when the Auto-Lock period expires, your audio is silenced.
     When your audio starts, other audio on the device—such as iPod audio that was already playing—is silenced.
     
     This collection of behavior is encapsulated in, and named by, the AVAudioSessionCategorySoloAmbient audio session category—the default category.
     */
    
    /*
     //Setting the audio session category using the AV Foundation framework
     NSError *setCategoryError = nil;
     [[AVAudioSession sharedInstance]
     setCategory: AVAudioSessionCategoryAmbient
     error: &setCategoryError];
     
     if (setCategoryError) { // handle the error condition  }
    */
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    //Setting the audio session category using Audio Session Services
    if (shouldMute) {
        
        UInt32 sessionCategory = kAudioSessionCategory_SoloAmbientSound;     
        
        AudioSessionSetProperty (
                                 kAudioSessionProperty_AudioCategory,                         
                                 sizeof (sessionCategory),                                    
                                 &sessionCategory                                             
                                 );
    }
    else {
        UInt32 sessionCategory = kAudioSessionCategory_MediaPlayback;     
        
        AudioSessionSetProperty (
                                 kAudioSessionProperty_AudioCategory,                         
                                 sizeof (sessionCategory),                                    
                                 &sessionCategory                                             
                                 );
    }
#pragma clang diagnostic pop
}
@end
