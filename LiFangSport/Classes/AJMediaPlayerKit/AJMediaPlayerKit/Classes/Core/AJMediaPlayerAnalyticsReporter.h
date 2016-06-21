//
//  AJMediaPlayerAnalyticsReporter.h
//  Pods
//
//  Created by Gang Li on 6/9/15.
//
//

@import Foundation;

///\defgroup AJMediaPlayerAnalyticsReporter MediaPlayer Analytics Event Reporter
///@{

///\ingroup AJMediaPlayerAnalyticsEventType
///\ref <a href="http://wiki.letv.cn/pages/viewpage.action?pageId=24309068" />

typedef NS_ENUM(NSInteger, AJMediaPlayerAnalyticsEventType) {
    AJMediaPlayerLaunch,
    AJMediaPlayerInitializing,  //初始化
    AJMediaPlayerStartLoading,  //加载
    AJMediaPlayerDidPlay,       //播放
    AJMediaPlayerHeartbeat,     //心跳
    AJMediaPlayerDidBlock,      //缓冲
    AJMediaPlayerDidFinishBlock,//缓冲完成
    AJMediaPlayerDidPause,
    AJMediaPlayerDidStop,
    AJMediaPlayerDidFinish,     //播放完成
    AJMediaPlayerDidInvalidate, //播放退出
    AJMediaPlayerDidFirstFrameAppears,
    AJMediaPlayerDidSeek,
    AJMediaPlayerSwitchStreamQuality  //切换码流
};
/// Event details definition, we will use the unreformed property name in order to reduce the complexities while convert instance to a dictionary required by web API
@interface AJMediaPlayerEventDetails : NSObject
@property(nonatomic, assign) NSInteger pt; ///播放时长，秒
@property(nonatomic, assign) NSInteger ut; ///动作耗时，毫秒
@property(nonatomic, copy) NSString *uid; ///乐视网用户注册ID
@property(nonatomic, copy) NSString *auid; ///标识设备的唯一ID \ref http://wiki.letv.cn/pages/viewpage.action?pageId=29330888
@property(nonatomic, copy) NSString *uuid; ///一次播放过程，播放器生成唯一的UUID, 如果一次播放过程出现了切换码率，那么uuid的后缀加1
@property(nonatomic, copy) NSString *vid, *pid, *zid, *lid;
@property(nonatomic, assign) int cid;
@property(nonatomic, copy) NSString *episodeid;
@property(nonatomic, assign) NSInteger vlen; ///视频时长
@property(nonatomic, copy) NSString *ch; ///渠道号
@property(nonatomic, assign) int ry; ///重试次数，从0开始 比如 第一次失败，第二次成功，那么只有在第二次上报，其中ry=1 如果第一次即成功，那么ry=0
@property(nonatomic, assign) int ty; /// 播放类型 \ref http://wiki.letv.cn/pages/viewpage.action?pageId=24309061
@property(nonatomic, copy) NSString *vt; ///视频类型 \ref http://wiki.letv.cn/pages/viewpage.action?pageId=24309065
@property(nonatomic, copy) NSString *url; ///视频播放地址, 需要url encoding
@property(nonatomic, copy) NSString *ref; ///播放页来源地址,需要url encoding
@property(nonatomic, copy) NSString *pv; ///播放器版本
@property(nonatomic, copy) NSString *py; ///播放属性,形式如:k1=v1&k2=v2...需要url encoding
@property(nonatomic, copy) NSString *st; ///Station 轮播台，轮播时必填
@property(nonatomic, assign) int ilu; ///是否登录用户, 0是登陆用户,1非登陆用户
@property(nonatomic, copy) NSString *pcode; ///\ref http://wiki.letv.cn/pages/viewpage.action?pageId=24309058
//@property(nonatomic, copy) NSString *weid; ///上报时获取js生成的页面 \deprecated only available for website
@property(nonatomic, copy) NSString *prg; /// 用户上报动作时视频时间轴上的时间点，例如：用户看到视频的第5分钟时，上报了time动作，此时prg=300     单位为秒  如果动作发生在视频时间轴的0点之前，此值可以为0
@property(nonatomic, copy) NSString *nt; ///上网类型 http://wiki.letv.cn/pages/viewpage.action?pageId=41199532
@property(nonatomic, copy) NSString *stc; ///stage time-consuming 每个阶段时长单位：毫秒。必须进行URL编码，例如：上报值为mr=10&uc=11&cn=12 编码之后变为mr%3d10%26uc%3d11%26cn%3d12，则上报内容为：stc=mr%3d10%26uc%3d11%26cn%3d12 \ref http://wiki.letv.cn/pages/viewpage.action?pageId=41199343 \ref http://wiki.letv.cn/pages/viewpage.action?pageId=41199269
@property(nonatomic, assign) int prl; ///预加载，ac=play时必须上报，其他不上报，0-未预加载，1-预加载
@property(nonatomic, copy) NSString *cdev; /// CDE版本号 ac=init时上报，其他不上报
@property(nonatomic, copy) NSString *caid; /// CDE App ID：cde为每个app指定的唯一ID ac=init时必须上报，其他不上报
@property(nonatomic, assign) long ctime; ///时间戳，单位 毫秒, 1423793629851表示2015/2/13 10:13:49.851
@property(nonatomic, assign) int pay; /// 是否收费 0:免费 1：收费 ac=play时上报
@property(nonatomic, assign) int joint; /// 是否拼接广告 0：无广告 1：有广告已拼接 2：有广告未拼接 ac=play时上报
@property(nonatomic, assign) int ipt; /// 起播类型 0：直接点播 1：连播 2：切换码流
@property(nonatomic, copy) NSString *apprunid; /// app_run_id：每次启动时生成的唯一标识
@property (nonatomic, copy) NSString *ver;  ///日志版本号


