//
//  HLLChainRequest.h
//  HLLRoot
//
//  Created by Rocky Young on 16/10/30.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HLLBaseRequestAdapter.h"

@class HLLChainRequest;

typedef void(^HLLChainCallback)(HLLChainRequest *chain ,HLLBaseRequestAdapter *request);

@protocol HLLChainRequestDelegate <NSObject>

@optional;

- (void) chainRequestDidFinished:(HLLChainRequest *)chainRequest;

- (void) chainRequestDidFailed:(HLLChainRequest *)chainRequest withRequest:(HLLBaseRequestAdapter *)request;

@end
@interface HLLChainRequest : NSObject

@property (nonatomic ,weak) id<HLLChainRequestDelegate> delegate;

/** 获得当前请求链中的所有请求对象 */
- (NSArray <HLLBaseRequestAdapter *> *) requestsArray;

/** 在请求链中添加一个请求，并且传入一个在请求成功之后的block回调 */
- (void) addRequest:(HLLBaseRequestAdapter *)request callback:(HLLChainCallback)callback;

/** 开始请求链中的第一个请求的发起 */
- (void) start;

/** 停止请求，如果请求链中还有其他的请求，统统停止 */
- (void) stop;

@end


@interface HLLChainRequestAgent : NSObject

+ (HLLChainRequestAgent *)sharedAgent;

- (void)addChainRequest:(HLLChainRequest *)request;

- (void)removeChainRequest:(HLLChainRequest *)request;

@end



