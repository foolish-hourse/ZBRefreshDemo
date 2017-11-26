//
//  ZBRefreshTimeTool.m
//  ZBRefreshDemo
//
//  Created by Martell on 2017/11/26.
//  Copyright © 2017年 YZL. All rights reserved.
//

#import "ZBRefreshTimeTool.h"

///最后更新时间的键值
NSString *ZBGetLastUpdateTimeKey = @"ZBGetLastUpdateTimeKey";

@implementation ZBRefreshTimeTool
///获取最后更新时间的键值日期
+ (NSString *)zb_getLastUpdateTime {
    NSDate *lastUpdateTime = [[NSUserDefaults standardUserDefaults] objectForKey:ZBGetLastUpdateTimeKey];
    if (lastUpdateTime) {
        NSCalendar *calendar = nil;
        if ([NSCalendar respondsToSelector:@selector(calendarWithIdentifier:)]) {//ios9之后
            calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
        }else {//ios9之前
            calendar = [NSCalendar currentCalendar];
        }
        NSUInteger unitFlags = NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitHour |NSCalendarUnitMinute;
        NSDateComponents *cmp1 = [calendar components:unitFlags fromDate:lastUpdateTime];
        NSDateComponents *cmp2 = [calendar components:unitFlags fromDate:[NSDate date]];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        BOOL isToday = NO;
        if ([cmp1 day] == [cmp2 day]) {// 今天
            formatter.dateFormat = @" HH:mm";
            isToday = YES;
        }else if ([cmp1 year] == [cmp2 year]) {// 今年
            formatter.dateFormat = @"MM-dd HH:mm";
        }else {
            formatter.dateFormat = @"yyyy-MM-dd HH:mm";
        }
        NSString *time = [formatter stringFromDate:lastUpdateTime];
        return [NSString stringWithFormat:@"最后更新：%@%@",isToday ?  @"今天" : @"",time];
    } else {
        return [NSString stringWithFormat:@"最后更新：无记录"];
    }
}

///设置最后更新时间的键值日期
+ (void)zb_setLastUpdateTime:(NSDate *)lastUpdateDate {
    [[NSUserDefaults standardUserDefaults] setObject:lastUpdateDate forKey:ZBGetLastUpdateTimeKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
