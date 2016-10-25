//
//  V_3_X_Networking.m
//  HLLNetworking
//
//  Created by admin on 16/2/22.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import "V_3_X_Networking.h"
#import "AFNetworking.h"
#import "AFHTTPSessionManager+AutoRetry.h"


@interface V_3_X_Networking ()

@property (nonatomic ,strong) AFHTTPSessionManager * session;

@property (nonatomic ,strong) NSURLSessionDataTask * dataTask;

@end
@implementation V_3_X_Networking

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.method          = [HLLGETMethodType type];
        self.requestType     = [HLLHTTPBodyType type];
        self.responseType    = [HLLHttpDataType type];
        self.timeoutInterval = @(15);
        self.session         = [AFHTTPSessionManager manager];
        
        self.HTTPHeaderFieldsWithValues = [NSMutableDictionary dictionary];
        
        self.timesToRetry       = 0;
        self.intervalInSeconds  = 0;
        
        self.EnableLogParseResponseDebug = YES;
    }
    return self;
}

- (void)startRequest{
    
    NSParameterAssert(self.urlString);
    
    [self resetData];
    [self accessRequestSerializer];
    [self accessHeaderFiled];
    [self accessResponseSerializer];
    [self accessTimeoutInterval];
    self.isRunning = YES;
    
    typeof(self) weakSelf = self;
    
    NSDictionary * requestDictionary = [self accessRequestDictionarySerializerWithRequestDictionary:self.requestDictionary];
    
    //获得缓存中的响应数据
    id cacheResponse = [self getCacheResponseWithURL:self.urlString parameters:self.requestDictionary];
    
    if( cacheResponse ){
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(networkingDidRequestSuccess:data:)]) {
                
                [weakSelf.delegate networkingDidRequestSuccess:weakSelf
                                                          data:cacheResponse];
                // 打印成功信息
                [self logWithSuccessResponse:cacheResponse
                                         url:self.urlString
                                      params:requestDictionary];
            }
        });
        // 有数据，直接发给请求发起者，结束
        return;
    }
    
    void (^success)(NSURLSessionDataTask *, id)
    = ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        
        weakSelf.isRunning = NO;
        weakSelf.originalResponseData = responseObject;
        
        // 如果设置了转换策略，则进行数据的转换
        if (weakSelf.responseDataSerializer && [weakSelf.responseDataSerializer respondsToSelector:@selector(serializerResponseDictionary:)]) {
            weakSelf.serializerResponseData = [weakSelf.responseDataSerializer serializerResponseDictionary:responseObject];
        }
        
        id response = (weakSelf.serializerResponseData == nil ?
                       weakSelf.originalResponseData :
                       weakSelf.serializerResponseData);
        
        if( weakSelf.needCache ){
            
            // 进行缓存操作
            [weakSelf cacheResponseObject:response
                                  request:task.currentRequest
                               parameters:requestDictionary];
        }
        
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(networkingDidRequestSuccess:data:)]) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [weakSelf.delegate networkingDidRequestSuccess:weakSelf
                                                          data:response];
            });
            // 打印成功信息
            [weakSelf logWithSuccessResponse:response
                                         url:weakSelf.urlString
                                      params:requestDictionary];
        }
    };
    
    void (^failure)(NSURLSessionDataTask *, NSError *)
    = ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
        
        weakSelf.isRunning = NO;
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(networkingDidRequestFailed:error:)] && !cacheResponse) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [weakSelf.delegate networkingDidRequestFailed:weakSelf
                                                        error:error];
            });
            
            [weakSelf logWithFailError:error
                                   url:weakSelf.urlString
                                params:requestDictionary];
        }
        
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(networkingDidRequestFailed:response:error:)] && cacheResponse) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [weakSelf.delegate networkingDidRequestFailed:weakSelf
                                                     response:cacheResponse
                                                        error:error];
            });
            
            [weakSelf logWithFailError:error
                                   url:weakSelf.urlString
                                params:requestDictionary];
        }
    };
    
    
    if ([self.method isKindOfClass:[HLLGETMethodType class]]) {
        
        _dataTask = [self.session GET:self.urlString
                           parameters:requestDictionary
                             progress:nil
                              success:success
                              failure:failure
                            autoRetry:self.timesToRetry
                        retryInterval:self.intervalInSeconds];
        
    }else if ([self.method isKindOfClass:[HLLPOSTMethodType class]]){
        
        _dataTask = [self.session POST:self.urlString
                            parameters:requestDictionary
                              progress:nil
                               success:success
                               failure:failure
                             autoRetry:self.timesToRetry
                         retryInterval:self.intervalInSeconds];
    }
    
    NSLog(@"RequestURL:%@",[self generateGETAbsoluteURL:self.urlString params:self.requestDictionary]);
}

