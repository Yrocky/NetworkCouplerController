//
//  PullToRefreshView.h
//  HLLPullToRefreshExample
//
//  Created by Rocky Young on 16/8/17.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HLLPullToRefreshInfiniteScrollHeader.h"

@interface PullToRefreshView : UIView<HLLPullToRefreshViewProtocol,HLLInfiniteScrollingViewProtocol>{

@protected
    UIActivityIndicatorView * _indicatorView;
    UILabel * _indicatorLabel;
}

@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
@property (nonatomic, strong) UILabel *indicatorLabel;

@end
