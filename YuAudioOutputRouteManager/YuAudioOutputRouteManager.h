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
@end

