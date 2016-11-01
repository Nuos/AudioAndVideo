//
//  VideoViewController.m
//  AudioAndVideo
//
//  Created by yxhe on 16/10/31.
//  Copyright © 2016年 tashaxing. All rights reserved.
//

#import "VideoViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface VideoViewController ()
@property (nonatomic, strong) MPMoviePlayerController *mpPlayer;
@property (nonatomic, strong) AVPlayer *avPalyer;
@end

@implementation VideoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"视频播放";
}

// 懒加载
- (MPMoviePlayerController *)mpPlayer
{
    if (!_mpPlayer)
    {
        // 1.获取视频的URL
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"zhuxian1.mov" withExtension:nil];
        
        // 2.创建控制器
        _mpPlayer = [[MPMoviePlayerController alloc] initWithContentURL:url];
        
        // 3.设置控制器的View的位置
        _mpPlayer.view.frame = CGRectMake(0, 130, self.view.bounds.size.width, self.view.bounds.size.width * 9 / 16);
        
        // 4.将View添加到控制器上
        [self.view addSubview:_mpPlayer.view];
        
        // 5.设置属性
        _mpPlayer.controlStyle = MPMovieControlStyleDefault;
    }
    return _mpPlayer;
}

// 播放本地
- (IBAction)playLocal:(id)sender
{
    [self.mpPlayer play];
}
- (IBAction)pauseLocal:(id)sender
{
    [self.mpPlayer pause];
}

- (AVPlayer *)avPalyer
{
    if (!_avPalyer)
    {
        // 1.获取URL(远程/本地)
        NSURL *url = [NSURL URLWithString:@"http://v1.mukewang.com/a45016f4-08d6-4277-abe6-bcfd5244c201/L.mp4"];
        
        // 2.创建AVPlayerItem
        AVPlayerItem *item = [AVPlayerItem playerItemWithURL:url];
        
        // 3.创建AVPlayer
        _avPalyer = [AVPlayer playerWithPlayerItem:item];
        
        // 4.添加AVPlayerLayer
        AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:self.avPalyer];
        layer.frame = CGRectMake(0, 400, self.view.bounds.size.width, self.view.bounds.size.width * 9 / 16);
        [self.view.layer addSublayer:layer];
    }
    return _avPalyer;
}

// 播放远程
- (IBAction)playRemote:(id)sender
{
    [self.avPalyer play];
}
- (IBAction)pauseRemote:(id)sender
{
    [self.avPalyer pause];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
