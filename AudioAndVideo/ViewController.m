//
//  ViewController.m
//  AudioAndVideo
//
//  Created by yxhe on 16/10/28.
//  Copyright © 2016年 tashaxing. All rights reserved.
//

// ---- 音频和视频播放测试 ---- //

#import "ViewController.h"
#import "AudioViewController.h"
#import "VideoViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"主页";
}

- (IBAction)audioBtn:(id)sender
{
    AudioViewController *audioVC = [[AudioViewController alloc] init];
    [self.navigationController pushViewController:audioVC animated:YES];
}

- (IBAction)videoBtn:(id)sender
{
    VideoViewController *videoVC = [[VideoViewController alloc] init];
    [self.navigationController pushViewController:videoVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
