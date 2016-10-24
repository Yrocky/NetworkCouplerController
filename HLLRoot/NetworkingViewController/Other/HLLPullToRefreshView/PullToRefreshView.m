//
//  PullToRefreshView.m
//  HLLPullToRefreshExample
//
//  Created by Rocky Young on 16/8/17.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import "PullToRefreshView.h"

@interface PullToRefreshView ()

@end

@implementation PullToRefreshView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor lightGrayColor];
        self.indicatorView = ({
            UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
            indicatorView.center = CGPointMake(self.center.x, self.center.y - 10.0f);
            indicatorView;
        });
        [self addSubview:self.indicatorView];
        
        self.indicatorLabel = ({
            UILabel *indicatorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.frame.size.width, 20.0f)];
            indicatorLabel.center = CGPointMake(self.center.x, CGRectGetMaxY(self.indicatorView.frame) + 10.0f);
            indicatorLabel.textAlignment = NSTextAlignmentCenter;
            indicatorLabel.textColor = [UIColor whiteColor];
            indicatorLabel;
        });
        [self addSubview:self.indicatorLabel];
    }
    
    return self;
}


- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    [self stopIndicatorView];
}

#pragma mark - UI update
- (void)stopIndicatorView
{
    self.indicatorView.hidden = YES;
    [self.indicatorView stopAnimating];
    self.indicatorLabel.text = NSStringFromSelector(_cmd);
    self.indicatorLabel.textColor = [UIColor lightTextColor];
}

#pragma mark - HLLPullToRefreshViewProtocol

- (void)HLLPullToRefreshStopped:(UIScrollView *)scrollView
{
    [self stopIndicatorView];
}

- (void)HLLPullToRefreshDragging:(UIScrollView *)scrollView
{
    self.indicatorLabel.text = NSStringFromSelector(_cmd);
    self.indicatorLabel.textColor = [UIColor lightTextColor];
}

- (void)HLLPullToRefreshView:(UIScrollView *)scrollView draggingWithProgress:(CGFloat)progress
{
    self.indicatorView.hidden = YES;
    int progressPercent = progress * 100;
    self.indicatorLabel.text = [NSString stringWithFormat:@" %d%% ", progressPercent];
    self.indicatorLabel.textColor = [UIColor lightTextColor];
}

- (void)HLLPullToRefreshTriggered:(UIScrollView *)scrollView
{
    self.indicatorView.hidden = NO;
    self.indicatorLabel.text = NSStringFromSelector(_cmd);
    self.indicatorLabel.textColor = [UIColor orangeColor];
}

- (void)HLLPullToRefreshLoading:(UIScrollView *)scrollView
{
    [self.indicatorView startAnimating];
    self.indicatorLabel.text = NSStringFromSelector(_cmd);
    self.indicatorLabel.textColor = [UIColor whiteColor];
}
- (CGFloat)HLLPullToRefreshTriggerDistanceTimes:(UIScrollView *)scrollView{

    return 1.f;
}

#pragma mark - HLLInfiniteScrollingViewProtocol

- (void)HLLInfiniteScrollingStopped:(UIScrollView *)scrollView
{
    [self stopIndicatorView];
}

- (void)HLLInfiniteScrollingDragging:(UIScrollView *)scrollView
{
    self.indicatorLabel.text = NSStringFromSelector(_cmd);
    self.indicatorLabel.textColor = [UIColor lightTextColor];
}

- (void)HLLInfiniteScrollView:(UIScrollView *)scrollView draggingWithProgress:(CGFloat)progress
{
    self.indicatorView.hidden = YES;
    int progressPercent = progress * 100;
    self.indicatorLabel.text = [NSString stringWithFormat:@" %d%% ",progressPercent];
    self.indicatorLabel.textColor = [UIColor lightTextColor];
}

- (void)HLLInfiniteScrollingTriggered:(UIScrollView *)scrollView
{
    self.indicatorView.hidden = NO;
    self.indicatorLabel.text = NSStringFromSelector(_cmd);
    self.indicatorLabel.textColor = [UIColor orangeColor];
}

- (void)HLLInfiniteScrollingLoading:(UIScrollView *)scrollView
{
    [self.indicatorView startAnimating];
    self.indicatorLabel.text = NSStringFromSelector(_cmd);
    self.indicatorLabel.textColor = [UIColor whiteColor];
}

- (CGFloat)HLLInfiniteScrollingTriggerDistanceTimes:(UIScrollView *)scrollView
{
    return 1.3f;
}

@end
