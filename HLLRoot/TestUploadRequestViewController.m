//
//  TestUploadRequestViewController.m
//  HLLRoot
//
//  Created by Rocky Young on 16/10/23.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import "TestUploadRequestViewController.h"
#import "HLLPlaceholderTextView.h"
#import "UIKit+AFNetworking.h"
#import "UIViewController+PhotoPicker.h"
#import "UIImage+ImageEffects.h"


@interface TestUploadRequestViewController ()<HLLBaseFileHandleAdapterProtocol>

@property (nonatomic ,strong) HLLPlaceholderTextView * logView;

@property (nonatomic ,strong) UIProgressView * progressView;

@property (nonatomic ,strong) UIImageView * imageView;

@property (nonatomic ,strong) UIButton * uploadButton;
@end

@implementation TestUploadRequestViewController

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    CGFloat margin = 30.0f;
    CGFloat width = (CGRectGetWidth(self.view.bounds) - 3 * margin) / 2;
    CGFloat height = 40.0f;
    
    UIButton * button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame = CGRectMake(margin, 30, width, height);
    button1.titleLabel.font = [UIFont systemFontOfSize:15];
    [button1 setTitle:@"选择文件" forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(chooseFile:) forControlEvents:UIControlEventTouchUpInside];
    [button1 setTitleColor:[UIColor colorWithHexString:@"EFF3F4"] forState:UIControlStateNormal];
    [button1 setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"FE8A8A"]] forState:UIControlStateNormal];
    button1.layer.cornerRadius = 5.0f;
    button1.layer.masksToBounds = YES;
    [self.view addSubview:button1];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(CGRectGetMaxX(button1.frame) + margin, 30, width, height);
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button setTitle:@"上传文件" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(startTestRequest) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor colorWithHexString:@"EFF3F4"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"FE8A8A"]] forState:UIControlStateNormal];
    button.layer.cornerRadius = 5.0f;
    button.layer.masksToBounds = YES;
    button.enabled = NO;
    [self.view addSubview:button];
    self.uploadButton = button;
    
    self.logView = [[HLLPlaceholderTextView alloc] init];
    self.logView.placeholder = @"上传进度会在这里进行输出";
    self.logView.placeholderColor = [UIColor colorWithHexString:@"#84949E"];
    self.logView.userInteractionEnabled = NO;
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
    
    self.imageView = [[UIImageView alloc] init];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds = YES;
    width = CGRectGetWidth(self.view.bounds) - 60.0f;
    self.imageView.frame = CGRectMake(30, CGRectGetMaxY(self.progressView.frame) + 30, width,width);
    [self.view addSubview:self.imageView];
}

- (void) chooseFile:(UIButton *)button{
    
    [self.progressView setProgress:0.0f];
    self.logView.text = nil;
//    UIImage * image = [UIImage imageWithColor:[UIColor randomColor]];
//    UIImage * image = [UIImage imageNamed:@"background.jpeg"];
    
    [self photoPickerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary result:^(UIImage *image) {
        
        if (image) {
            UIColor * color = [UIColor randomColorWithAlpha:0.5f];
            
            image = [image applyBlurWithRadius:10 tintColor:color];
            self.imageView.image = image;
        }
        self.uploadButton.enabled = YES;
    }cancel:^{
        
    }];
}

- (void) startTestRequest{
    
    self.uploadButton.enabled = NO;
    TestUploadAPI * upload = (TestUploadAPI *)self.baseRequest;
    NSDictionary * params = @{
                              @"app":@"Cas",
                              @"birthday": @"1982-10-25",
                              @"class": @"UpdateUserInfo",
                              @"gender": @"1",
                              @"nickname":@"我的头像",
                              @"sign":@"f6064718029e5389255f818aaac6e59d",
                              @"uid" :@"1932891"};
    NSDictionary * header = @{@"fileName":@"1932891.jpg",
                              @"name":@"image",
                              @"mimeType":@"image/jpeg"};
    [upload post:@"http://175.102.24.16/api" parameters:params image:self.imageView.image appendHTTPHeader:header];
}

- (HLLBaseRequestAdapter *)generateRequest{

    TestUploadAPI * upload = [[TestUploadAPI alloc] initWithNetworkManager:self.networkManager];
    upload.fileHandleDelegate = self;
    
    return upload;
}


#pragma mark -
#pragma mark HLLBaseFileHandleAdapterProtocol

- (void)requestAdapter:(HLLBaseFileHandleAdapter *)requestAdapter uploadFileProgress:(NSProgress *)progress{

    CGFloat progressValue = progress.fractionCompleted;

    [self.progressView setProgress:progressValue];
    
    self.logView.text = [NSString stringWithFormat:@"<%@>当前进度为：%.6f%%",requestAdapter.userInfo,progressValue * 100];
}

- (void)requestAdapter:(HLLBaseRequestAdapter *)requestAdapter didCompleteWithUserInfo:(id)userInfo{

    [super requestAdapter:requestAdapter didCompleteWithUserInfo:userInfo];

    self.uploadButton.enabled = YES;
}


- (void)requestAdapter:(HLLBaseRequestAdapter *)requestAdapter didFailWithError:(NSError *)error{
    
    [super requestAdapter:requestAdapter didFailWithError:error];
 
    self.uploadButton.enabled = YES;

}

@end



@implementation TestUploadAPI

- (NSString *)userInfo{

    return @"test-file-upload-api";
}

- (void) progress:(CGFloat)progress withUserInfo:(id)userInfo{

    
}
@end
