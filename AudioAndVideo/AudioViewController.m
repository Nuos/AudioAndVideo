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
@end

@implementation AudioViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"音频播放";
    
    
}

#pragma mark - 录音
- (IBAction)recordStart:(id)sender
{
    NSString *dir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filePath = [dir stringByAppendingPathComponent:@"record123.caf"]; // 可以无后缀
    NSURL *fileUrl = [NSURL URLWithString:filePath];
    
    self.audioRecorder = [[AVAudioRecorder alloc] initWithURL:fileUrl settings:nil error:nil];
    [self.audioRecorder prepareToRecord];
    
    // 开始录音
    [self.audioRecorder record];
}

- (IBAction)recordStop:(id)sender
{
//    [self.audioRecorder pause];
    [self.audioRecorder stop];
}

#pragma mark - 播放系统声音
- (IBAction)soundStart:(id)sender
{
    
}

#pragma mark - 播放本地声音
- (IBAction)playLocalMusic:(id)sender
{
    
}

- (IBAction)stopLocalMusic:(id)sender
{
}

#pragma mark - 播放远程声音
- (IBAction)playRemoteMusic:(id)sender
{
}

- (IBAction)stopRemoteMusic:(id)sender
{
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
