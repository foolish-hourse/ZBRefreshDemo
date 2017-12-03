//
//  UIScrollView+ZBRefresh.m
//  ZBRefreshDemo
//
//  Created by YZL on 17/9/11.
//  Copyright © 2017年 YZL. All rights reserved.
//

#import "UIScrollView+ZBRefresh.h"
#import "ZBRefreshTool.h"
#import <objc/runtime.h>

@interface UIScrollView()

@end

@implementation UIScrollView (ZBRefresh)
#pragma mark - private methods
///初始化数据方法
- (void)initRefreshConfig {
    //在使用约束后调用layoutIfNeeded可立即获得视图的frame
    [self layoutIfNeeded];
    self.zb_offsetHeight = -[ZBRefreshTool zb_getNavHeightByView:self];
    
    // 监听偏移量
    [self addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    ///适配iOS11的滚动视图
    if (@available(iOS 11.0, *)) {
        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    //矫正头部初始位置
    self.contentInset = UIEdgeInsetsMake(-self.zb_offsetHeight, 0, 0, 0);
}

#pragma mark - set methods
- (void)setHeaderBlock:(ZBHeaderRefreshingBlock)headerBlock {
    objc_setAssociatedObject(self, @selector(headerBlock), headerBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setFooterBlock:(ZBFooterRefreshingBlock)footerBlock {
    objc_setAssociatedObject(self, @selector(footerBlock), footerBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setZb_headerView:(ZBRefreshBaseView *)zb_headerView {
    if (self.zb_headerView) {
        [self.zb_headerView removeFromSuperview];
    }
    objc_setAssociatedObject(self, @selector(zb_headerView), zb_headerView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self initRefreshConfig];
    [self addSubview:zb_headerView];
    zb_headerView.frame = CGRectMake(zb_headerView.frame.origin.x, zb_headerView.frame.origin.y, self.frame.size.width, zb_headerView.frame.size.height);
    
}

- (void)setZb_footerView:(ZBRefreshBaseView *)zb_footerView {
    if (self.zb_footerView) {
        [self.zb_footerView removeFromSuperview];
    }
    objc_setAssociatedObject(self, @selector(zb_footerView), zb_footerView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self initRefreshConfig];
    [self addSubview:zb_footerView];
    zb_footerView.frame = CGRectMake(zb_footerView.frame.origin.x, -[ZBRefreshTool zb_getNavHeightByView:self] + self.frame.origin.y + self.frame.size.height, self.frame.size.width, zb_footerView.frame.size.height);
}

- (void)setZb_offsetHeight:(CGFloat)zb_offsetHeight {
    NSValue *value = [NSValue value:&zb_offsetHeight withObjCType:@encode(CGFloat)];
    objc_setAssociatedObject(self, @selector(setZb_offsetHeight:), value, OBJC_ASSOCIATION_RETAIN);
}

- (void)setZb_refreshState:(ZB_RefreshState)zb_refreshState {
    NSValue *value = [NSValue value:&zb_refreshState withObjCType:@encode(ZB_RefreshState)];
    objc_setAssociatedObject(self, @selector(setZb_refreshState:), value, OBJC_ASSOCIATION_RETAIN);
    
    //上下部分的刷新视图的状态改变
    if (self.contentOffset.y < self.zb_offsetHeight) {//下拉
        self.zb_headerView.refreshState = zb_refreshState;
    }else {//上拉
        self.zb_footerView.refreshState = zb_refreshState;
    }
    //整体视图的状态改变
    switch (zb_refreshState) {
        case ZB_RefreshStateNormal:{
            break;
        }
        case ZB_RefreshStateWillBeginRefresh:{
            break;
        }
        case ZB_RefreshStateRefreshing:{
//            if (self.dragging) {
//                return;
//            }
            if (self.contentOffset.y < self.zb_offsetHeight) {//下拉
                [UIView animateWithDuration:zb_normalAnimationDuration animations:^{
                    self.contentInset = UIEdgeInsetsMake(zb_headRefreshHeight - self.zb_offsetHeight, 0, 0, 0);
                }];
                [self setContentOffset:CGPointMake(0, -zb_headRefreshHeight + self.zb_offsetHeight) animated:YES];
                if (self.zb_headerView.headerBlock) {
                    self.zb_headerView.headerBlock();
                }
            }else {//上拉
                [UIView animateWithDuration:zb_normalAnimationDuration animations:^{
                    CGSize contentSize = self.contentSize;
                    CGFloat contentY = contentSize.height;
                    CGFloat frameY = self.frame.size.height;
                    CGFloat load_y = contentY;
                    if (frameY >= contentY) {
                        load_y = frameY;
                        self.contentInset = UIEdgeInsetsMake(-self.zb_offsetHeight, 0, frameY - contentY + self.zb_offsetHeight + zb_footerRefreshHeight, 0);
                    }else {
                        self.contentInset = UIEdgeInsetsMake(-self.zb_offsetHeight, 0, zb_footerRefreshHeight, 0);
                    }
                }];
                if (self.zb_footerView.footerBlock) {
                    self.zb_footerView.footerBlock();
                }
            }
            break;
        }
        case ZB_RefreshStateWillEndLoad:{
            if (self.contentOffset.y < self.zb_offsetHeight) {//下拉
                [UIView animateWithDuration:zb_normalAnimationDuration animations:^{
                    self.contentInset = UIEdgeInsetsMake(-self.zb_offsetHeight, 0, 0, 0);
                    [self setContentOffset:CGPointMake(0, self.zb_offsetHeight) animated:YES];
                }];
            }else {//上拉
                [UIView animateWithDuration:zb_normalAnimationDuration animations:^{
                    self.contentInset = UIEdgeInsetsMake(-self.zb_offsetHeight, 0, 0, 0);
                }];
            }
            break;
        }
        default:
            NSLog(@"未知状态：%ld",zb_refreshState);
            break;
    }
}

//#pragma mark - public methods
/////开始刷新
//- (void)zb_beginRefresh {
////    self.contentInset = UIEdgeInsetsMake(-self.zb_offsetHeight, 0, 0, 0);
//    [self setContentOffset:CGPointMake(0, 0) animated:YES];
//}

#pragma mark - get methods
- (ZBHeaderRefreshingBlock)headerBlock {
    return objc_getAssociatedObject(self, @selector(headerBlock));
}

- (ZBFooterRefreshingBlock)footerBlock {
    return objc_getAssociatedObject(self, @selector(footerBlock));
}

- (ZBRefreshBaseView *)zb_headerView {
    return objc_getAssociatedObject(self, @selector(zb_headerView));
}

- (ZBRefreshBaseView *)zb_footerView {
    return objc_getAssociatedObject(self, @selector(zb_footerView));
}

- (CGFloat)zb_offsetHeight {
    CGFloat cValue = {0};
    NSValue *value = objc_getAssociatedObject(self, @selector(setZb_offsetHeight:));
    [value getValue:&cValue];
    return cValue;
}

- (ZB_RefreshState)zb_refreshState {
    ZB_RefreshState cValue = {0};
    NSValue *value = objc_getAssociatedObject(self, @selector(setZb_refreshState:));
    [value getValue:&cValue];
    return cValue;
}

#pragma mark - kvo methods
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentOffset"]) {
        CGFloat percent_length = self.zb_offsetHeight - self.contentOffset.y;
        if (percent_length >= 0 && percent_length <= zb_headRefreshHeight) {
            if (zb_headRefreshHeight == 0) {
                NSLog(@"头部高度不能为0");
                return;
            }
            CGFloat percent = percent_length / zb_headRefreshHeight;
            NSLog(@"percent:%lf",percent);
        }
        
        if (self.dragging) {// 拖拽
//            NSLog(@"dragging:%lf",self.contentOffset.y);
            if (self.zb_refreshState == ZB_RefreshStateRefreshing) {
                return;
            }
            if (self.contentOffset.y < self.zb_offsetHeight) {// 处理下拉刷新
                if (self.contentOffset.y < -zb_headRefreshHeight + self.zb_offsetHeight) {// 拉到触发下拉刷新的临界位置 改变刷新状态
                    self.zb_refreshState = ZB_RefreshStateWillBeginRefresh;
                }else {// 未拉到临界位置
                    self.zb_refreshState = ZB_RefreshStateNormal;
                }
            }else {// 处理上拉加载
                CGFloat offsetY = self.contentOffset.y;
                CGFloat frameY = self.frame.size.height;
                CGFloat contentY = self.contentSize.height;
                CGFloat load_Y = offsetY + frameY - contentY + self.zb_offsetHeight;// 根据这个值来判断是否到了scrollView的最低点
                if (frameY > contentY) {
                    load_Y = offsetY;
                }
//                NSLog(@"offsetY:%lf,loadY:%lf\n%@",offsetY,load_Y,self);
                if (load_Y > zb_footerRefreshHeight + self.zb_offsetHeight) {// 拉到触发上拉刷新的临界位置 改变刷新状态
                    self.zb_refreshState = ZB_RefreshStateWillBeginRefresh;
                }else {// 未拉到临界位置
                    self.zb_refreshState = ZB_RefreshStateNormal;
                }
            }
        }else {///松手
            if (self.zb_refreshState == ZB_RefreshStateWillBeginRefresh) {
                if (self.contentOffset.y < self.zb_offsetHeight) {//下拉
                    if (self.zb_headerView) {
                        self.zb_refreshState = ZB_RefreshStateRefreshing;
                    }
                }else {//上拉
                    if (self.zb_footerView) {
                        self.zb_refreshState = ZB_RefreshStateRefreshing;
                    }
                }
            }
        }
    }
    if ([keyPath isEqualToString:@"contentSize"]) {
        if (self.zb_footerView) {
            CGFloat contentY = self.contentSize.height;
            CGFloat frameY = self.frame.size.height;
            CGFloat load_y = contentY;
            if (frameY >= contentY) {
                load_y = frameY;
                self.zb_footerView.frame = CGRectMake(0, self.frame.size.height + self.zb_offsetHeight, self.frame.size.width, zb_footerRefreshHeight);
            }else {
                self.zb_footerView.frame = CGRectMake(0, load_y, self.frame.size.width, zb_footerRefreshHeight);
            }
        }
    }
}


#pragma mark - dealloc
- (void)dealloc {
    //删除多次kvo的观察者，防止崩溃
    id info = self.observationInfo;
    NSArray *array = [info valueForKey:@"_observances"];
    for (id objc in array) {
        id Properties = [objc valueForKeyPath:@"_property"];
        NSString *keyPath = [Properties valueForKeyPath:@"_keyPath"];
        if ([@"contentOffset" isEqualToString:keyPath]) {
            [self removeObserver:self forKeyPath:@"contentOffset"];
        }
        if ([@"contentSize" isEqualToString:keyPath]) {
            [self removeObserver:self forKeyPath:@"contentSize"];
        }
    }
}

@end
