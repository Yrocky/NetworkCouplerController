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
        self.backgroundColor = [UIColor whiteColor];
        self.indicatorView = ({
            UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
            indicatorView.center = CGPointMake(self.center.x, self.center.y - 10.0f);
            indicatorView.color = [UIColor colorWithHexString:@"84949E"];
            indicatorView;
        });
        [self addSubview:self.indicatorView];
        
        self.indicatorLabel = ({
            UILabel *indicatorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.frame.size.width, 20.0f)];
            indicatorLabel.center = CGPointMake(self.center.x, CGRectGetMaxY(self.indicatorView.frame) + 10.0f);
            indicatorLabel.textAlignment = NSTextAlignmentCenter;
            indicatorLabel.textColor = [UIColor colorWithHexString:@"84949E"];
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
    self.indicatorLabel.textColor = [UIColor colorWithHexString:@"84949E"];
}

#pragma mark - HLLPullToRefreshViewProtocol

- (void)HLLPullToRefreshStopped:(UIScrollView *)scrollView
{
    [self stopIndicatorView];
}

- (void)HLLPullToRefreshDragging:(UIScrollView *)scrollView
{
    self.indicatorLabel.text = NSStringFromSelector(_cmd);
    self.indicatorLabel.textColor = [UIColor colorWithHexString:@"84949E"];
}

- (void)HLLPullToRefreshView:(UIScrollView *)scrollView draggingWithProgress:(CGFloat)progress
{
    self.indicatorView.hidden = YES;
    int progressPercent = progress * 100;
    self.indicatorLabel.text = [NSString stringWithFormat:@" %d%% ", progressPercent];
    self.indicatorLabel.textColor = [UIColor colorWithHexString:@"84949E"];
}

- (void)HLLPullToRefreshTriggered:(UIScrollView *)scrollView
{
    self.indicatorView.hidden = NO;
    self.indicatorLabel.text = NSStringFromSelector(_cmd);
    self.indicatorLabel.textColor = [UIColor colorWithHexString:@"84949E"];
}

- (void)HLLPullToRefreshLoading:(UIScrollView *)scrollView
{
    [self.indicatorView startAnimating];
    self.indicatorLabel.text = NSStringFromSelector(_cmd);
    self.indicatorLabel.textColor = [UIColor colorWithHexString:@"84949E"];
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
    self.indicatorLabel.textColor = [UIColor colorWithHexString:@"84949E"];
}

- (void)HLLInfiniteScrollView:(UIScrollView *)scrollView draggingWithProgress:(CGFloat)progress
{
    self.indicatorView.hidden = YES;
    int progressPercent = progress * 100;
    self.indicatorLabel.text = [NSString stringWithFormat:@" %d%% ",progressPercent];
    self.indicatorLabel.textColor = [UIColor colorWithHexString:@"84949E"];
}

- (void)HLLInfiniteScrollingTriggered:(UIScrollView *)scrollView
{
    self.indicatorView.hidden = NO;
    self.indicatorLabel.text = NSStringFromSelector(_cmd);
    self.indicatorLabel.textColor = [UIColor colorWithHexString:@"#FE8A8A"];
}

- (void)HLLInfiniteScrollingLoading:(UIScrollView *)scrollView
{
    [self.indicatorView startAnimating];
    self.indicatorLabel.text = NSStringFromSelector(_cmd);
    self.indicatorLabel.textColor = [UIColor colorWithHexString:@"84949E"];
}

- (CGFloat)HLLInfiniteScrollingTriggerDistanceTimes:(UIScrollView *)scrollView
{
    return 1.3f;
}

- (UIView *)HLLInfiniteScrollViewNoMoreDataView:(UIScrollView *)scrollView{

    UILabel * noMoreDataView = [[UILabel alloc] initWithFrame:self.bounds];
    [noMoreDataView setText:@"所有数据都已经加载完了~"];
    [noMoreDataView setTextColor:[UIColor colorWithHexString:@"#FE8A8A"]];
    [noMoreDataView setFont:[UIFont systemFontOfSize:14]];
    [noMoreDataView setTextAlignment:NSTextAlignmentCenter];
    [noMoreDataView setBackgroundColor:[UIColor whiteColor]];
    return noMoreDataView;
}
@end
