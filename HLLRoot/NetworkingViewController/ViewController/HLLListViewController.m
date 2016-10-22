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
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self configureBaseListRequest];
}

- (void) refreshUIWithRequest:(HLLBaseRequestAdapter *)request withUserInfo:(id)userInfo{
    
    [super refreshUIWithRequest:request withUserInfo:userInfo];
    
    [self.tableView reloadData];
}

- (void) configureBaseListRequest{
    
    _listRequest = [self generateListRequest];
    _listRequest.delegate = self;
    [_listRequest refresh];
}

#pragma mark -
#pragma mark API

- (HLLBaseListItem *)generateListRequest{
    
    /** 供子类重写，进行生成可以分页请求的网络加载 */
    return nil;
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
    
    
}

- (void)requestAdapter:(HLLBaseRequestAdapter *)requestAdapter didFailWithError:(NSError *)error{
    
    [super requestAdapter:requestAdapter didFailWithError:error];
    
    
}
@end
