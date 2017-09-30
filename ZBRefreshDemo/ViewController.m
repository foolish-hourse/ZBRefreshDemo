//
//  ViewController.m
//  ZBRefreshDemo
//
//  Created by YZL on 17/9/11.
//  Copyright © 2017年 YZL. All rights reserved.
//

#import "ViewController.h"

#import "ZBRefresh.h"
#import "ZBRefreshTool.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>
///列表视图
@property (nonatomic, strong) UITableView *tableView;
///数据源
@property (nonatomic, strong) NSMutableArray *dataArr;
@end

@implementation ViewController

#pragma mark - lazy load
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 49) style:UITableViewStylePlain];
        [self.view addSubview:_tableView];
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
    self.navigationItem.title = @"ZBRefreshDemo";
    ///初始化数据
    [self initData];
    self.tableView.hidden = NO;
    
    __weak typeof(self) weakSelf = self;
    [self.tableView zb_headerRefreshWithBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"下拉加载结束");
            [weakSelf.dataArr removeAllObjects];
            [weakSelf.dataArr addObjectsFromArray:[weakSelf testData]];
            [weakSelf.tableView reloadData];
            [weakSelf.tableView zb_endRefresh];
        });
    }];
    
    self.tableView.zb_headerView.testBlock = ^{
        NSLog(@"333");
    };
    
    [self.tableView zb_footerRefreshWithBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"上拉加载结束");
            [weakSelf.dataArr addObjectsFromArray:[weakSelf testData]];
            [weakSelf.tableView reloadData];
            [weakSelf.tableView zb_endRefresh];
        });
    }];
//    [ZBRefreshTool zb_getNavInfoByView:self.tableView];
    //    [self.tableView zb_beginRefresh];
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
    cell.textLabel.text = self.dataArr[indexPath.section];
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
    return @[@"111",@"222",@"333"];
}

@end
