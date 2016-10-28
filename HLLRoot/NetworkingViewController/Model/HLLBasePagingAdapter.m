//
//  HLLBasePagingAdapter.m
//  HLLRoot
//
//  Created by Rocky Young on 16/10/25.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import "HLLBasePagingAdapter.h"

@implementation HLLBasePagingAdapter

- (instancetype)initWithNetworkManager:(HLLNetworking *)manager
{
    if( self = [super initWithNetworkManager:manager])
    {
        _pageSize = 50;
        _currentPage = 0;
        _list = [NSMutableArray array];
    }
    
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _pageSize = 50;
        _currentPage = 0;
        _list = [NSMutableArray array];
    }
    return self;
}

- (void)refresh
{
    _currentPage = 1;
    [self startRequest];
}

- (void)loadMore
{
    _currentPage += 1;
    [self startRequest];
}

- (id)objectAtIndex:(NSInteger)index
{
    return _list[index];
}


- (void)clear
{
    [_list removeAllObjects];
    
    _result = nil;
}

/** 模型执行startRequest-->self.networkmanager请求成功-->self.networkmanager的代理模型执行request-->请求成功后调用parseResponse:withUserInfo:*/
- (void)parseResponse:(id)response withUserInfo:(id)userInfo{
    
    [super parseResponse:response withUserInfo:userInfo];
    
    if(_currentPage == 0){
        
        [self clear];
    }
    
    [_list addObjectsFromArray:[self parsePage:response withUserInfo:userInfo]];
    
    _result = [self parsePage:response withUserInfo:userInfo];
}

- (void)startRequest{
    
    [super startRequest];
}

- (NSArray *)parsePage:(id)response withUserInfo:(id)userInfo{
    
    [NSException raise:@"List item parse Data with response"
                format:@"You Must Override This Method."];
    
    return nil;
}
@end
