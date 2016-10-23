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
/** 本次请求之前的所有数据，下拉的时候星空，上提的时候向里面追加数据 */
@property (nonatomic, strong ,readonly) NSMutableArray * items;
/** 当前一次请求得到的数据，用来判断是否有获取到数据 */
@property (nonatomic ,strong ,readonly) NSArray * result;

- (void)refresh;//刷新
- (void)loadMore;//加载更多

- (id)objectAtIndex:(NSInteger)index;

- (void)clear;//清除所有数据

- (NSArray *)parsePage:(id)response withUserInfo:(id)userInfo;

@end




/*///////////////
 
 该类用于具有分段数据的请求，可以设置每页的个数以及默认起始页
 
 1.一般具有分页的接口都是需要设定第几页、一次请求的个数，
 
 2.也有的接口是设定从第几个开始、一次请求的个数
 
 具体需要根据接口文档来操作，这里仅仅默认是前一种情况
 
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




