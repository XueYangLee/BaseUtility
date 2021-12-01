//
//  DateOperation.m
//  textPod
//
//  Created by 李雪阳 on 2017/11/22.
//  Copyright © 2017年 singularity. All rights reserved.
//

#import "DateOperation.h"
#import "NSDate+Extension.h"
#import "UtilityMacro.h"

@implementation DateOperation

#pragma mark date转为字符串时间 自定义格式日期
+ (NSString *)convertDateStringFromDate:(NSDate *)date dateFormat:(NSString *)dateFormat
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:dateFormat];//yyyy-MM-dd
    return [formatter stringFromDate:date];
}

#pragma mark 字符串时间转为date 自定义格式日期
+ (NSDate *)convertDateWithDateString:(NSString *)dateString dateFormat:(NSString *)dateFormat
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateFormat];
    return [dateFormatter dateFromString:dateString];;
}

#pragma mark 时间戳转字符串时间
+ (NSString *)dateStringWithTimeStamp:(NSString *)timeStamp isShowExactTime:(BOOL)showSecond
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    if (showSecond==YES)
    {
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    else
    {
        [formatter setDateFormat:@"yyyy-MM-dd"];
    }
    
    NSString *timeStr=[formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[timeStamp doubleValue]/1000]];
    return timeStr;
}

#pragma mark 时间戳转字符串时间 dateFormat自定义
+ (NSString *)dateStringWithTimeStamp:(NSString *)timeStamp dateFormat:(NSString *)dateFormat
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:dateFormat];
    
    NSString *timeStr=[formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[timeStamp doubleValue]/1000]];
    return timeStr;
}

#pragma mark 获取当前时间时间戳
+ (NSString *)getCurrentTimeStamp
{
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
    NSTimeInterval stamp=[date timeIntervalSince1970]*1000;// *1000 是精确到毫秒，不乘就是精确到秒
    NSString*timeString = [NSString stringWithFormat:@"%0.f", stamp];//转为字符型
    return timeString;
}

#pragma mark 指定字符串时间转为时间戳（毫秒）
+ (NSString *)timeStampWithDateString:(NSString *)dateString dateFormat:(NSString *)dateFormat{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateFormat];
    NSDate *date = [dateFormatter dateFromString:dateString];
    NSTimeInterval stamp=[date timeIntervalSince1970]*1000;
    
    NSString *timeString = [NSString stringWithFormat:@"%0.f", stamp];
    return timeString;
}


#pragma mark 获取当前时间
+ (NSString *)currentTimeIsShowExactTime:(BOOL)isShowExact{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    if (isShowExact) {
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }else{
        [formatter setDateFormat:@"yyyy-MM-dd"];
    }
    //现在时间,你可以输出来看下是什么格式
    NSDate *datenow = [NSDate date];
    //----------将nsdate按formatter格式转成nsstring
    NSString *nowtimeStr = [formatter stringFromDate:datenow];
    return nowtimeStr;
}


#pragma mark 秒数转为时分秒
+ (NSString *)getHHMMSSFromSS:(NSInteger)seconds{
    //format of hour
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",seconds/3600];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(seconds%3600)/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];

    return format_time;
}


#pragma mark 秒数转为分秒
+ (NSString *)getMMSSFromSS:(NSInteger)seconds{
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%ld",seconds/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%ld",seconds%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@分钟%@秒",str_minute,str_second];

    return format_time;
}


#pragma mark 从开始时间的时间戳获取与当前时间的时间差
+ (void)intervalTimeFromTimeStamp:(NSString *)fromTimeStamp toTimeStamp:(NSString *)toTimeStamp completion:(void(^)(NSInteger year, NSInteger month, NSInteger day, NSInteger hour, NSInteger minute, NSInteger second))comp{
    NSDate* fromDate = [NSDate dateWithTimeIntervalSince1970:[fromTimeStamp doubleValue]/1000];
    NSDate *toDate = [NSDate date];
    if (toTimeStamp.length!=0) {
        toDate= [NSDate dateWithTimeIntervalSince1970:[toTimeStamp doubleValue]/1000];
    }
    
    NSDateComponents *components=[NSDate intervalTimeFromDate:fromDate ToDate:toDate];
    
    if (comp) {
        comp(components.year,components.month,components.day,components.hour,components.minute,components.second);
    }
}


#pragma mark 获取从时间的时间戳到当前时间相隔的时分秒
+ (NSString *)intervalTimeWithHMSFromTimeStamp:(NSString *)fromTimeStamp toTimeStamp:(NSString *)toTimeStamp{
    NSDate* fromDate = [NSDate dateWithTimeIntervalSince1970:[fromTimeStamp doubleValue]/1000];
    NSDate *toDate = [NSDate date];
    if (toTimeStamp.length!=0) {
        toDate= [NSDate dateWithTimeIntervalSince1970:[toTimeStamp doubleValue]/1000];
    }
    
    NSInteger intervalTime=[NSDate secondIntervalSinceDate:fromDate EndDate:toDate];
    
    NSInteger hourInterval=intervalTime / 3600;
    NSInteger minuteInterval=(intervalTime / 60) % 60;
    NSInteger secondInterval=intervalTime % 60;
    
    NSString *intervalStr=[NSString stringWithFormat:@"%ld时%ld分%ld秒",hourInterval,minuteInterval,secondInterval];
    return intervalStr;
}



