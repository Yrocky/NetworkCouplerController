//
//  UIScrollView+HLLPullToRefreshView.m
//  HLLPullToRefreshExample
//
//  Created by Rocky Young on 16/8/17.
//  Copyright © 2016年 HLL. All rights reserved.
//
#import <objc/runtime.h>

#import "UIScrollView+HLLPullToRefreshView.h"

@interface UIScrollView ()

@property (nonatomic, readonly) CGFloat pullToRefreshViewHeight;
@property (nonatomic, weak) HLLPullToRefreshContentView *pullToRefreshContentView;
@property (nonatomic, weak) UIView <HLLPullToRefreshViewProtocol> *pullToRefreshHandleView;

@end


@interface HLLPullToRefreshContentView ()

- (void)resetScrollViewContentInset;
- (void)setScrollViewContentInsetForLoading;
- (void)setScrollViewContentInset:(UIEdgeInsets)contentInset;
- (void)updateLayout;

@property (nonatomic, copy) void (^pullToRefreshActionHandler)(void);
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, assign) HLLPullToRefreshState state;
@property (nonatomic, assign) HLLPullToRefreshState previousState;
@property (nonatomic, assign) BOOL isObserving;
@property (nonatomic, assign) CGFloat pullToRefreshContentViewBottomMargin;

@end



@implementation UIScrollView (HLLPullToRefreshView)

NSString * const pullToRefreshContentViewKey;
NSString * const pullToRefreshHandleViewKey;
NSString * const pullToRefreshContentViewBottomMarginKey;

@dynamic showPullToRefresh, pullToRefreshContentView;

- (void)hll_AddPullToRefreshWithHandleView:(UIView <HLLPullToRefreshViewProtocol> *)refreshHandleView actionHandler:(void (^)(void))actionHandler
{
    HLLPullToRefreshContentView *pullToRefreshContentView = self.pullToRefreshContentView;
    if (!pullToRefreshContentView) {
        CGRect refreshViewFrame = CGRectMake(0.0f, -CGRectGetHeight(refreshHandleView.bounds), CGRectGetWidth(self.bounds), CGRectGetHeight(refreshHandleView.bounds));
        HLLPullToRefreshContentView *pullToRefreshContentView = [[HLLPullToRefreshContentView alloc] initWithFrame:refreshViewFrame];
        pullToRefreshContentView.alpha = 0.0f;
        pullToRefreshContentView.scrollView = self;
        [self addSubview:pullToRefreshContentView];
        [pullToRefreshContentView addSubview:refreshHandleView];
        
        pullToRefreshContentView.originalTopInset = self.contentInset.top;
        pullToRefreshContentView.originalBottomInset = self.contentInset.bottom;
        pullToRefreshContentView.pullToRefreshActionHandler = actionHandler;
        self.pullToRefreshContentView = pullToRefreshContentView;
        self.pullToRefreshHandleView = refreshHandleView;
        self.showPullToRefresh = YES;
        
        [pullToRefreshContentView updateLayout];
    }
}

- (void)willRemoveSubview:(UIView *)subview
{
    HLLPullToRefreshContentView *pullToRefreshContentView = self.pullToRefreshContentView;
    if (subview == pullToRefreshContentView && pullToRefreshContentView.isObserving) {
        [self removeObserver:pullToRefreshContentView forKeyPath:@"contentOffset"];
        pullToRefreshContentView.isObserving = NO;
    }
    [super willRemoveSubview:subview];
}

- (void)hll_TriggerPullToRefresh
{
    HLLPullToRefreshContentView *pullToRefreshContentView = self.pullToRefreshContentView;
    if (pullToRefreshContentView.state == HLLPullToRefreshStateLoading || pullToRefreshContentView.hidden) {
        return;
    }
    
    pullToRefreshContentView.state = HLLPullToRefreshStateTriggered;
    
    [pullToRefreshContentView startAnimating];
}

#pragma mark - Setter & Getter

- (CGFloat)pullToRefreshViewHeight
{
    return CGRectGetHeight(self.pullToRefreshContentView.frame);
}

- (void)setPullToRefreshContentView:(HLLPullToRefreshContentView *)pullToRefreshContentView
{
    [self willChangeValueForKey:@"PullToRefreshContentView"];
    objc_setAssociatedObject(self, &pullToRefreshContentViewKey, pullToRefreshContentView, OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"PullToRefreshContentView"];
}

- (HLLPullToRefreshContentView *)pullToRefreshContentView
{
    return objc_getAssociatedObject(self, &pullToRefreshContentViewKey);
}

- (void)setPullToRefreshHandleView:(UIView <HLLPullToRefreshViewProtocol> *)pullToRefreshHandleView
{
    [self willChangeValueForKey:@"PullToRefreshHandleView"];
    objc_setAssociatedObject(self, &pullToRefreshHandleViewKey, pullToRefreshHandleView, OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"PullToRefreshHandleView"];
}