- (void) resetData{
    
    self.originalResponseData = nil;
    self.serializerResponseData = nil;
}

- (void) accessRequestSerializer{
    
    // 设置最大并发数，不宜过多
    self.session.operationQueue.maxConcurrentOperationCount = 5;
    
    if ([self.requestType isKindOfClass:[HLLJsonBodyType class]]) {
        self.session.requestSerializer = [AFJSONRequestSerializer serializer];
        
    }else if ([self.requestType isKindOfClass:[HLLHTTPBodyType class]]){
        self.session.requestSerializer = [AFHTTPRequestSerializer serializer];
        
    }else if([self.requestType isKindOfClass:[HLLPlistBodyType class]]){
        self.session.requestSerializer = [AFPropertyListRequestSerializer serializer];
        
    }else{
        self.session.requestSerializer = [AFHTTPRequestSerializer serializer];
    }
}
- (void) accessResponseSerializer{
    
    if ([self.responseType isKindOfClass:[HLLHttpDataType class]]) {
        
        self.session.responseSerializer = [AFHTTPResponseSerializer serializer];
        self.session.responseSerializer.acceptableContentTypes = [self.session.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    }else if ([self.responseType isKindOfClass:[HLLJsonDataType class]]){
        
        self.session.responseSerializer = [AFJSONResponseSerializer serializer];
        self.session.responseSerializer.acceptableContentTypes = [self.session.responseSerializer.acceptableContentTypes setByAddingObject:@"text/json"];
    }else{
        
        self.session.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    
    self.session.responseSerializer.acceptableContentTypes = [self.session.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    self.session.responseSerializer.acceptableContentTypes = [self.session.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    
}
- (void) accessHeaderFiled{
    
    if (self.HTTPHeaderFieldsWithValues) {
        NSArray * allKeys = self.HTTPHeaderFieldsWithValues.allKeys;
        for (NSString * headerField in allKeys) {
            NSString * value = [self.HTTPHeaderFieldsWithValues objectForKey:headerField];
            [self.session.requestSerializer setValue:value forHTTPHeaderField:headerField];
        }
    }
}
- (void) accessTimeoutInterval{
    
    if (self.timeoutInterval && self.timeoutInterval.floatValue > 0.0) {
        self.session.requestSerializer.timeoutInterval = self.timeoutInterval.floatValue;
    }
}
- (void)cancelRequest{
    
    [self.dataTask cancel];
}

- (NSDictionary *) accessRequestDictionarySerializerWithRequestDictionary:(NSDictionary *)requestDictionary{
    
    if (self.requestDictionarySerializer &&
        [self.requestDictionarySerializer respondsToSelector:@selector(serializerRequestDictionary:)]) {
        return [self.requestDictionarySerializer serializerRequestDictionary:requestDictionary];
    }else{
        return requestDictionary;
    }
}

+ (id)getMethodNetworkingWithUrlString:(NSString *)urlString
                     requestDictionary:(NSDictionary *)requestDictioinary
                       requestBodyType:(HLLRequestBodyType *)requestType
                      responseDataType:(HLLResponseDataType *)responseType{
    
    HLLNetworking * networking = [[V_3_X_Networking alloc] init];
    networking.urlString = urlString;
    networking.requestDictionary = requestDictioinary;
    networking.method = [HLLGETMethodType type];
    
    if (requestType) {
        networking.requestType = requestType;
    }
    if (responseType) {
        networking.responseType = responseType;
    }
    return networking;
}

+ (id)postMethodNetworkingWithUrlString:(NSString *)urlString
                      requestDictionary:(NSDictionary *)requestDictioinary
                        requestBodyType:(HLLRequestBodyType *)requestType
                       responseDataType:(HLLResponseDataType *)responseType{
    
    HLLNetworking * networking = [[V_3_X_Networking alloc] init];
    networking.urlString = urlString;
    networking.requestDictionary = requestDictioinary;
    networking.method = [HLLPOSTMethodType type];
    
    if (requestType) {
        networking.requestType = requestType;
    }
    if (responseType) {
        networking.responseType = responseType;
    }
    return networking;
}


#pragma mark -
#pragma mark 上传文件操作

- (void)uploadWithUrl:(NSString *)urlString parameters:(NSDictionary *)parameters constructingBodyWithBlock:(nullable void (^)(id <AFMultipartFormData> formData))block{
    
    NSParameterAssert(urlString);
    
    [self resetData];
    [self accessRequestSerializer];
    [self accessHeaderFiled];
    [self accessResponseSerializer];
    [self accessTimeoutInterval];
    
    self.isRunning = YES;
    
    typeof(self) weakSelf = self;
    
    NSDictionary * requestDictionary = [self accessRequestDictionarySerializerWithRequestDictionary:parameters];
    
    void (^uploadProgress)(NSProgress *)
    = ^(NSProgress *uploadProgress){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (weakSelf.uploadFileDelegate && [weakSelf.uploadFileDelegate respondsToSelector:@selector(networkingDidUploadFile:progress:)]) {
                
                [weakSelf.uploadFileDelegate networkingDidUploadFile:weakSelf
                                                            progress:uploadProgress];
            }
        });
    };
    
    void (^success)(NSURLSessionDataTask *, id _Nullable)
    = ^(NSURLSessionDataTask *task, id _Nullable responseObject){
        
        weakSelf.isRunning = NO;
        weakSelf.originalResponseData = responseObject;
        
        // 如果设置了转换策略，则进行数据的转换
        if (weakSelf.responseDataSerializer && [weakSelf.responseDataSerializer respondsToSelector:@selector(serializerResponseDictionary:)]) {
            weakSelf.serializerResponseData = [weakSelf.responseDataSerializer serializerResponseDictionary:responseObject];
        }
        
        id response = (weakSelf.serializerResponseData == nil ?
                       weakSelf.originalResponseData :
                       weakSelf.serializerResponseData);
        
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(networkingDidRequestSuccess:data:)]) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [weakSelf.delegate networkingDidRequestSuccess:weakSelf
                                                          data:response];
            });
            // 打印成功信息
            [weakSelf logWithSuccessResponse:response
                                         url:urlString
                                      params:parameters];
        }
    };
    
    void (^failure)(NSURLSessionDataTask * _Nullable, NSError *)
    = ^(NSURLSessionDataTask * _Nullable task, NSError *error){
        
        weakSelf.isRunning = NO;
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(networkingDidRequestFailed:error:)]) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [weakSelf.delegate networkingDidRequestFailed:weakSelf
                                                        error:error];
            });
            
            [weakSelf logWithFailError:error
                                   url:weakSelf.urlString
                                params:requestDictionary];
        }
    };
    
    _dataTask = [self.session POST:urlString
                        parameters:requestDictionary
         constructingBodyWithBlock:block
                          progress:uploadProgress
                           success:success
                           failure:failure];
}
@end
