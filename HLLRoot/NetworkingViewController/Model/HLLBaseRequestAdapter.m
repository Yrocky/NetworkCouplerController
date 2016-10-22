//
//  HLLBaseRequestAdapter.m
//  HLLRoot
//
//  Created by Rocky Young on 16/10/23.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import "HLLBaseRequestAdapter.h"

NSString * const HLLHostURL = @"www.baidu.com";

@interface HLLBaseRequestAdapter ()

@end

@implementation HLLBaseRequestAdapter

- (instancetype)initWithNetworkManager:(HLLNetworking *)manager
{
    if( self = [super init] )
    {
        _networkManager = (V_3_X_Networking *)manager;
        _networkManager.delegate = self;
    }
    
    return self;
}

- (void)startRequest{
 
    [NSException raise:@"Reauest Adapter did start request"
                format:@"You Must Override This Method."];
}

- (void)refreshRequest{
    
    [self startRequest];
}

- (id)objectForKey:(NSString *)key{
    
    if (key) {
        return _data[key];
    }
    return key;
}

- (void)parseResponse:(id)response withUserInfo:(id)userInfo{
    
    /** 供子类进行解析response的操作 */
}

+ (NSMutableDictionary *)createParamWithApp:(NSString *)app class:(NSString *)cls
{
    
    NSMutableDictionary * ret = [NSMutableDictionary dictionary];
    /** 根据自己后台服务器的请求规则进行相同参数的设定 */
    return ret;
}

- (void)post:(NSString*)url parameters:(id)parameters userInfo:(id)userInfo{
    
    self.networkManager.method = [HLLPOSTMethodType type];
    [self _configureNetworkManagerWithUrl:url parameters:parameters tag:userInfo];
}

- (void)get:(NSString*)url parameters:(id)parameters userInfo:(id)userInfo{
    
    self.networkManager.method = [HLLGETMethodType type];
    [self _configureNetworkManagerWithUrl:url parameters:parameters tag:userInfo];
}

- (void) _configureNetworkManagerWithUrl:(NSString *)url parameters:(id)parameters tag:(id)tag{
    
    self.networkManager.tag = [NSString stringWithFormat:@"%@",tag];
    self.networkManager.urlString = url;
    self.networkManager.requestDictionary = parameters;
    self.networkManager.requestType = [HLLHTTPBodyType type];
    self.networkManager.responseType = [HLLJsonDataType type];
    
    [self.networkManager startRequest];
    
    if (_delegate && [_delegate respondsToSelector:@selector(requestAdapterDidStartRequest:)]) {
        [_delegate requestAdapterDidStartRequest:self];
    }
}

#pragma mark -
#pragma mark HLLNetworkingDelegate

- (void) networkingDidRequestSuccess:(HLLNetworking *)networking data:(id)data{

    [self parseResponse:data withUserInfo:networking.tag];
    
    if([_delegate respondsToSelector:@selector(requestAdapter:didCompleteWithUserInfo:)]){
        
        [_delegate requestAdapter:self didCompleteWithUserInfo:networking.tag];
    }
}

- (void) networkingDidRequestFailed:(HLLNetworking *)networking error:(NSError *)error{

    if( [_delegate respondsToSelector:@selector(requestAdapter:didFailWithError:)]){
        
        [_delegate requestAdapter:self didFailWithError:error];
    }
}

@end
