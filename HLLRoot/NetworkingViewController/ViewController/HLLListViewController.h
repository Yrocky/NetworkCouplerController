//
//  HLLListViewController.h
//  HLLRoot
//
//  Created by Rocky Young on 16/10/23.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import "HLLBaseViewController.h"
#import "HLLBasePagingAdapter.h"
#import "HLLNoDataView.h"
#import "MJRefresh.h"

@interface HLLListViewController : HLLBaseViewController<UITableViewDataSource, UITableViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, readonly) HLLBasePagingAdapter * listRequest;

@property (strong, nonatomic) UITableView * tableView;

@property (strong, nonatomic) UICollectionView * collectionView;

- (HLLBasePagingAdapter *)generateListRequest;

- (void) configureTableView;

- (void) configureCollectionView;

#pragma mark -
#pragma mark RefreshView

- (void) addRefreshForListView:(UIScrollView *)scrollView
                  headerHandle:(void(^)())headerHandle
                  footerHandle:(void(^)())footerHandle;
- (void) addRefreshForListView:(UIScrollView *)scrollView
                  headerHandle:(void(^)())headerHandle;
- (void) addRefreshForListView:(UIScrollView *)scrollView
                  footerHandle:(void(^)())footerHandle;

/** `header:`下拉刷新的时候进行处理，`footer:`上提加载的时候进行处理，`noMore:`即用于下拉也用于上提 */
/** 如果是下拉刷新，`noMore`根据返回的数据个数决定1-0，并且要处理是否显示`noDataView视图` */
/** 如果是上提加载，`noMore`根据返回的数据个数决定1-0 */
- (void) hidenRefreshForListView:(UIScrollView *)scrollView
                          header:(BOOL)header
                          footer:(BOOL)footer
                      noMoreData:(BOOL)noMore;

#pragma mark -
#pragma mark NoDataView

- (void) addNoDataView:(NSString *)title image:(NSString *)imageName;
- (void) autoHidenNoDataView:(BOOL)hiden;
@end




/*///////////////
 
 添加下拉刷新以及上拉加载更多控件，具体控制状态见以上方法
 
 ///////////////*/





/*///////////////
 
 使用`-addNoDataView:image:`方法为列表视图添加在没有数据显示时候的占位视图，
 注意这个方法要在`tableView`进行初始化并且设置rect之后进行调用
 
 使用`-autoHidenNoDataView:`进行占位视图的显示与隐藏
 
 ///////////////*/





/*///////////////
 
 <##>
 
 ///////////////*/