- (UIView <HLLPullToRefreshViewProtocol> *)pullToRefreshHandleView
{
    return objc_getAssociatedObject(self, &pullToRefreshHandleViewKey);
}

- (void)setShowPullToRefresh:(BOOL)showPullToRefresh
{
    HLLPullToRefreshContentView *pullToRefreshContentView = self.pullToRefreshContentView;
    if (pullToRefreshContentView) {
        pullToRefreshContentView.hidden = !showPullToRefresh;
        if (showPullToRefresh) {
            if (!pullToRefreshContentView.isObserving) {
                [self addObserver:pullToRefreshContentView forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
                pullToRefreshContentView.isObserving = YES;
            }
        } else {
            if (pullToRefreshContentView.isObserving) {
                [self removeObserver:pullToRefreshContentView forKeyPath:@"contentOffset"];
                pullToRefreshContentView.isObserving = NO;
            }
        }
    }
}

- (BOOL)showPullToRefresh
{
    HLLPullToRefreshContentView *pullToRefreshContentView = self.pullToRefreshContentView;
    if (pullToRefreshContentView) {
        return !pullToRefreshContentView.hidden;
    }
    return NO;
}

- (void)setPullToRefreshContentViewBottomMargin:(CGFloat)pullToRefreshContentViewBottomMargin
{
    [self willChangeValueForKey:@"PullToRefreshContentViewBottomMargin"];
    self.pullToRefreshContentView.pullToRefreshContentViewBottomMargin = pullToRefreshContentViewBottomMargin;
    [self didChangeValueForKey:@"PullToRefreshContentViewBottomMargin"];
}

- (CGFloat)pullToRefreshContentViewBottomMargin
{
    return self.pullToRefreshContentView.pullToRefreshContentViewBottomMargin;
}

@end

#pragma mark - HLLPullToRefreshContentView

@implementation HLLPullToRefreshContentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.state = HLLPullToRefreshStateStopped;
    }
    
    return self;
}

- (void)setState:(HLLPullToRefreshState)state
{
    UIView <HLLPullToRefreshViewProtocol> *pullToRefreshHandleView = self.scrollView.pullToRefreshHandleView;
    if (self.state != state) {
        _state = state;
        switch (self.state) {
            case HLLPullToRefreshStateStopped:
                [self resetScrollViewContentInset];
                if ([pullToRefreshHandleView respondsToSelector:@selector(HLLPullToRefreshStopped:)]) {
                    [pullToRefreshHandleView HLLPullToRefreshStopped:self.scrollView];
                }
                break;
            case HLLPullToRefreshStateDragging:
                if ([pullToRefreshHandleView respondsToSelector:@selector(HLLPullToRefreshDragging:)]) {
                    [pullToRefreshHandleView HLLPullToRefreshDragging:self.scrollView];
                }
                break;
            case HLLPullToRefreshStateTriggered:
                if ([pullToRefreshHandleView respondsToSelector:@selector(HLLPullToRefreshTriggered:)]) {
                    [pullToRefreshHandleView HLLPullToRefreshTriggered:self.scrollView];
                }
                break;
            case HLLPullToRefreshStateLoading:
                [self setScrollViewContentInsetForLoading];
                if ([pullToRefreshHandleView respondsToSelector:@selector(HLLPullToRefreshLoading:)]) {
                    [pullToRefreshHandleView HLLPullToRefreshLoading:self.scrollView];
                }
                if (self.previousState == HLLPullToRefreshStateTriggered && self.pullToRefreshActionHandler) {
                    self.pullToRefreshActionHandler();
                }
                break;
        }
        
        self.previousState = state;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentOffset"]) {
        CGPoint offsetPoint = [[change valueForKey:NSKeyValueChangeNewKey] CGPointValue];
        [self scrollViewDidScroll:offsetPoint];
    }
}

