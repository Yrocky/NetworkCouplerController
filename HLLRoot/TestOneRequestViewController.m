//
//  TestOneRequestViewController.m
//  HLLRoot
//
//  Created by Rocky Young on 16/10/23.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import "TestOneRequestViewController.h"
#import "HLLPlaceholderTextView.h"

@interface TestOneRequestViewController ()

@property (nonatomic ,strong) HLLPlaceholderTextView * logView;
@end

@implementation TestOneRequestViewController

- (void)viewDidLoad{

    [super viewDidLoad];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(80, 30, CGRectGetWidth(self.view.bounds) - 160, 40);
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button setTitle:@"点击发送一个请求" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(startTestRequest:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor colorWithHexString:@"EFF3F4"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"FE8A8A"]] forState:UIControlStateNormal];
    button.layer.cornerRadius = 5.0f;
    button.layer.masksToBounds = YES;
    [self.view addSubview:button];
    
    self.logView = [[HLLPlaceholderTextView alloc] init];
    self.logView.placeholder = @"请求成功会在这里输出日志";
    self.logView.placeholderColor = [UIColor colorWithHexString:@"#84949E"];
    self.logView.textColor = [UIColor colorWithHexString:@"#84949E"];
    self.logView.font = [UIFont systemFontOfSize:14];
    self.logView.frame = CGRectMake(20, CGRectGetMaxY(button.frame) + 40, CGRectGetWidth(self.view.bounds) - 40, 300);
    self.logView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.logView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

- (void)startTestRequest:(UIButton *)sender{

    [self.baseRequest refresh];
}

- (HLLBaseRequestAdapter *)generateRequest{

    TestAPI * test = [[TestAPI alloc] init];
    test.needCache = YES;
    return test;
}

- (void)refreshUIWithRequest:(TestAPI *)request withUserInfo:(id)userInfo{

    self.logView.text = [NSString stringWithFormat:@"%@请求成功\n================\n%@",userInfo,request.response];
}
@end


@implementation TestAPI

- (NSString *)userInfo{

    return @"test-api";
}

- (void)start{

    [self get:@"http://news-at.zhihu.com/api/4/news/latest" parameters:nil];
}

- (void)parseResponse:(id)response withUserInfo:(id)userInfo{

    _top_stories = response[@"top_stories"];
    _stories = response[@"stories"];
}
@end

