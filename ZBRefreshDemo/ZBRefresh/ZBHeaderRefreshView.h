//
//  ZBHeaderRefreshView.h
//  ZBRefreshDemo
//
//  Created by YZL on 17/9/12.
//  Copyright © 2017年 YZL. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ZBRefreshConfig.h"

typedef void(^TESTBLOCK)();

@interface ZBHeaderRefreshView : UIView
///刷新状态
@property (nonatomic, assign) ZB_RefreshState refreshState;

@property (nonatomic, strong) TESTBLOCK testBlock;
@end
