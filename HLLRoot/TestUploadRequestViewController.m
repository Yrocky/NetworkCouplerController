//
//  TestUploadRequestViewController.m
//  HLLRoot
//
//  Created by Rocky Young on 16/10/23.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import "TestUploadRequestViewController.h"
#import "HLLPlaceholderTextView.h"

@interface TestUploadRequestViewController ()

@property (nonatomic ,strong) HLLPlaceholderTextView * logView;
@property (nonatomic ,strong) UIImageView * imageView;

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
    [self.view addSubview:button];
    
    self.logView = [[HLLPlaceholderTextView alloc] init];
    self.logView.placeholder = @"上传进度会在这里进行输出";
    self.logView.placeholderColor = [UIColor colorWithHexString:@"#84949E"];
    self.logView.textColor = [UIColor colorWithHexString:@"#84949E"];
    self.logView.font = [UIFont systemFontOfSize:14];
    self.logView.frame = CGRectMake(20, CGRectGetMaxY(button.frame) + 40, CGRectGetWidth(self.view.bounds) - 40, 40);
    self.logView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.logView];
 
    self.imageView = [[UIImageView alloc] init];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds = YES;
    width = CGRectGetWidth(self.view.bounds) - 60.0f;
    self.imageView.frame = CGRectMake(30, CGRectGetMaxY(self.logView.frame) + 30, width,width);
    [self.view addSubview:self.imageView];
}

- (void) chooseFile:(UIButton *)button{
    
    UIImage * image = [UIImage imageWithColor:[UIColor randomColor]];
    
    self.imageView.image = image;
}

- (void) startTestRequest{
    
}

- (HLLBaseRequestAdapter *)generateRequest{

    return nil;
}

@end
