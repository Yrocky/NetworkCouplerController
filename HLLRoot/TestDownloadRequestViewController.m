//
//  TestDownloadRequestViewController.m
//  HLLRoot
//
//  Created by Rocky Young on 16/10/23.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import "TestDownloadRequestViewController.h"
#import "HLLPlaceholderTextView.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

@interface TestDownloadRequestViewController ()

@property (nonatomic ,strong) HLLPlaceholderTextView * logView;

@property (nonatomic ,strong) UIProgressView * progressView;

@property (nonatomic, strong) AVPlayer * player;
@property (nonatomic, strong) AVPlayerLayer * playerLayer;
@property (nonatomic, strong) AVPlayerItem * currentItem;


@end
@implementation TestDownloadRequestViewController

//http://v.jxvdy.com/sendfile/kQEXWYvRJsQzdmkNJuZO7jo_rQKUgTbPIsRaXyBUE5mXVS1ULfFSqgEn2inRMdbTLFGCgG1A1iqBGW8H3idrivI9HHhOPg
- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(80, 30, CGRectGetWidth(self.view.bounds) - 160, 40);
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button setTitle:@"点击进行下载文件" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(startTestRequest:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor colorWithHexString:@"EFF3F4"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"FE8A8A"]] forState:UIControlStateNormal];
    button.layer.cornerRadius = 5.0f;
    button.layer.masksToBounds = YES;
    [self.view addSubview:button];
    
    self.logView = [[HLLPlaceholderTextView alloc] init];
    self.logView.placeholder = @"下载进度会在这里进行输出";
    self.logView.userInteractionEnabled = NO;
    self.logView.placeholderColor = [UIColor colorWithHexString:@"#84949E"];
    self.logView.textColor = [UIColor colorWithHexString:@"#84949E"];
    self.logView.font = [UIFont systemFontOfSize:14];
    self.logView.frame = CGRectMake(20, CGRectGetMaxY(button.frame) + 40, CGRectGetWidth(self.view.bounds) - 40, 30);
    self.logView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.logView];
    
    self.progressView = [[UIProgressView alloc] init];
    self.progressView.frame = CGRectMake(20, CGRectGetMaxY(self.logView.frame) + 10, CGRectGetWidth(self.logView.frame), 10);
    self.progressView.layer.cornerRadius = 2.0f;
    self.progressView.layer.masksToBounds = YES;
    self.progressView.tintColor = [UIColor colorWithHexString:@"FE8A8A"];
    self.progressView.backgroundColor = [UIColor colorWithHexString:@"84949E"];
    [self.progressView setProgress:0.43];
    [self.view addSubview:self.progressView];
    
    self.player = [AVPlayer playerWithPlayerItem:self.currentItem];

    //AVPlayerLayer
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.playerLayer.frame = CGRectMake(0, CGRectGetMaxY(self.progressView.frame) + 20, CGRectGetWidth(self.view.bounds), 300);
    [self.view.layer insertSublayer:self.playerLayer atIndex:0];
}


-(AVPlayerItem *)getPlayItem{
    
    NSString * filePath = @"";
    AVAsset *movieAsset  = [[AVURLAsset alloc]initWithURL:[NSURL fileURLWithPath:filePath] options:nil];
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:movieAsset];
    return playerItem;
}


- (void)startTestRequest:(UIButton *)sender{
    
    [self.baseRequest startRequest];
}

- (HLLBaseRequestAdapter *)generateRequest{
    
    return [[TestDownload alloc] initWithNetworkManager:self.networkManager];
}

- (void)refreshUIWithRequest:(HLLBaseRequestAdapter *)request withUserInfo:(id)userInfo{
    
    NSLog(@"%@",userInfo);
    self.logView.text = [NSString stringWithFormat:@"%@\n%@  请求成功",self.logView.text,userInfo];
}
@end


@implementation TestDownload

- (NSString *)userInfo{

    return @"test-download-api";
}

- (void)startRequest{


}

@end


