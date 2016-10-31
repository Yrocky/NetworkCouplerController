//
//  HLLChainRequest.m
//  HLLRoot
//
//  Created by Rocky Young on 16/10/30.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import "HLLChainRequest.h"

@interface HLLChainRequest ()<HLLBaseRequestAdapterProtocol>

@property (strong, nonatomic) NSMutableArray<HLLBaseRequestAdapter *> *requestArray;
@property (strong, nonatomic) NSMutableArray<HLLChainCallback> *requestCallbackArray;
@property (assign, nonatomic) NSUInteger nextRequestIndex;
@property (strong, nonatomic) HLLChainCallback emptyCallback;

@end
@implementation HLLChainRequest

- (instancetype)init {
    
    self = [super init];
    if (self) {
        _nextRequestIndex = 0;
        _requestArray = [NSMutableArray array];
        _requestCallbackArray = [NSMutableArray array];
        _emptyCallback = ^(HLLChainRequest *chainRequest, HLLBaseRequestAdapter *baseRequest) {
            // do nothing
        };
    }
    return self;
}

- (NSArray<HLLBaseRequestAdapter *> *)requestsArray{

    return _requestArray;
}

- (void)addRequest:(HLLBaseRequestAdapter *)request callback:(HLLChainCallback)callback{

    [_requestArray addObject:request];
    
    if (callback) {
        [_requestCallbackArray addObject:callback];
    }else{
        [_requestCallbackArray addObject:_emptyCallback];
    }
}

- (void)start{

    if (_nextRequestIndex > 0) {
        NSLog(@"该请求已经开始");
        return;
    }
    
    if (_requestArray.count > 0) {
        
        [self startNextRequest];
        
        [[HLLChainRequestAgent sharedAgent] addChainRequest:self];
    }else{
        NSLog(@"请求链中没有请求可以发起");
    }
}

- (void)stop{

    [self clearRequest];
    
    [[HLLChainRequestAgent sharedAgent] removeChainRequest:self];
}

- (BOOL) startNextRequest{
    
    if (_nextRequestIndex < [_requestArray count]) {
        HLLBaseRequestAdapter * request = _requestArray[_nextRequestIndex];
        _nextRequestIndex++;
        request.delegate = self;
        [request start];
        return YES;
    } else {
        return NO;
    }
    return NO;
}

- (void)clearRequest {
    
    NSUInteger currentRequestIndex = _nextRequestIndex - 1;
    if (currentRequestIndex < [_requestArray count]) {
        HLLBaseRequestAdapter * request = _requestArray[currentRequestIndex];
        [request stop];
    }
    [_requestArray removeAllObjects];
    [_requestCallbackArray removeAllObjects];
}

#pragma mark -
#pragma mark HLLBaseRequestAdapterProtocol

- (void)requestAdapter:(__kindof HLLBaseRequestAdapter *)requestAdapter didCompleteWithUserInfo:(id)userInfo{

    NSUInteger currentRequestIndex = _nextRequestIndex - 1;
    HLLChainCallback callback = _requestCallbackArray[currentRequestIndex];
    callback(self, requestAdapter);
    
    if (![self startNextRequest]) {
        if ([_delegate respondsToSelector:@selector(chainRequestDidFinished:)]) {
            [_delegate chainRequestDidFinished:self];
            [[HLLChainRequestAgent sharedAgent] removeChainRequest:self];
        }
    }
}

- (void)requestAdapter:(__kindof HLLBaseRequestAdapter *)requestAdapter didFailWithError:(NSError *)error{
    
    if ([_delegate respondsToSelector:@selector(chainRequestDidFailed:withRequest:)]) {
        [_delegate chainRequestDidFailed:self withRequest:requestAdapter];
        [[HLLChainRequestAgent sharedAgent] removeChainRequest:self];
    }
}

@end


@interface HLLChainRequestAgent()

@property (strong, nonatomic) NSMutableArray<HLLChainRequest *> *requestArray;

@end

@implementation HLLChainRequestAgent

+ (HLLChainRequestAgent *)sharedAgent {
    
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _requestArray = [NSMutableArray array];
    }
    return self;
}

- (void)addChainRequest:(HLLChainRequest *)request {
    @synchronized(self) {
        [_requestArray addObject:request];
    }
}

- (void)removeChainRequest:(HLLChainRequest *)request {
    @synchronized(self) {
        [_requestArray removeObject:request];
    }
}

@end

