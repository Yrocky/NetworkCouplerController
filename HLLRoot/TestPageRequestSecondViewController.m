//
//  TestPageRequestSecondViewController.m
//  HLLRoot
//
//  Created by Rocky Young on 16/10/24.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import "TestPageRequestSecondViewController.h"
#import "TestCollectionViewCell.h"

@interface TestPageRequestSecondViewController ()

@end

@implementation TestPageRequestSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.allowHUDWhenRequestLoading = NO;
    
    __weak typeof(self) weakSelf = self;
    
    NSInteger count = 3;
    CGFloat margin = 10;
    CGFloat width = (CGRectGetWidth(self.view.frame) - (count + 1) * margin) / 3;
    CGFloat height = width * 1.5;
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(10, margin, 10, margin);
    layout.minimumLineSpacing = margin;
    layout.minimumInteritemSpacing = margin;
    layout.itemSize = CGSizeMake(width, height);
    
    CGRect frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - 64.0f);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
    [self configureCollectionView];
    [self.collectionView registerNib:[TestCollectionViewCell nib]
          forCellWithReuseIdentifier:[TestCollectionViewCell cellIdentifier]];
    [self.view addSubview:self.collectionView];
    
    [self addNoDataView:@"没有数据~" image:@"no_data"];
    
    [self addRefreshForListView:self.collectionView headerHandle:^{
        
        [weakSelf.listRequest refresh];
    } footerHandle:^{
        
        [weakSelf.listRequest loadMore];
    } ];
}

- (HLLBaseRequestAdapter *)generateListRequest{
    
    return [[TestPageSecondAPI alloc] initWithNetworkManager:self.networkManager];
}

- (void)refreshUIWithRequest:(TestPageSecondAPI *)request withUserInfo:(id)userInfo{
    
    [self.collectionView reloadData];
}

#pragma mark -
#pragma mark UICollectionViewDataSource,UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.listRequest.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    TestCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:[TestCollectionViewCell cellIdentifier] forIndexPath:indexPath];
    
    id data = [self.listRequest objectAtIndex:indexPath.item];
    
    [cell configureCellWithData:data atIndexPath:indexPath];

    return cell;
}
@end


@implementation TestPageSecondAPI

- (void)refresh
{
    self.currentPage = 0;
    [self startRequest];
}

- (void)loadMore
{
    self.currentPage += self.pageSize;
    [self startRequest];
}

- (NSString *)userInfo{
    
    return @"test-list-api";
}

- (void)startRequest{
    
    NSDictionary * parmars = @{@"start":@(self.currentPage),
                               @"count":@(self.pageSize)};
    
    [self get:@"https://api.douban.com/v2/movie/top250" parameters:parmars userInfo:self.userInfo];
}

- (NSArray *)parsePage:(id)response withUserInfo:(id)userInfo{
    
    return response[@"subjects"];
}
@end






