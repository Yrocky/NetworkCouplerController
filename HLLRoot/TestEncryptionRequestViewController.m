//
//  TestEncryptionRequestViewController.m
//  HLLRoot
//
//  Created by Rocky Young on 16/10/28.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import "TestEncryptionRequestViewController.h"
#import "HLLPlaceholderTextView.h"

@interface TestEncryptionRequestViewController ()

@property (nonatomic ,strong) UISegmentedControl * segmentControl;

@property (nonatomic ,strong) HLLPlaceholderTextView * logView;

@property (nonatomic ,strong) TestEncryptionOneAPI * oneAPI;
@property (nonatomic ,strong) TestEncryptionTwoAPI * twoAPI;
@property (nonatomic ,strong) TestEncryptionThreeAPI * threeAPI;
@end

@implementation TestEncryptionRequestViewController



- (void) viewDidLoad{

    [super viewDidLoad];
    
    NSArray * items = @[@"测试请求一",@"测试请求二",@"测试请求三"];
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
    
    self.oneAPI = [[TestEncryptionOneAPI alloc] init];
    self.twoAPI = [[TestEncryptionTwoAPI alloc] init];
    self.threeAPI = [[TestEncryptionThreeAPI alloc] init];
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
        [self testThree];
    }
}

- (void) testOne{
    [self.oneAPI start];
}

- (void) testTwo{
    
    [self.twoAPI start];
}

- (void) testThree{

    [self.threeAPI start];
}
- (void)refreshUIWithRequest:(HLLBaseRequestAdapter *)request withUserInfo:(id)userInfo{
    
    self.logView.text = [NSString stringWithFormat:@"%@请求成功\n================\n%@",userInfo,request.response];
}
@end


@implementation TestEncryptionOneAPI


- (NSString *)userInfo{
    
    return @"test-encryption-one-api";
}

- (void)start{
    
    NSMutableDictionary * parmars = [TestEncryptionThreeAPI createCommonParamWithApp:@"app1" class:@"class1"];
    parmars[@"arg1"] = @"value1";
    parmars[@"arg2"] = @"value2";
    parmars[@"arg3"] = @"value3";
    [self get:@"url" parameters:parmars];
}

- (void)parseResponse:(id)response withUserInfo:(id)userInfo{
    
}

@end


@implementation TestEncryptionTwoAPI


- (NSString *)userInfo{
    
    return @"test-encryption-two-api";
}

- (void)start{
    
    NSMutableDictionary * parmars = [TestEncryptionThreeAPI createCommonParamWithApp:@"app2" class:@"class2"];
    parmars[@"arg1"] = @"value1";
    [self get:@"url" parameters:parmars];
}

- (void)parseResponse:(id)response withUserInfo:(id)userInfo{
    
    [super parseResponse:response withUserInfo:userInfo];
}

@end


@implementation TestEncryptionThreeAPI


- (NSString *)userInfo{
    
    return @"test-encryption-three-api";
}

- (void)start{
    
    NSMutableDictionary * parmars = [TestEncryptionThreeAPI createCommonParamWithApp:@"app3" class:@"class3"];
    parmars[@"arg1"] = @"value1";
    parmars[@"arg2"] = @"value2";
    [self get:@"url" parameters:parmars];
}

- (void)parseResponse:(id)response withUserInfo:(id)userInfo{
    
    [super parseResponse:response withUserInfo:userInfo];

}

@end
