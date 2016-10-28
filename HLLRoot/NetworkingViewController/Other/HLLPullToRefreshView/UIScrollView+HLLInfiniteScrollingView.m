//
//  UIScrollView+HLLInfiniteScrollingView.m
//  HLLPullToRefreshExample
//
//  Created by Rocky Young on 16/8/17.
//  Copyright © 2016年 HLL. All rights reserved.
//
#import <objc/runtime.h>

#import "UIScrollView+HLLInfiniteScrollingView.h"

@interface UIScrollView ()

@property (nonatomic, readonly) CGFloat infiniteScrollingViewHeight;
@property (nonatomic, weak) HLLInfiniteScrollingContentView *infiniteScrollingContentView;
@property (nonatomic, weak) UIView <HLLInfiniteScrollingViewProtocol> *infiniteScrollingHandleView;

@end


@interface HLLInfiniteScrollingContentView ()

- (void)resetScrollViewContentInset;
- (void)setScrollViewContentInsetForLoading;
- (void)setScrollViewContentInset:(UIEdgeInsets)contentInset;
- (void)updateLayout;

@property (nonatomic, copy) void (^infiniteScrollingActionHandler)(void);
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, assign) CGFloat originalTopInset;
@property (nonatomic, assign) CGFloat originalBottomInset;
@property (nonatomic, assign) HLLInfiniteScrollingState state;
@property (nonatomic, assign) HLLInfiniteScrollingState previousState;
@property (nonatomic, assign) BOOL isObserving;

@property (nonatomic, assign) HLLInfiniteScrollingEnableState enableState;
@property (nonatomic ,strong) UIView * noMoreDataView;
@end


@implementation UIScrollView (HLLInfiniteScrollingView)

NSString * const infiniteScrollingContentViewKey;
NSString * const infiniteScrollingHandleViewKey;
@dynamic showInfiniteScrolling, infiniteScrollingContentView;


- (void)hll_AddInfiniteScrollingWithHandleView:(UIView<HLLInfiniteScrollingViewProtocol> *)infiniteScrollingHandleView actionHandler:(void (^)(void))actionHandler
{
    HLLInfiniteScrollingContentView *infiniteScrollingContentView = self.infiniteScrollingContentView;
    if (!infiniteScrollingContentView) {
        CGRect scrollingViewFrame = CGRectMake(0.0f, self.contentSize.height, CGRectGetWidth(self.bounds), CGRectGetHeight(infiniteScrollingHandleView.bounds));
        HLLInfiniteScrollingContentView *infiniteScrollingContentView = [[HLLInfiniteScrollingContentView alloc] initWithFrame:scrollingViewFrame];
        infiniteScrollingContentView.scrollView = self;
        [self addSubview:infiniteScrollingContentView];
        
        [infiniteScrollingContentView addSubview:infiniteScrollingHandleView];
        
        if ([infiniteScrollingHandleView respondsToSelector:@selector(HLLInfiniteScrollViewNoMoreDataView:)]) {
            
            UIView * noMoreDataView = [infiniteScrollingHandleView HLLInfiniteScrollViewNoMoreDataView:self];
            noMoreDataView.hidden = YES;
            [infiniteScrollingContentView addSubview:noMoreDataView];
            
            infiniteScrollingContentView.noMoreDataView = noMoreDataView;
        }
        
        infiniteScrollingContentView.originalTopInset = self.contentInset.top;
        infiniteScrollingContentView.originalBottomInset = self.contentInset.bottom;
        infiniteScrollingContentView.infiniteScrollingActionHandler = actionHandler;
        self.infiniteScrollingContentView = infiniteScrollingContentView;
        self.infiniteScrollingHandleView = infiniteScrollingHandleView;
        self.showInfiniteScrolling = YES;
        
        [infiniteScrollingContentView updateLayout];
    }
}