#pragma mark 仅获取从时间的时间戳到当前时间相隔的分秒
+ (NSString *)intervalTimeWithMinuteSecFromTimeStamp:(NSString *)fromTimeStamp toTimeStamp:(NSString *)toTimeStamp{
    NSDate* fromDate = [NSDate dateWithTimeIntervalSince1970:[fromTimeStamp doubleValue]/1000];
    NSDate *toDate = [NSDate date];
    if (toTimeStamp.length!=0) {
        toDate=[NSDate dateWithTimeIntervalSince1970:[toTimeStamp doubleValue]/1000];
    }
    
    NSInteger intervalTime=[NSDate secondIntervalSinceDate:fromDate EndDate:toDate];
    
    NSInteger minuteInterval=intervalTime/60;
    NSInteger secondInterval=intervalTime%60;
    
    NSString *intervalStr=[NSString stringWithFormat:@"%ld分%ld秒",minuteInterval,secondInterval];
    return intervalStr;
}





#pragma mark 获取日期组成
+ (NSDateComponents *)getComponents
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *now;
    NSDateComponents *comps = nil;
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    now=[NSDate date];
    comps = [calendar components:unitFlags fromDate:now];
    return comps;
}

#pragma mark 判断是否是周末
+ (BOOL)isWeekendDate:(NSDate *)date
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    return [calendar isDateInWeekend:date];
}

#pragma mark 获取当前星期
+(id)getCurrentWeekStringisNumberText:(BOOL)isText
{
    NSInteger week=0;
    week = [[self getComponents] weekday];
    NSString *weekString=nil;
    NSNumber *weekStringNumberText=nil;
    switch (week) {
        case 1:
            weekString=[NSString stringWithFormat:@"星期日"];
            weekStringNumberText = @7;
            break;
        case 2:
            weekString=[NSString stringWithFormat:@"星期一"];
            weekStringNumberText = @1;
            break;
        case 3:
            weekString=[NSString stringWithFormat:@"星期二"];
            weekStringNumberText = @2;
            break;
        case 4:
            weekString=[NSString stringWithFormat:@"星期三"];
            weekStringNumberText = @3;
            break;
        case 5:
            weekString=[NSString stringWithFormat:@"星期四"];
            weekStringNumberText = @4;
            break;
        case 6:
            weekString=[NSString stringWithFormat:@"星期五"];
            weekStringNumberText = @5;
            break;
        case 7:
            weekString=[NSString stringWithFormat:@"星期六"];
            weekStringNumberText = @6;
            break;
        default:
            break;
    }
    return isText ? weekString : weekStringNumberText;
}

#pragma mark 根据日期获取星期
+ (NSString *)getWeekStringByDate:(NSDate *)date
{
    NSDateComponents *components = [self getCompansbyDay:0 andDate:date];
    NSInteger week = [components weekday];
    NSString *weekString=nil;
    switch (week) {
        case 1:
            weekString=[NSString stringWithFormat:@"星期日"];
            break;
        case 2:
            weekString=[NSString stringWithFormat:@"星期一"];
            break;
        case 3:
            weekString=[NSString stringWithFormat:@"星期二"];
            break;
        case 4:
            weekString=[NSString stringWithFormat:@"星期三"];
            break;
        case 5:
            weekString=[NSString stringWithFormat:@"星期四"];
            break;
        case 6:
            weekString=[NSString stringWithFormat:@"星期五"];
            break;
        case 7:
            weekString=[NSString stringWithFormat:@"星期六"];
            break;
        default:
            break;
    }
    return weekString;
}


#pragma mark 今年第一天跟最后一天
+ (NSDate *)getYearTimeIsFirstDate:(BOOL)isFirstDate
{
    NSDate *  senddate=[NSDate date];
    NSCalendar  * cal=[NSCalendar  currentCalendar];
    NSUInteger  unitFlags=NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear;
    NSDateComponents * conponent= [cal components:unitFlags fromDate:senddate];
    NSInteger year=[conponent year];
    NSString *first= [NSString stringWithFormat:@"%ld-1-1",(long)year];
    NSString *end=[NSString stringWithFormat:@"%ld-12-31",(long)year];
    
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"yyyy-MM-dd";
    
    if (isFirstDate==YES)
    {
        return [formatter dateFromString:first];
    }
    else
    {
        return [formatter dateFromString:end];
    }
}


