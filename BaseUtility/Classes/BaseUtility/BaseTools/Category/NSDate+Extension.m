//
//  NSDate+Extension.m
//  textPod
//
//  Created by 李雪阳 on 2017/11/22.
//  Copyright © 2017年 singularity. All rights reserved.
//

#import "NSDate+Extension.h"

@implementation NSDate (Extension)

#pragma mark 日期描述
- (NSString *)dateDescription
{
    
    // 1. 获取当前日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    // 2. 判断是否是今天
    if ([calendar isDateInToday:self]) {
        
        NSInteger interval = ABS((NSInteger)[self timeIntervalSinceNow]);
        
        if (interval < 60) {
            return @"刚刚";
        }
        interval /= 60;
        if (interval < 60) {
            return [NSString stringWithFormat:@"%zd 分钟前", interval];
        }
        
        return [NSString stringWithFormat:@"%zd 小时前", interval / 60];
    }
    
    // 3. 昨天
    NSMutableString *formatString = [NSMutableString stringWithString:@" HH:mm"];
    if ([calendar isDateInYesterday:self]) {
        [formatString insertString:@"昨天" atIndex:0];
    } else {
        [formatString insertString:@"MM-dd" atIndex:0];
        
        // 4. 是否当年
        NSDateComponents *components = [calendar components:NSCalendarUnitYear fromDate:self toDate:[NSDate date] options:0];
        
        if (components.year != 0) {
            [formatString insertString:@"yyyy-" atIndex:0];
        }
    }
    
    // 5. 转换格式字符串
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.locale = [NSLocale localeWithLocaleIdentifier:@"en"];
    fmt.dateFormat = formatString;
    
    return [fmt stringFromDate:self];
}


- (NSDate *)dateWithYMD
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSString *selfStr = [fmt stringFromDate:self];
    return [fmt dateFromString:selfStr];
}


#pragma mark 是否为今天
- (BOOL)isToday
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitDay | NSCalendarUnitMonth |  NSCalendarUnitYear;
    
    // 1.获得当前时间的年月日
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    
    // 2.获得self的年月日
    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];
    return
    (selfCmps.year == nowCmps.year) &&
    (selfCmps.month == nowCmps.month) &&
    (selfCmps.day == nowCmps.day);
}


#pragma mark 是否为昨天
- (BOOL)isYesterday
{
    // 2014-05-01
    NSDate *nowDate = [[NSDate date] dateWithYMD];
    
    // 2014-04-30
    NSDate *selfDate = [self dateWithYMD];
    
    // 获得nowDate和selfDate的差距
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *cmps = [calendar components:NSCalendarUnitDay fromDate:selfDate toDate:nowDate options:0];
    return cmps.day == 1;
}


#pragma mark 是否为今年
- (BOOL)isThisYear
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitYear;
    
    // 1.获得当前时间的年月日
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    
    // 2.获得self的年月日
    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];
    
    return nowCmps.year == selfCmps.year;
}


#pragma mark 比较fromDate和toDate的时间差值
+ (NSDateComponents *)intervalTimeFromDate:(NSDate *)fromDate ToDate:(NSDate *)toDate{
    // 日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // 比较时间
    NSCalendarUnit unit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    NSDateComponents *components = [calendar components:unit fromDate:fromDate toDate:toDate options:0];
//    DLog(@"差值%ld天,%ld小时%ld分%ld秒",components.day ,components.hour, components.minute,components.second);
    return components;
}


#pragma mark 比较sinceDate和endDate的相隔秒数
+ (NSInteger)secondIntervalSinceDate:(NSDate *)sinceDate EndDate:(NSDate *)endDate{
    NSTimeInterval intervalTime = [endDate timeIntervalSinceDate:sinceDate];
    NSInteger second=intervalTime;
    return second;
}



@end
