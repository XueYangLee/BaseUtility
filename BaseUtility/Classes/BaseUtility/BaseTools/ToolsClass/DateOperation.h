//
//  DateOperation.h
//  textPod
//
//  Created by 李雪阳 on 2017/11/22.
//  Copyright © 2017年 singularity. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateOperation : NSObject



/**
 date转为字符串时间 自定义格式日期（yyyy-MM-dd）
 
 @param date 日期
 @param dateFormat 自定义format（yyyy-MM-dd HH:mm:ss）
 */
+ (NSString *)convertDateStringFromDate:(NSDate *)date dateFormat:(NSString *)dateFormat;


/**
 字符串时间转为date 自定义格式日期
 
 @param dateString 字符串时间
 @param dateFormat 自定义format（yyyy-MM-dd HH:mm:ss）
 */
+ (NSDate *)convertDateWithDateString:(NSString *)dateString dateFormat:(NSString *)dateFormat;


/**
 时间戳转字符串时间
 
 @param timeStamp 时间戳
 @param showSecond 是否显示详细时间（是则返回时分秒）
 */
+ (NSString *)dateStringWithTimeStamp:(NSString *)timeStamp isShowExactTime:(BOOL)showSecond;


/**
 时间戳转字符串时间 dateFormat自定义
 
 @param timeStamp 时间戳
 @param dateFormat 自定义format （yyyy-MM-dd HH:mm:ss）
 */
+ (NSString *)dateStringWithTimeStamp:(NSString *)timeStamp dateFormat:(NSString *)dateFormat;


/**
 获取当前时间时间戳（毫秒）
 */
+ (NSString *)getCurrentTimeStamp;


/** 指定字符串时间转为时间戳（毫秒） */
+ (NSString *)timeStampWithDateString:(NSString *)dateString dateFormat:(NSString *)dateFormat;


/**
 获取当前时间
 
 @param isShowExact 是返回详细到时分秒 否返回年月日
 */
+ (NSString *)currentTimeIsShowExactTime:(BOOL)isShowExact;


/** 秒数转为时分秒   **:**:** */
+ (NSString *)getHHMMSSFromSS:(NSInteger)seconds;


/** 秒数转为分秒     **分钟**秒 */
+ (NSString *)getMMSSFromSS:(NSInteger)seconds;


/**
 从开始时间的时间戳获取与目标时间（nil则为当前时间）的时间差

 @param fromTimeStamp 开始时间的时间戳
 @param toTimeStamp 结束时间的时间戳 传nil默认为当前时间
 @param comp 返回的时间
 */
+ (void)intervalTimeFromTimeStamp:(NSString *)fromTimeStamp toTimeStamp:(NSString *)toTimeStamp completion:(void(^)(NSInteger year, NSInteger month, NSInteger day, NSInteger hour, NSInteger minute, NSInteger second))comp;




/**
 获取从时间的时间戳到目标时间（nil则为当前时间）相隔的时分秒

 @param fromTimeStamp 开始时间的时间戳
 @param toTimeStamp 结束时间的时间戳 传nil默认为当前时间
 @return 时分秒
 */
+ (NSString *)intervalTimeWithHMSFromTimeStamp:(NSString *)fromTimeStamp toTimeStamp:(NSString *)toTimeStamp;




/**
 仅获取从时间的时间戳到目标时间（nil则为当前时间）相隔的分秒

 @param fromTimeStamp 开始时间的时间戳
 @param toTimeStamp 结束时间的时间戳 传nil默认为当前时间
 @return 分秒
 */
+ (NSString *)intervalTimeWithMinuteSecFromTimeStamp:(NSString *)fromTimeStamp toTimeStamp:(NSString *)toTimeStamp;



/**
 24小时闹钟时间间隔 秒  传入HH:mm
 @return 秒
 */
+ (NSInteger)clockIntervalSecWithStartTime:(NSString * )startTime endTime:(NSString *)endTime;




/**
 获取指定日期前后N天日期
 
 @param fromDate 指定日期
 @param before 是否指点日期往前推算
 @param days N天
 */
+ (NSDate *)getBeforeAndAfterDateFromDate:(NSDate *)fromDate before:(BOOL)before intervalDays:(NSInteger)days;



/// 从出生年月日获取年龄
+ (NSInteger)getAgeFromBirthDate:(NSDate *)birthDate;





/**
 获取日期组成
 */
+ (NSDateComponents *)getComponents;



/**
 判断是否是周末
 */
+ (BOOL)isWeekendDate:(NSDate *)date;


/**
 获取当前星期

 @param isText 返回数字表示还是文字表示
 */
+ (id)getCurrentWeekStringisNumberText:(BOOL)isText;


/**
 根据日期获取星期
 */
+ (NSString *)getWeekStringByDate:(NSDate *)date;


/**
 获取指定日期对应周的日期范围  周的起始日期

 @param date 指定日期
 @param firstWeekday 星期起始日  1.周日 2.周一 3.周二 4.周三 5.周四 6.周五  7.周六
 @param dateFormat 日期格式
 @return 结果数组 起始日期
 */
+ (NSArray *)getWeekScopeFromDate:(NSDate *)date firstWeekday:(NSUInteger)firstWeekday dateFormat:(NSString *)dateFormat;



/**
 获取指定日期对应月的日期范围  月的起始日期

 @param date 指定日期
 @param dateFormat 日期格式
 @return 结果数组 起始日期
 */
+ (NSArray *)getMonthScopeFromDate:(NSDate *)date dateFormat:(NSString *)dateFormat;


/**
 本年第一天至最后一天
 
 @param isFirstDate YES 第一天date    NO 最后一天date
 */
+ (NSDate *)getYearTimeIsFirstDate:(BOOL)isFirstDate;


/**
 本月第一天到最后一天
 
 @param isFirstDate YES 第一天date    NO 最后一天date
 */
+ (NSDate *)getMonthTimeIsFirstDate:(BOOL)isFirstDate;


/**
 本周周一到周末
 
 @param isFirstDate YES 周一date   NO 周末date
 */
+ (NSDate *)getWeekTimeIsFirthDate:(BOOL)isFirstDate;


#pragma mark

/**
 根据日期获取农历 年月日

 @param date 日期
 */
+ (NSString*)getChineseCalendarWithDate:(NSDate *)date;



/**
 根据日期获取农历

 @param date 日期
 */
+ (NSString *)getLunarFormatterWithDate:(NSDate *)date;

@end





/**
 G:      公元时代，例如AD公元
 yy:     年的后2位
 yyyy:   完整年
 MM:     月，显示为1-12,带前置0
 MMM:    月，显示为英文月份简写,如 Jan
 MMMM:   月，显示为英文月份全称，如 Janualy
 dd:     日，2位数表示，如02
 d:      日，1-2位显示，如2，无前置0
 EEE:    简写星期几，如Sun
 EEEE:   全写星期几，如Sunday
 aa:     上下午，AM/PM
 H:      时，24小时制，0-23
 HH:     时，24小时制，带前置0
 h:      时，12小时制，无前置0
 hh:     时，12小时制，带前置0
 m:      分，1-2位
 mm:     分，2位，带前置0
 s:      秒，1-2位
 ss:     秒，2位，带前置0
 S:      毫秒
 Z：      GMT（时区）
*/
