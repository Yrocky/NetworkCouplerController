//
//  HLLBaseListItem.m
//  HLLRoot
//
//  Created by Rocky Young on 16/10/23.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import "HLLBaseListItem.h"

@implementation HLLBaseListItem

- (instancetype)initWithNetworkManager:(HLLNetworking *)manager
{
    if( self = [super initWithNetworkManager:manager])
    {
        _pageSize = 10;
        _currentPage = 0;
        _items = [NSMutableArray array];
    }
    
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _pageSize = 10;
        _currentPage = 0;
        _items = [NSMutableArray array];
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
    return _items[index];
}


- (void)clear
{
    [_items removeAllObjects];
}

/** 模型执行startRequest-->self.networkmanager请求成功-->self.networkmanager的代理模型执行request-->请求成功后调用parseResponse:withUserInfo:*/
- (void)parseResponse:(id)response withUserInfo:(id)userInfo{

    [super parseResponse:response withUserInfo:userInfo];
    
    if(_currentPage == 1)
    {
        [_items removeAllObjects];
    }
    
    [_items addObjectsFromArray:[self parsePage:response withUserInfo:userInfo]];
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
