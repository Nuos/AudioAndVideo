//
//  AudioViewController.m
//  AudioAndVideo
//
//  Created by yxhe on 16/10/31.
//  Copyright © 2016年 tashaxing. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "AudioViewController.h"

@interface AudioViewController ()
@property (nonatomic, strong) AVAudioRecorder *audioRecorder; // 录音机
@property (nonatomic, strong) AVAudioPlayer *localAudioPlayer; // 本地播放器
@property (nonatomic, strong) AVPlayer *audioPlayer; // 全功能播放器
@end

@implementation AudioViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"音频播放";

    // 录音
    NSString *recordDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *recordFilePath = [recordDir stringByAppendingPathComponent:@"record123.caf"]; // 可以无后缀或者别的格式
    NSURL *recordFileUrl = [NSURL URLWithString:recordFilePath];
    self.audioRecorder = [[AVAudioRecorder alloc] initWithURL:recordFileUrl settings:nil error:nil];
    [self.audioRecorder prepareToRecord];
    
    // 本地声音
    // 一个player只能对应一个url，无法更换的
    NSURL *localMusicUrl = [[NSBundle mainBundle] URLForResource:@"张韶涵 - 欧若拉.mp3" withExtension:nil];
    self.localAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:localMusicUrl error:nil];
    [self.localAudioPlayer prepareToPlay];
    
    // 远程声音
    // 从某院校网站拿到的未加密流媒体音乐网址
    NSURL *remoteMusicUrl = [NSURL URLWithString:@"http://202.204.208.83/gangqin/download/music/02/03/02/Track08.mp3"];
    // 创建item(可以通过替换item来替换播放文件，而不用重新加layer)
    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:remoteMusicUrl];
    // 创建播放器
    self.audioPlayer = [AVPlayer playerWithPlayerItem:item];
    // 添加layer
    AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:self.audioPlayer];
    layer.frame = CGRectMake(0, self.view.frame.size.height - 200, self.view.frame.size.width, 200);
    
    [self.view.layer addSublayer:layer];
    
    // 耳机拔掉暂停监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(audioRouteChange:)
                                                 name:AVAudioSessionRouteChangeNotification object:nil];
    // 处理中断事件
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleInterreption:)
                                                 name:AVAudioSessionInterruptionNotification
                                               object:[AVAudioSession sharedInstance]];
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVAudioSessionRouteChangeNotification object:nil];
}

#pragma mark - 音轨变化监听
- (void)audioRouteChange:(NSNotification *)notification
{
    // 拿到描述文件
    NSDictionary *dict = notification.userInfo;
    int changeReason= [dict[AVAudioSessionRouteChangeReasonKey] intValue];
    // 旧的音频设备不可用了，说明拔掉了耳机
    if (changeReason == AVAudioSessionRouteChangeReasonOldDeviceUnavailable)
    {
        AVAudioSessionRouteDescription *routeDescription=dict[AVAudioSessionRouteChangePreviousRouteKey];
        AVAudioSessionPortDescription *portDescription= [routeDescription.outputs firstObject];
        if ([portDescription.portType isEqualToString:@"Headphones"])
        {
            [self.localAudioPlayer pause];
        }
    }
}

#pragma mark - 中断控制
- (void)handleInterreption:(NSNotification *)notification
{
    NSDictionary *interruptionDictionary = notification.userInfo;
    AVAudioSessionInterruptionType type = [interruptionDictionary [AVAudioSessionInterruptionTypeKey] unsignedIntegerValue];
    switch (type)
    {
        case AVAudioSessionInterruptionTypeBegan:
            [self.localAudioPlayer pause];
            break;
        case AVAudioSessionInterruptionTypeEnded:
            [self.localAudioPlayer play];
            break;
        default:
            break;
    }
}

#pragma mark - 远程控制/锁屏控制/控制中心控制
- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    // 重写这个函数实现后台播放控制
    switch (event.subtype)
    {
        case UIEventSubtypeRemoteControlPlay:
            // 播放
            [self.localAudioPlayer play];
            break;
        case UIEventSubtypeRemoteControlPause:
            // 暂停
            [self.localAudioPlayer pause];
            break;
        case UIEventSubtypeRemoteControlNextTrack:
            // 下一曲
            break;
        case UIEventSubtypeRemoteControlPreviousTrack:
            // 上一曲
            break;
        default:
            break;
    }
}

#pragma mark - 录音
- (IBAction)recordStart:(id)sender
{
    // 开始录音
    [self.audioRecorder record];
}

- (IBAction)recordStop:(id)sender
{
//    [self.audioRecorder pause];
    // 录音完成存入文件，可以用后面的方式播放出来
    [self.audioRecorder stop];
}

#pragma mark - 播放系统声音
- (IBAction)soundStart:(id)sender
{
    // 创建音效ID,加载资源
    SystemSoundID soundID = 0;
    
    NSURL *soundUrl = [[NSBundle mainBundle] URLForResource:@"pair.wav" withExtension:nil];
    CFURLRef soundUrlRef = (__bridge CFURLRef)(soundUrl);
    AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)(soundUrl), &soundID);
    
    // 播放音效
//    AudioServicesPlaySystemSound(soundID); // 不震动
    AudioServicesPlayAlertSound(soundID);  // 有震动
}

#pragma mark - 播放本地声音
- (IBAction)playLocalMusic:(id)sender
{
    // 开始播放
    [self.localAudioPlayer play];
}

- (IBAction)stopLocalMusic:(id)sender
{
    [self.localAudioPlayer pause];
//    [self.localAudioPlayer stop];
}

#pragma mark - 播放远程声音
- (IBAction)playRemoteMusic:(id)sender
{
    [self.audioPlayer play];
    
}

- (IBAction)stopRemoteMusic:(id)sender
{
    [self.audioPlayer pause];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
