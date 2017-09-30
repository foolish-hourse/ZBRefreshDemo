//
//  UIScrollView+ZBRefresh.m
//  ZBRefreshDemo
//
//  Created by YZL on 17/9/11.
//  Copyright © 2017年 YZL. All rights reserved.
//

#import "UIScrollView+ZBRefresh.h"

#import <objc/runtime.h>

@interface UIScrollView()
///刷新状态
@property (nonatomic, assign) ZB_RefreshState zb_refreshState;
///滚动视图偏移量
@property (nonatomic, assign) CGFloat zb_offsetHeight;
@end

@implementation UIScrollView (ZBRefresh)
#pragma mark - public methods
///头部刷新回调
- (void)zb_headerRefreshWithBlock:(ZBHeaderRefreshingBlock)block {
    self.headerBlock = block;
    [self initRefreshConfig];
}

///底部刷新回调
- (void)zb_footerRefreshWithBlock:(ZBFooterRefreshingBlock)block {
    self.footerBlock = block;
    [self initRefreshConfig];
}

///开始刷新
- (void)zb_beginRefresh {
    self.zb_refreshState = ZB_RefreshStateWillBeginRefresh;
}

///结束刷新
- (void)zb_endRefresh {
    self.zb_refreshState = ZB_RefreshStateWillEndLoad;
}

