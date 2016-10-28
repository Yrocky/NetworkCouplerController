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
    
    return @"test-api";
}

- (void)startRequest{
    
    [self get:@"http://news-at.zhihu.com/api/4/news/latest" parameters:nil userInfo:self.userInfo];
}

- (void)parseResponse:(id)response withUserInfo:(id)userInfo{
    
}

@end




@implementation TestEncryptionTwoAPI


- (NSString *)userInfo{
    
    return @"test-api";
}

- (void)startRequest{
    
    [self get:@"http://news-at.zhihu.com/api/4/news/latest" parameters:nil userInfo:self.userInfo];
}

- (void)parseResponse:(id)response withUserInfo:(id)userInfo{
    
}

@end



@implementation TestEncryptionThreeAPI


- (NSString *)userInfo{
    
    return @"test-api";
}

- (void)startRequest{
//    NSMutableDictionary * parmars
//    [self get:@"http://news-at.zhihu.com/api/4/news/latest" parameters:nil userInfo:self.userInfo];
}

- (void)parseResponse:(id)response withUserInfo:(id)userInfo{
    
}

@end
