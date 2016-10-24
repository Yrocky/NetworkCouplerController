//
//  ViewController.m
//  HLLRoot
//
//  Created by Rocky Young on 16/10/20.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import "ViewController.h"
#import "TestOneRequestViewController.h"
#import "TestMultiRequestViewController.h"
#import "TestPageRequestViewController.h"
#import "TestDownloadRequestViewController.h"
#import "TestUploadRequestViewController.h"
#import "TestPageRequestSecondViewController.h"


@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic ,strong) UITableView * testListView;
@property (nonatomic ,strong) NSArray * listItems;

@property (nonatomic ,strong) NSArray * classItems;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"测试列表";
    
    self.testListView = [[UITableView alloc] init];
    self.testListView.dataSource = self;
    self.testListView.delegate = self;
    self.testListView.tableFooterView = [UIView new];
    [self.view addSubview:self.testListView];
    [self.testListView mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.mas_equalTo(0);
    }];
    
    self.listItems = @[@"单请求",
                       @"多请求",
                       @"分页请求 01",
                       @"分页请求 02",
                       @"下载文件",
                       @"上传文件"];
    
    self.classItems = @[@"TestOneRequestViewController",
                        @"TestMultiRequestViewController",
                        @"TestPageRequestViewController",
                        @"TestPageRequestSecondViewController",
                        @"TestDownloadRequestViewController",
                        @"TestUploadRequestViewController"];
}

#pragma mark -
#pragma mark UITableViewDataSource,UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.listItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textColor = [UIColor colorWithHexString:@"#6F818D"];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",self.listItems[indexPath.row]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString * title = self.listItems[indexPath.row];
    
    NSString * className = self.classItems[indexPath.row];
    
    id vc = [[NSClassFromString(className) alloc] init];
    [vc setValue:title forKey:@"title"];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
