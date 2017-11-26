//
//  ZBHeaderNormalRefreshView.m
//  ZBRefreshDemo
//
//  Created by Martell on 2017/11/26.
//  Copyright © 2017年 YZL. All rights reserved.
//

#import "ZBHeaderNormalRefreshView.h"
#import "ZBRefreshTimeTool.h"

@interface ZBHeaderNormalRefreshView ()
///状态标签
@property (nonatomic , strong) UILabel *stateLabel;
///箭头视图
@property (nonatomic, strong) UIImageView *arrowImageView;
///loading视图
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
///更新时间标签
@property (nonatomic , strong) UILabel *dateLabel;
@end

@implementation ZBHeaderNormalRefreshView

#pragma mark - init
- (instancetype)init {
    if (self = [super init]) {
        self.frame = CGRectMake(0, -zb_headRefreshHeight, 0, zb_headRefreshHeight);
        [self initSubView];
        ///设置默认的状态
        self.refreshState = ZB_RefreshStateNormal;
    }
    return self;
}

- (void)initSubView {
    // TODO 内部视图布局
    UILabel *stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, zb_headRefreshHeight / 2)];
    [self addSubview:stateLabel];
    stateLabel.textColor = [UIColor blackColor];
    stateLabel.font = [UIFont systemFontOfSize:15];
    stateLabel.textAlignment = NSTextAlignmentCenter;
    _stateLabel = stateLabel;
    
    UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow"]];
    [self addSubview:arrowImageView];
    arrowImageView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - arrowImageView.image.size.width / 2 - 90, zb_headRefreshHeight / 2 - arrowImageView.image.size.height / 2, arrowImageView.image.size.width, arrowImageView.image.size.height);
    _arrowImageView = arrowImageView;
    
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicatorView.frame = arrowImageView.frame;
    [self addSubview:indicatorView];
    indicatorView.hidesWhenStopped = YES;
    _indicatorView = indicatorView;
    
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, stateLabel.frame.origin.y + stateLabel.frame.size.height, [UIScreen mainScreen].bounds.size.width, zb_headRefreshHeight / 2)];
    [self addSubview:dateLabel];
    dateLabel.textColor = [UIColor blackColor];
    dateLabel.font = [UIFont systemFontOfSize:15];
    dateLabel.textAlignment = NSTextAlignmentCenter;
    _dateLabel = dateLabel;
}

#pragma mark - set methods
- (void)setRefreshState:(ZB_RefreshState)refreshState {
    [super setRefreshState:refreshState];
    switch (refreshState) {
        case ZB_RefreshStateNormal:{
            _stateLabel.text = @"下拉可以刷新";
            _dateLabel.text = [ZBRefreshTimeTool zb_getLastUpdateTime];
            [UIView animateWithDuration:arrowChangeDuration animations:^{
                _arrowImageView.transform = CGAffineTransformIdentity;
            }];
            [self indicatorViewShowWithState:0];
            break;
        }
        case ZB_RefreshStateWillBeginRefresh:{
            _stateLabel.text = @"松开立即刷新";
            _dateLabel.text = [ZBRefreshTimeTool zb_getLastUpdateTime];
            [UIView animateWithDuration:arrowChangeDuration animations:^{
                _arrowImageView.transform = CGAffineTransformMakeRotation(0.000001 - M_PI);
            }];
            [self indicatorViewShowWithState:0];
            break;
        }
        case ZB_RefreshStateRefreshing:{
            _stateLabel.text = @"正在刷新数据中...";
            _dateLabel.text = [ZBRefreshTimeTool zb_getLastUpdateTime];
            [UIView animateWithDuration:arrowChangeDuration animations:^{
                _arrowImageView.transform = CGAffineTransformMakeRotation(0.000001 - M_PI);
            }];
            [self indicatorViewShowWithState:1];
            break;
        }
        case ZB_RefreshStateWillEndLoad:{
            _stateLabel.text = @"下拉可以刷新";
            [ZBRefreshTimeTool zb_setLastUpdateTime:[NSDate date]];
            _dateLabel.text = [ZBRefreshTimeTool zb_getLastUpdateTime];
            [UIView animateWithDuration:arrowChangeDuration animations:^{
                _arrowImageView.transform = CGAffineTransformIdentity;
            }];
            [self indicatorViewShowWithState:0];
            break;
        }
        default:
            _stateLabel.text = @"未知状态";
            break;
    }
}

#pragma mark - private methods
///0表示箭头显示菊花隐藏 1表示箭头隐藏菊花显示
- (void)indicatorViewShowWithState:(NSInteger)state {
    if (state == 0) {
        _arrowImageView.hidden = NO;
        _indicatorView.hidden = YES;
        [_indicatorView stopAnimating];
    }else {
        _arrowImageView.hidden = YES;
        _indicatorView.hidden = NO;
        [_indicatorView startAnimating];
    }
}

@end
