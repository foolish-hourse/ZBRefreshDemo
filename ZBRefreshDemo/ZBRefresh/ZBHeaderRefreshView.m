//
//  ZBHeaderRefreshView.m
//  ZBRefreshDemo
//
//  Created by YZL on 17/9/12.
//  Copyright © 2017年 YZL. All rights reserved.
//

#import "ZBHeaderRefreshView.h"

@interface ZBHeaderRefreshView ()
///标题标签
@property (nonatomic , strong) UILabel *titleLabel;
@end

@implementation ZBHeaderRefreshView

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:titleLabel];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel = titleLabel;
        
        UIButton *button = [[UIButton alloc] initWithFrame:titleLabel.bounds];
        [self addSubview:button];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        ///设置默认的状态
        self.refreshState = ZB_RefreshStateNormal;
    }
    return self;
}

#pragma mark - set methods
- (void)setRefreshState:(ZB_RefreshState)refreshState {
    _refreshState = refreshState;
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

#pragma mark - SEL
- (void)buttonClick:(UIButton *)sender {
    self.testBlock();
}

@end
