//
//  TestPageRequestViewController.m
//  HLLRoot
//
//  Created by Rocky Young on 16/10/23.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import "TestPageRequestViewController.h"

@implementation TestPageRequestViewController


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

    return [[TestPageAPI alloc] initWithNetworkManager:self.networkManager];
}

- (void)refreshUIWithRequest:(TestPageAPI *)request withUserInfo:(id)userInfo{

    NSLog(@"%lu",(unsigned long)request.list.count);
    [self.tableView reloadData];

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

@end


@implementation TestPageAPI

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

    return @"test-list-api";
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





/*///////////////
 
 这里使用的豆瓣Top250的接口，但是这个接口的`currentPage`是从第几个开始，所以这里需要重写`-refresh`方法和`loadMore`方法
 
 ///////////////*/







