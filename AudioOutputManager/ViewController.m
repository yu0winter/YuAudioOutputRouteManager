//
//  ViewController.m
//  AudioOutputManager
//
//  Created by NiuYulong on 2017/3/1.
//  Copyright © 2017年 牛玉龙. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "YuAudioOutputRouteManager.h"

@interface ViewController () <AVAudioPlayerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (nonatomic, strong) AVAudioPlayer *player;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (IBAction)playAction:(UIButton *)sender {
    
    sender.enabled = NO;
    
    [self.player prepareToPlay];
    [self.player play];
    //  开始监听音频输出源的变化
    [[YuAudioOutputRouteManager sharedManager] startObserveAudioOutputRouteChange];
    //  打断其他app播放音乐
    //  设定音频行为Playback
    [[YuAudioOutputRouteManager sharedManager] startAudioPlayWithCategoryPlayback];
}

- (IBAction)stopAction:(id)sender {
    [self audioPlayerDidFinishPlaying:self.player successfully:YES];
}

- (AVAudioPlayer *)player {
    if (_player)return _player;
    
    // 取出资源的URL
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"clock.m4a" withExtension:nil];
    
    // 创建播放器
    NSError *error = nil;
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    
    player.delegate = self;
    player = player;
    [player prepareToPlay];
    
    _player = player;
    return _player;
}
#pragma mark └ AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    
    self.playBtn.enabled = YES;
    [self.player stop];
    //  结束监听音频输出源的变化
    [[YuAudioOutputRouteManager sharedManager] stopObserveAudioOutputRouteChange];
    //  回复之前打断播放事件
    //  关闭当前音频行为，并且向系统发送通知（使被打断的播放继续）
    [[YuAudioOutputRouteManager sharedManager] stopAudioPlayWithNotifyOthersOnDeactivation];
    
}

@end
