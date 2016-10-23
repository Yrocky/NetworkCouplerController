//
//  HLLListViewController.m
//  HLLRoot
//
//  Created by Rocky Young on 16/10/23.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import "HLLListViewController.h"

@interface HLLListViewController ()

@end

@implementation HLLListViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureBaseListRequest];
}

- (void) configureBaseListRequest{
    
    _listRequest = [self generateListRequest];
    _listRequest.delegate = self;
}

#pragma mark -
#pragma mark API

- (HLLBaseListItem *)generateListRequest{
    
    /** 供子类重写，进行生成可以分页请求的网络加载 */
    return nil;
}

- (void) configureTableView{

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

#pragma mark NoDataView

- (void) addNoDataView:(NSString *)title image:(NSString *)imageName{

    CGRect noDataViewFrame = CGRectMake(0, 0, CGRectGetWidth(self.tableView.bounds), CGRectGetHeight(self.tableView.bounds));
    HLLNoDataView * noDataView = [[HLLNoDataView alloc] initWithFrame:noDataViewFrame];
    [noDataView configureNoDataViewWithCapion:title alertImage:[UIImage imageNamed:imageName]];
    self.tableView.noDataView = noDataView;
}

- (void) autoHidenNoDataView:(BOOL)hiden{

    self.tableView.noDataView.hidden = hiden;
}

#pragma mark -
#pragma mark UITableViewDataSource,UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    /** 子类可以重写改数据源方法 */
    return self.listRequest.items.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    /** 不建议在这里做很多东西，子类可以重写改数据源方法 */
    return nil;
}



#pragma mark -
#pragma mark HLLBaseRequestAdapterProtocol

- (void)requestAdapterDidStartRequest:(HLLBaseRequestAdapter *)requestAdapter{

    [super requestAdapterDidStartRequest:requestAdapter];
    
    
}

- (void)requestAdapter:(HLLBaseRequestAdapter *)requestAdapter didCompleteWithUserInfo:(id)userInfo{
    
    [super requestAdapter:requestAdapter didCompleteWithUserInfo:userInfo];
    
    [self hidenRefreshForTableView:self.tableView
                            header:self.listRequest.currentPage == 0
                            footer:self.listRequest.currentPage != 0
                        noMoreData:self.listRequest.result.count == 0];
}

- (void)requestAdapter:(HLLBaseRequestAdapter *)requestAdapter didFailWithError:(NSError *)error{
    
    [super requestAdapter:requestAdapter didFailWithError:error];
    
    [self hidenRefreshForTableView:self.tableView
                            header:YES
                            footer:YES
                        noMoreData:NO];
}


#pragma mark -
#pragma mark MJRefresh

- (void) addRefreshForTableView:(UIScrollView *)scrollView headerHandle:(void(^)())headerHandle footerHandle:(void(^)())footerHandle{
    
    [self addRefreshForTableView:scrollView headerHandle:headerHandle];
    [self addRefreshForTableView:scrollView footerHandle:footerHandle];
}

- (void) addRefreshForTableView:(UIScrollView *)scrollView headerHandle:(void(^)())headerHandle{
    
    //添加下拉刷新
    scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:headerHandle];
    scrollView.mj_header.automaticallyChangeAlpha = YES;
    MJRefreshNormalHeader * header = (MJRefreshNormalHeader *)scrollView.mj_header;
    header.lastUpdatedTimeLabel.hidden = YES;// 隐藏时间label
    [scrollView.mj_header beginRefreshing];
}

- (void) addRefreshForTableView:(UIScrollView *)scrollView footerHandle:(void(^)())footerHandle{
    
    // 添加上拉加载更多
    scrollView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:footerHandle];
}

- (void) hidenRefreshForTableView:(UIScrollView *)scrollView header:(BOOL)header footer:(BOOL)footer noMoreData:(BOOL)noMore{
    
    if (header) {
        
        [scrollView.mj_header endRefreshing];
        
        [scrollView.mj_footer setState:MJRefreshStateIdle];
        
        [self autoHidenNoDataView:!noMore];
    }
    if (footer) {
        
        [scrollView.mj_footer endRefreshing];
        
        [self autoHidenNoDataView:YES];

        if (noMore) {
            
            [scrollView.mj_footer setState:MJRefreshStateNoMoreData];
        }else{
            
            [scrollView.mj_footer setState:MJRefreshStateIdle];
        }
    }
}

@end