/**
 *  env 新增参数
 */
@property (nonatomic, copy)NSString *mac;   //标识设备的全球唯一id
@property (nonatomic, copy)NSString *os;
@property (nonatomic, copy)NSString *osv;
@property (nonatomic, copy)NSString *app;
@property (nonatomic, copy)NSString *bd;
@property (nonatomic, copy)NSString *xh;
@property (nonatomic, copy)NSString *ro;
@property (nonatomic, copy)NSString *src;
@property (nonatomic, copy)NSString *ep;
@property (nonatomic, copy)NSString *r;
@property (nonatomic, copy)NSString *cs;
@property (nonatomic, copy)NSString *ssid;
@property (nonatomic, copy)NSString *lo;
@property (nonatomic, copy)NSString *la;


-(NSDictionary *)availableDictionaryRepresetation;

@end

typedef void (^AJMediaPlayerAnalyticsReporterFailureCallback)(NSError *);
@interface AJAnalyticsAppMetadata : NSObject
@property(nonatomic, copy) NSString *firstLevelID, *secondLevelID, *thirdLevelID; ///一，二，三级业务线代码 \ref http://wiki.letv.cn/pages/viewpage.action?pageId=24309028
@property(nonatomic, copy) NSString *userID;
+(instancetype)metadata;
@end

@interface AJMediaPlayerAnalyticsReporter : NSObject
@property(nonatomic, copy)AJMediaPlayerAnalyticsReporterFailureCallback failureHandler;
+(instancetype)sharedReporter;
-(void)registerWithMetadata:(AJAnalyticsAppMetadata *)appMetadata;
- (AJAnalyticsAppMetadata *)shareAppMetadata;
/// Generic method to report events
-(void)sendPlayerEvent:(AJMediaPlayerAnalyticsEventType)eventType parameters:(NSDictionary *)parameters;

/// Convenient methods to report fined events

- (NSString*)getCurrentNetStatus;

#pragma mark - play
-(void)playerDidFinishLaunchingWithDetails:(AJMediaPlayerEventDetails *) details;
-(void)playerWillInitializeWithDetails:(AJMediaPlayerEventDetails *) details;
-(void)playerDidBeginToPlayWithDetails:(AJMediaPlayerEventDetails *) details;
-(void)playerDidBecomeBlockedWithDetails:(AJMediaPlayerEventDetails *) details;
-(void)playerDidFinishBlockedWithDetails:(AJMediaPlayerEventDetails *) details;
-(void)playerDidFinishPlayWithDetails:(AJMediaPlayerEventDetails *) details;
-(void)playerDidInterruptWithDetails:(AJMediaPlayerEventDetails *)details;
-(void)playerDidToggleSwitchStreamQualityWithDetails:(AJMediaPlayerEventDetails *) details;
-(void)playerDidFinishSeekWithDetails:(AJMediaPlayerEventDetails *) details;
-(void)playerDidFireHeartbeatWithPlayDuration:(NSTimeInterval)duration details:(AJMediaPlayerEventDetails *) details;
#pragma mark - env
-(void)applicationSubmitEnvWithDetails:(AJMediaPlayerEventDetails *)details;

@end

///@}
