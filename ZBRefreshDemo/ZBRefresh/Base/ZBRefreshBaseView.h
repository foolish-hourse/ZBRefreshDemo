//
//  ZBRefreshBaseView.h
//  ZBRefreshDemo
//
//  Created by Martell on 2017/11/26.
//  Copyright © 2017年 YZL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBRefreshConfig.h"

@interface ZBRefreshBaseView : UIView

@property (nonatomic , copy) ZBHeaderRefreshingBlock headerBlock;

@property (nonatomic , copy) ZBFooterRefreshingBlock footerBlock;
///刷新状态
@property (nonatomic, assign) ZB_RefreshState refreshState;
///头部刷新回调
+ (ZBRefreshBaseView *)zb_headerRefreshWithBlock:(ZBHeaderRefreshingBlock)block;
///底部刷新回调
+ (ZBRefreshBaseView *)zb_footerRefreshWithBlock:(ZBFooterRefreshingBlock)block;
///开始刷新
- (void)zb_beginRefresh;
///结束刷新
- (void)zb_endRefresh;
@end
