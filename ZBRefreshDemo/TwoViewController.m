//
//  TwoViewController.m
//  ZBRefreshDemo
//
//  Created by YZL on 17/9/11.
//  Copyright © 2017年 YZL. All rights reserved.
//

#import "TwoViewController.h"
#import "ZBRefresh.h"
#import "MJRefresh.h"
#import "Masonry.h"

@interface TwoViewController () <UITableViewDataSource, UITableViewDelegate>
///列表视图
@property (nonatomic, strong) UITableView *tableView;
///数据源
@property (nonatomic, strong) NSMutableArray *dataArr;
@end

@implementation TwoViewController

#pragma mark - lazy load
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - self.tabBarController.tabBar.frame.size.height) style:UITableViewStylePlain];
        //        _tableView = [[UITableView alloc] init];
        [self.view addSubview:_tableView];
        //        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        //            make.edges.mas_equalTo(0);
        //        }];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray new];
    }
    return _dataArr;
}

#pragma mark - view Func
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Second";
    self.view.backgroundColor = [UIColor whiteColor];
    ///初始化数据
    [self initData];
    self.tableView.hidden = NO;
    [self initZBRefresh];
    //    [self initMJRefresh];
}

#pragma mark - init methods
///初始化数据
- (void)initData {
    [self.dataArr addObjectsFromArray:[self testData]];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = self.dataArr[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"indexpath:%ld",(long)indexPath.row);

}

#pragma mark - test data
- (NSArray *)testData {
    return @[@"111",@"222"];
}

- (void)initZBRefresh {
    __weak typeof(self) weakSelf = self;
    
    //    self.tableView.zb_headerView = [ZBHeaderRefreshView zb_headerRefreshWithBlock:^{
    //        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //            NSLog(@"下拉加载结束");
    //            [weakSelf.dataArr removeAllObjects];
    //            [weakSelf.dataArr addObjectsFromArray:[weakSelf testData]];
    //            [weakSelf.tableView reloadData];
    //            [weakSelf.tableView.zb_headerView zb_endRefresh];
    //        });
    //    }];
    self.tableView.zb_headerView = [ZBHeaderNormalRefreshView zb_headerRefreshWithBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"下拉加载结束");
            [weakSelf.dataArr removeAllObjects];
            [weakSelf.dataArr addObjectsFromArray:[weakSelf testData]];
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.zb_headerView zb_endRefresh];
        });
    }];
    
    self.tableView.zb_footerView = [ZBFooterNormalRefreshView zb_footerRefreshWithBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"上拉加载结束");
            [weakSelf.dataArr addObjectsFromArray:[weakSelf testData]];
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.zb_footerView zb_endRefresh];
        });
    }];
    
    //    [self.tableView.zb_headerView zb_beginRefresh];
}

- (void)initMJRefresh {
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"下拉加载结束");
            [weakSelf.dataArr removeAllObjects];
            [weakSelf.dataArr addObjectsFromArray:[weakSelf testData]];
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.mj_header endRefreshing];
        });
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"上拉加载结束");
            [weakSelf.dataArr addObjectsFromArray:[weakSelf testData]];
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.mj_footer endRefreshing];
        });
    }];
}

@end

