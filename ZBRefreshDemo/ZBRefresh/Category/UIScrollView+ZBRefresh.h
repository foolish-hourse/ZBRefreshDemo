//
//  UIScrollView+ZBRefresh.h
//  ZBRefreshDemo
//
//  Created by YZL on 17/9/11.
//  Copyright © 2017年 YZL. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ZBRefreshConfig.h"

#import "ZBRefreshBaseView.h"

@interface UIScrollView (ZBRefresh)
///刷新状态
@property (nonatomic, assign) ZB_RefreshState zb_refreshState;
///刷新头部视图
@property (nonatomic , strong) ZBRefreshBaseView *zb_headerView;
///刷新尾部视图
@property (nonatomic , strong) ZBRefreshBaseView *zb_footerView;

@end