- (void)hll_TriggerInfiniteScrollingWithAnimation:(BOOL)animated
{
    HLLInfiniteScrollingContentView *infiniteScrollingContentView = self.infiniteScrollingContentView;
    if (infiniteScrollingContentView.state == HLLInfiniteScrollingStateLoading || infiniteScrollingContentView.hidden) {
        return;
    }
    
    infiniteScrollingContentView.state = HLLInfiniteScrollingStateTriggered;
    
    if (!animated) {
        infiniteScrollingContentView.state = HLLInfiniteScrollingStateLoading;
    } else {
        [infiniteScrollingContentView startAnimating];
    }
}

#pragma mark - Setter & Getter

- (CGFloat)infiniteScrollingViewHeight
{
    return CGRectGetHeight(self.infiniteScrollingContentView.frame);
}

- (void)setInfiniteScrollingContentView:(HLLInfiniteScrollingContentView *)infiniteScrollingContentView
{
    [self willChangeValueForKey:@"InfiniteScrollingContentView"];
    objc_setAssociatedObject(self, &infiniteScrollingContentViewKey, infiniteScrollingContentView, OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"InfiniteScrollingContentView"];
}

- (HLLInfiniteScrollingContentView *)infiniteScrollingContentView
{
    return objc_getAssociatedObject(self, &infiniteScrollingContentViewKey);
}

- (void)setInfiniteScrollingHandleView:(UIView<HLLInfiniteScrollingViewProtocol> *)infiniteScrollingHandleView
{
    [self willChangeValueForKey:@"InfiniteScrollingHandleView"];
    objc_setAssociatedObject(self, &infiniteScrollingHandleViewKey, infiniteScrollingHandleView, OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"InfiniteScrollingHandleView"];
}

- (UIView <HLLInfiniteScrollingViewProtocol> *)infiniteScrollingHandleView
{
    return objc_getAssociatedObject(self, &infiniteScrollingHandleViewKey);
}

- (void)setShowInfiniteScrolling:(BOOL)showInfiniteScrolling
{
    HLLInfiniteScrollingContentView *infiniteScrollingContentView = self.infiniteScrollingContentView;
    if (infiniteScrollingContentView) {
        infiniteScrollingContentView.hidden = !showInfiniteScrolling;
        if (showInfiniteScrolling) {
            if (!infiniteScrollingContentView.isObserving) {
                [self addObserver:infiniteScrollingContentView forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
                [self addObserver:infiniteScrollingContentView forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
                infiniteScrollingContentView.isObserving = YES;
            }
        } else {
            if (infiniteScrollingContentView.isObserving) {
                [self removeObserver:infiniteScrollingContentView forKeyPath:@"contentOffset"];
                [self removeObserver:infiniteScrollingContentView forKeyPath:@"contentSize"];
                infiniteScrollingContentView.isObserving = NO;
            }
        }
    }
}

- (BOOL)showInfiniteScrolling
{
    HLLInfiniteScrollingContentView *infiniteScrollingContentView = self.infiniteScrollingContentView;
    if (infiniteScrollingContentView) {
        return !infiniteScrollingContentView.hidden;
    }
    return NO;
}

- (void)willRemoveSubview:(UIView *)subview
{
    HLLInfiniteScrollingContentView *infiniteScrollingContentView = self.infiniteScrollingContentView;
    if (subview == infiniteScrollingContentView && infiniteScrollingContentView.isObserving) {
        [self removeObserver:infiniteScrollingContentView forKeyPath:@"contentOffset"];
        [self removeObserver:infiniteScrollingContentView forKeyPath:@"contentSize"];
        infiniteScrollingContentView.isObserving = NO;
    }
    [super willRemoveSubview:subview];
}

@end


@implementation HLLInfiniteScrollingContentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.state = HLLInfiniteScrollingStateStopped;
        self.alwaysDisplayNoMoreDataView = NO;
        self.enableState = HLLInfiniteScrollingStateNormal;
    }
    
    return self;
}

- (void) setupState:(HLLInfiniteScrollingEnableState)state{

    if (self.enableState != state) {
        _enableState = state;
        
        if (state == HLLInfiniteScrollingStateNormal) {
        
            self.noMoreDataView.hidden = YES;
        }
        
        if (state == HLLInfiniteScrollingStateNoMore) {
            
            self.noMoreDataView.hidden = NO;
        }
        
        if (self.alwaysDisplayNoMoreDataView) {
            [self setScrollViewContentInsetForLoading];
        }else{
            [self resetScrollViewContentInset];
        }
    }
}

