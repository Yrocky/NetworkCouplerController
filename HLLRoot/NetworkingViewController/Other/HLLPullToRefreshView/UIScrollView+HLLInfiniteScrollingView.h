//
//  UIScrollView+HLLInfiniteScrollingView.h
//  HLLPullToRefreshExample
//
//  Created by Rocky Young on 16/8/17.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import <UIKit/UIKit.h>


@class HLLInfiniteScrollingContentView;

@protocol HLLInfiniteScrollingViewProtocol <NSObject>

@required
/**
 *  结束全部拖动的代理回调方法
 */
- (void)HLLInfiniteScrollingStopped:(UIScrollView *)scrollView;
/**
 *  结束拖动之后的dialing回调方法
 */
- (void)HLLInfiniteScrollingTriggered:(UIScrollView *)scrollView;
/**
 *  完成指定位置的拖动，开始传递handle view需要做的动画回调方法
 */
- (void)HLLInfiniteScrollingLoading:(UIScrollView *)scrollView;

@optional

/**
 *  返回最大拖动高度与添加的handle view的高度比例，默认是1.0，不建议修改为小于1.0的数值
 */
- (CGFloat)HLLInfiniteScrollingTriggerDistanceTimes:(UIScrollView *)scrollView;

/**
 *  scrollView拖动的代理回调方法
 */
- (void)HLLInfiniteScrollingDragging:(UIScrollView *)scrollView;

/**
 *  scrollView滚动的时候的代理回调方法，可以在这个方法中进行进度、动画的调整
 *
 *  @param scrollView UIScrollView、UITableView、UICollectionView
 *  @param progress   拖动进度
 */
- (void)HLLInfiniteScrollView:(UIScrollView *)scrollView draggingWithProgress:(CGFloat)progress;

/**
 *  在进行分页的表加载时，上提加载更多返回的数据为0时显示的视图
 *
 *  @param scrollView UIScrollView、UITableView、UICollectionView
 */
- (UIView *)HLLInfiniteScrollViewNoMoreDataView:(UIScrollView *)scrollView;

@end


@interface UIScrollView (HLLInfiniteScrollingView)

/**
 *  @brief 添加一个自定义的显示视图，会在结束操作之后实现actionHandler
 *
 *  @param infiniteScrollingHandleView 一个实现HLLInfiniteScrollingViewProtocol协议的自定义handle view
 *  @param actionHandler               当结束操作之后的下一步操作block
 */
- (void)hll_AddInfiniteScrollingWithHandleView:(UIView <HLLInfiniteScrollingViewProtocol> *)infiniteScrollingHandleView actionHandler:(void (^)(void))actionHandler;

/**
 *  是否代码调用上提加载视图的动画
 */
- (void)hll_TriggerInfiniteScrollingWithAnimation:(BOOL)animated;

/**
 *  上提加载视图的内容视图，用于盛放handle view，可以用来传递scrollView的状态
 */
@property (nonatomic, readonly) HLLInfiniteScrollingContentView * infiniteScrollingContentView;

/**
 *  是否显示上提加载视图
 */
@property (nonatomic, assign) BOOL showInfiniteScrolling;

@end


typedef NS_ENUM(NSInteger ,HLLInfiniteScrollingState) {

    HLLInfiniteScrollingStateStopped = 1,
    HLLInfiniteScrollingStateDragging,
    HLLInfiniteScrollingStateTriggered,
    HLLInfiniteScrollingStateLoading,
};

typedef NS_ENUM(NSInteger ,HLLInfiniteScrollingEnableState) {

    HLLInfiniteScrollingStateNormal = 1010,// 正常状态，可以上提加载以及展示中间进度
    HLLInfiniteScrollingStateNoMore,// 没有更多数据的状态
};
@interface HLLInfiniteScrollingContentView : UIView

- (void)startAnimating;

/**
 *  用于结束动画，一定要在完成加载之后结束动画
 */
- (void)stopAnimating;

/**
 *  当前视图的状态
 */
@property (nonatomic ,readonly) HLLInfiniteScrollingState state;

/**
 *  是否在显示的时候有渐变的效果
 */
@property (nonatomic, assign) BOOL autoFadeEffect;

/** 用于外部进行设置状态，主要设置1010以后的枚举 */
- (void) setupState:(HLLInfiniteScrollingEnableState)state;
/** 是否一直显示noMoreDataView，如果为YES，会通过改变scrollView的contentInset来展示 默认为NO */
@property (nonatomic, assign) BOOL alwaysDisplayNoMoreDataView;
@end
