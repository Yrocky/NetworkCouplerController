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

@protocol HLLUploadFileProtocol <NSObject>

+ (void)postUploadWithUrl:(NSString *)urlStr fileUrl:(NSURL *)fileURL fileName:(NSString *)fileName fileType:(NSString *)fileTye success:(void (^)(id responseObject))success fail:(void (^)())fail;

@end

@protocol HLLNetworkingDelegate <NSObject>

- (void) networkingDidRequestSuccess:(HLLNetworking *)networking data:(id)data;

- (void) networkingDidRequestFailed:(HLLNetworking *)networking error:(NSError *)error;

@end
@interface HLLNetworking : NSObject

// 网络请求地址
@property (nonatomic ,strong) NSString * urlString;

@property (nonatomic ,weak) id<HLLNetworkingDelegate> delegate;
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
@end