#pragma mark - private methods
///初始化数据方法
- (void)initRefreshConfig {
    NSLog(@"%@",self);
//    self.zb_offsetHeight = -64;
    if (self.zb_headerView == nil) {
        self.zb_headerView = [[ZBHeaderRefreshView alloc] initWithFrame:CGRectMake(0, -zb_headHeight, self.frame.size.width, zb_headHeight)];
    }
    [self addSubview:self.zb_headerView];
    
    if (self.zb_footerView == nil) {
        self.zb_footerView = [[ZBFooterRefreshView alloc] initWithFrame:CGRectMake(0, self.zb_offsetHeight + self.frame.origin.y + self.frame.size.height, self.frame.size.width, zb_footerHeight)];
    }
    [self addSubview:self.zb_footerView];
    
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

- (void)setZb_headerView:(ZBHeaderRefreshView *)zb_headerView {
    objc_setAssociatedObject(self, @selector(zb_headerView), zb_headerView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setZb_footerView:(ZBFooterRefreshView *)zb_footerView {
    objc_setAssociatedObject(self, @selector(zb_footerView), zb_footerView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setZb_offsetHeight:(CGFloat)zb_offsetHeight {
    NSValue *value = [NSValue value:&zb_offsetHeight withObjCType:@encode(CGFloat)];
    objc_setAssociatedObject(self, @selector(setZb_offsetHeight:), value, OBJC_ASSOCIATION_RETAIN);
}

- (void)setZb_refreshState:(ZB_RefreshState)zb_refreshState {
    NSValue *value = [NSValue value:&zb_refreshState withObjCType:@encode(ZB_RefreshState)];
    objc_setAssociatedObject(self, @selector(setZb_refreshState:), value, OBJC_ASSOCIATION_RETAIN);
    
    if (self.contentOffset.y < self.zb_offsetHeight) {//下拉
        self.zb_headerView.refreshState = zb_refreshState;
    }else {//上拉
        self.zb_footerView.refreshState = zb_refreshState;
    }
    switch (zb_refreshState) {
        case ZB_RefreshStateNormal:{
            [UIView animateWithDuration:0.5 animations:^{
                self.contentInset = UIEdgeInsetsMake(-self.zb_offsetHeight, 0, 0, 0);
            }];
            break;
        }
        case ZB_RefreshStateWillBeginRefresh:
            break;
        case ZB_RefreshStateRefreshing:{
            if (self.dragging) {
                return;
            }
            if (self.contentOffset.y < self.zb_offsetHeight) {//下拉
                [UIView animateWithDuration:0.5 animations:^{
                    self.contentInset = UIEdgeInsetsMake(zb_headHeight - self.zb_offsetHeight, 0, 0, 0);
                }];
                [self setContentOffset:CGPointMake(0, -zb_headHeight + self.zb_offsetHeight) animated:YES];
                self.headerBlock();
            }else {//上拉
                [UIView animateWithDuration:0.5 animations:^{
                    CGSize contentSize = self.contentSize;
                    CGFloat contentY = contentSize.height;
                    CGFloat frameY = self.frame.size.height;
                    float load_y = contentY;
                    if (frameY >= contentY) {
                        load_y = frameY;
                        self.contentInset = UIEdgeInsetsMake(-self.zb_offsetHeight, 0, frameY - contentY + self.zb_offsetHeight + zb_footerHeight, 0);
                    }else {
                        self.contentInset = UIEdgeInsetsMake(-self.zb_offsetHeight, 0, zb_footerHeight, 0);
                    }
                }];
                self.footerBlock();
            }
            break;
        }
        case ZB_RefreshStateWillEndLoad:{
            if (self.contentOffset.y < self.zb_offsetHeight) {//下拉
                [UIView animateWithDuration:0.5 animations:^{
                    self.contentInset = UIEdgeInsetsMake(-self.zb_offsetHeight, 0, 0, 0);
                    [self setContentOffset:CGPointMake(0, self.zb_offsetHeight) animated:YES];
                }];
            }else {//上拉
                [UIView animateWithDuration:0.5 animations:^{
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

#pragma mark - get methods
- (ZBHeaderRefreshingBlock)headerBlock {
    return objc_getAssociatedObject(self, @selector(headerBlock));
}

- (ZBFooterRefreshingBlock)footerBlock {
    return objc_getAssociatedObject(self, @selector(footerBlock));
}

- (ZBHeaderRefreshView *)zb_headerView {
    return objc_getAssociatedObject(self, @selector(zb_headerView));
}

- (ZBFooterRefreshView *)zb_footerView {
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
        if (percent_length >= 0 && percent_length <= zb_headHeight) {
            if (zb_headHeight == 0) {
                NSLog(@"头部高度不能为0");
                return;
            }
            CGFloat percent = percent_length / zb_headHeight;
            NSLog(@"percent:%lf",percent);
        }
        
        if (self.dragging) {// 拖拽
//            NSLog(@"dragging:%lf",self.contentOffset.y);
            if (self.zb_refreshState == ZB_RefreshStateRefreshing) {
                return;
            }
            if (self.contentOffset.y < self.zb_offsetHeight) {// 处理下拉刷新
                if (self.contentOffset.y < -zb_headHeight + self.zb_offsetHeight) {// 拉到触发下拉刷新的临界位置 改变刷新状态
                    self.zb_refreshState = ZB_RefreshStateWillBeginRefresh;
                }else {// 未拉到临界位置
                    self.zb_refreshState = ZB_RefreshStateNormal;
                }
            }else {// 处理上拉加载
                CGFloat offsetY = self.contentOffset.y;
                CGFloat frameY = self.frame.size.height;
                CGFloat contentY = self.contentSize.height;
                CGFloat load_Y = offsetY + frameY - contentY + self.zb_offsetHeight;// 根据这个值来判断是否到了tableView的最低点
                if (frameY > contentY) {
                    load_Y = offsetY;
                }
//                NSLog(@"offsetY:%lf,loadY:%lf\n%@",offsetY,load_Y,self);
                if (load_Y > zb_footerHeight + self.zb_offsetHeight) {// 拉到触发上拉刷新的临界位置 改变刷新状态
                    self.zb_refreshState = ZB_RefreshStateWillBeginRefresh;
                }else {// 未拉到临界位置
                    self.zb_refreshState = ZB_RefreshStateNormal;
                }
            }
        }else {///松手
            if (self.zb_refreshState == ZB_RefreshStateWillBeginRefresh) {
                self.zb_refreshState = ZB_RefreshStateRefreshing;
            }
            if (self.zb_refreshState == ZB_RefreshStateNormal) {//初始化的时候读取当前contentoffset是否被设置过 很重要！！！
                NSLog(@"contentSizexxx:%@",self);
                self.zb_offsetHeight = self.contentOffset.y;
            }
            
//            NSLog(@"enddragging:%lf",self.contentOffset.y);
        }
    }
    if ([keyPath isEqualToString:@"contentSize"]) {
//        NSLog(@"contentSizexxx:%@",self);
        if (self.zb_footerView) {
            CGFloat contentY = self.contentSize.height;
            CGFloat frameY = self.frame.size.height;
            CGFloat load_y = contentY;
            if (frameY >= contentY) {
                load_y = frameY;
                self.zb_footerView.frame = CGRectMake(0, self.frame.size.height + self.zb_offsetHeight, self.frame.size.width, zb_footerHeight);
            }else {
                self.zb_footerView.frame = CGRectMake(0, load_y, self.frame.size.width, zb_footerHeight);
            }
        }
    }
}


#pragma mark - dealloc
- (void)dealloc {
    [self removeObserver:self forKeyPath:@"contentOffset"];
    [self removeObserver:self forKeyPath:@"contentSize"];
}

@end
