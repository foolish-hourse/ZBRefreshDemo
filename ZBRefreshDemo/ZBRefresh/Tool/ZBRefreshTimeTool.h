//
//  ZBRefreshTimeTool.h
//  ZBRefreshDemo
//
//  Created by Martell on 2017/11/26.
//  Copyright © 2017年 YZL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZBRefreshTimeTool : NSObject
///获取最后更新时间的键值日期
+ (NSString *)zb_getLastUpdateTime;
///设置最后更新时间的键值日期
+ (void)zb_setLastUpdateTime:(NSDate *)lastUpdateDate;
@end