- (void)setState:(HLLInfiniteScrollingState)state
{
    
    if (self.enableState != HLLInfiniteScrollingStateNormal) {
        return;
    }
    if (self.state != state) {
        _state = state;
        UIView <HLLInfiniteScrollingViewProtocol> *infiniteScrollingHandleView = self.scrollView.infiniteScrollingHandleView;
        
        switch (self.state) {
            case HLLInfiniteScrollingStateStopped:
                [self resetScrollViewContentInset];
                if ([infiniteScrollingHandleView respondsToSelector:@selector(HLLInfiniteScrollingStopped:)]) {
                    [infiniteScrollingHandleView HLLInfiniteScrollingStopped:self.scrollView];
                }
                break;
            case HLLInfiniteScrollingStateDragging:
                if ([infiniteScrollingHandleView respondsToSelector:@selector(HLLInfiniteScrollingDragging:)]) {
                    [infiniteScrollingHandleView HLLInfiniteScrollingDragging:self.scrollView];
                }
                break;
            case HLLInfiniteScrollingStateTriggered:
                if ([infiniteScrollingHandleView respondsToSelector:@selector(HLLInfiniteScrollingTriggered:)]) {
                    [infiniteScrollingHandleView HLLInfiniteScrollingTriggered:self.scrollView];
                }
                break;
            case HLLInfiniteScrollingStateLoading:
                [self setScrollViewContentInsetForLoading];
                if ([infiniteScrollingHandleView respondsToSelector:@selector(HLLInfiniteScrollingLoading:)]) {
                    [infiniteScrollingHandleView HLLInfiniteScrollingLoading:self.scrollView];
                }
                if (self.previousState == HLLInfiniteScrollingStateTriggered && self.infiniteScrollingActionHandler) {
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        
                        self.infiniteScrollingActionHandler();
                    });
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
    } else if ([keyPath isEqualToString:@"contentSize"]) {
        [self updateLayout];
    }
}

- (void)scrollViewDidScroll:(CGPoint)contentOffset
{
    CGFloat visibleThreshold = (contentOffset.y + CGRectGetHeight(self.scrollView.bounds) - self.scrollView.contentSize.height) / (self.scrollView.infiniteScrollingViewHeight * 1.0f);
    visibleThreshold = MAX(visibleThreshold, 0.0f);
    visibleThreshold = MIN(visibleThreshold, 1.0f);
    
    if (self.autoFadeEffect) {
        self.alpha = visibleThreshold;
    } else {
        self.alpha = 1.0f;
    }
    
    if (self.state != HLLInfiniteScrollingStateLoading) {
        // Infinite scrolling feature will trigger when user scroll to bottom over specific distance of infiniteScrollingViewHeight. (Default is 1.0 time height)
        CGFloat triggerDistanceTimes = 1.0f;
        UIView <HLLInfiniteScrollingViewProtocol> *infiniteScrollingHandleView = self.scrollView.infiniteScrollingHandleView;
        if ([infiniteScrollingHandleView respondsToSelector:@selector(HLLInfiniteScrollingTriggerDistanceTimes:)]) {
            if ([infiniteScrollingHandleView HLLInfiniteScrollingTriggerDistanceTimes:self.scrollView] >= 1.0f) {
                triggerDistanceTimes = [infiniteScrollingHandleView HLLInfiniteScrollingTriggerDistanceTimes:self.scrollView];
            }
        }
        
        CGFloat scrollOffsetLimit = self.scrollView.contentInset.bottom + self.scrollView.infiniteScrollingViewHeight * triggerDistanceTimes;
        CGFloat scrollOffsetThreshold = self.scrollView.contentSize.height - CGRectGetHeight(self.scrollView.bounds) - contentOffset.y + scrollOffsetLimit;
        
        if (self.scrollView.isDragging && self.state == HLLInfiniteScrollingStateStopped && scrollOffsetThreshold < scrollOffsetLimit) {
            self.state = HLLInfiniteScrollingStateDragging;
        } else if (self.scrollView.isDragging && self.state == HLLInfiniteScrollingStateDragging && scrollOffsetThreshold >= scrollOffsetLimit) {
            self.state = HLLInfiniteScrollingStateStopped;
        } else if (self.scrollView.isDragging && self.state == HLLInfiniteScrollingStateDragging && scrollOffsetThreshold <= 0.0f ) {
            self.state = HLLInfiniteScrollingStateTriggered;
        } else if (self.scrollView.isDragging && self.state != HLLInfiniteScrollingStateStopped && scrollOffsetThreshold > 0.0f) {
            self.state = HLLInfiniteScrollingStateDragging;
        } else if (!self.scrollView.isDragging && self.state == HLLInfiniteScrollingStateTriggered) {
            self.state = HLLInfiniteScrollingStateLoading;
        } else if (!self.scrollView.isDragging && self.state == HLLInfiniteScrollingStateDragging && scrollOffsetThreshold <= scrollOffsetLimit ) {
            self.state = HLLInfiniteScrollingStateStopped;
        }
        
        if (self.scrollView.isDragging && self.state == HLLInfiniteScrollingStateDragging) {
            if ([infiniteScrollingHandleView respondsToSelector:@selector(HLLInfiniteScrollView:draggingWithProgress:)]) {
                CGFloat progressValue = (contentOffset.y + CGRectGetHeight(self.scrollView.bounds) - self.scrollView.contentSize.height) / (self.scrollView.infiniteScrollingViewHeight * triggerDistanceTimes);
                [infiniteScrollingHandleView HLLInfiniteScrollView:self.scrollView draggingWithProgress:progressValue];
            }
        }
    }
}

