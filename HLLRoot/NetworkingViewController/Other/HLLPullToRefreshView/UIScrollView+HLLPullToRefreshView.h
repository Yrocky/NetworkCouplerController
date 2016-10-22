//
//  UIScrollView+HLLPullToRefreshView.h
//  HLLPullToRefreshExample
//
//  Created by Rocky Young on 16/8/17.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import <UIKit/UIKit.h>


@class HLLPullToRefreshContentView;

@protocol HLLPullToRefreshViewProtocol <NSObject>

@required
- (void)HLLPullToRefreshStopped:(UIScrollView *)scrollView;
- (void)HLLPullToRefreshTriggered:(UIScrollView *)scrollView;
- (void)HLLPullToRefreshLoading:(UIScrollView *)scrollView;

@optional
/**
 *  @brief Determine when pull to refresh will trigger, should be times of handle view height, default is 1.5.
 *
 *  @return times of handle view height
 */
- (CGFloat)HLLPullToRefreshTriggerDistanceTimes:(UIScrollView *)scrollView;
- (void)HLLPullToRefreshDragging:(UIScrollView *)scrollView;
- (void)HLLPullToRefreshView:(UIScrollView *)scrollView draggingWithProgress:(CGFloat)progress;

@end


@interface UIScrollView (HLLPullToRefreshView)

/**
 *  @brief Add a pull to refresh view at scrollview content view top, when pull to refresh trigger, actionHandler will be triggered.
 *
 *  @param refreshHandleView A UIView should conform HLLPullToRefreshViewProtocol
 *  @param actionHandler Block will invoke while pull to refresh triggered
 */
- (void)hll_AddPullToRefreshWithHandleView:(UIView <HLLPullToRefreshViewProtocol> *)refreshHandleView actionHandler:(void (^)(void))actionHandler;

/**
 *  @brief Programmatically trigger pull to refresh, will invoke actionHandler.
 */
- (void)hll_TriggerPullToRefresh;

/**
 *  @brief Deal animation and infinite scrolling state. Please reference Class HLLPullToRefreshContentView.
 */
@property (nonatomic, readonly) HLLPullToRefreshContentView *pullToRefreshContentView;

/**
 *  @brief Change content size to make refreshHandleView visiable or not.
 */
@property (nonatomic, assign) BOOL showPullToRefresh;

/**
 *  @brief The distance between the bottom of pullToRefreshContentView and the top value of contentInset.  The default value is 0.  This method should be set after -addPullToRefreshWithHandleView:actionHandler: is invoked.
 */
@property (nonatomic, assign) CGFloat pullToRefreshContentViewBottomMargin;

@end


typedef NS_ENUM(NSUInteger, HLLPullToRefreshState) {
    HLLPullToRefreshStateStopped = 1,
    HLLPullToRefreshStateDragging,
    HLLPullToRefreshStateTriggered,
    HLLPullToRefreshStateLoading,
};

@interface HLLPullToRefreshContentView : UIView

- (void)startAnimating;

/**
 *  用于结束动画，一定要在完成加载之后结束动画
 */
- (void)stopAnimating;

/**
 *  用于结束动画，并滚动到顶端，一定要在完成加载之后结束动画
 */
- (void)stopAnimatingAndScrollToTop;

@property (nonatomic, assign) CGFloat originalTopInset;

@property (nonatomic, assign) CGFloat originalBottomInset;

@property (nonatomic, readonly) HLLPullToRefreshState state;

@property (nonatomic, assign) BOOL autoFadeEffect;

@property (nonatomic, assign) BOOL detectDisplayStatusMode;

@end

