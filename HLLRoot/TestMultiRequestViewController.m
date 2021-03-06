//
//  TestMultiRequestViewController.m
//  HLLRoot
//
//  Created by Rocky Young on 16/10/23.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import "TestMultiRequestViewController.h"
#import "HLLPlaceholderTextView.h"
#import "HLLChainRequest.h"

@interface TestMultiRequestViewController ()<HLLChainRequestDelegate>

@property (nonatomic ,strong) UISegmentedControl * segmentControl;
@property (nonatomic ,strong) HLLPlaceholderTextView * logView;
@end

@implementation TestMultiRequestViewController

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    NSArray * items = @[@"测试请求一",@"测试请求二",@"测试同时发送"];
    UISegmentedControl * segmentControl = [[UISegmentedControl alloc] initWithItems:items];
    segmentControl.frame = CGRectMake(20, 30, CGRectGetWidth(self.view.bounds) - 40, 40);
    [segmentControl addTarget:self
                       action:@selector(startTestRequest:)
             forControlEvents:UIControlEventValueChanged];
    segmentControl.layer.cornerRadius = 5.0f;
    segmentControl.layer.masksToBounds = YES;
    [segmentControl setTintColor:[UIColor colorWithHexString:@"EFF3F4"]];
    [segmentControl setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"FE8A8A"]] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.view addSubview:segmentControl];
    self.segmentControl = segmentControl;
    
    self.logView = [[HLLPlaceholderTextView alloc] init];
    self.logView.placeholder = @"请求成功会在这里输出日志";
    self.logView.placeholderColor = [UIColor colorWithHexString:@"#84949E"];
    self.logView.textColor = [UIColor colorWithHexString:@"#84949E"];
    self.logView.font = [UIFont systemFontOfSize:14];
    self.logView.frame = CGRectMake(20, CGRectGetMaxY(segmentControl.frame) + 40, CGRectGetWidth(segmentControl.frame), 300);
    self.logView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.logView];
    
    self.testOneAPI = [[TestOneAPI alloc] init];
    self.testOneAPI.delegate = self;
    self.testTwoAPI = [[TestTwoAPI alloc] init];
    self.testTwoAPI.delegate = self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

- (void)startTestRequest:(UISegmentedControl *)sender{
    
    if (sender.selectedSegmentIndex == 0) {
        [self testOne];
    }else if (sender.selectedSegmentIndex == 1) {
        [self testTwo];
    }else if (sender.selectedSegmentIndex == 2) {
        self.logView.text = nil;
        
        TestOneAPI * oneAPI = [TestOneAPI api];
        
        HLLChainRequest * chainRequest = [[HLLChainRequest alloc] init];
        [chainRequest addRequest:oneAPI callback:^(HLLChainRequest *chain, HLLBaseRequestAdapter *request) {
            
            TestTwoAPI * twoAPI = [TestTwoAPI api];
            
            [chain addRequest:twoAPI callback:nil];
        }];
        chainRequest.delegate = self;
        [chainRequest start];
    }
}

- (void) testOne{
    
    [self.testOneAPI start];
}

- (void) testTwo{
    
    [self.testTwoAPI start];
}

- (void)refreshUIWithRequest:(HLLBaseRequestAdapter *)request withUserInfo:(id)userInfo{
    
    if (self.segmentControl.selectedSegmentIndex == 2) {
        
        self.logView.text = [NSString stringWithFormat:@"%@\n请求成功%@",self.logView.text,userInfo];
    }else{
    
        self.logView.text = [NSString stringWithFormat:@"%@请求成功\n================\n%@",userInfo,request.response];
    }
}


#pragma mark -
#pragma mark HLLChainRequestDelegate

- (void) chainRequestDidFinished:(HLLChainRequest *)chainRequest{

    for (HLLBaseRequestAdapter * request in chainRequest.requestsArray) {
        
        self.logView.text = [NSString stringWithFormat:@"%@\n%@请求成功\n",self.logView.text,request.userInfo];
    }
}

- (void) chainRequestDidFailed:(HLLChainRequest *)chainRequest withRequest:(HLLBaseRequestAdapter *)request{

    NSLog(@"----%@",request.userInfo);
}
@end


@implementation TestOneAPI

- (NSString *)userInfo{
    
    return @"test-one-api";
}

- (void)start{
    
    [self get:@"http://news-at.zhihu.com/api/4/news/latest" parameters:nil];
}

- (void)parseResponse:(id)response withUserInfo:(id)userInfo{
    
    _top_stories = response[@"top_stories"];
    _stories = response[@"stories"];
}
@end


@implementation TestTwoAPI

- (NSString *)userInfo{
    
    return @"test-two-api";
}

- (void)start{
    
    NSDictionary * p = @{
                         @"app" :@"Goods",
                         @"class"  :@"Recommend",
                         @"sign" : @"3e3ae73f6be8ea3f333af93c76d20c0f",
                         @"uid" :@"1932891"
                         };
    
    [self post:@"http://175.102.24.16/api" parameters:p];
}

- (void)parseResponse:(id)response withUserInfo:(id)userInfo{
    
    self.data = response[@"data"];
}
@end
