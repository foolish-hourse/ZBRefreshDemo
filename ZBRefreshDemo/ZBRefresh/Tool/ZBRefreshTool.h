//
//  ZBRefreshTool.h
//  ZBRefreshDemo
//
//  Created by YZL on 2017/9/30.
//  Copyright © 2017年 YZL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ZBRefreshTool : NSObject
///根据view获取当前控制器的导航栏加电池栏高度
+ (CGFloat)zb_getNavHeightByView:(UIView *)view;
@end