#pragma mark 本月一号到月底
+ (NSDate *)getMonthTimeIsFirstDate:(BOOL)isFirstDate
{
    NSDate *newDate=[NSDate date];
    double interval = 0;
    NSDate *beginDate = nil;
    NSDate *endDate = nil;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar setFirstWeekday:2];//设定周一为周首日
    BOOL ok = [calendar rangeOfUnit:NSMonthCalendarUnit startDate:&beginDate interval:&interval forDate:newDate];
    //分别修改为 NSDayCalendarUnit NSWeekCalendarUnit NSYearCalendarUnit
    if (ok) {
        endDate = [beginDate dateByAddingTimeInterval:interval-1];
    }else {
        return @"";
    }
    
    if (isFirstDate==YES)
    {
        return beginDate;
    }
    else
    {
        return endDate;
    }
}


#pragma mark 本周周一到周末
+ (NSDate *)getWeekTimeIsFirthDate:(BOOL)isFirstDate
{
    NSDate *nowDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comp = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSDayCalendarUnit fromDate:nowDate];
    // 获取今天是周几
    NSInteger weekDay = [comp weekday];
    // 获取几天是几号
    NSInteger day = [comp day];
    
    // 计算当前日期和本周的星期一和星期天相差天数
    long firstDiff,lastDiff;
    //    weekDay = 1;
    if (weekDay == 1)
    {
        firstDiff = -6;
        lastDiff = 0;
    }
    else
    {
        firstDiff = [calendar firstWeekday] - weekDay + 1;
        lastDiff = 8 - weekDay;
    }
    
    // 在当前日期(去掉时分秒)基础上加上差的天数
    NSDateComponents *firstDayComp = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit  fromDate:nowDate];
    [firstDayComp setDay:day + firstDiff];
    NSDate *firstDayOfWeek = [calendar dateFromComponents:firstDayComp];
    
    NSDateComponents *lastDayComp = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit   fromDate:nowDate];
    [lastDayComp setDay:day + lastDiff];
    NSDate *lastDayOfWeek = [calendar dateFromComponents:lastDayComp];
    
    
    if (isFirstDate==YES)
    {
        return firstDayOfWeek;
    }
    else
    {
        return lastDayOfWeek;
    }
    
}

#pragma mark 根据日期获取农历
+ (NSString*)getChineseCalendarWithDate:(NSDate *)date
{
    
    NSArray *chineseYears = @[
                              @"甲子", @"乙丑", @"丙寅", @"丁卯",  @"戊辰",  @"己巳",  @"庚午",  @"辛未",  @"壬申",  @"癸酉",
                              @"甲戌",   @"乙亥",  @"丙子",  @"丁丑", @"戊寅",   @"己卯",  @"庚辰",  @"辛己",  @"壬午",  @"癸未",
                              @"甲申",   @"乙酉",  @"丙戌",  @"丁亥",  @"戊子",  @"己丑",  @"庚寅",  @"辛卯",  @"壬辰",  @"癸巳",
                              @"甲午",   @"乙未",  @"丙申",  @"丁酉",  @"戊戌",  @"己亥",  @"庚子",  @"辛丑",  @"壬寅",  @"癸丑",
                              @"甲辰",   @"乙巳",  @"丙午",  @"丁未",  @"戊申",  @"己酉",  @"庚戌",  @"辛亥",  @"壬子",  @"癸丑",
                              @"甲寅",   @"乙卯",  @"丙辰",  @"丁巳",  @"戊午",  @"己未",  @"庚申",  @"辛酉",  @"壬戌",  @"癸亥"];
    
    NSArray *chineseMonths = @[
                               @"正月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月",
                               @"九月", @"十月", @"冬月", @"腊月"];
    
    
    NSArray *chineseDays = @[
                             @"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十",
                             @"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十",
                             @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十"];
    
    
    NSCalendar *localeCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSChineseCalendar];
    
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    
    NSDateComponents *localeComp = [localeCalendar components:unitFlags fromDate:date];
    
    DLog(@"%d_%d_%d  %@",localeComp.year,localeComp.month,localeComp.day, localeComp.date);
    
    NSString *y_str = [chineseYears objectAtIndex:localeComp.year-1];
    NSString *m_str = [chineseMonths objectAtIndex:localeComp.month-1];
    NSString *d_str = [chineseDays objectAtIndex:localeComp.day-1];
    
    NSString *chineseCal_str =[NSString stringWithFormat: @"%@_%@_%@",y_str,m_str,d_str];
    
    return chineseCal_str;
}



+(NSDateComponents *) getCompansbyDay:(NSInteger) dayCount
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *now;
    NSTimeInterval timeInterval=dayCount*60*60*24;
    NSDateComponents *comps = nil;
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    now=[[NSDate alloc] init];
    NSDate *date=[now dateByAddingTimeInterval:timeInterval];
    comps = [calendar components:unitFlags fromDate:date];
    return comps;
}


+(NSDateComponents *)getCompansbyDay:(NSInteger) dayCount andDate:(NSDate *) customerDate
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSTimeInterval timeInterval=dayCount*60*60*24;
    NSDateComponents *comps = nil;
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDate *date=[customerDate dateByAddingTimeInterval:timeInterval];
    comps = [calendar components:unitFlags fromDate:date];
    return comps;
}

@end
