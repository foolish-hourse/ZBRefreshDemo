//
//  UIScrollView+ZBRefresh.h
//  ZBRefreshDemo
//
//  Created by YZL on 17/9/11.
//  Copyright © 2017年 YZL. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ZBRefreshConfig.h"

#import "ZBHeaderRefreshView.h"
#import "ZBFooterRefreshView.h"

@interface UIScrollView (ZBRefresh)

@property (nonatomic , copy) ZBHeaderRefreshingBlock headerBlock;
@property (nonatomic , copy) ZBFooterRefreshingBlock footerBlock;

///刷新头部视图
@property (nonatomic , strong) ZBHeaderRefreshView *zb_headerView;
///刷新尾部视图
@property (nonatomic , strong) ZBFooterRefreshView *zb_footerView;

///头部刷新回调
- (void)zb_headerRefreshWithBlock:(ZBHeaderRefreshingBlock)block;
///底部刷新回调
- (void)zb_footerRefreshWithBlock:(ZBFooterRefreshingBlock)block;

///开始刷新
- (void)zb_beginRefresh;
///结束刷新
- (void)zb_endRefresh;

@end
