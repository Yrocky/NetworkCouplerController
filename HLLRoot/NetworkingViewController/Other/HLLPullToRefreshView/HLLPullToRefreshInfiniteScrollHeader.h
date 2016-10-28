//
//  HLLPullToRefreshInfiniteScrollHeader.h
//  HLLPullToRefreshExample
//
//  Created by Rocky Young on 16/8/17.
//  Copyright © 2016年 HLL. All rights reserved.
//

#ifndef HLLPullToRefreshInfiniteScrollHeader_h
#define HLLPullToRefreshInfiniteScrollHeader_h

#import "UIScrollView+HLLPullToRefreshView.h"
#import "UIScrollView+HLLInfiniteScrollingView.h"

/** 使用这个分类进行添加`下拉刷新`以及`上提加载更多`功能的注意点：
    
    * 由于使用了KVO，contentView关注了scrollView的一些属性，需要在持有scrollView的控制器dealloc的时候进行
     
     scrollView.showInfiniteScrolling = NO;
     scrollView.showPullToRefresh = NO;
    
      使用起来可能会有一点儿麻烦，但是基本的刷新功能是有的，还支持自定义视图
 */
#endif /* HLLPullToRefreshInfiniteScrollHeader_h */
