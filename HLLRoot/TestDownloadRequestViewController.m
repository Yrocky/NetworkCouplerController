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
#import "FileHandle.h"

@interface TestDownloadRequestViewController ()<HLLBaseFileHandleAdapterProtocol>

@property (nonatomic ,strong) HLLPlaceholderTextView * logView;

@property (nonatomic ,strong) UIProgressView * progressView;

@property (nonatomic, strong) AVPlayer * player;
@property (nonatomic, strong) AVPlayerLayer * playerLayer;
@property (nonatomic, strong) AVPlayerItem * currentItem;
@property (nonatomic ,strong) UIButton * clearButton;
@property (nonatomic ,strong) UIButton * downloadButton;
@property (nonatomic ,strong) UIButton * playButton;

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
    self.downloadButton = button;
    
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
    [self.progressView setProgress:0.];
    [self.view addSubview:self.progressView];
    
//    self.currentItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:@"http://v.jxvdy.com/sendfile/kQEXWYvRJsQzdmkNJuZO7jo_rQKUgTbPIsRaXyBUE5mXVS1ULfFSqgEn2inRMdbTLFGCgG1A1iqBGW8H3idrivI9HHhOPg"]];
//    self.player = [AVPlayer playerWithPlayerItem:self.currentItem];

    //AVPlayerLayer
    self.playerLayer = [[AVPlayerLayer alloc] init];
    self.playerLayer.frame = CGRectMake(0, CGRectGetMaxY(self.progressView.frame) + 20, CGRectGetWidth(self.view.bounds), 300);
    self.playerLayer.backgroundColor = [UIColor clearColor].CGColor;
    [self.view.layer insertSublayer:self.playerLayer atIndex:0];
    
    CGFloat margin = 30.0f;
    CGFloat width = (CGRectGetWidth(self.view.bounds) - 3 * margin) / 2;
    CGFloat height = 40.0f;

    UIButton * clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    clearButton.frame = CGRectMake(margin, CGRectGetHeight(self.view.frame) - 130, width, height);
    clearButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [clearButton setTitle:@"清除文件" forState:UIControlStateNormal];
    [clearButton addTarget:self action:@selector(clearDownload:) forControlEvents:UIControlEventTouchUpInside];
    [clearButton setTitleColor:[UIColor colorWithHexString:@"EFF3F4"] forState:UIControlStateNormal];
    [clearButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"FE8A8A"]] forState:UIControlStateNormal];
    clearButton.layer.cornerRadius = 5.0f;
    clearButton.layer.masksToBounds = YES;
    clearButton.hidden = YES;
    [self.view addSubview:clearButton];
    self.clearButton = clearButton;
    
    UIButton * button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame = CGRectMake(CGRectGetMaxX(clearButton.frame) + margin, CGRectGetMinY(clearButton.frame), width, height);
    button2.titleLabel.font = [UIFont systemFontOfSize:15];
    [button2 setTitle:@"播放视频" forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(playHandle) forControlEvents:UIControlEventTouchUpInside];
    [button2 setTitleColor:[UIColor colorWithHexString:@"EFF3F4"] forState:UIControlStateNormal];
    [button2 setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"FE8A8A"]] forState:UIControlStateNormal];
    button2.layer.cornerRadius = 5.0f;
    button2.layer.masksToBounds = YES;
    button2.hidden = NO;
    [self.view addSubview:button2];
    self.playButton = button2;
}

-(AVPlayerItem *)getPlayItem{
    
    NSString * filePath = @"";
    AVAsset *movieAsset  = [[AVURLAsset alloc]initWithURL:[NSURL fileURLWithPath:filePath] options:nil];
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:movieAsset];
    return playerItem;
}

- (void)startTestRequest:(UIButton *)sender{
    
    self.downloadButton.enabled = NO;
    TestDownloadAPI * download = (TestDownloadAPI *)self.baseRequest;
    
    NSString * urlString = @"http://v.jxvdy.com/sendfile/TsSTUO6VkwJYnAqO1pIgdKchiEHopan-P8YoKE1_HHuczV4gCNDf6gM3m8-wA7fHCBdyr4qrAvEZn7T9EJVhy2xUvJiYHA";
    
    FileHandle * fileHandle = [FileHandle sharedFileHandle];
    [fileHandle creatCacheFile];
    [download download:urlString documentsDirectoryPath:[fileHandle getMediaCachePath] fileName:@"vedio.mp4"];
}


- (void) clearDownload:(UIButton *)button{
    
    FileHandle * fileHandle = [FileHandle sharedFileHandle];
    
    [fileHandle removeMediaCacheFileWithFileName:@"vedio.mp4"];
    self.clearButton.hidden = YES;
}

- (void) playHandle{
    
    if (!self.currentItem) {
        
        NSURL * url = [[FileHandle sharedFileHandle] getMediaUrlWithMediaName:@"vedio.mp4"];
        self.currentItem = [AVPlayerItem playerItemWithURL:url];
        self.player = [AVPlayer playerWithPlayerItem:self.currentItem];
        self.playerLayer.player = self.player;
    }
    
    if (self.player.timeControlStatus != AVPlayerTimeControlStatusPlaying) {
        
        [self.player play];
    }else{
        [self.player pause];
    }
}

- (HLLBaseRequestAdapter *)generateRequest{
    
    TestDownloadAPI * download = [[TestDownloadAPI alloc] initWithNetworkManager:self.networkManager];
    download.fileHandleDelegate = self;
    
    return download;
}


#pragma mark -
#pragma mark HLLBaseFileHandleAdapterProtocol

- (void)requestAdapter:(HLLBaseFileHandleAdapter *)requestAdapter downloadFileProgress:(NSProgress *)progress{

    CGFloat progressValue = progress.fractionCompleted;
    
    [self.progressView setProgress:progressValue];
    
    self.logView.text = [NSString stringWithFormat:@"<%@>当前进度为：%.6f%%",requestAdapter.userInfo,progressValue * 100];
}

- (void)requestAdapter:(TestDownloadAPI *)requestAdapter didCompleteWithUserInfo:(id)userInfo{
    
    [super requestAdapter:requestAdapter didCompleteWithUserInfo:userInfo];
    
    // 在这里通过requestAdapter的response可以获得到下载路径
    NSLog(@"%@",requestAdapter.response);
    
    self.downloadButton.enabled = YES;
    self.clearButton.hidden = NO;
    self.playButton.hidden = NO;
    
    float size = [[FileHandle sharedFileHandle] getCacheFileSizeAtCachePath];

    self.logView.text = [NSString stringWithFormat:@"%.3f M",size];
}

- (void)requestAdapter:(HLLBaseRequestAdapter *)requestAdapter didFailWithError:(NSError *)error{
    
    [super requestAdapter:requestAdapter didFailWithError:error];
    
    self.downloadButton.enabled = YES;
}


@end


@implementation TestDownloadAPI

- (NSString *)userInfo{

    return @"test-download-api";
}

- (void)startRequest{

    
}

- (void)parseResponse:(id)response withUserInfo:(id)userInfo{

    // 下载的成功之后返回的是下载的路径
    NSLog(@"filePath:%@",response);
}

- (void) progress:(CGFloat)progress withUserInfo:(id)userInfo{
    
    
}
@end


