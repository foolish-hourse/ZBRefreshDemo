//
//  ZBRefreshTool.m
//  ZBRefreshDemo
//
//  Created by YZL on 2017/9/30.
//  Copyright © 2017年 YZL. All rights reserved.
//

#import "ZBRefreshTool.h"

@implementation ZBRefreshTool
///根据view获取当前控制器的导航栏加电池栏高度
+ (CGFloat)zb_getNavHeightByView:(UIView *)view {
    UIResponder *next = [view nextResponder];
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            UIViewController *vc = (UIViewController *)next;
            if (vc.navigationController) {
                CGFloat statusHeight = vc.navigationController.navigationBar.frame.origin.y;
                CGFloat navHeight = vc.navigationController.navigationBar.frame.size.height;
                return statusHeight + navHeight;
            }
        }
        next = [next nextResponder];
    } while (next != nil);
    return 0;
}

@end
