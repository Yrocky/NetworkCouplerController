//
//  HLLBaseRequestAdapter.h
//  HLLRoot
//
//  Created by Rocky Young on 16/10/23.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "V_3_X_Networking.h"

extern NSString * const HLLHostURL;

@class HLLBaseRequestAdapter;
@protocol HLLBaseRequestAdapterProtocol <NSObject>

- (void)requestAdapterDidStartRequest:(HLLBaseRequestAdapter *)requestAdapter;
- (void)requestAdapter:(HLLBaseRequestAdapter *)requestAdapter didCompleteWithUserInfo:(id)userInfo;
- (void)requestAdapter:(HLLBaseRequestAdapter *)requestAdapter didFailWithError:(NSError *)error;
@end

@interface HLLBaseRequestAdapter : NSObject<HLLNetworkingDelegate>

@property (nonatomic, strong, readonly) V_3_X_Networking * networkManager;

@property (nonatomic, weak) id<HLLBaseRequestAdapterProtocol> delegate;

/** 在网络请求成功之后返回的原始数据 */
@property (nonatomic ,strong) id response;

/** 在网络请求返回的数据进行解析之后的有用数据，详见`-parseResponse:withUserInfo:`方法 */
@property (nonatomic, strong) id data;

/** 用来标示每一个request，类似于tag */
@property (nonatomic ,strong) NSString * userInfo;

- (instancetype)initWithNetworkManager:(HLLNetworking *)manager;

- (void)post:(NSString *)url parameters:(id)parameters userInfo:(id)userInfo;
- (void) get:(NSString *)url parameters:(id)parameters userInfo:(id)userInfo;

- (void)startRequest;
- (void)refreshRequest;
- (void)parseResponse:(id)response withUserInfo:(id)userInfo;

/** 为请求失败设置重连次数以及每次之间的时间间隔 */
- (void)setTimesToRetry:(int)timesToRetry intervalInSeconds:(int)intervalInSeconds;

- (id)objectForKey:(NSString *)key;

+ (NSMutableDictionary *)createCommonParamWithApp:(NSString *)app class:(NSString *)cls;

@end




/*///////////////
 
 该类为网络请求的基类，用于对控制器之间进行网络加载以及数据交互
 
 支持发送基本的`post`、`get`请求，支持发送请求以及重复发送请求等操作
 
 ///////////////*/




/*///////////////

 假如现在遇到的response结构为
 
    msg:""
    status:""
    data:{
 
    }

 那么`data`属性是用来方便取相应数据中data部分的
 
 并且用`-parseResponse:withUserInfo:`对`data`进行获取，以及`-objectForKey:`具体字段下数据的获取
 针对于其他的response结构可以重新实现`-parseResponse:withUserInfo:`方法
///////////////*/




/*///////////////
 
 `-startRequest`方法子类需要重写，进行请求的`url`、`参数`的设定，并且发送对应的`post`、`get`等请求
 
///////////////*/




/*///////////////
 
 一般而言，某些公司的网络请求会有一些相同的参数字段，用来标示表等作用，
 
 有的作用是将某些参数进行加密操作，这些都是些相同代码，可以在父类中进行统一操作
 
 `+createCommonParamWithApp:class:`是一个胶水代码，用来生成一个具有相同部分的请求的参数
 
 ///////////////*/




/*///////////////
 
 `-startRequest`和`-refreshRequest`用来进行网络请求的加载以及重复加载，后者基本用于刷新表数据
 
 ///////////////*/




/*///////////////
 
 `-setTimesToRetry:intervalInSeconds:`方法用来设置请求失败之后的重连次数以及每次之间的间隔
 
 ///////////////*/


