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

+ (instancetype) api{

    return [[self alloc] init];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _networkManager = [[V_3_X_Networking alloc] init];
        _networkManager.delegate = self;
    }
    return self;
}

- (instancetype)initWithNetworkManager:(__kindof HLLNetworking *)manager
{
    if( self = [super init] )
    {
        _networkManager = (V_3_X_Networking *)manager;
        _networkManager.delegate = self;
    }
    
    return self;
}

-(void)dealloc{

    [self.networkManager cancelRequest];
}

- (void)setNeedCache:(BOOL)needCache{

    _networkManager.needCache = needCache;
}

- (void)start{
 
    [NSException raise:@"Reauest Adapter did start request"
                format:@"You Must Override This Method."];
}

- (void)refresh{
    
    [self start];
}

- (void)stop{

    [_networkManager cancelRequest];
}

- (id)objectForKey:(NSString *)key{
    
    if (key) {
        return _data[key];
    }
    return key;
}

- (void) setTimesToRetry:(int)timesToRetry intervalInSeconds:(int)intervalInSeconds{

    _networkManager.timesToRetry = timesToRetry;
    _networkManager.intervalInSeconds = intervalInSeconds;
}

- (void)parseResponse:(id)response withUserInfo:(id)userInfo{
    
    self.data = response;// 这里先将原始数据赋给data属性，子类如果需要具体的数据结构可以进行重写该方法
    /** 供子类进行解析response的操作 */
}

+ (NSMutableDictionary *)createCommonParamWithApp:(NSString *)app class:(NSString *)class{
    
    NSMutableDictionary * ret = [NSMutableDictionary dictionary];
    /** 根据自己后台服务器的请求规则进行相同参数的设定 */
    // 一个例子如下，
    ret[@"app"] = app;
    ret[@"class"] = class;
    ret[@"sign"] = @"";// 使用md5或者base64进行加密app、class操作然后赋值给sign参数

    return ret;
}

- (NSString *)userInfo{

    return @"base-request";
}

- (void)post:(NSString*)url parameters:(id)parameters{
    
    self.networkManager.method = [HLLPOSTMethodType type];
    [self _configureNetworkManagerWithUrl:url parameters:parameters tag:self.userInfo];
}

- (void)get:(NSString*)url parameters:(id)parameters{
    
    self.networkManager.method = [HLLGETMethodType type];
    [self _configureNetworkManagerWithUrl:url parameters:parameters tag:self.userInfo];
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

- (void) networkingDidRequestSuccess:(__kindof HLLNetworking *)networking response:(id)response{

    self.response = response;

    [self parseResponse:response withUserInfo:networking.tag];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if([_delegate respondsToSelector:@selector(requestAdapter:didCompleteWithUserInfo:)]){
            
            [_delegate requestAdapter:self didCompleteWithUserInfo:networking.tag];
        }
    });
}

- (void) networkingDidRequestFailed:(__kindof HLLNetworking *)networking error:(NSError *)error{

    if( [_delegate respondsToSelector:@selector(requestAdapter:didFailWithError:)]){
        
        [_delegate requestAdapter:self didFailWithError:error];
    }
}

// 请求失败之后，从缓存中获取的数据
- (void)networkingDidRequestFailed:(__kindof HLLNetworking *)networking response:(id)response error:(NSError *)error{

    self.response = response;
    
    [self parseResponse:response withUserInfo:networking.tag];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if([_delegate respondsToSelector:@selector(requestAdapter:didCompleteWithUserInfo:)]){
            
            [_delegate requestAdapter:self didCompleteWithUserInfo:networking.tag];
        }
    });
}
@end
