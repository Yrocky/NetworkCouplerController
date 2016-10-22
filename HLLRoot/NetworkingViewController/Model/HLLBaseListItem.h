//
//  HLLBaseListItem.h
//  HLLRoot
//
//  Created by Rocky Young on 16/10/23.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import "HLLBaseRequestAdapter.h"

@interface HLLBaseListItem : HLLBaseRequestAdapter

@property (nonatomic, assign) int pageSize;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSMutableArray * items;

- (void)refresh;//刷新
- (void)loadMore;//加载更多

- (id)objectAtIndex:(NSInteger)index;

- (void)clear;//清除所有数据

- (NSArray *)parsePage:(id)response withUserInfo:(id)userInfo;

@end




/*///////////////
 
 该类用于具有分段数据的请求，可以设置每页的个数以及默认起始页
 
///////////////*/


/*///////////////
 
 `-parsePage:`方法是对response的数据进行分组的解析
 
 子类必须重写该方法，以解决针对不同的返回数据结构进行解析
 
 一个例子比如请求到的数据结构为:
 msg:""
 status:""
 data:(
    {},
    {},
    ...
 )
 
 或者是如下这种可能:
 msg:""
 status:""
 data:(
    file:(
        {},
        {},
        ...
    ),
    whaterver:""
 )
///////////////*/




