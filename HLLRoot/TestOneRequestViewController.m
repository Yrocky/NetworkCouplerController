//
//  TestOneRequestViewController.m
//  HLLRoot
//
//  Created by Rocky Young on 16/10/23.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import "TestOneRequestViewController.h"

@implementation TestOneRequestViewController


- (void)viewDidLoad{

    [super viewDidLoad];
    
//    [self testOne];
    
    [self testTwo];
}

- (void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
    
//    [self testTwo];
    
}
- (void) testOne{

    TestOneAPI * one = [[TestOneAPI alloc] initWithNetworkManager:self.networkManager];
    one.delegate = self;
    [one startRequest];
}

- (void) testTwo{
    
    TestTwoAPI * two = [[TestTwoAPI alloc] initWithNetworkManager:self.networkManager];
    two.delegate = self;
    [two startRequest];
}

//- (HLLBaseRequestAdapter *)generateRequest{
//
//    return [[TestTwoAPI alloc] initWithNetworkManager:self.networkManager];
//}

- (void)refreshUIWithRequest:(HLLBaseRequestAdapter *)request withUserInfo:(id)userInfo{

    NSLog(@"%@",userInfo);
    
}
@end


@implementation TestOneAPI

- (void)startRequest{

    NSDictionary * p = @{
                         @"app" :@"Goods",
                         @"class"  :@"Recommend",
                         @"sign" : @"3e3ae73f6be8ea3f333af93c76d20c0f",
                         @"uid" :@"1932891"
                         };
    
    [self get:@"http://news-at.zhihu.com/api/4/news/latest" parameters:nil userInfo:@"test-one-api"];
}

- (void)parseResponse:(id)response withUserInfo:(id)userInfo{

    _top_stories = response[@"top_stories"];
    _stories = response[@"stories"];
}
@end


@implementation TestTwoAPI

- (void)startRequest{
    
    NSDictionary * p = @{
                         @"app" :@"Goods",
                         @"class"  :@"Recommend",
                         @"sign" : @"3e3ae73f6be8ea3f333af93c76d20c0f",
                         @"uid" :@"1932891"
                         };
    
    [self post:@"http://175.102.24.16/api" parameters:p userInfo:@"test-two-api"];
}

- (void)parseResponse:(id)response withUserInfo:(id)userInfo{
    
    self.data = response[@"data"];
}
@end