- (void)resetScrollViewContentInset
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIEdgeInsets currentInsets = self.scrollView.contentInset;
        currentInsets.bottom = self.originalBottomInset;
        
        [self setScrollViewContentInset:currentInsets];
    });
}

- (void)setScrollViewContentInsetForLoading
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIEdgeInsets currentInsets = self.scrollView.contentInset;
        CGFloat contentInsetsBottom = self.scrollView.infiniteScrollingViewHeight + self.originalBottomInset;
        contentInsetsBottom = MAX(contentInsetsBottom, CGRectGetHeight(self.scrollView.bounds) - self.scrollView.contentSize.height + self.scrollView.infiniteScrollingViewHeight - self.originalTopInset);
        currentInsets.bottom = contentInsetsBottom;
        
        [self setScrollViewContentInset:currentInsets];
    });
}

- (void)setScrollViewContentInset:(UIEdgeInsets)contentInset
{
    [UIView animateWithDuration:0.25 animations:^{
        
        self.scrollView.contentInset = contentInset;
    }];
}

- (void)startAnimating
{
    CGFloat contentOffsetBottom = self.scrollView.contentSize.height - CGRectGetHeight(self.scrollView.bounds) + self.scrollView.contentInset.bottom + self.scrollView.infiniteScrollingViewHeight;
    contentOffsetBottom = MAX(contentOffsetBottom, self.scrollView.infiniteScrollingViewHeight - self.originalTopInset);
    
    CGPoint scrollPoint = CGPointMake(self.scrollView.contentOffset.x, contentOffsetBottom);
    [UIView animateWithDuration:0.3f
                     animations:^{
                         self.scrollView.contentOffset = scrollPoint;
                     } completion:^(BOOL finished) {
                         // no-op
                     }];
    
    self.state = HLLInfiniteScrollingStateLoading;
}

- (void)stopAnimating
{
    self.state = HLLInfiniteScrollingStateStopped;
}

- (void)updateLayout
{
    CGFloat infiniteScrollPositionY = MAX(self.scrollView.contentSize.height, CGRectGetHeight(self.scrollView.bounds) - self.originalTopInset - self.originalBottomInset);
    CGRect scrollingViewFrame = CGRectMake(0.0f, infiniteScrollPositionY, CGRectGetWidth(self.scrollView.bounds), CGRectGetHeight(self.bounds));
    self.frame = scrollingViewFrame;
}


@end
