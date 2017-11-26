//
//  ZBFooterRefreshView.m
//  ZBRefreshDemo
//
//  Created by YZL on 17/9/12.
//  Copyright © 2017年 YZL. All rights reserved.
//

#import "ZBFooterRefreshView.h"

@interface ZBFooterRefreshView ()
///标题标签
@property (nonatomic , strong) UILabel *titleLabel;
@end

@implementation ZBFooterRefreshView

#pragma mark - init
- (instancetype)init {
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, 0, zb_footerRefreshHeight);
        [self initSubView];
        ///设置默认的状态
        self.refreshState = ZB_RefreshStateNormal;
    }
    return self;
}

- (void)initSubView {
    // TODO 内部视图布局
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, zb_headRefreshHeight)];
    [self addSubview:titleLabel];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel = titleLabel;
}

#pragma mark - set methods
- (void)setRefreshState:(ZB_RefreshState)refreshState {
    [super setRefreshState:refreshState];
    switch (refreshState) {
        case ZB_RefreshStateNormal:
            _titleLabel.text = @"普通状态";
            break;
        case ZB_RefreshStateWillBeginRefresh:
            _titleLabel.text = @"将开始刷新";
            break;
        case ZB_RefreshStateRefreshing:
            _titleLabel.text = @"正在刷新";
            break;
        case ZB_RefreshStateWillEndLoad:
            _titleLabel.text = @"将结束刷新";
            break;
        default:
            _titleLabel.text = @"未知状态";
            break;
    }
}

@end
