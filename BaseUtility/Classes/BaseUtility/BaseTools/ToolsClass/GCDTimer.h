//
//  GCDTimer.h
//  NowMeditation
//
//  Created by 李雪阳 on 2020/11/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/** 计时器 */
@interface GCDTimer : NSObject

//MARK: - 计时器
/**
 初始化计时器并开始   dispatch_source_t
 @param interval 计时时间间隔
 @param event_handle 时间操作
 */
+ (dispatch_source_t)timeCountStartWithInterval:(float)interval handler:(dispatch_block_t)event_handle;


/** 继续已暂停的定时器 */
+ (void)resumeTimer:(dispatch_source_t)timer;

/** 暂停计时器 */
+ (void)suspendTimer:(dispatch_source_t)timer;

/** 停止结束计时器 */
+ (void)cancelTimer:(dispatch_source_t)timer;



//MARK: - 秒数倒计时 验证码获取
/**
 秒数倒计时 验证码获取
 
 @param maxSec 最大秒数
 @param comp isReturnZero 倒计时是否归零   second 倒计时每秒的秒数
 */
+ (dispatch_source_t)countdownSecWithMaxSec:(NSInteger)maxSec completion:(void (^)(BOOL isReturnZero, NSInteger second))comp;



//MARK: - 时间倒计时 活动倒计时

/**
 时间倒计时 活动开始时间到结束时间（nil则为当前时间）的倒计时（天时分秒）

 @param startTimeStamp 开始时间的时间戳
 @param endTimeStamp 结束时间的时间戳 传nil默认为当前时间
 @param comp 返回的时间 （天时分秒）
 */
+ (dispatch_source_t)countdownDHMSTimeWithStartTimeStamp:(NSString *)startTimeStamp endTimeStamp:(NSString *)endTimeStamp completion:(void (^)(BOOL isReturnZero, NSInteger day, NSInteger hour, NSInteger minute, NSInteger second))comp;

/**
 时间倒计时 活动开始时间到结束时间（nil则为当前时间）的倒计时（秒）

 @param startTimeStamp 开始时间的时间戳
 @param endTimeStamp 结束时间的时间戳 传nil默认为当前时间
 @param comp 返回的时间 （秒）
 */
+ (dispatch_source_t)countdownTimeWithStartTimeStamp:(NSString *)startTimeStamp endTimeStamp:(NSString *)endTimeStamp completion:(void (^)(BOOL isReturnZero, NSInteger sec))comp;



@end

NS_ASSUME_NONNULL_END
