//
//  YuAudioOutputRouteManager.h
//  AudioOutputManager
//
//  Created by NiuYulong on 2017/3/1.
//  Copyright © 2017年 牛玉龙. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YuAudioOutputRouteManager : NSObject
+ (instancetype)sharedManager;
/*
 *  开始监听音频输出源的变化
 */
- (void)startObserveAudioOutputRouteChange;
/*
 *  结束监听音频输出源的变化
 */
- (void)stopObserveAudioOutputRouteChange;
/*
 *  设定音频行为Playback
 *  是否会被静音键或锁屏键静音:否
 *  是否打断不支持混音播放的应用:是
 *  是否允许音频输入/输出：只输出
 */
- (void)startAudioPlayWithCategoryPlayback;
/*
 *  关闭当前音频行为，并且向系统发送通知（使被打断的播放继续）
 */
- (void)stopAudioPlayWithNotifyOthersOnDeactivation;
@end

