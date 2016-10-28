//
//  TestEncryptionRequestViewController.m
//  HLLRoot
//
//  Created by Rocky Young on 16/10/28.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import "TestEncryptionRequestViewController.h"

@implementation TestEncryptionRequestViewController



@end


@implementation TestEncryptionOneAPI


- (NSString *)userInfo{
    
    return @"test-encryption-one-api";
}

- (void)startRequest{
    
    NSMutableDictionary * parmars = [TestEncryptionThreeAPI createCommonParamWithApp:@"app1" class:@"class1"];
    parmars[@"arg1"] = @"value1";
    parmars[@"arg2"] = @"value2";
    parmars[@"arg3"] = @"value3";
    [self get:@"url" parameters:parmars userInfo:self.userInfo];
}

- (void)parseResponse:(id)response withUserInfo:(id)userInfo{
    
}

@end




@implementation TestEncryptionTwoAPI


- (NSString *)userInfo{
    
    return @"test-encryption-two-api";
}

- (void)startRequest{
    
    NSMutableDictionary * parmars = [TestEncryptionThreeAPI createCommonParamWithApp:@"app2" class:@"class2"];
    parmars[@"arg1"] = @"value1";
    [self get:@"url" parameters:parmars userInfo:self.userInfo];
}

- (void)parseResponse:(id)response withUserInfo:(id)userInfo{
    
    [super parseResponse:response withUserInfo:userInfo];
}

@end



@implementation TestEncryptionThreeAPI


- (NSString *)userInfo{
    
    return @"test-encryption-three-api";
}

- (void)startRequest{
    
    NSMutableDictionary * parmars = [TestEncryptionThreeAPI createCommonParamWithApp:@"app3" class:@"class3"];
    parmars[@"arg1"] = @"value1";
    parmars[@"arg2"] = @"value2";
    [self get:@"url" parameters:parmars userInfo:self.userInfo];
}

- (void)parseResponse:(id)response withUserInfo:(id)userInfo{
    
}

@end
