//
//  ZBRefreshBaseView.m
//  ZBRefreshDemo
//
//  Created by Martell on 2017/11/26.
//  Copyright © 2017年 YZL. All rights reserved.
//

#import "ZBRefreshBaseView.h"
#import "UIScrollView+ZBRefresh.h"
#import "ZBRefreshTool.h"

@implementation ZBRefreshBaseView

- (void)setRefreshState:(ZB_RefreshState)refreshState {
    _refreshState = refreshState;
}

///头部刷新回调
+ (ZBRefreshBaseView *)zb_headerRefreshWithBlock:(ZBHeaderRefreshingBlock)block {
    ZBRefreshBaseView *baseView = [[self alloc] init];
    baseView.headerBlock = block;
    return baseView;
}

///底部刷新回调
+ (ZBRefreshBaseView *)zb_footerRefreshWithBlock:(ZBFooterRefreshingBlock)block {
    ZBRefreshBaseView *baseView = [[self alloc] init];
    baseView.footerBlock = block;
    return baseView;
}

///开始刷新
- (void)zb_beginRefresh {
    UIScrollView *scrollView = (UIScrollView *)self.superview;
    scrollView.zb_footerView.hidden = YES;
    [UIView animateWithDuration:zb_normalAnimationDuration animations:^{
//        if ([NSStringFromClass([self class]) isEqualToString:@"ZBHeaderNormalRefreshView"]) {
            scrollView.contentOffset = CGPointMake(0, -([ZBRefreshTool zb_getNavHeightByView:self] + zb_headRefreshHeight));
//        }else if ([NSStringFromClass([self class]) isEqualToString:@"ZBFooterNormalRefreshView"]) {
//
//        }
        scrollView.zb_refreshState = ZB_RefreshStateRefreshing;
    } completion:^(BOOL finished) {
        scrollView.zb_footerView.hidden = NO;
    
    }];
    
}

///结束刷新
- (void)zb_endRefresh {
    UIScrollView *scrollView = (UIScrollView *)self.superview;
    scrollView.zb_refreshState = ZB_RefreshStateWillEndLoad;
}

@end
