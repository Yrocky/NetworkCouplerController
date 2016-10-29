//
//  TestPageRequestThirdViewController.m
//  HLLRoot
//
//  Created by Rocky Young on 16/10/24.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import "TestPageRequestThirdViewController.h"
#import "PullToRefreshView.h"

@interface TestPageRequestThirdViewController ()

@end

@implementation TestPageRequestThirdViewController

-(void)viewDidLoad{
    
    [super viewDidLoad];
    
    self.allowHUDWhenRequestLoading = NO;
    
    __weak typeof(self) weakSelf = self;
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - 64.0f);
    self.tableView.tableFooterView = [UIView new];
    [self configureTableView];
    [self.view addSubview:self.tableView];
    
    [self addNoDataView:@"没有数据~" image:@"no_data"];
    
    [self addRefreshForListView:self.tableView headerHandle:^{
        
        [weakSelf.listRequest refresh];
    } footerHandle:^{
        
        [weakSelf.listRequest loadMore];
    } ];
}

- (HLLBaseRequestAdapter *)generateListRequest{
    
    return [[TestPageThridAPI alloc] init];
}

- (void)refreshUIWithRequest:(HLLBaseRequestAdapter *)request withUserInfo:(id)userInfo{
    
    [self.tableView reloadData];
}

- (void)dealloc
{
    // 如果使用了`UIScrollView+HLLInfiniteScrollingView`以及`UIScrollView+HLLPullToRefreshView`
    // 必须要在控制器dealloc的时候进行如下操作来去除监听
    self.tableView.showInfiniteScrolling = NO;
    self.tableView.showPullToRefresh = NO;
}

#pragma mark -
#pragma mark UITableViewDataSource,UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    id data = [self.listRequest objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textColor = [UIColor colorWithHexString:@"#6F818D"];
    cell.textLabel.text = [NSString stringWithFormat:@"NO.%ld\t%@\t%@",(long)indexPath.row + 1,data[@"title"],data[@"year"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark CustomPullToRefreshView

- (void) addRefreshForListView:(UIScrollView *)scrollView headerHandle:(void(^)())headerHandle{
    
    // add pull to refresh
    PullToRefreshView * pullToRefreshView = [[PullToRefreshView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(scrollView.bounds), 60)];
    [scrollView hll_AddPullToRefreshWithHandleView:pullToRefreshView
                                     actionHandler:headerHandle];
    scrollView.pullToRefreshContentView.autoFadeEffect = YES;
    scrollView.pullToRefreshContentView.detectDisplayStatusMode = YES;
    [scrollView hll_TriggerPullToRefresh];
}

- (void) addRefreshForListView:(UIScrollView *)scrollView footerHandle:(void(^)())footerHandle{
    
    // add bottom view
    PullToRefreshView * infiniteScrollingView = [[PullToRefreshView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(scrollView.bounds), 60)];
    [scrollView hll_AddInfiniteScrollingWithHandleView:infiniteScrollingView
                                         actionHandler:footerHandle];
    scrollView.infiniteScrollingContentView.alwaysDisplayNoMoreDataView = YES;
    scrollView.infiniteScrollingContentView.autoFadeEffect = YES;
}

- (void) hidenRefreshForListView:(UIScrollView *)scrollView header:(BOOL)header footer:(BOOL)footer noMoreData:(BOOL)noMore{
    
    if (header) {
        
        [scrollView.pullToRefreshContentView stopAnimatingAndScrollToTop];
        
        [self autoHidenNoDataView:!noMore];
        
        [scrollView.infiniteScrollingContentView setupState:HLLInfiniteScrollingStateNormal];
    }
    if (footer) {
        
        [scrollView.infiniteScrollingContentView stopAnimating];
        
        [self autoHidenNoDataView:YES];
        
        if (noMore) {
            
            [scrollView.infiniteScrollingContentView setupState:HLLInfiniteScrollingStateNoMore];
        }else{

            [scrollView.infiniteScrollingContentView setupState:HLLInfiniteScrollingStateNormal];
        }
    }
}

@end


@implementation TestPageThridAPI

- (void)refresh
{
    self.currentPage = 0;
    [self start];
}

- (void)loadMore
{
    self.currentPage += self.pageSize;
    [self start];
}

- (NSString *)userInfo{
    
    return @"test-list-thrid-api";
}

- (void)start{
    
    NSDictionary * parmars = @{@"start":@(self.currentPage),
                               @"count":@(self.pageSize)};
    
    [self get:@"https://api.douban.com/v2/movie/top250" parameters:parmars userInfo:self.userInfo];
}

- (NSArray *)parsePage:(id)response withUserInfo:(id)userInfo{
    
    return response[@"subjects"];
}
@end




