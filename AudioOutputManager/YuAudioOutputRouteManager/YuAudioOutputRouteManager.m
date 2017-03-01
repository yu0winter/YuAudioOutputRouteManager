//
//  YuAudioOutputRouteManager.m
//  AudioOutputManager
//
//  Created by NiuYulong on 2017/3/1.
//  Copyright © 2017年 牛玉龙. All rights reserved.
//

#import "YuAudioOutputRouteManager.h"
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@implementation YuAudioOutputRouteManager

static id sharedManager = nil;

+ (instancetype)sharedManager
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedManager = [[self alloc]init];
    });
    return sharedManager;
}

- (void)startObserveAudioOutputRouteChange {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(audioSessionRouteChange:)
                                                 name:AVAudioSessionRouteChangeNotification
                                               object:nil];
    
    [self audioSessionRouteChange:nil];
}

- (void)stopObserveAudioOutputRouteChange {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self endProximityMonitoring];
}

- (void)audioSessionRouteChange:(NSNotification *)notification {
    
    if ([self isSpeakerPlugging] == NO) {
        [self startProximityMonitoring];
        [self sensorStateChange:nil];
    } else {
        [self endProximityMonitoring];
    }
}

- (BOOL)isSpeakerPlugging {
    AVAudioSessionRouteDescription* route = [[AVAudioSession sharedInstance] currentRoute];
    for (AVAudioSessionPortDescription* desc in [route outputs]) {
        
        NSString *portType = [desc portType];
        if ([portType isEqualToString:AVAudioSessionPortBuiltInReceiver]) {
            return NO;
        }
        
        if ([portType isEqualToString:AVAudioSessionPortBuiltInSpeaker]) {
            return NO;
        }
    }
    return YES;
}

#pragma mark └ ProximityMonitoring 红外线距离传感器监听
- (void)startProximityMonitoring {
    
    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES]; //建议在播放之前设置yes，播放结束设置NO，这个功能是开启红外感应
    
    if ([UIDevice currentDevice].proximityMonitoringEnabled == NO) {
        NSLog(@"设置完后还是NO的读话，说明当前设备没有近距离传感器");
        return;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(sensorStateChange:)
                                                 name:UIDeviceProximityStateDidChangeNotification
                                               object:nil];
}

- (void)endProximityMonitoring {
    
    if ([UIDevice currentDevice].proximityMonitoringEnabled == YES) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceProximityStateDidChangeNotification object:nil];
        [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
    }
}

//处理监听触发事件
- (void)sensorStateChange:(NSNotification *)notification;
{
    // 如果正在使用外放扬声器不处理。
    if ([self isSpeakerPlugging]) {
        return;
    }
    
    //如果此时手机靠近面部放在耳朵旁，那么声音将通过听筒输出，并将屏幕变暗（省电啊）
    if ([[UIDevice currentDevice] proximityState] == YES)
    {
        NSLog(@"Device is close to user");
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    }
    else
    {
        NSLog(@"Device is not close to user");
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    }
}

#pragma mark └ AVAudioSessionCategory 设定音频行为
- (void)startAudioPlayWithCategoryPlayback {
    
    NSError *error;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error];
    [[AVAudioSession sharedInstance] setActive:YES error:&error];
    
    if (error) {
        NSLog(@"%s error:%@",__func__,error.userInfo);
    }
}

- (void)stopAudioPlayWithNotifyOthersOnDeactivation {
    
    NSError *error;
    [[AVAudioSession sharedInstance] setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:&error];
    if (error) {
        NSLog(@"%s error:%@",__func__,error.userInfo);
    }
}

@end
