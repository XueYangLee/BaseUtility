//
//  NSDate+Extension.h
//  textPod
//
//  Created by 李雪阳 on 2017/11/22.
//  Copyright © 2017年 singularity. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extension)


/**  调用：[[NSDate date]dateDescription]
 日期描述

 @return
      -   刚刚(一分钟内)
      -   X分钟前(一小时内)
      -   X小时前(当天)
      -   昨天 HH:mm(昨天)
      -   MM-dd HH:mm(一年内)
      -   yyyy-MM-dd HH:mm(更早期)
 */
- (NSString *)dateDescription;



/**
 返回yyyy-MM-dd形式date

 */
- (NSDate *)dateWithYMD;



/**
 是否为今天
 */
- (BOOL)isToday;


/**
 是否为昨天
 */
- (BOOL)isYesterday;


/**
 是否为今年
 */
- (BOOL)isThisYear;


/**
 从fromDate(开始时间)的时间到toDate(结束时间)的时间差值

 @param fromDate 开始时间
 @param toDate 结束时间
 @return compas.year年,compas.month月,compas.day日,compas.hour时,compas.minute分,compas.second秒
 */
+ (NSDateComponents *)intervalTimeFromDate:(NSDate *)fromDate ToDate:(NSDate *)toDate;



/**
 比较sinceDate(开始时间)和endDate(结束时间)的相隔秒数

 @param sinceDate 开始时间
 @param endDate 结束时间
 @return 相差的秒数
 */
+ (NSInteger)secondIntervalSinceDate:(NSDate *)sinceDate EndDate:(NSDate *)endDate;



@end