- (void)scrollViewDidScroll:(CGPoint)contentOffset
{
    CGFloat visibleThreshold = fabs(contentOffset.y + self.originalTopInset) / (self.scrollView.pullToRefreshViewHeight * 1.0f);
    visibleThreshold = MAX(visibleThreshold, 0.0f);
    visibleThreshold = MIN(visibleThreshold, 1.0f);
    
    if (self.autoFadeEffect) {
        self.alpha = visibleThreshold;
    } else {
        self.alpha = 1.0f;
    }
    
    UIView <HLLPullToRefreshViewProtocol> *pullToRefreshHandleView = self.scrollView.pullToRefreshHandleView;
    if (self.state != HLLPullToRefreshStateLoading) {
        // Pull to refresh feature will trigger when user pull it down specific distance of pullToRefreshViewHeight. (Default is 1.5 times height)
        CGFloat triggerDistanceTimes = 1.5f;
        if ([pullToRefreshHandleView respondsToSelector:@selector(HLLPullToRefreshTriggerDistanceTimes:)]) {
            CGFloat distanceTimes = [pullToRefreshHandleView HLLPullToRefreshTriggerDistanceTimes:self.scrollView];
            if (distanceTimes >= 1.0f) {
                triggerDistanceTimes = distanceTimes;
            }
        }
        CGFloat scrollOffsetLimit = self.scrollView.pullToRefreshViewHeight * triggerDistanceTimes;
        CGFloat scrollOffsetThreshold = contentOffset.y + self.scrollView.contentInset.top + scrollOffsetLimit;
        
        if (self.scrollView.isDragging && self.state == HLLPullToRefreshStateStopped && scrollOffsetThreshold < scrollOffsetLimit) {
            self.state = HLLPullToRefreshStateDragging;
        } else if (self.scrollView.isDragging && self.state == HLLPullToRefreshStateDragging && scrollOffsetThreshold < 0.0f ) {
            self.state = HLLPullToRefreshStateTriggered;
        } else if (self.scrollView.isDragging && self.state == HLLPullToRefreshStateTriggered && scrollOffsetThreshold >= 0.0f) {
            self.state = HLLPullToRefreshStateDragging;
        } else if (self.scrollView.isDragging && self.state == HLLPullToRefreshStateDragging && scrollOffsetThreshold > scrollOffsetLimit) {
            self.state = HLLPullToRefreshStateStopped;
        } else if (!self.scrollView.isDragging && self.state == HLLPullToRefreshStateTriggered) {
            self.state = HLLPullToRefreshStateLoading;
        } else if (!self.scrollView.isDragging && self.state != HLLPullToRefreshStateStopped && self.state == HLLPullToRefreshStateDragging && scrollOffsetThreshold >= 0.0f) {
            self.state = HLLPullToRefreshStateStopped;
        } else if (self.detectDisplayStatusMode && self.state == HLLPullToRefreshStateDragging) {
            // Only update display view but not for status.
            if (scrollOffsetThreshold < 0.0f) {
                if ([pullToRefreshHandleView respondsToSelector:@selector(HLLPullToRefreshTriggered:)]) {
                    [pullToRefreshHandleView HLLPullToRefreshTriggered:self.scrollView];
                }
            } else {
                if ([pullToRefreshHandleView respondsToSelector:@selector(HLLPullToRefreshDragging:)]) {
                    [pullToRefreshHandleView HLLPullToRefreshDragging:self.scrollView];
                }
            }
        } else if (self.scrollView.isDragging && self.state == HLLPullToRefreshStateDragging) {
            if ([pullToRefreshHandleView respondsToSelector:@selector(HLLPullToRefreshView:draggingWithProgress:)]) {
                CGFloat progressValue = fabs(contentOffset.y + self.originalTopInset) / (self.scrollView.pullToRefreshViewHeight * triggerDistanceTimes);
                [pullToRefreshHandleView HLLPullToRefreshView:self.scrollView draggingWithProgress:progressValue];
            }
        }
    }
}

- (void)resetScrollViewContentInset
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIEdgeInsets contentInset = self.scrollView.contentInset;
        contentInset.top = self.originalTopInset;
        
        [self setScrollViewContentInset:contentInset];
    });
}

- (void)setScrollViewContentInsetForLoading
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIEdgeInsets currentInsets = self.scrollView.contentInset;
        currentInsets.top = self.originalTopInset + self.scrollView.pullToRefreshViewHeight;
        
        [self setScrollViewContentInset:currentInsets];
    });
}

- (void)setScrollViewContentInset:(UIEdgeInsets)contentInset
{
    self.scrollView.contentInset = contentInset;
}

- (void)setPullToRefreshContentViewBottomMargin:(CGFloat)pullToRefreshContentViewBottomMargin
{
    _pullToRefreshContentViewBottomMargin = pullToRefreshContentViewBottomMargin;
    [self updateLayout];
}

- (void)startAnimating
{
    self.state = HLLPullToRefreshStateLoading;
    
    CGFloat contentOffsetTop = self.scrollView.pullToRefreshViewHeight + self.originalTopInset;
    CGPoint scrollPoint = CGPointMake(self.scrollView.contentOffset.x, -contentOffsetTop);
    
    [UIView animateWithDuration:0.3f
                     animations:^{
                         self.scrollView.contentOffset = scrollPoint;
                     } completion:^(BOOL finished) {
                         // no-op
                     }];
}

- (void)stopAnimating
{
    self.state = HLLPullToRefreshStateStopped;
}

- (void)stopAnimatingAndScrollToTop
{
    [self stopAnimating];
    
    CGFloat contentOffsetTop = self.originalTopInset;
    CGPoint scrollPoint = CGPointMake(self.scrollView.contentOffset.x, -contentOffsetTop);
    [UIView animateWithDuration:.55f
                     animations:^{
                         self.scrollView.contentOffset = scrollPoint;
                     } completion:^(BOOL finished) {
                         // no-op
                     }];
}

- (void)updateLayout
{
    CGRect refreshViewFrame = CGRectMake(0.0f, -(CGRectGetHeight(self.bounds) + self.pullToRefreshContentViewBottomMargin), CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    self.frame = refreshViewFrame;
}


@end