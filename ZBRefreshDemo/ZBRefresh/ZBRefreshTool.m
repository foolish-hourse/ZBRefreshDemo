//
//  ZBRefreshTool.m
//  ZBRefreshDemo
//
//  Created by YZL on 2017/9/30.
//  Copyright © 2017年 YZL. All rights reserved.
//

#import "ZBRefreshTool.h"

@implementation ZBRefreshTool

+ (CGFloat)zb_getNavHeightByView:(UIView *)view {
    UIResponder *next = [view nextResponder];
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            UIViewController *vc = (UIViewController *)next;
            if (vc.navigationController) {
                return vc.navigationController.navigationBar.bounds.size.height;
            }
        }
        next = [next nextResponder];
    } while (next != nil);
    return 0;
}

@end
