//
//  ZBRefreshConfig.h
//  ZBRefreshDemo
//
//  Created by YZL on 17/9/14.
//  Copyright © 2017年 YZL. All rights reserved.
//
/// 刷新状态枚举
typedef NS_ENUM(NSInteger , ZB_RefreshState) {
    ///正常状态
    ZB_RefreshStateNormal = 0,
    ///将要刷新
    ZB_RefreshStateWillBeginRefresh,
    ///正在刷新
    ZB_RefreshStateRefreshing,
    ///将要结束刷新
    ZB_RefreshStateWillEndLoad
};

/// 刷新的回调
typedef void(^ZBHeaderRefreshingBlock)(void);
typedef void(^ZBFooterRefreshingBlock)(void);

///头部高度
static CGFloat zb_headRefreshHeight = 54.0;
///底部高度
static CGFloat zb_footerRefreshHeight = 44.0;
///正常动画时间
static CGFloat zb_normalAnimationDuration = 0.5;
///箭头改变状态时间
static CGFloat arrowChangeDuration = 0.4;
