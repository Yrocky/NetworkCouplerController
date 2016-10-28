//
//  HLLNetworking.h
//  HLLNetworking
//
//  Created by admin on 16/2/22.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HLLRequestBodyType.h"
#import "HLLResponseDataType.h"
#import "HLLRequestMethodType.h"
#import "HLLRequestDictionarySerializer.h"
#import "HLLResponseDataSerializer.h"


@class HLLNetworking;

@protocol HLLFileHandleProtocol <NSObject>

/** 上传文件的进度回调 */
- (void) networkingDidUploadFile:(HLLNetworking *)networking progress:(NSProgress *)progress;

/** 下载文件的进度回调 */
- (void) networkingDidDownloadFile:(HLLNetworking *)networking progress:(NSProgress *)progress;

@end

@protocol HLLNetworkingDelegate <NSObject>

/** 请求成功的时候调用 */
- (void) networkingDidRequestSuccess:(HLLNetworking *)networking response:(id)response;

/** 请求失败的时候调用 */
- (void) networkingDidRequestFailed:(HLLNetworking *)networking error:(NSError *)error;

/** 在请求失败并且有缓存数据的时候调用 */
- (void) networkingDidRequestFailed:(HLLNetworking *)networking response:(id)response error:(NSError *)error;

@end
@interface HLLNetworking : NSObject

// 网络请求地址
@property (nonatomic ,strong) NSString * urlString;

@property (nonatomic ,weak) id<HLLNetworkingDelegate> delegate;
@property (nonatomic ,weak) id<HLLFileHandleProtocol> fileHandleDelegate;
// GET、POST
@property (nonatomic ,strong) HLLRequestMethodType * method;

// 用于在不在初始化的地方进行修改请求参数用
@property (nonatomic ,strong) NSDictionary * requestDictionary;
@property (nonatomic ,strong) HLLRequestBodyType * requestType;

/** 将请求参数进行修改 */
@property (nonatomic ,strong) id<HLLRequestDictionarySerializer> requestDictionarySerializer;

@property (nonatomic ,strong) NSDictionary * HTTPHeaderFieldsWithValues;

@property (nonatomic ,strong) HLLResponseDataType * responseType;
/** 处理返回的数据 */
@property (nonatomic ,strong) id<HLLResponseDataSerializer> responseDataSerializer;
/** 没有处理过的原始数据 */
@property (nonatomic ,strong) id originalResponseData;
/** 处理过的数据 */
@property (nonatomic ,strong) id serializerResponseData;

/** 用于区分不同的网络请求 */
@property (nonatomic ,strong) NSString * tag;

@property (nonatomic) BOOL isRunning;

@property (nonatomic ,strong) NSNumber *timeoutInterval;
/** 网络请求失败之后重试的次数，默认为0 */
@property (nonatomic ,assign) int timesToRetry;
/** 每次重试之间的间隔，默认为0 */
@property (nonatomic ,assign) int intervalInSeconds;
/** 是否需要进行缓存响应结果，默认为NO */
@property (nonatomic ,assign) BOOL needCache;
/** 是否进行解析过后的响应数据log输出，默认为NO */
@property (nonatomic ,assign) BOOL EnableLogParseResponseDebug;


- (void) startRequest;

- (void) cancelRequest;

+ (id) getMethodNetworkingWithUrlString:(NSString *)urlString
                      requestDictionary:(NSDictionary *)requestDictioinary
                        requestBodyType:(HLLRequestBodyType *)requestType
                       responseDataType:(HLLResponseDataType *)responseType;

+ (id) postMethodNetworkingWithUrlString:(NSString *)urlString
                       requestDictionary:(NSDictionary *)requestDictioinary
                         requestBodyType:(HLLRequestBodyType *)requestType
                        responseDataType:(HLLResponseDataType *)responseType;

- (NSDictionary *) accessRequestDictionarySerializerWithRequestDictionary:(NSDictionary *)requestDictionary;

- (NSString *) descriptionRequestURL;


- (void)logWithSuccessResponse:(id)response
                           url:(NSString *)url
                        params:(NSDictionary *)params;
- (void)logWithFailError:(NSError *)error
                     url:(NSString *)url
                  params:(id)params;

- (NSString *)generateGETAbsoluteURL:(NSString *)url params:(id)params;
- (id)tryToParseData:(id)responseData;

/** 进行缓存数据以及获取缓存数据 */
- (void)cacheResponseObject:(id)responseObject
                    request:(NSURLRequest *)request
                 parameters:params ;
- (id)getCacheResponseWithRequest:(NSURLRequest *)request
                       parameters:params ;
@end



/*///////////////
 
 为网络请求添加缓存机制，
 
 具体缓存机制见方法`-cacheResponseObject: request: parameters:`
 
 具体操作流程为：
 
             __需要缓存__-->`缓存响应结果`
    请求成功--|                           -->`返回成功的请求结果`
             __不需要缓存__
             
             
             __缓存中有对应的数据__-->`返回相应结果并且抛出异常`
    请求失败--|
             __没有缓存数据__-->`抛出异常`
 
 ///////////////*/



